#!/usr/bin/env bash
set -euo pipefail

AGENTS_DIR="$HOME/.claude/agents"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Removing spec-driven development agents from $AGENTS_DIR ..."

for f in "$SCRIPT_DIR/agents/"*.md; do
  name="$(basename "$f")"
  target="$AGENTS_DIR/$name"
  if [[ -f "$target" ]]; then
    rm "$target"
    echo "  removed  $name"
  fi
done

echo ""
echo "Done. Restart Claude Code to apply changes."
