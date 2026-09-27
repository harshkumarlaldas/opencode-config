#!/usr/bin/env bash
# Bootstraps opencode on macOS/Linux using this repo's shared config.
#
# What it does:
#   1. Installs the opencode CLI if it isn't already on PATH.
#   2. Symlinks opencode.json and AGENTS.md into opencode's global config
#      directory (~/.config/opencode) so every machine that runs this script
#      behaves the same way.
#
# Usage: ./scripts/install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config/opencode"

if ! command -v opencode >/dev/null 2>&1; then
  echo "opencode not found, installing..."
  curl -fsSL https://opencode.ai/install | bash
else
  echo "opencode is already installed ($(opencode --version 2>/dev/null || echo 'version unknown'))."
fi

mkdir -p "$CONFIG_DIR"

for f in opencode.json AGENTS.md; do
  ln -sf "$REPO_DIR/$f" "$CONFIG_DIR/$f"
  echo "Linked $CONFIG_DIR/$f -> $REPO_DIR/$f"
done

echo
echo "Done. Next steps:"
echo "  1. Run 'opencode auth login' to connect a provider (OpenCode Zen recommended)."
echo "  2. Run 'opencode' from any project to start."
