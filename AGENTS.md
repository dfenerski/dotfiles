## Overview

This repository syncs selected dotfiles between the repo and `~/.config`, with simple Makefile workflows and clear, readable diffs.

## Commands

- make diff — colorized preview of changes; non‑zero exit if differences. Uses:
  - File diffs: git --no-pager diff --no-index (fallback to diff)
  - Directory summaries: rsync -rcni --delete with excludes and a legend
- make push — sync from repo ➜ `$CONFIG_HOME`
- make pull — sync from `$CONFIG_HOME` ➜ repo
- make reset — remove synced directories from the repo
- make check-deps — ensure rsync/sed and scripts are executable
- make check-syntax — run bash -n on all scripts

## Paths tracked (repo ↔ $CONFIG_HOME)

- nvim/nvim ↔ $CONFIG_HOME/nvim
- tmux/tmux.conf ↔ $CONFIG_HOME/tmux/tmux.conf
- bash/.bashrc ↔ $CONFIG_HOME/bash/.bashrc (CONFIG copy is transformed for diffs)
- Code/User/settings.json ↔ $CONFIG_HOME/Code/User/settings.json
- Code/User/keybindings.json ↔ $CONFIG_HOME/Code/User/keybindings.json
- scripts/ ↔ $CONFIG_HOME/scripts
- nix/ ↔ $CONFIG_HOME/nix

## Script behavior

- sync_config.sh — copies from repo into $CONFIG_HOME; validates sources; requires rsync.
- sync_repo.sh — copies from $CONFIG_HOME back into the repo; transforms bash/.bashrc via:
  - sed '/MP=/d; /getmp/{N;N;N;d;}'
- diff.sh — readable diffs:
  - Files: git diff --no-index (or diff)
  - Dirs: rsync -rcni --delete with excludes like .git/, swap files, .DS_Store, plus a legend
- reset_repo.sh — clears all synced dirs

Tip: all scripts must be kept in sync with the tracked directories!

## Neovim layout and conventions

- Entry: nvim/nvim/init.lua → lua/dfenerski/init.lua (opts, keymaps, quickfix, plugins, LSP, theme)
- Plugins: declared per-file **with vim.pack.add**; add require('dfenerski.plugin.<name>') in dfenerski/init.lua
- LSP: lua_ls, pyright, tinymist, ts_ls (install via Nix; see comments)
- Treesitter: languages configured in plugin/treesitter.lua (ensure_installed)
- Theme: maxmx03/solarized.nvim with vim.o.background = 'dark'

## Keymaps (Leader = space)

- Telescope: <leader>ff (git files), <leader>fg (live grep args), <leader>fl (LSP symbols), <leader>sf (prompt grep)
- Oil: - (open parent dir); <leader>ll (toggle detail columns)
- Quickfix: <leader>j/<leader>k (next/prev); dd in qf removes; <leader>aq appends location
- Editing: <leader>f (format via LSP); <leader>ih (toggle inlay hints); Ctrl-/ (native comment); <leader>z (Undotree)
- Harpoon: <leader>ah/<leader>sh; Git: <leader>gs
- Custom: :Translate and <leader>t transliterate Shlyokavica → Cyrillic (skips $…$ unless quoted)

## Tmux

- Config: tmux/tmux.conf. Uses TPM (tmux-plugins/tpm). Install/update with TPM: prefix C-b then I.
- Pane nav integrated with Neovim: C-h/j/k/l.

## VS Code

- Settings and keybindings live in Code/User and are included in the sync flows.

## Adding a new tracked directory

When you want to mirror another directory between the repo and $CONFIG_HOME, update scripts and docs consistently.

1. sync_config.sh (repo ➜ $CONFIG_HOME)

   - Add validation: [ -d "repo_dir" ] || die "Missing source directory: repo_dir"
   - Ensure destination: mkdir -p "$CONFIG_HOME/target_dir"
   - Add sync: rsync -rv "repo_dir/" "$CONFIG_HOME/target_dir"

2. sync_repo.sh ($CONFIG_HOME ➜ repo)

   - Ensure repo path: mkdir -p repo_dir
   - Validate source: [ -d "$CONFIG_HOME/target_dir" ] || die "Missing source directory: $CONFIG_HOME/target_dir"
   - Add sync: rsync -rv --exclude ".git" "$CONFIG_HOME/target_dir/" repo_dir

3. diff.sh

   - Add repo existence note: [ -d "repo_dir" ] || note "Repo: repo_dir not found (skipping)"
   - Add section: compare_dir "repo_dir" "$CONFIG_HOME/target_dir" "repo_dir/ (repo vs $CONFIG_HOME/target_dir)"
   - Prefer rsync summary for directories; add excludes if needed.

4. reset_repo.sh

   - Add the new repo_dir to the removal list so make reset cleans it.

5. Documentation
   - Update this Paths tracked section with repo_dir ↔ $CONFIG_HOME/target_dir

Notes:

- Keep directory names in the repo simple; map to the $CONFIG_HOME target as needed.
- For special cases (like bash/.bashrc), normalize the $CONFIG_HOME copy in sync_repo.sh to keep diffs stable.

## Gotchas

- Scripts are strict: they fail if expected paths (e.g., scripts/, nix/) are missing. Create them or relax checks before running.
- Always run make diff before push/pull to avoid clobbering changes.
- Keep secrets out of the repo.
