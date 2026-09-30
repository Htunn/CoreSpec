# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Removed

- `linkedin-writer` and `blog-writer` agents (`agents/linkedin-writer.md`,
  `agents/blog-writer.md`) and their Copilot Agent Skills
  (`copilot/skills/linkedin-writer/`, `copilot/skills/blog-writer/`). The
  optional Phase 9 (Claude Code) / Phase 8 (Copilot) "Communication" step has
  been removed from the `spec-driver` workflow accordingly.

## [0.2.0] - 2026-09-14

### Added

- GitHub Copilot Agent Skills for all 16 roles (`copilot/skills/<role>/SKILL.md`).
  Each skill is invokable via `/<role-name>` slash commands in Copilot Agent Mode
  without loading any always-on context.
- Heavy-output roles — `software-architect`, `platform-architect`,
  `devsecops-architect`, `code-reviewer`, `pentester`, `ai-engineer`,
  `qa-engineer`, and `release-engineer` — declare `context: fork` in their skill
  frontmatter to run in an isolated subagent context, preventing context pollution
  across turns.
- Product Manager agent (`agents/product-manager.md`) for user story writing,
  acceptance criteria, backlog prioritisation, and RICE/MoSCoW scoring.
- Code Reviewer agent (`agents/code-reviewer.md`) with a structured review
  checklist across correctness, security, performance, and maintainability.
- AI Engineer agent (`agents/ai-engineer.md`) covering prompt engineering, RAG
  pipeline design, evaluation harnesses, and LLM cost/latency trade-off analysis.
- README workflow diagram, spec writing guide (how to write a good spec), and ADR
  (Architecture Decision Record) writing guide.

### Changed

- **BREAKING**: Copilot integration now uses Agent Skills exclusively. The
  always-on `.github/instructions/` context-injection layer has been removed.
  Any project that previously ran `install-copilot.sh` must re-run it after
  upgrading; the old `.github/instructions/` directory and
  `.github/copilot-instructions.md` will remain on disk until
  `uninstall-copilot.sh` is run.
- `install-copilot.sh` simplified: installs only `copilot/skills/` →
  `.github/skills/<role>/SKILL.md`. The previous instructions-install code path
  is removed.
- `uninstall-copilot.sh` simplified: removes only `.github/skills/`. The previous
  instructions-removal code path is removed.

### Removed

- `copilot/instructions/` — all 15 role instruction files superseded by Agent
  Skills.
- `copilot/copilot-instructions.md` — the global always-on instructions file.
- `copilot/vscode-settings-snippet.json` — no longer needed with the skills-only
  workflow.

## [0.1.0] - 2026-09-14

### Added

- Spec-driven development workflow with 13 Claude Code agents: `spec-driver`,
  `software-architect`, `platform-architect`, `devsecops-architect`,
  `backend-engineer`, `frontend-engineer`, `qa-engineer`, `release-engineer`,
  `platform-engineer`, `linkedin-writer`, `blog-writer`, `pentester`, and
  `software-architect`.
- `install.sh` and `uninstall.sh` scripts to symlink agent files into
  `.claude/agents/` for Claude Code multi-agent use.
- Release Engineer agent with Mermaid sequence diagram generation for release
  notes, migration guides, deployment flows, and rollback documentation.
- Senior Pentester agent covering OWASP Top 10, threat modelling, CVE triage, and
  structured penetration test reports.

[Unreleased]: https://github.com/htunn/spec-driven-development/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/htunn/spec-driven-development/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/htunn/spec-driven-development/releases/tag/v0.1.0
