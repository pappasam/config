import json
import os
import tempfile

from kitty.boss import Boss
from kitty.fast_data_types import Color, get_options
from kitty.rgb import color_as_sharp, color_from_int
from kitty.utils import natsort_ints, which
from kittens.tui.handler import result_handler


def main():
    raise SystemExit("Must be run as kitten kitty_scrollback")


@result_handler(type_of_input=None, no_ui=True, has_ready_notification=False)
def handle_result(args, result, target_window_id, boss: Boss):
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
    color_dict = {k: getattr(opts, k) for k in opts if isinstance(getattr(opts, k), Color)}
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
        "window_id": int(target_window_id),
        "colors": kitty_colors,
    }

    text = w.as_text(as_ansi=True, add_history=True, add_wrap_markers=True)

    # Compute which terminal row the cursor is on (0-indexed in the full text).
    # The screen area is the last `screen.lines` rows of the text.
    # cursor_y is 1-indexed within the screen area.
    raw_rows = text.split("\r\n")
    # Last element may be empty after final \r\n
    if raw_rows and raw_rows[-1] == "":
        raw_rows.pop()
    # Each raw_row may contain \r for soft-wrap joins within it — but actually
    # after split on \r\n, soft-wrap \r chars are still inside rows.
    # Count terminal rows: split each raw_row on remaining \r to get sub-rows.
    terminal_rows = []
    for raw_row in raw_rows:
        sub_rows = raw_row.split("\r")
        if sub_rows and sub_rows[-1] == "":
            sub_rows.pop()
        if not sub_rows:
            sub_rows = [""]
        terminal_rows.extend(sub_rows)

    total_term_rows = len(terminal_rows)
    cursor_term_row = total_term_rows - screen.lines + screen.cursor.y  # 0-indexed

    # Now rejoin: soft wraps (\r without \n) get merged.
    # Track which terminal row maps to which buffer line and column offset.
    buf_line = 0
    col_offset = 0  # byte offset within the buffer line for each terminal row start
    cursor_buf_line = 0
    cursor_buf_col = 0

    result_lines = []
    current_parts = []
    term_row_idx = 0

    for raw_row in raw_rows:
        sub_rows = raw_row.split("\r")
        if sub_rows and sub_rows[-1] == "":
            sub_rows.pop()
        if not sub_rows:
            sub_rows = [""]
        for i, sub_row in enumerate(sub_rows):
            if term_row_idx == cursor_term_row:
                cursor_buf_line = buf_line
                # Strip ANSI escapes to count visible columns up to cursor_x
                import re
                plain = re.sub(r'\x1b\[[^A-Za-z]*[A-Za-z]', '', "".join(current_parts))
                cursor_buf_col = len(plain.encode('utf-8')) + screen.cursor.x + 1
            current_parts.append(sub_row)
            term_row_idx += 1
        # End of a real line (\r\n boundary)
        result_lines.append("".join(current_parts))
        current_parts = []
        buf_line += 1

    if current_parts:
        if term_row_idx > cursor_term_row >= term_row_idx - len(current_parts):
            cursor_buf_line = buf_line
        result_lines.append("".join(current_parts))

    metadata["cursor_buf_line"] = cursor_buf_line + 1  # 1-indexed for nvim
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
        "--type", "overlay",
        "--title", "kitty-scrollback",
        nvim_path,
        "--clean", "--noplugin", "-n",
        "-c", "let g:mapleader = ','",
        "--cmd", lua_cmd,
    )
    boss.call_remote_control(w, cmd)
