#!/usr/bin/env bash

set -euo pipefail

CONFIG_HOME="${HOME}/.config"

die() { echo "Error: $*" >&2; exit 1; }

# Require rsync
command -v rsync >/dev/null 2>&1 || die "rsync is required but not installed."

# Ensure destination directories exist in repo
mkdir -p tmux
mkdir -p bash
mkdir -p Code/User
mkdir -p nvim
mkdir -p scripts
mkdir -p nix

# Validate sources exist in CONFIG_HOME
[ -d "${CONFIG_HOME}/nvim" ] || die "Missing source directory: ${CONFIG_HOME}/nvim"
[ -f "${CONFIG_HOME}/tmux/tmux.conf" ] || die "Missing source file: ${CONFIG_HOME}/tmux/tmux.conf"
[ -f "${CONFIG_HOME}/bash/.bashrc" ] || die "Missing source file: ${CONFIG_HOME}/bash/.bashrc"
[ -f "${CONFIG_HOME}/Code/User/settings.json" ] || die "Missing source file: ${CONFIG_HOME}/Code/User/settings.json"
[ -f "${CONFIG_HOME}/Code/User/keybindings.json" ] || die "Missing source file: ${CONFIG_HOME}/Code/User/keybindings.json"
[ -d "${CONFIG_HOME}/scripts" ] || die "Missing source directory: ${CONFIG_HOME}/scripts"
[ -d "${CONFIG_HOME}/nix" ] || die "Missing source directory: ${CONFIG_HOME}/nix"

echo "Syncing ${CONFIG_HOME}/nvim -> repo nvim/"
rsync -rv --exclude ".git" "${CONFIG_HOME}/nvim" nvim

echo "Syncing ${CONFIG_HOME}/tmux/tmux.conf -> repo tmux/tmux.conf"
rsync -v "${CONFIG_HOME}/tmux/tmux.conf" tmux/tmux.conf

echo "Transforming and syncing ${CONFIG_HOME}/bash/.bashrc -> repo bash/.bashrc"
sed '/MP=/d; /getmp/{N;N;N;d;}' "${CONFIG_HOME}/bash/.bashrc" > bash/.bashrc

echo "Syncing VS Code settings -> repo Code/User"
rsync -v "${CONFIG_HOME}/Code/User/settings.json" Code/User/settings.json
rsync -v "${CONFIG_HOME}/Code/User/keybindings.json" Code/User/keybindings.json

echo "Syncing ${CONFIG_HOME}/scripts -> repo scripts/"
rsync -rv --exclude ".git" "${CONFIG_HOME}/scripts/" scripts

echo "Syncing ${CONFIG_HOME}/nix -> repo nix/"
rsync -rv --exclude ".git" "${CONFIG_HOME}/nix/" nix

echo "Sync complete."
