#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROJECT_DIR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || { echo "Usage: ./uninstall.sh [--project <repo-path>]" >&2; exit 1; }
      PROJECT_DIR="$2"
      shift 2
      ;;
    -h|--help) echo "Usage: ./uninstall.sh [--project <repo-path>]"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ -n "$PROJECT_DIR" ]]; then
  [[ -d "$PROJECT_DIR" ]] || { echo "Not a directory: $PROJECT_DIR" >&2; exit 1; }
  AGENTS_DIR="$(cd "$PROJECT_DIR" && pwd)/.claude/agents"
else
  AGENTS_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/agents"
fi

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
echo "The attribution setting in settings.json is left in place; remove it manually if desired."
