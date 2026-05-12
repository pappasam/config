## Screen Capture

Tools like `scrot`, `wmctrl`, `import`, and `xdotool` are available for screen capture. Use them when asked about visible windows or what's on screen.

## Shell command policy

- Prefer `rg` and `fd` for search.
- Never use `find -exec`, `find -delete`, or `find ... | xargs ...` unless I explicitly request it.
- For locating files, use `fd <pattern> <path>` or `find <path> -name <pattern> -print`.
- For reading file contents, use `rg`, `cat`, `sed -n`, `head`, or `tail`.
- Avoid shell pipelines when a single read-only command is sufficient.
- Before destructive operations, show the candidate files first and wait for confirmation.
