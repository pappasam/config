#!/bin/bash

SESSION=SR

# Create session in detached mode
tmux new-session -d -s $SESSION

# Change directory to source code and select first window
tmux select-window -t $SESSION:0
tmux send-keys 'cd ~/src; clear' C-m

# Rename first window to 'edit'
tmux rename-window edit

# Attach to session
tmux attach -t $SESSION
