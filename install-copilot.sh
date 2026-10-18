#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_DIR="$SCRIPT_DIR/copilot"

usage() {
  cat <<EOF
Usage: ./install-copilot.sh [--project <repo-path>]

Installs CoreSpec Agent Skills.

  (default)              User scope: ~/.copilot/skills, \${CLAUDE_CONFIG_DIR:-~/.claude}/skills,
                         ~/.agents/skills
  --project <repo-path>  Project scope: <repo-path>/.github/skills and <repo-path>/.claude/skills
                         (commit them to share the skills with everyone who clones the repo)
EOF
}

PROJECT_DIR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || { usage >&2; exit 1; }
      PROJECT_DIR="$2"
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

# See: https://code.visualstudio.com/docs/agent-customization/agent-skills
if [[ -n "$PROJECT_DIR" ]]; then
  [[ -d "$PROJECT_DIR" ]] || { echo "Not a directory: $PROJECT_DIR" >&2; exit 1; }
  PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
  SKILL_DIRS=(
    "$PROJECT_DIR/.github/skills"
    "$PROJECT_DIR/.claude/skills"
  )
  echo "Installing Agent Skills into project $PROJECT_DIR ..."
else
  SKILL_DIRS=(
    "$HOME/.copilot/skills"
    "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"
    "$HOME/.agents/skills"
  )
  echo "Installing Agent Skills globally for this user ..."
fi
echo ""

for skills_dir in "${SKILL_DIRS[@]}"; do
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
if [[ -n "$PROJECT_DIR" ]]; then
  echo "Done. Commit the skill directories above so everyone who clones the repo gets them."
else
  echo "Done. Skills are invokable via /<skill-name> slash commands in every project —"
  echo "no per-project install step required."
fi
echo ""
echo "AI commit attribution: keep the VS Code setting \"git.addAICoAuthor\": \"off\""
echo "(the default) so commits don't get a Co-authored-by trailer for Copilot."
echo ""
echo "Skills installed:"
for skill_dir in "$COPILOT_DIR/skills/"*/; do
  skill_name="$(basename "$skill_dir")"
  if [[ -f "$skill_dir/SKILL.md" ]]; then
    echo "  - /$skill_name"
  fi
done
