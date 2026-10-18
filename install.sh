#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<EOF
Usage: ./install.sh [--project <repo-path>] [--keep-attribution]

Installs CoreSpec Claude Code agents.

  (default)              User scope: \${CLAUDE_CONFIG_DIR:-~/.claude}/agents/
  --project <repo-path>  Project scope: <repo-path>/.claude/agents/ (commit it to
                         share the agents with everyone who clones the repo)
  --keep-attribution     Do not disable Claude Code's Co-Authored-By commit trailer
                         and PR attribution in settings.json
EOF
}

PROJECT_DIR=""
DISABLE_ATTRIBUTION=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || { usage >&2; exit 1; }
      PROJECT_DIR="$2"
      shift 2
      ;;
    --keep-attribution) DISABLE_ATTRIBUTION=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ -n "$PROJECT_DIR" ]]; then
  [[ -d "$PROJECT_DIR" ]] || { echo "Not a directory: $PROJECT_DIR" >&2; exit 1; }
  CLAUDE_DIR="$(cd "$PROJECT_DIR" && pwd)/.claude"
else
  CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
fi
AGENTS_DIR="$CLAUDE_DIR/agents"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

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

# Disable the Co-Authored-By trailer and PR attribution Claude Code adds by default.
ATTRIBUTION_JSON='{"attribution":{"commit":"","pr":"","sessionUrl":false},"includeCoAuthoredBy":false}'
if [[ "$DISABLE_ATTRIBUTION" -eq 1 ]]; then
  echo ""
  if [[ ! -f "$SETTINGS_FILE" ]]; then
    printf '%s\n' "$ATTRIBUTION_JSON" > "$SETTINGS_FILE"
    echo "  created    $SETTINGS_FILE (AI commit/PR attribution disabled)"
  elif command -v jq >/dev/null 2>&1; then
    tmp="$(mktemp)"
    if jq --argjson patch "$ATTRIBUTION_JSON" '. * $patch' "$SETTINGS_FILE" > "$tmp"; then
      cat "$tmp" > "$SETTINGS_FILE"
      echo "  updated    $SETTINGS_FILE (AI commit/PR attribution disabled)"
    else
      echo "  WARNING: could not parse $SETTINGS_FILE; add this manually:" >&2
      echo "    $ATTRIBUTION_JSON" >&2
    fi
    rm -f "$tmp"
  else
    echo "  NOTE: jq not found; add this to $SETTINGS_FILE to disable AI attribution:"
    echo "    $ATTRIBUTION_JSON"
  fi
fi

echo ""
echo "Done. Restart Claude Code to pick up the new agents."
echo ""
echo "Agents installed:"
for f in "$SCRIPT_DIR/agents/"*.md; do
  name="$(basename "$f" .md)"
  echo "  - $name"
done
