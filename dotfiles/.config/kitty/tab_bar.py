"""Compact project labels with application-provided status indicators."""

from pathlib import Path
from typing import Any

from kitty.fast_data_types import get_boss, truncate_point_for_length, wcswidth


def status_indicator(title: str) -> str:
    # Codex blinks between these two prefixes while waiting for user input.
    for marker in ("[ ! ]", "[ . ]"):
        prefix = f"{marker} Action Required"
        if title == prefix or title.startswith(prefix + " "):
            return marker

    # Claude's working/idle icons and Codex's braille spinner frames.
    marker = title.partition(" ")[0]
    if marker in {"◐", "◑", "✳", *"⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"}:
        return marker
    return ""


def project_name(cwd: str) -> str:
    if not cwd:
        return "terminal"

    directory = Path(cwd)
    # A .git file also marks a worktree or submodule root.
    for candidate in (directory, *directory.parents):
        if (candidate / ".git").exists():
            return candidate.name or "/"
    if directory == Path.home():
        return "~"
    return directory.name or "/"


def draw_title(data: dict[str, Any]) -> str:
    tab = get_boss().tab_for_id(data["tab_id"])
    # Keep kitty's explicit tab renaming available for same-project tasks.
    name = tab.name if tab and tab.name else project_name(data["tab"].active_oldest_wd)
    name = "".join(character for character in name if character.isprintable())
    width = max(1, min(20, data["max_title_length"]))
    # Read the window title directly: the template title can be a manual tab name.
    window = tab.active_window if tab else None
    status = status_indicator(window.title) if window else ""
    # Codex's default title drops its spinner when idle. Check the whole
    # foreground group: Kitty's single-executable lookup can select a helper.
    # Background/suspended Codex sessions must not mark a shell/editor as idle.
    if (
        not status
        and window
        and any(
            Path(command[0]).name == "codex"
            for process in window.child.foreground_processes
            if (command := process["cmdline"])
        )
    ):
        status = "○"
    if wcswidth(status) > width:
        # Keep the attention symbol itself when its brackets will not fit.
        status = status.strip("[ ]")
    prefix = f"{status} " if status else ""
    width -= wcswidth(prefix)
    if width <= 0:
        return status
    if wcswidth(name) > width:
        name = name[: truncate_point_for_length(name, width - 1)] + "…"
    return prefix + name
