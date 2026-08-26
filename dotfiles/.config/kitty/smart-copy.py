"""Make clipboard copies read naturally outside of the terminal.

Kitty already removes newlines created by terminal soft wrapping. Some terminal
programs render prose with real newline characters, though, so those newlines
normally survive a copy. This watcher joins likely prose continuations while
leaving blank lines and structured output alone.

This wraps Kitty's selection reader so it applies both to ``copy_on_select`` and
to explicit copy actions such as Ctrl+Shift+C. Kitty does not dispatch a
mouse-release mapping after finishing a drag selection.
"""

from __future__ import annotations

import itertools
import re
import textwrap
from typing import Any

_BLOCK_START = re.compile(
    r"^\s*(?:"
    r"[-*+]\s+|"  # Bulleted list
    r"\d+[.)]\s+|"  # Numbered list
    r"#{1,6}\s+|"  # Markdown heading
    r">\s+|"  # Quoted text
    r"```|~~~|"  # Fenced code block
    r"(?:diff --git|index\s|@@\s|---\s|\+\+\+\s)|"  # Diff metadata
    r"(?:[$%❯λ]|\w+@[-.\w]+(?::[^ ]+)?)\s+"  # Shell prompt
    r")"
)
_CODE_START = re.compile(
    r"^(?:"
    r"class|def|async\s+def|if|elif|else|for|while|with|try|except|finally|"
    r"return|yield|raise|import|from|const|let|var|function|local|"
    r"case|select|insert|update|delete|create|alter|drop"
    r")\b",
    re.IGNORECASE,
)
_TABLE_DIVIDER = re.compile(r"^\s*\|?(?:\s*:?-{3,}:?\s*\|)+\s*$")
_TIMESTAMP = re.compile(r"^\s*(?:\d{4}-\d\d-\d\d[T ]|\[?\d\d?:\d\d(?::\d\d)?)")
_LIST_START = re.compile(r"^\s*(?:[-*+]\s+|\d+[.)]\s+)")


def _display_width(text: str) -> int:
    """Return a close-enough terminal width without importing Kitty modules."""
    import unicodedata

    return sum(2 if unicodedata.east_asian_width(char) in "WF" else 1 for char in text)


def _looks_structured(line: str) -> bool:
    stripped = line.strip()
    return bool(
        not stripped
        or _BLOCK_START.match(line)
        or _TABLE_DIVIDER.match(line)
        or _TIMESTAMP.match(line)
        or (stripped.startswith("|") and stripped.endswith("|"))
    )


def _looks_like_code(line: str) -> bool:
    stripped = line.strip()
    if not stripped:
        return False
    if _CODE_START.match(stripped):
        return True
    if stripped.endswith(("{", "}", ";")):
        return True
    if any(
        operator in stripped
        for operator in (" => ", " == ", " != ", " := ", " && ", " || ")
    ):
        return True
    return len(line) - len(line.lstrip()) >= 4 and bool(
        re.search(r"[(){}=;]", stripped)
    )


def _joiner(left: str, right: str) -> str:
    if left.endswith("-") and right[:1].isalpha():
        return ""
    if right[:1] in ",.;:!?)]}":
        return ""
    return " "


def smart_unwrap(text: str, screen_columns: int | None = None) -> str:
    """Join likely hard-wrapped prose lines, preserving meaningful structure."""
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    # Remove indentation shared by the entire selection, but retain relative
    # indentation within code, lists, and other nested structures.
    text = textwrap.dedent(text)
    lines = text.split("\n")
    if len(lines) < 2:
        return text

    prose_widths = [
        _display_width(line.rstrip())
        for line in lines
        if line.strip() and not _looks_structured(line) and not _looks_like_code(line)
    ]
    reference_width = max(prose_widths, default=0)
    if screen_columns:
        reference_width = min(reference_width, screen_columns)
    likely_wrap_width = max(24, round(reference_width * 0.65))

    output = lines[0].rstrip()
    for left, right in itertools.pairwise(lines):
        left = left.rstrip()
        right_stripped = right.strip()

        preserve_break = (
            not left.strip()
            or not right_stripped
            or _looks_structured(right)
            or (_looks_structured(left) and not _LIST_START.match(left))
            or _looks_like_code(left)
            or _looks_like_code(right)
        )
        left_width = _display_width(left)
        continuation_signal = left_width >= likely_wrap_width or (
            left_width >= 24
            and (
                right_stripped[:1].islower()
                or right_stripped.startswith(("(", "[", '"', "'"))
            )
        )

        if not preserve_break and continuation_signal:
            output += _joiner(left, right_stripped) + right_stripped
        else:
            output += "\n" + right.rstrip()

    return output


def on_load(boss: Any, data: dict[str, Any]) -> None:
    """Install the selection wrapper once per Kitty process."""
    del boss
    del data

    from kitty.window import Window

    if getattr(Window, "_smart_copy_installed", False):
        return

    original_text_for_selection = Window.text_for_selection

    def text_for_selection(self: Any, as_ansi: bool = False) -> str:
        selection = original_text_for_selection(self, as_ansi)
        if not selection or as_ansi:
            return selection
        columns = getattr(self.screen, "columns", None)
        return smart_unwrap(selection, columns)

    Window.text_for_selection = text_for_selection
    Window._smart_copy_installed = True
