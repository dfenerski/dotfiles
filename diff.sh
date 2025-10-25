#!/usr/bin/env bash

set -euo pipefail

CONFIG_HOME="${CONFIG_HOME:-${HOME}/.config}"

die() { echo "Error: $*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

# Choose a diff function
if have git; then
	diff_cmd() {
		# git diff returns 1 when differences found; 0 when none; 2 on error
		git --no-pager diff --no-index --color=always -U1 -- "$1" "$2" || {
			rc=$?; [ $rc -eq 1 ] && return 1 || return $rc
		}
		return 0
	}
else
	have diff || die "Neither git nor diff is available. Install git or diffutils."
	diff_cmd() {
		# Fallback without colors
		diff -ruN -- "$1" "$2" || {
			rc=$?; [ $rc -eq 1 ] && return 1 || return $rc
		}
		return 0
	}
fi

bold="\033[1m"; dim="\033[2m"; red="\033[31m"; green="\033[32m"; yellow="\033[33m"; blue="\033[34m"; reset="\033[0m"

header() { printf "\n${bold}${blue}==>${reset} %s\n" "$1"; }
note()   { printf "${dim}%s${reset}\n" "$1"; }

# For directory comparisons, prefer an rsync summary with excludes for readability
compare_dir() {
	local left="$1" right="$2" title="$3"
	header "$title"
	if [ ! -d "$left" ] && [ ! -d "$right" ]; then
		echo "Both directories missing: $left | $right"
		return 0
	fi
	if ! have rsync; then
		note "rsync not available; falling back to raw diff"
		compare "$left" "$right" "$title"
		return $?
	fi
	# Common excludes to keep output minimal
	local excludes=(
		--exclude ".git/"
		--exclude "*.swp" --exclude "*.swo"
		--exclude ".DS_Store"
	)
	# rsync --dry-run summary; -i itemize changes, -r recursive, -c checksum for accuracy
	local output
	if output=$(rsync -rcni --delete "${excludes[@]}" -- "$left/" "$right/" 2>/dev/null); then
		# rsync prints a list; first line can be blank depending on versions
		# Filter out the leading sending/receiving lines if any
		output=$(echo "$output" | sed '/^sending/ d; /^receiving/ d; /^$/ d')
		if [ -z "$output" ]; then
			echo "No changes"
		else
			any_changes=1
			# Colorize change indicators lightly
			echo "$output" | sed -E \
				-e "s/^>f\.\.\.\.\.\./${green}&${reset}/" \
				-e "s/^>f\+\+\+\+\+\+/${yellow}&${reset}/" \
				-e "s/^\.d\.\.\.\.\.\./${dim}&${reset}/" \
				-e "s/^\*deleting/${red}&${reset}/"
			note "Legend: >f++++++ add file, >f..... update, *deleting remove, .d..... directory"
		fi
	else
		printf "${red}rsync comparison failed${reset}\n"
		return 2
	fi
}

# Validate expected repo structure
[ -d "nvim/nvim" ] || note "Repo: nvim/nvim not found (skipping)"
[ -f "tmux/tmux.conf" ] || note "Repo: tmux/tmux.conf not found (skipping)"
[ -f "bash/.bashrc" ] || note "Repo: bash/.bashrc not found (skipping)"
[ -f "Code/User/settings.json" ] || note "Repo: Code/User/settings.json not found (skipping)"
[ -f "Code/User/keybindings.json" ] || note "Repo: Code/User/keybindings.json not found (skipping)"

any_changes=0

compare() {
	local left="$1" right="$2" title="$3"
	header "$title"
	if [ ! -e "$left" ] && [ ! -e "$right" ]; then
		echo "Both sides missing: $left | $right"
		return 0
	fi
	if diff_output=$(diff_cmd "$left" "$right" 2>&1); then
		# No differences
		echo "No changes"
	else
		rc=$?
		if [ $rc -eq 1 ]; then
			any_changes=1
			echo "$diff_output"
		else
			printf "${red}Diff error (%d)${reset}\n" "$rc"
			echo "$diff_output"
			return $rc
		fi
	fi
}

echo -e "Comparing repo (left) -> ${CONFIG_HOME} (right)"

# nvim directory
if [ -d "nvim/nvim" ] || [ -d "${CONFIG_HOME}/nvim" ]; then
	compare_dir "nvim/nvim" "${CONFIG_HOME}/nvim" "nvim/ (repo nvim/nvim vs ${CONFIG_HOME}/nvim)"
fi

# tmux.conf
if [ -f "tmux/tmux.conf" ] || [ -f "${CONFIG_HOME}/tmux/tmux.conf" ]; then
	compare "tmux/tmux.conf" "${CONFIG_HOME}/tmux/tmux.conf" "tmux/tmux.conf"
fi

# bashrc (with transform applied to CONFIG copy to match repo convention)
if [ -f "bash/.bashrc" ] || [ -f "${CONFIG_HOME}/bash/.bashrc" ]; then
	tmp_bashrc=""
	if [ -f "${CONFIG_HOME}/bash/.bashrc" ]; then
		tmp_bashrc=$(mktemp)
		# Apply the same transform as sync_repo.sh
		# Remove lines with MP= and the 3-line block following a line matching getmp
		sed '/MP=/d; /getmp/{N;N;N;d;}' "${CONFIG_HOME}/bash/.bashrc" >"${tmp_bashrc}"
	fi
	left="bash/.bashrc"
	right="${tmp_bashrc:-${CONFIG_HOME}/bash/.bashrc}"
	compare "$left" "$right" "bash/.bashrc (repo) vs ${CONFIG_HOME}/bash/.bashrc (transformed)"
	[ -n "${tmp_bashrc}" ] && rm -f "${tmp_bashrc}"
fi

# VS Code settings
if [ -f "Code/User/settings.json" ] || [ -f "${CONFIG_HOME}/Code/User/settings.json" ]; then
	compare "Code/User/settings.json" "${CONFIG_HOME}/Code/User/settings.json" "VS Code settings.json"
fi

if [ -f "Code/User/keybindings.json" ] || [ -f "${CONFIG_HOME}/Code/User/keybindings.json" ]; then
	compare "Code/User/keybindings.json" "${CONFIG_HOME}/Code/User/keybindings.json" "VS Code keybindings.json"
fi

echo
if [ "$any_changes" -eq 1 ]; then
	echo -e "${yellow}Differences found.${reset}"
	exit 1
else
	echo -e "${green}No differences across checked items.${reset}"
fi

