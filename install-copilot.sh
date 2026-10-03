#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_DIR="$SCRIPT_DIR/copilot"

# Personal/global skill locations (user profile, available in every project).
# See: https://code.visualstudio.com/docs/agent-customization/agent-skills
GLOBAL_DIRS=(
  "$HOME/.copilot/skills"
  "$HOME/.claude/skills"
  "$HOME/.agents/skills"
)

echo "Installing Copilot Agent Skills globally for this user ..."
echo ""

for skills_dir in "${GLOBAL_DIRS[@]}"; do
  mkdir -p "$skills_dir"
  rel_dir="${skills_dir/#$HOME/~}"
  for skill_dir in "$COPILOT_DIR/skills/"*/; do
    skill_name="$(basename "$skill_dir")"
    skill_src="$skill_dir/SKILL.md"
    skill_dest_dir="$skills_dir/$skill_name"
    skill_dest="$skill_dest_dir/SKILL.md"
    if [[ ! -f "$skill_src" ]]; then
      continue
    fi
    mkdir -p "$skill_dest_dir"
    if [[ -f "$skill_dest" ]]; then
      echo "  overwrite  $rel_dir/$skill_name/SKILL.md"
    else
      echo "  install    $rel_dir/$skill_name/SKILL.md"
    fi
    cp "$skill_src" "$skill_dest"
  done
done

echo ""
echo "Done. Skills are invokable via /<skill-name> slash commands in every project —"
echo "no per-project install step required."
echo ""
echo "Skills installed:"
for skill_dir in "$COPILOT_DIR/skills/"*/; do
  skill_name="$(basename "$skill_dir")"
  if [[ -f "$skill_dir/SKILL.md" ]]; then
    echo "  - /$skill_name"
  fi
done
