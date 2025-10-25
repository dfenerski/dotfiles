#!/bin/bash

DIRS=(
    "$HOME/Projects"
    "$HOME/Notes"
    "$HOME/University"
)
SPECIFIC_DIRS=(
    "$HOME/.config/nvim"
    "$HOME/.config/tmux"
    "$HOME/.config/scripts"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    choices=$(
        {
            fd . "${DIRS[@]}" --type=dir --max-depth=1 --full-path --base-directory "$HOME";
            for d in "${SPECIFIC_DIRS[@]}"; do
                echo "${d/#$HOME\//}"
            done
        }
    )
    selected=$(
        printf "%s\n" "$choices" \
        | sed "s|^$HOME/||" \
        | fzf --height=40% --border --reverse --prompt="Pick session: "
    )

    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ -z $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name"

