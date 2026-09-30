# Security Policy

## Supported Versions

CoreSpec follows [Semantic Versioning](https://semver.org/). Only the latest
released version (see [VERSION](VERSION) and [CHANGELOG.md](CHANGELOG.md)) is
actively supported with security fixes.

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| Older   | :x:                |

## Reporting a Vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Instead, report it privately using one of these channels:

1. **GitHub Security Advisories** (preferred): open a draft advisory at
   [https://github.com/Htunn/CoreSpec/security/advisories/new](https://github.com/Htunn/CoreSpec/security/advisories/new).
2. **Email**: contact the maintainer listed on the
   [repository's GitHub profile](https://github.com/Htunn) with a description
   of the issue, steps to reproduce, and potential impact.

You should receive an acknowledgement within **5 business days**. We aim to
provide a fix or mitigation plan within **30 days** of a confirmed report,
depending on severity and complexity.

Please include as much detail as possible:

- A clear description of the vulnerability and its impact
- Steps to reproduce (a proof-of-concept is ideal)
- The affected file(s) — e.g. `install.sh`, `install-copilot.sh`, a specific
  agent or skill file
- Any suggested remediation, if you have one

## Scope

This project ships two kinds of content, and both are considered in scope for
security reports:

- **Shell scripts** (`install.sh`, `uninstall.sh`, `install-copilot.sh`,
  `uninstall-copilot.sh`) — these run locally with the permissions of the
  invoking user. Reports of command injection, path traversal, unsafe
  temp-file handling, or unintended file overwrites are welcome. Scripts are
  linted with [ShellCheck](https://www.shellcheck.net/) in CI; if you find a
  pattern ShellCheck misses, please report it.
- **Agent and skill definitions** (`agents/*.md`, `copilot/skills/*/SKILL.md`)
  — these files are loaded as instructions by AI coding agents (Claude Code,
  GitHub Copilot). A malicious or compromised change to these files could
  attempt **prompt injection** — e.g. instructing an agent to exfiltrate
  secrets, run destructive commands, or silently alter its behavior. Reports
  of prompt-injection-capable content, unsafe example commands, or
  instructions that could cause an agent to take harmful action are welcome
  and treated as security issues, not just bugs.

## Security Best Practices for Contributors

- Never commit credentials, tokens, API keys, or `.env` files. See
  [.gitignore](.gitignore) for patterns already excluded.
- Keep `set -euo pipefail` and quoted variable expansions in all shell
  scripts; run `shellcheck` locally before submitting a PR.
- Do not add instructions to any agent/skill file that fetch and execute
  remote code (e.g. `curl | bash`) or that instruct the agent to disable
  safety checks, hide actions from the user, or exfiltrate data.
- Review diffs to `agents/` and `copilot/skills/` as carefully as you would
  review executable code — these files directly drive AI agent behavior.
