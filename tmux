
# attach or create
function tmux.enter(){
    local session="${1}"
    if [ ! "$session" ]; then
        session="$(tmux ls | head -n1 | awk '{ print substr($1, 1, length($1)-1); }')"
        [ ! $session ] && echo "Please provide session. tmux.enter <session>" >&2
        read -p "Press any key into first session: $session"
    fi

    local answer
    if ! tmux attach -t "$session" 2>/dev/null; then
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


