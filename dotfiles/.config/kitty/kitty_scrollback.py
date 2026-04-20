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
    # With add_wrap_markers: every line ends with \r.
    # Real newlines are \r\n, soft wraps are \r alone.
    # Replace \r\n (real newline) with a placeholder, strip remaining \r (soft wraps), restore.
    text = text.replace("\r\n", "\x00")
    text = text.replace("\r", "")
    text = text.replace("\x00", "\n")
    text = "\n".join(line + "\x1b[0m" for line in text.split("\n"))

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
