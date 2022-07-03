
. $HOME/.x-cmd/xrc/latest
# . "${___X_CMD_ROOT_MOD}/xrc/latest"

# Command Pallate

echo "Command:"
select name in "choose-tree" "vertical-split" "horizontal-split" "new-window" "kill-window" "new-session"
do
    case "$name" in
        choose-tree)            tmux choose-tree;       exit ;;
        vertical-split)         tmux split-window -v;   exit ;;
        horizontal-split)       tmux split-window -h;   exit ;;
        new-window)             tmux new-window;        exit ;;
        kill-window)            tmux kill-window;       exit ;;
        kill-session)           tmux kill-window;       exit ;;
        kill-panel)             tmux kill-window;       exit ;;
        new-session)            tmux new-session;       exit ;;
        *)                      ;;
    esac
done
