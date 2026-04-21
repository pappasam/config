import json
import os
import re
import tempfile

from kitty.boss import Boss
from kitty.fast_data_types import Color, get_options
from kitty.rgb import color_as_sharp, color_from_int
from kitty.utils import which
from kittens.tui.handler import result_handler


def main():
    """Required entry point for kitty's kitten protocol, even with no_ui=True."""
    raise SystemExit("Must be run as kitten kitty_scrollback")


@result_handler(type_of_input=None, no_ui=True, has_ready_notification=False)
def handle_result(_args, _result, target_window_id: int, boss: Boss):
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        raise Exception(f"Failed to get window with id: {target_window_id}")
    if w.title.startswith("kitty-scrollback"):
        return

    kitty_path = which("kitty")
    if not kitty_path:
        boss.show_error("kitty_scrollback", "Cannot find kitty in PATH")
        return
    nvim_path = which("nvim")
    if not nvim_path:
        boss.show_error("kitty_scrollback", "Cannot find nvim in PATH")
        return

    # Gather colors directly from kitty's API (avoids deadlock from subprocess)
    opts = get_options()
    color_dict = {
        k: getattr(opts, k) for k in opts if isinstance(getattr(opts, k), Color)
    }
    for k, v in w.current_colors.items():
        if v is None:
            color_dict.pop(k, None)
        elif isinstance(v, int):
            color_dict[k] = color_from_int(v)
    kitty_colors = {k: color_as_sharp(v) for k, v in color_dict.items()}

    screen = w.screen
    metadata = {
        "kitty_path": kitty_path,
        "scrolled_by": screen.scrolled_by,
        "cursor_x": screen.cursor.x + 1,
        "cursor_y": screen.cursor.y + 1,
        "lines": screen.lines + 1,
        "columns": screen.columns,
        "window_id": target_window_id,
        "colors": kitty_colors,
    }

    text = w.as_text(as_ansi=True, add_history=True, add_wrap_markers=True)

    # Split on \r\n (real newlines). Remaining \r within a row = soft wraps to rejoin.
    raw_rows = text.split("\r\n")
    if raw_rows and raw_rows[-1] == "":
        raw_rows.pop()

    # Single forward pass: rejoin soft-wrapped sub-rows, track count per line.
    strip_ansi = re.compile(r"\x1b\[[^A-Za-z]*[A-Za-z]|\x1b\].*?(?:\x07|\x1b\\)").sub
    result_lines = []
    sub_row_counts = []
    for raw_row in raw_rows:
        sub_rows = raw_row.split("\r")
        if sub_rows and sub_rows[-1] == "":
            sub_rows.pop()
        if not sub_rows:
            sub_rows = [""]
        result_lines.append("".join(sub_rows))
        sub_row_counts.append(len(sub_rows))

    # Backward scan for cursor position (bounded by screen.lines).
    rows_from_end = screen.lines - 1 - screen.cursor.y
    cursor_buf_line = len(result_lines) - 1
    cursor_buf_col = screen.cursor.x + 1
    for i in range(len(sub_row_counts) - 1, -1, -1):
        if rows_from_end < sub_row_counts[i]:
            cursor_buf_line = i
            preceding = sub_row_counts[i] - rows_from_end - 1
            if preceding > 0:
                parts = raw_rows[i].split("\r")
                if parts and parts[-1] == "":
                    parts.pop()
                plain = strip_ansi("", "".join(parts[:preceding]))
                cursor_buf_col = len(plain.encode("utf-8")) + screen.cursor.x + 1
            break
        rows_from_end -= sub_row_counts[i]

    metadata["cursor_buf_line"] = cursor_buf_line + 1
    metadata["cursor_buf_col"] = cursor_buf_col

    text = "\n".join(line + "\x1b[0m" for line in result_lines)

    fd, meta_path = tempfile.mkstemp(prefix="ksb_", suffix=".json")
    text_path = meta_path.replace(".json", ".ansi")
    with os.fdopen(fd, "w") as f:
        json.dump({"metadata": metadata, "text_path": text_path}, f)
    with open(text_path, "w") as f:
        f.write(text)

    lua_cmd = (
        " lua"
        " vim.opt.runtimepath:append(vim.fn.stdpath('config'))"
        f" require('kitty_scrollback').launch([[{meta_path}]])"
    )

    cmd = (
        "launch",
        "--copy-env",
        "--type",
        "overlay",
        "--title",
        "kitty-scrollback",
        nvim_path,
        "--clean",
        "--noplugin",
        "-n",
        "-c",
        "let g:mapleader = ','",
        "--cmd",
        lua_cmd,
    )
    boss.call_remote_control(w, cmd)
