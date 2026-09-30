#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_DIR="$SCRIPT_DIR/copilot"

# Target project directory — defaults to current working directory
TARGET_DIR="${1:-$PWD}"

GITHUB_DIR="$TARGET_DIR/.github"
SKILLS_DIR="$GITHUB_DIR/skills"

echo "Installing Copilot Agent Skills to $TARGET_DIR ..."
echo ""

mkdir -p "$SKILLS_DIR"

# Install skills (each skill lives in its own named directory)
for skill_dir in "$COPILOT_DIR/skills/"*/; do
  skill_name="$(basename "$skill_dir")"
  skill_src="$skill_dir/SKILL.md"
  skill_dest_dir="$SKILLS_DIR/$skill_name"
  skill_dest="$skill_dest_dir/SKILL.md"
  if [[ ! -f "$skill_src" ]]; then
    continue
  fi
  mkdir -p "$skill_dest_dir"
  if [[ -f "$skill_dest" ]]; then
    echo "  overwrite  .github/skills/$skill_name/SKILL.md"
  else
    echo "  install    .github/skills/$skill_name/SKILL.md"
  fi
  cp "$skill_src" "$skill_dest"
done

echo ""
echo "Done. Skills are invokable via /<skill-name> slash commands in Copilot Agent Mode."
echo ""
echo "Skills installed:"
for skill_dir in "$COPILOT_DIR/skills/"*/; do
  skill_name="$(basename "$skill_dir")"
  if [[ -f "$skill_dir/SKILL.md" ]]; then
    echo "  - /$skill_name"
  fi
done
