# shellcheck shell=sh

# . "${___X_CMD_ROOT_MOD}/xrc/latest"
. "${___X_CMD_ROOT_MOD}/xrc/latest"

___X_CMD_TMUX_BIN="${___X_CMD_TMUX_BIN:-tmux}"

# Plugin management
xrc:mod tmux/lib/config/plugin-util.sh

xrc:mod     tmux/lib/config/plugin-copy.sh      \
            tmux/lib/config/plugin-control.sh   \
            tmux/lib/config/plugin-scroll.sh    \
            tmux/lib/config/plugin-theme-default.sh
