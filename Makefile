SHELL := /usr/bin/env bash

CONFIG_HOME ?= $(HOME)/.config
SCRIPTS := sync_repo.sh sync_config.sh reset_repo.sh diff.sh

.PHONY: help pull push reset diff check-deps check-syntax

help: ## Show help
	@grep -E '^[a-zA-Z0-9_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-12s %s\n", $$1, $$2}'

check-deps: ## Verify required commands and scripts exist
	@command -v rsync >/dev/null || { echo "rsync not found"; exit 1; }
	@command -v sed   >/dev/null || { echo "sed not found"; exit 1; }
	@for s in $(SCRIPTS); do [ -x $$s ] || { echo "making $$s executable"; chmod +x $$s; }; done

check-syntax: ## bash -n on scripts
	@for s in $(SCRIPTS); do echo "checking $$s"; bash -n $$s || exit 1; done
	@echo "Syntax OK"

pull: check-deps check-syntax ## Pull from ~/.config into repo
	@./sync_repo.sh

push: check-deps check-syntax ## Push from repo into ~/.config
	@./sync_config.sh

reset: ## Remove synced directories from repo
	@./reset_repo.sh

diff: check-deps ## Show what would change (both directions)
	@./diff.sh
