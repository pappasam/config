"""Compact project labels without changing terminal window titles."""

from pathlib import Path
from typing import Any

from kitty.fast_data_types import get_boss, truncate_point_for_length, wcswidth


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
    if wcswidth(name) > width:
        name = name[:truncate_point_for_length(name, width - 1)] + "…"
    return name
