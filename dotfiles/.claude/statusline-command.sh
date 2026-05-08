#!/usr/bin/env bash
# Claude Code status line script
#
# To enable, add the following to ~/.claude/settings.json:
#
#   "statusLine": {
#     "type": "command",
#     "command": "bash ~/.claude/statusline-command.sh"
#   }
#
# Displays: dir + git branch (colored) + python venv + model + context

COLOR_BRIGHT_BLUE="\033[38;5;115m"
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_ORANGE="\033[38;5;202m"
COLOR_SILVER="\033[38;5;248m"
COLOR_RESET="\033[0m"
COLOR_BOLD="\033[1m"

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten cwd: replace $HOME with ~, then abbreviate intermediate dirs
home_dir="$HOME"
short_dir="${cwd/#$home_dir/\~}"
short_dir=$(echo "$short_dir" | sed -E 's|([^/.])[^/]+/|\1/|g')

# Git info (skip lock to avoid blocking)
git_status=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" status 2>/dev/null)
git_branch=""
git_color="$COLOR_SILVER"
if [[ -n "$git_status" ]]; then
  on_branch_re="On branch ([^[:space:]]+)"
  on_commit_re="HEAD detached at ([^[:space:]]+)"
  if [[ "$git_status" =~ $on_branch_re ]]; then
    git_branch=" ${BASH_REMATCH[1]}"
  elif [[ "$git_status" =~ $on_commit_re ]]; then
    git_branch=" ${BASH_REMATCH[1]}"
  fi

  if [[ "$git_status" =~ "not staged for commit" ]]; then
    git_color="$COLOR_RED"
  elif [[ "$git_status" =~ "Your branch is ahead of" ]]; then
    git_color="$COLOR_YELLOW"
  elif [[ "$git_status" =~ "nothing to commit" ]]; then
    git_color="$COLOR_GREEN"
  else
    git_color="$COLOR_ORANGE"
  fi
fi

# Python virtualenv
venv_part=""
if [[ -n "$VIRTUAL_ENV" ]]; then
  venv_part=" ($(basename "$VIRTUAL_ENV"))"
fi

# Model (short label)
model_part=""
if [[ -n "$model" ]]; then
  model_part=" [$model]"
fi

# Context usage
ctx_part=""
if [[ -n "$used_pct" ]]; then
  ctx_part=$(printf " ctx:%.0f%%" "$used_pct")
fi

printf "${COLOR_BOLD}${COLOR_BRIGHT_BLUE}%s${COLOR_RESET}" "$short_dir"
printf "${COLOR_BOLD}${git_color}%s${COLOR_RESET}" "$git_branch"
printf "${COLOR_BOLD}${COLOR_SILVER}%s${COLOR_RESET}" "$venv_part"
printf "${COLOR_SILVER}%s%s${COLOR_RESET}" "$model_part" "$ctx_part"
printf "\n"
