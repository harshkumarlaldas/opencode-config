#!/usr/bin/env bash
# Bootstraps opencode on macOS/Linux using this repo's shared config.
#
# What it does:
#   1. Installs the opencode CLI if it isn't already on PATH.
#   2. Symlinks opencode.json and AGENTS.md into opencode's global config
#      directory (~/.config/opencode) so every machine that runs this script
#      behaves the same way.
#   3. Clones/updates the GeniusOrchestrator skills repo alongside this one
#      and copies its skills/ into opencode's global skills directory, so
#      the same personal skill library (newsletter engine, LinkedIn content,
#      research-niche, telegram-notify) is available from any project,
#      the same way it's available from any Claude Code session via the
#      genius-orchestrator plugin.
#
# Usage: ./scripts/install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config/opencode"
GENIUS_ORCHESTRATOR_REPO="https://github.com/harshkumarlaldas/GeniusOrchestrator.git"
GENIUS_ORCHESTRATOR_DIR="$(dirname "$REPO_DIR")/GeniusOrchestrator"

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

# --- Sync GeniusOrchestrator skills into opencode's global skills dir ---
if command -v git >/dev/null 2>&1; then
  if [ -d "$GENIUS_ORCHESTRATOR_DIR/.git" ]; then
    git -C "$GENIUS_ORCHESTRATOR_DIR" pull --ff-only || echo "Couldn't fast-forward GeniusOrchestrator, skipping skill sync this run."
  else
    git clone "$GENIUS_ORCHESTRATOR_REPO" "$GENIUS_ORCHESTRATOR_DIR" || echo "Couldn't clone GeniusOrchestrator (private repo — check your git credentials), skipping skill sync."
  fi

  if [ -d "$GENIUS_ORCHESTRATOR_DIR/skills" ]; then
    mkdir -p "$CONFIG_DIR/skills"
    for skill in "$GENIUS_ORCHESTRATOR_DIR"/skills/*/; do
      name="$(basename "$skill")"
      rm -rf "$CONFIG_DIR/skills/$name"
      cp -r "$skill" "$CONFIG_DIR/skills/$name"
      echo "Synced skill: $name"
    done
  fi
else
  echo "git not found — skipping GeniusOrchestrator skill sync."
fi

echo
echo "Done. Next steps:"
echo "  1. Run 'opencode auth login' to connect a provider (OpenCode Zen recommended)."
echo "  2. Run 'opencode' from any project to start."
