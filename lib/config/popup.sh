
# . $HOME/.x-cmd/xrc/latest
. "${___X_CMD_ROOT_MOD}/xrc/latest"

# Command Pallate

echo "Command:"
select name in "Vertical-Split" "Horizontal-Split" "New-Window" "Kill-Window" "New-Session" "choose-client"
do
    case "$name" in
        Vertical-Split)         tmux split-window -v;   exit ;;
        Horizontal-Split)       tmux split-window -h;   exit ;;
        New-Window)             tmux new-window;        exit ;;
        Kill-Window)            tmux kill-window;       exit ;;
        Kill-Session)           tmux kill-window;       exit ;;
        Kill-Panel)             tmux kill-window;       exit ;;
        New-Session)            tmux new-session;       exit ;;
        choose-client)          tmux choose-client;     exit ;;
        *)                      ;;
    esac
done
