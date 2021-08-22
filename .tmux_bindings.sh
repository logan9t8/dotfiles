#!/bin/bash

# Switch pane layout
tmux bind -n "M-v" select-layout "main-horizontal" \\\; select-layout -E
tmux bind -n "M-h" select-layout "main-vertical" \\\; select-layout -E

# Split pane
tmux bind -n "M-H" split-window -h
tmux bind -n "M-V" split-window -v

# Toggle pane zoom
tmux bind -n "M-f" resize-pane -Z

for i in {0..9}; do
    tmux bind -n "M-$i" if-shell "tmux select-window -t :$i" "" "new-window -t :$i" # Change window
    shift_num=$(echo '!@#$%^&*()' | cut -c $i)
    tmux bind -n "M-$shift_num" if-shell "tmux join-pane -t :$i" "" \
        "new-window -dt :$i; join-pane -t :$i; select-pane -t top-left; kill-pane" \\\; select-layout \\\; select-layout -E # Move pane to window
done

# Refresh the current layout (e.g. after deleting a pane).
tmux bind -n "M-r" select-layout -E

# Switch to pane via Alt + cursor.
tmux bind -n "M-up" select-pane -U
tmux bind -n "M-down" select-pane -D
tmux bind -n "M-left" select-pane -L
tmux bind -n "M-right" select-pane -R

tmux bind -n "M-i" select-pane -U
tmux bind -n "M-k" select-pane -D
tmux bind -n "M-j" select-pane -L
tmux bind -n "M-l" select-pane -R

# Move a pane via Alt + Shift + cursor.
tmux bind -n "M-S-up" swap-pane -s '{up-of}'
tmux bind -n "M-S-down" swap-pane -s '{down-of}'
tmux bind -n "M-S-left" swap-pane -s '{left-of}'
tmux bind -n "M-S-right" swap-pane -s '{right-of}'

tmux bind -n "M-I" swap-pane -s '{up-of}'
tmux bind -n "M-K" swap-pane -s '{down-of}'
tmux bind -n "M-J" swap-pane -s '{left-of}'
tmux bind -n "M-L" swap-pane -s '{right-of}'

# Name a window with Alt + n.
tmux bind -n "M-n" command-prompt -p 'Workspace name:' 'rename-window "%%"'

# Close a window with Alt + Shift + q.
tmux bind -n "M-Q" kill-pane

# Reload configuration with Alt + Shift + r.
tmux bind -n "M-R" source-file ~/.tmux.conf \\\; display "Reloaded config"
