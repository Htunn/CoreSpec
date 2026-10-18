#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_DIR="$SCRIPT_DIR/copilot"

PROJECT_DIR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || { echo "Usage: ./uninstall-copilot.sh [--project <repo-path>]" >&2; exit 1; }
      PROJECT_DIR="$2"
      shift 2
      ;;
    -h|--help) echo "Usage: ./uninstall-copilot.sh [--project <repo-path>]"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ -n "$PROJECT_DIR" ]]; then
  [[ -d "$PROJECT_DIR" ]] || { echo "Not a directory: $PROJECT_DIR" >&2; exit 1; }
  PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
  SKILL_DIRS=(
    "$PROJECT_DIR/.github/skills"
    "$PROJECT_DIR/.claude/skills"
  )
  echo "Removing Agent Skills from project $PROJECT_DIR ..."
else
  SKILL_DIRS=(
    "$HOME/.copilot/skills"
    "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"
    "$HOME/.agents/skills"
  )
  echo "Removing Agent Skills from the user profile ..."
fi

for skills_dir in "${SKILL_DIRS[@]}"; do
  rel_dir="${skills_dir/#$HOME/~}"
  for skill_dir in "$COPILOT_DIR/skills/"*/; do
    skill_name="$(basename "$skill_dir")"
    target_skill="$skills_dir/$skill_name/SKILL.md"
    target_skill_dir="$skills_dir/$skill_name"
    if [[ -f "$target_skill" ]]; then
      rm "$target_skill"
      echo "  removed  $rel_dir/$skill_name/SKILL.md"
    fi
    if [[ -d "$target_skill_dir" ]] && [[ -z "$(ls -A "$target_skill_dir")" ]]; then
      rmdir "$target_skill_dir"
      echo "  removed  $rel_dir/$skill_name/ (empty)"
    fi
  done
  # Remove skills dir if now empty
  if [[ -d "$skills_dir" ]] && [[ -z "$(ls -A "$skills_dir")" ]]; then
    rmdir "$skills_dir"
    echo "  removed  $rel_dir/ (empty)"
  fi
done

echo ""
echo "Done."
