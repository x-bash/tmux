

# split:
#     - vertical
#     - horizontal
# new:
#     - window
#     - session
#     - pane
# kill:
#     - window
#     - session
#     - pane


. $HOME/.x-cmd/xrc/latest

while true; do
    x ui select idx "Command: " \
        "choose-tree (<PREFIX> + s)" \
        "vertical-split (<PREFIX> + \")" \
        "horizontal-split (<PREFIX> + \%)" \
        "new-window (<PREFIX> + n)" \
        "kill-window (<PREFIX> + k)" \
        "kill-panel (<PREFIX> + x)" \
        "new-session (<PREFIX> + Ctrl-C)"

    case "$idx" in
        1)              $___X_CMD_TMUX_BIN choose-tree;           exit ;;
        2)              $___X_CMD_TMUX_BIN split-window -v;       exit ;;
        3)              $___X_CMD_TMUX_BIN split-window -h;       exit ;;
        4)              $___X_CMD_TMUX_BIN new-window;            exit ;;
        5)              $___X_CMD_TMUX_BIN kill-window;           exit ;;
        6)              $___X_CMD_TMUX_BIN kill-panel;            exit ;;
        7)              $___X_CMD_TMUX_BIN new-session;           exit ;;
        *)              ;;
    esac
done

