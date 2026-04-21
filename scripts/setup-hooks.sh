#!/usr/bin/env bash
# scripts/setup-hooks.sh — Install git pre-commit hook

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK_SRC="$SCRIPT_DIR/pre-commit"
GIT_HOOKS_DIR="$(git rev-parse --git-dir 2>/dev/null)/hooks"

if [[ ! -d "$GIT_HOOKS_DIR" ]]; then
    echo "Not a git repository. Skipping hook setup."
    exit 0
fi

if [[ -f "$HOOK_SRC" ]]; then
    cp "$HOOK_SRC" "$GIT_HOOKS_DIR/pre-commit"
    chmod +x "$GIT_HOOKS_DIR/pre-commit"
    echo "Pre-commit hook installed"
else
    echo "Warning: pre-commit hook source not found at $HOOK_SRC"
fi
