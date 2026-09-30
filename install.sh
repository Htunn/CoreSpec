#!/usr/bin/env bash
set -euo pipefail

AGENTS_DIR="$HOME/.claude/agents"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing spec-driven development agents to $AGENTS_DIR ..."

mkdir -p "$AGENTS_DIR"

for f in "$SCRIPT_DIR/agents/"*.md; do
  name="$(basename "$f")"
  dest="$AGENTS_DIR/$name"
  if [[ -f "$dest" ]]; then
    echo "  overwrite  $name"
  else
    echo "  install    $name"
  fi
  cp "$f" "$dest"
done

echo ""
echo "Done. Restart Claude Code to pick up the new agents."
echo ""
echo "Agents installed:"
for f in "$SCRIPT_DIR/agents/"*.md; do
  name="$(basename "$f" .md)"
  echo "  - $name"
done
