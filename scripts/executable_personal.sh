#!/bin/env bash

# Define directory paths
FE_DIR="$HOME/personal/school-management"
BE_DIR="$HOME/personal/school-management"

# Create new tmux session named "work" with first window
tmux new-session -d -s work -n frontend

# Window 1: Frontend - navigate to frontend directory and clear screen
tmux send-keys -t work:1 "cd $FE_DIR && clear" C-m

# Window 2: Frontend Server - create window and navigate to frontend directory and clear screen
tmux new-window -t work -n frontend-server
tmux send-keys -t work:2 "cd $FE_DIR && clear" C-m

# Window 3: Backend - create window and navigate to backend directory and clear screen
tmux new-window -t work -n backend
tmux send-keys -t work:3 "cd $BE_DIR && clear" C-m

# Window 4: Backend Server - create window and navigate to backend directory and clear screen
tmux new-window -t work -n backend-server
tmux send-keys -t work:4 "cd $BE_DIR && clear" C-m

# Select the first window
tmux select-window -t work:1

# Attach to the session
tmux attach-session -t work
