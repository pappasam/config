# /// script
# dependencies = ["pynvim>=0.6"]
# ///
"""Run with `uv run scripts/test_markdown_tables.py`.

Requires the configured Neovim 0.13 nightly and installed Markdown parsers/queries.
Uses an isolated editor with an attached UI to check what is actually displayed.
"""

import os
from pathlib import Path
import tempfile
import time

import pynvim


def check(nvim):
    config = Path(__file__).resolve().parents[1] / "dotfiles/.config/nvim"
    nvim.exec_lua("vim.opt.rtp:prepend(...)", str(config))
    nvim.exec_lua("vim.bo.filetype = 'markdown'")
    source = [
        "Before " + "words " * 30,
        "",
        "| Name | Description |",
        "| :--- | ---: |",
        "| **bold** | " + "long content " * 20 + " |",
        "| next | [label](https://example.com) and `code` |",
        "",
        "After prose",
    ]
    nvim.current.buffer[:] = source
    # Exercise the real entry point, including Tree-sitter highlighting.
    nvim.exec_lua("dofile(...)", str(config / "ftplugin/markdown.lua"))

    def settle():
        time.sleep(0.06)
        nvim.command("redraw!")

    def marks(win=None):
        return nvim.exec_lua(
            "local ns = vim.api.nvim_get_namespaces()['markdown_tables_' .. ...]; "
            "return ns and vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, "
            "{ details = true }) or {}",
            win or nvim.current.window.handle,
        )

    def screen():
        settle()
        return nvim.exec_lua(r"""
            local rows = {}
            for row = 1, 42 do
                local text = ''
                for col = 1, 100 do
                    text = text .. vim.fn.screenstring(row, col)
                end
                rows[#rows + 1] = text
            end
            return table.concat(rows, '\n')
        """)

    settle()
    assert not marks(), "ordinary Markdown must stay unrendered"
    nvim.command("setlocal conceallevel=3 concealcursor=nvic wrap")
    settle()
    assert marks()
    nvim.current.window.cursor = (5, 160)
    rendered = screen()
    assert "**bold**" not in rendered and "bold" in rendered
    assert "https://" not in rendered and "label and code" in rendered
    assert "After prose" in rendered
    assert nvim.current.buffer[:] == source, "rendering must not change source"
    assert nvim.eval("[&wrap, &conceallevel, &concealcursor]") == [1, 3, "nvic"]

    for mode, key in [("insert", "i"), ("visual", "v"), ("command", ":")]:
        nvim.input(key)
        rendered = screen()
        assert "**bold**" not in rendered and "long content" in rendered, mode
        assert marks(), mode
        nvim.input("\x1b")
        settle()

    nvim.current.window.cursor = (6, 2)
    nvim.input("iX")
    assert "Xnext" in screen(), "insert changes must refresh"
    nvim.input("\x1b")
    settle()

    reading_window = nvim.current.window.handle
    nvim.command("vsplit")
    nvim.command("setlocal conceallevel=0 concealcursor=")
    assert "**bold**" in screen(), "the source split must stay raw"
    assert not marks()
    assert nvim.eval("[&wrap, &conceallevel, &concealcursor]") == [1, 0, ""]
    assert nvim.exec_lua(
        "return vim.api.nvim__ns_get(vim.api.nvim_get_namespaces()"
        "['markdown_tables_' .. ...]).wins",
        reading_window,
    ) == [reading_window]

    nvim.command("setlocal conceallevel=3 concealcursor=nvic")
    nvim.command("vertical resize 25")
    assert "**bold**" not in screen()
    for mark in marks():
        chunks = mark[3].get("virt_text", [])
        text = "".join(chunk[0] for chunk in chunks)
        assert nvim.exec_lua("return vim.fn.strdisplaywidth(...)", text) <= 25

    for disable, enable in [
        ("concealcursor=nvc", "concealcursor=nvic"),
        ("diff", "nodiff"),
    ]:
        nvim.command("setlocal " + disable)
        settle()
        assert not marks(), disable
        nvim.command("setlocal " + enable)
        settle()
        assert marks(), enable

    nvim.command("only")
    nvim.current.buffer[:] = [
        "```markdown", "| A | B |", "| - | - |", "| nope | no |", "```", "",
        "| A | B |", "| - | - |", "| 世界世界世界 | café |",
    ]
    settle()
    assert all(mark[1] >= 6 for mark in marks()), "exclude fenced code"
    rendered = screen()
    assert "世界" in rendered and "café" in rendered

    nvim.current.buffer[:] = ["| A | B |", "| - | - |"]
    rendered = screen()
    assert rendered.index("├") < rendered.index("╰"), "header-only border order"
    nvim.current.buffer[:] = ["ordinary prose"]
    settle()
    assert not marks(), "deleting tables must remove decorations"
    assert nvim.command_output("messages") == "", nvim.command_output("messages")


if __name__ == "__main__":
    with tempfile.TemporaryDirectory(prefix="markdown-tables-test-") as temp:
        os.environ["NVIM_LOG_FILE"] = str(Path(temp) / "nvim.log")
        editor = pynvim.attach(
            "child", argv=["nvim", "--embed", "--headless", "-u", "NONE", "-i", "NONE", "-n"]
        )
        editor.ui_attach(100, 45, rgb=True, ext_linegrid=True, ext_messages=True)
        try:
            check(editor)
            print("Markdown table UI checks passed.")
        finally:
            try:
                editor.command("qa!")
            except EOFError:
                pass
