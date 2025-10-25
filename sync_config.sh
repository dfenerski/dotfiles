#!/usr/bin/env bash

set -euo pipefail

CONFIG_HOME="${HOME}/.config"

die() { echo "Error: $*" >&2; exit 1; }

# Require rsync
command -v rsync >/dev/null 2>&1 || die "rsync is required but not installed."

# Validate sources exist in repo
[ -d "nvim/nvim" ] || die "Missing source directory: nvim/nvim"
[ -f "tmux/tmux.conf" ] || die "Missing source file: tmux/tmux.conf"
[ -f "bash/.bashrc" ] || die "Missing source file: bash/.bashrc"
[ -f "Code/User/settings.json" ] || die "Missing source file: Code/User/settings.json"
[ -f "Code/User/keybindings.json" ] || die "Missing source file: Code/User/keybindings.json"
[ -d "scripts" ] || die "Missing source directory: scripts"
[ -d "nix" ] || die "Missing source directory: nix"

# Ensure destination directories under ~/.config
mkdir -p "${CONFIG_HOME}/nvim"
mkdir -p "${CONFIG_HOME}/tmux"
mkdir -p "${CONFIG_HOME}/bash"
mkdir -p "${CONFIG_HOME}/Code/User"
mkdir -p "${CONFIG_HOME}/scripts"
mkdir -p "${CONFIG_HOME}/nix"

echo "Syncing nvim -> ${CONFIG_HOME}/nvim"
rsync -rv "nvim/nvim/" "${CONFIG_HOME}/nvim"

echo "Syncing tmux.conf -> ${CONFIG_HOME}/tmux/tmux.conf"
rsync -v "tmux/tmux.conf" "${CONFIG_HOME}/tmux/tmux.conf"

echo "Syncing .bashrc -> ${CONFIG_HOME}/bash/.bashrc"
rsync -v "bash/.bashrc" "${CONFIG_HOME}/bash/.bashrc"

echo "Syncing VS Code settings -> ${CONFIG_HOME}/Code/User"
rsync -v "Code/User/settings.json" "${CONFIG_HOME}/Code/User/settings.json"
rsync -v "Code/User/keybindings.json" "${CONFIG_HOME}/Code/User/keybindings.json"

echo "Syncing scripts -> ${CONFIG_HOME}/scripts"
rsync -rv "scripts/" "${CONFIG_HOME}/scripts"

echo "Syncing nix -> ${CONFIG_HOME}/nix"
rsync -rv "nix/" "${CONFIG_HOME}/nix"

echo "Sync complete."

