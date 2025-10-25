#!/usr/bin/env bash

set -euo pipefail

CATEGORIES=("WORK" "STUDY" "WASTE" "STOP")

selected=$(printf "%s\n" "${CATEGORIES[@]}" | fzf --height=40% --border --prompt="Select activity > ")
[[ -z "${selected:-}" ]] && exit 0

# refresh tmux bar periodically
tmux set -g status-interval 5 2>/dev/null || true

if [[ "$selected" == "STOP" ]]; then
  timew stop >/dev/null 2>&1 || true
  tmux set -g status-right "" 2>/dev/null || true
  exit 0
fi

# start tracking selected category
timew start "$selected" >/dev/null 2>&1 || true

# show current project + elapsed time in tmux
tmux set -g status-right "$selected #(timew | awk '/^ *Total/ {print \$NF}')" 2>/dev/null || true

