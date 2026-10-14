#!/bin/bash

# Keep "gedit" in the basename so Claude Code preserves its conversation view
# while waiting, without adding VS Code's -g filename:line arguments.
# Use Neovim directly for multiple files, new files, stdin, and editor-specific
# arguments. Tabbed editing needs the socket configured in kitty.conf.
# See: <https://github.com/anthropics/claude-code/issues/20045>
# and: <https://github.com/anthropics/claude-code/issues/20045#issuecomment-4149259186>
if [[ -n "${KITTY_WINDOW_ID:-}" && -z "${SSH_CONNECTION:-}${SSH_TTY:-}${TMUX:-}${STY:-}" ]] &&
  [[ "${KITTY_LISTEN_ON:-}" == unix:* && -S "${KITTY_LISTEN_ON#unix:}" ]] &&
  [[ -t 0 && -t 1 ]] &&
  [[ $# -eq 1 && -f "$1" && "$1" != -* && "$1" != +* ]] &&
  command -v kitten >/dev/null 2>&1; then
  nvim_path="$(command -v nvim)" || exit 127
  # edit-in-kitty writes status messages into the caller's display. Use the
  # socket instead, and capture the editor's exit code without touching the TTY.
  # A separate tab keeps the caller's terminal dimensions unchanged.
  editor_status="$(kitten @ --to "$KITTY_LISTEN_ON" launch \
    --type=tab --location=after \
    --match "window_id:$KITTY_WINDOW_ID" --next-to "id:$KITTY_WINDOW_ID" \
    --cwd "$PWD" --env "PATH=$PATH" --wait-for-child-to-exit \
    -- "$nvim_path" -- "$1")" || exit "$?"
  if [[ "$editor_status" =~ ^[0-9]+$ ]]; then
    exit "$editor_status"
  fi
  printf 'Neovim did not exit normally: %s\n' "$editor_status" >&2
  exit 1
fi

exec nvim "$@"
