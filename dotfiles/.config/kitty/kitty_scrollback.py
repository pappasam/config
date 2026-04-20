import json
import os
import tempfile

from kitty.boss import Boss
from kitty.utils import which
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

    screen = w.screen
    metadata = {
        "kitty_path": kitty_path,
        "scrolled_by": screen.scrolled_by,
        "cursor_x": screen.cursor.x + 1,
        "cursor_y": screen.cursor.y + 1,
        "lines": screen.lines + 1,
        "columns": screen.columns,
        "window_id": int(target_window_id),
    }

    text = w.as_text(as_ansi=True, add_history=True, add_wrap_markers=True)
    text = text.replace("\r", "")
    text = "\n".join(line + "\x1b[0m" for line in text.split("\n"))

    fd, data_path = tempfile.mkstemp(prefix="ksb_", suffix=".json")
    with os.fdopen(fd, "w") as f:
        json.dump({"text": text, "metadata": metadata}, f)

    lua_cmd = (
        " lua"
        " vim.opt.runtimepath:append(vim.fn.stdpath('config'))"
        f" require('kitty_scrollback').launch([[{data_path}]])"
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
