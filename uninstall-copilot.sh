#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_DIR="$SCRIPT_DIR/copilot"

# Personal/global skill locations (user profile, available in every project).
GLOBAL_DIRS=(
  "$HOME/.copilot/skills"
  "$HOME/.claude/skills"
  "$HOME/.agents/skills"
)

echo "Removing Copilot Agent Skills from the user profile ..."

for skills_dir in "${GLOBAL_DIRS[@]}"; do
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
