#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_DIR="$SCRIPT_DIR/copilot"

# Target project directory — defaults to current working directory
TARGET_DIR="${1:-$PWD}"

GITHUB_DIR="$TARGET_DIR/.github"
SKILLS_DIR="$GITHUB_DIR/skills"

echo "Removing Copilot Agent Skills from $TARGET_DIR ..."

# Remove skill directories
for skill_dir in "$COPILOT_DIR/skills/"*/; do
  skill_name="$(basename "$skill_dir")"
  target_skill="$SKILLS_DIR/$skill_name/SKILL.md"
  target_skill_dir="$SKILLS_DIR/$skill_name"
  if [[ -f "$target_skill" ]]; then
    rm "$target_skill"
    echo "  removed  .github/skills/$skill_name/SKILL.md"
  fi
  if [[ -d "$target_skill_dir" ]] && [[ -z "$(ls -A "$target_skill_dir")" ]]; then
    rmdir "$target_skill_dir"
    echo "  removed  .github/skills/$skill_name/ (empty)"
  fi
done

# Remove skills dir if now empty
if [[ -d "$SKILLS_DIR" ]] && [[ -z "$(ls -A "$SKILLS_DIR")" ]]; then
  rmdir "$SKILLS_DIR"
  echo "  removed  .github/skills/ (empty)"
fi

echo ""
echo "Done."
