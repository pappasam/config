## Screen Capture

Tools like `scrot`, `wmctrl`, `import`, and `xdotool` are available for screen capture. Use them when asked about visible windows or what's on screen.

## Command Usage

Do not use `find -exec` or `find -delete`. Use `rg`, `fd`, or `find ... -print0 | xargs -0 ...` instead. For destructive operations, first show the candidate files, then use an explicit command only after confirmation.
