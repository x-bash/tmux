
___x_cmd_tmux_set_color(){
    : bg : color222 color111 color150 color140
    x tmux set status-bg "$1"
    # x tmux set status-fg "$2"
}


tmux source-file $___X_CMD_ROOT_MOD/tmux/lib/style/entrance.tmux.conf

tmux setw -g    window-status-separator ' '
tmux setw -g    window-status-format "#I:#W "
tmux setw -g    window-status-current-format "#[fg=red,bg=blue]#I:#W "

tmux set -g     status-right-style "bg=yellow"

# tmux set -g     status-left "#(tmux show -v mouse)  "

# tmux set -g     status-left "#(date +%H:%M)  "

# tmux set-interval 1
# tmux set -g     status-left "#(date +%T)  "

tmux set -g     status-right "#{host} #(date +%H:%M)"

tmux bind M     set mouse

tmux bind b     display-menu \
    split-vertical      '-'     "split-window -v" \
    split-horizontal    '|'     "split-window -h"

