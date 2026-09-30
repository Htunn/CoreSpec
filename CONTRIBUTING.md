# Contributing to CoreSpec

Thanks for your interest in contributing to CoreSpec — the core spec-driven
development framework for AI agents.

## Ways to contribute

- **Fix a bug** in `install.sh`, `uninstall.sh`, `install-copilot.sh`, or
  `uninstall-copilot.sh`.
- **Improve an existing agent or skill** in `agents/` or `copilot/skills/`.
- **Propose a new role** (agent + matching Copilot skill) if it fills a real
  gap in the spec-driven workflow.
- **Improve documentation** in [README.md](README.md).

## Before you start

For anything beyond a trivial fix (typo, one-line bug fix), please open an
issue first describing the problem or proposal. This avoids duplicate work
and lets maintainers weigh in on direction before you invest time.

## Development workflow

1. Fork the repository and create a branch from `main`.
2. Make your changes.
3. If you touched any `.sh` file, run [ShellCheck](https://www.shellcheck.net/)
   locally and fix any warnings:
   ```bash
   shellcheck install.sh uninstall.sh install-copilot.sh uninstall-copilot.sh
   ```
4. If you touched an agent or skill file, manually run the relevant install
   script against a scratch directory and confirm the file lands where
   expected:
   ```bash
   ./install.sh                       # Claude Code agents → ~/.claude/agents/
   ./install-copilot.sh /tmp/scratch  # Copilot skills → /tmp/scratch/.github/skills/
   ```
5. Update [CHANGELOG.md](CHANGELOG.md) under `[Unreleased]` describing your
   change (Added / Changed / Removed).
6. Open a pull request with a clear description of the change and why it's
   needed.

## Adding a new role (agent + skill)

Each role needs **two** matching files kept in sync:

- `agents/<role>.md` — Claude Code agent (YAML frontmatter + body)
- `copilot/skills/<role>/SKILL.md` — GitHub Copilot Agent Skill

Both install scripts (`install.sh`, `install-copilot.sh`) discover files
dynamically by globbing their source directories — you do not need to edit
the scripts themselves to register a new role. You do need to add the new
role to the roles table and relevant workflow sections in
[README.md](README.md).

## Security

Agent and skill files are loaded as instructions by AI coding agents — please
review [SECURITY.md](SECURITY.md) before contributing changes to `agents/` or
`copilot/skills/`, and never add instructions that fetch/execute remote code
or attempt to exfiltrate data.

## Code of conduct

Be respectful and constructive. Assume good intent, and focus feedback on the
change, not the contributor.

## License

By contributing, you agree that your contributions will be licensed under the
project's [MIT License](LICENSE).
