#!/usr/bin/env bash

set -euo pipefail

# Remove selected directories in the repo if they exist
for path in ./nvim ./tmux ./bash ./Code ./scripts ./nix ./yazi ./sioyek; do
	if [ -e "$path" ]; then
		echo "Removing $path"
		rm -rf -- "$path"
	else
		echo "Skip (not found): $path"
	fi
done

echo "Reset complete."

