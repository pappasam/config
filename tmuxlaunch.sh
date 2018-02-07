#!/bin/bash

# stop script if encounter errors
# prevents script from making changes to previously running session
# if one already exists
set -e

if [[ $# > 0 ]]; then
  SESSION=$1
else
  SESSION=SR
fi

# Create session in detached mode
tmux new-session -d -s $SESSION

# Select first window
tmux select-window -t $SESSION:1

# Rename first window to 'edit'
tmux rename-window edit

# Attach to session newly-created session
tmux attach -t $SESSION
