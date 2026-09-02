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
from typing import Any

_BLOCK_START = re.compile(
    r"^\s*(?:"
    r"[-*+•◦‣]\s+|"  # Bulleted list
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
    r"class|def|async\s+def|if|elif|else|for|while|try|except|finally|"
    r"return|yield|raise|import|from|const|let|var|function|local|"
    r"case|select|insert|update|delete|create|alter|drop"
    r")\b",
    re.IGNORECASE,
)
_TABLE_DIVIDER = re.compile(r"^\s*\|?(?:\s*:?-{3,}:?\s*\|)+\s*$")
_TIMESTAMP = re.compile(r"^\s*(?:\d{4}-\d\d-\d\d[T ]|\[?\d\d?:\d\d(?::\d\d)?)")
_LIST_START = re.compile(r"^\s*(?:[-*+•◦‣]\s+|\d+[.)]\s+)")
_FENCE = re.compile(r"^\s*(`{3,}|~{3,})")
_COMMAND_WORD = re.compile(r"^[a-z0-9_./+@%:=,-]+$")
_ASSIGNMENT = re.compile(r"^\s*(?:export\s+)?[A-Za-z_][A-Za-z0-9_]*\s*[:?+]?=")
_YAML_ENTRY = re.compile(r"^\s*[A-Za-z_][\w.-]*:\s*(?:\S.*)?$")
_RESOURCE = re.compile(r"^(?:[a-z][a-z0-9+.-]*://|(?:\.{1,2}|~)?/|[A-Za-z]:\\)")
_PROSE_STARTS = frozenset(
    {
        "a",
        "an",
        "and",
        "are",
        "as",
        "at",
        "be",
        "but",
        "by",
        "can",
        "for",
        "from",
        "has",
        "have",
        "he",
        "her",
        "here",
        "his",
        "how",
        "i",
        "if",
        "in",
        "is",
        "it",
        "its",
        "not",
        "of",
        "on",
        "or",
        "our",
        "she",
        "that",
        "the",
        "their",
        "there",
        "these",
        "they",
        "this",
        "those",
        "to",
        "we",
        "what",
        "when",
        "where",
        "which",
        "who",
        "why",
        "will",
        "with",
        "you",
        "your",
    }
)
_KNOWN_COMMANDS = frozenset(
    {
        "ansible",
        "apt",
        "apt-get",
        "awk",
        "bun",
        "cargo",
        "cat",
        "chmod",
        "chown",
        "cmake",
        "cp",
        "curl",
        "deno",
        "docker",
        "echo",
        "env",
        "find",
        "gh",
        "git",
        "go",
        "gradle",
        "grep",
        "helm",
        "java",
        "journalctl",
        "kubectl",
        "make",
        "mkdir",
        "mv",
        "nix",
        "node",
        "npm",
        "ollama",
        "pip",
        "pip3",
        "pnpm",
        "printf",
        "python",
        "python3",
        "rg",
        "rm",
        "rsync",
        "ruby",
        "scp",
        "sed",
        "ssh",
        "sudo",
        "systemctl",
        "tar",
        "terraform",
        "uv",
        "wget",
        "yarn",
    }
)
_PROSE_COMMAND_FOLLOWUPS = _PROSE_STARTS | {
    "could",
    "does",
    "may",
    "might",
    "should",
    "sure",
    "was",
    "were",
    "would",
}


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
    # ``with`` commonly begins a prose continuation. Treat it as Python only
    # when the line also has the punctuation of a with statement.
    if re.match(r"with\b", stripped, re.IGNORECASE) and stripped.endswith(":"):
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


def _looks_like_resource(line: str) -> bool:
    """Recognize URLs and absolute or explicitly relative paths."""
    return bool(_RESOURCE.match(line.strip()))


def _looks_like_config(line: str) -> bool:
    """Recognize common unmarked config and tabular rows."""
    stripped = line.strip()
    return bool(
        "\t" in line
        or re.search(r"\S\s{2,}\S", stripped)
        or _ASSIGNMENT.match(line)
        or _YAML_ENTRY.match(line)
        or stripped in {"---", "..."}
    )


def _is_single_value(line: str) -> bool:
    """Return whether a line is one value rather than a prose fragment."""
    return len(line.strip().split()) == 1


def _command_words(line: str) -> list[str]:
    words = line.strip().split()
    if len(words) < 2 or not _COMMAND_WORD.fullmatch(words[0]):
        return []
    return words


def _looks_like_command(line: str) -> bool:
    """Recognize shell commands without requiring the executable to exist."""
    words = _command_words(line)
    if not words or words[0] in _PROSE_STARTS:
        return False
    if words[0] in _KNOWN_COMMANDS and words[1] not in _PROSE_COMMAND_FOLLOWUPS:
        return True
    shell_tokens = {"|", "||", "&&", ";", ">", ">>", "<", "2>", "2>&1"}
    return any(
        word in shell_tokens
        or word.startswith("-")
        or any(char in word for char in ("/", "=", "$", "*"))
        or (":" in word and not word.endswith(":"))
        for word in words[1:]
    )


def _command_prefix(line: str) -> tuple[str, str] | None:
    """Return the shared part of a likely repeated shell command."""
    words = _command_words(line)
    if (
        len(words) < 3
        or words[0] in _PROSE_STARTS
        or not _COMMAND_WORD.fullmatch(words[1])
    ):
        return None
    return words[0], words[1]


def _same_command_family(left: str, right: str) -> bool:
    """Recognize command lists such as repeated ``ollama pull`` lines."""
    left_prefix = _command_prefix(left)
    return left_prefix is not None and left_prefix == _command_prefix(right)


def _table_boundaries(lines: list[str]) -> set[int]:
    """Find whitespace-delimited tables with an uppercase header row."""
    boundaries: set[int] = set()
    for index, line in enumerate(lines):
        words = line.strip().split()
        is_header = len(words) >= 2 and all(
            any(char.isalpha() for char in word) and word.upper() == word
            for word in words
        )
        if not is_header:
            continue

        column_count = len(words)
        block_end = index + 1
        while block_end < len(lines) and len(lines[block_end].split()) == column_count:
            block_end += 1
        if block_end > index + 1:
            boundaries.update(range(index, block_end - 1))
    return boundaries


def _code_block_boundaries(lines: list[str]) -> set[int]:
    """Preserve every newline inside Markdown-style fenced code blocks."""
    boundaries: set[int] = set()
    fence_start: int | None = None
    fence_character = ""
    for index, line in enumerate(lines):
        match = _FENCE.match(line)
        if fence_start is None:
            if match:
                fence_start = index
                fence_character = match.group(1)[0]
            continue
        if match and match.group(1)[0] == fence_character:
            boundaries.update(range(fence_start, index))
            fence_start = None
            fence_character = ""
    if fence_start is not None:
        boundaries.update(range(fence_start, len(lines) - 1))
    return boundaries


def _poetry_boundaries(lines: list[str], screen_columns: int | None) -> set[int]:
    """Find likely verse or other intentionally line-broken text blocks."""
    boundaries: set[int] = set()
    block_start = 0
    for block_end in range(len(lines) + 1):
        if block_end < len(lines) and lines[block_end].strip():
            continue

        block = lines[block_start:block_end]
        if len(block) >= 3:
            widths = [_display_width(line.strip()) for line in block]
            single_values = sum(_is_single_value(line) for line in block)
            uppercase_starts = sum(line.strip()[:1].isupper() for line in block)
            verse_endings = sum(
                line.rstrip().endswith((",", ";", ":", "—", "–")) for line in block
            )
            compact = all(len(line.split()) <= 8 for line in block)
            far_from_screen_edge = bool(
                screen_columns and max(widths) <= round(screen_columns * 0.55)
            )
            ragged = max(widths) - min(widths) >= max(3, round(max(widths) * 0.2))
            looks_like_verse = (
                single_values == len(block)
                or (uppercase_starts >= len(block) - 1 and verse_endings >= 2)
                or (compact and far_from_screen_edge and ragged)
            )
            if looks_like_verse:
                boundaries.update(range(block_start, block_end - 1))

        block_start = block_end + 1
    return boundaries


def _joiner(left: str, right: str) -> str:
    if left.endswith("-") and right[:1].isalpha():
        return ""
    if right[:1] in ",.;:!?)]}":
        return ""
    return " "


def smart_unwrap(text: str, screen_columns: int | None = None) -> str:
    """Join likely hard-wrapped prose lines, preserving meaningful structure."""
    text = text.replace("\r\n", "\n").replace("\r", "\n")
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
    likely_wrap_width = max(8, round(reference_width * 0.65))
    poetry_boundaries = _poetry_boundaries(lines, screen_columns)
    table_boundaries = _table_boundaries(lines)
    code_block_boundaries = _code_block_boundaries(lines)

    output = lines[0].rstrip()
    for index, (left, right) in enumerate(itertools.pairwise(lines)):
        left = left.rstrip()
        right_stripped = right.strip()

        preserve_break = (
            not left.strip()
            or not right_stripped
            or _looks_structured(right)
            or (_looks_structured(left) and not _LIST_START.match(left))
            or _looks_like_code(left)
            or _looks_like_code(right)
            or _looks_like_resource(left)
            or _looks_like_resource(right)
            or _looks_like_config(left)
            or _looks_like_config(right)
            or _looks_like_command(left)
            or _looks_like_command(right)
            or _same_command_family(left, right)
            or (_is_single_value(left) and _is_single_value(right))
            or index in poetry_boundaries
            or index in table_boundaries
            or index in code_block_boundaries
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
