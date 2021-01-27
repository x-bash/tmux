
# attach or create
function tmux.enter(){
    local answer
    if ! tmux attach -t "${1:?Session}" 2>/dev/null; then
        read -p "Session not exists; Do you want to new session(y for yes)? : " -r answer
        if [ "$answer" = y ]; then
            tmux new -s "$1"
        else
            echo "Detect not y. So quit."
        fi
    fi
}

# tmux enter
alias te=tmux.enter

# export -f ta

function tmux.reset(){
    tmux detach -t "$1"
    # TODO: then what? I forgot.
}


