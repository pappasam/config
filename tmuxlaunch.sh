#!/bin/bash

# stop script if encounter errors
# prevents script from making changes to previously running session
# if one already exists
set -e

SESSION=SR

# Create session in detached mode
tmux new-session -d -s $SESSION

# Change directory to source code and select first window
tmux select-window -t $SESSION:0
tmux send-keys 'cd ~/src; clear' C-m

# Rename first window to 'edit'
tmux rename-window edit

# Attach to session newly-created session
tmux attach -t $SESSION
