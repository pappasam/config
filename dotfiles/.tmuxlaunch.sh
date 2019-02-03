#!/bin/bash

# stop script if encounter errors
# prevents script from making changes to previously running session
# if one already exists
set -e

if [[ $# > 0 ]]; then
  SESSION=$1
else
  SESSION=Main
fi

# Create session in detached mode
tmux -2 new-session -d -s $SESSION

# Select first window
tmux -2 select-window -t $SESSION:1

# Rename first window to 'edit'
tmux -2 rename-window edit

# Attach to session newly-created session
tmux -2 attach -t $SESSION
