# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-10-28

### Added

- `templates/constitution.md`: optional `specs/CONSTITUTION.md` of
  non-negotiable project principles, checked by `spec-driver` and the
  architects, with a recorded-exception path.
- `templates/SPEC-template.md`: canonical spec shape.
- `scripts/validate.py` and `.github/workflows/validate.yml`: CI that checks
  front-matter, agent/skill pairing, the Git Commit Policy section, spec
  template sections, and that the `spec-driver` phases match across the agent,
  skill, and README.
- `mobile-app-engineer` agent and Copilot Agent Skill: implements iOS, Android,
  React Native, and Flutter apps from an approved spec — offline-first sync,
  push notifications, permissions, secure on-device storage, accessibility,
  and store release builds. Complements `frontend-engineer` (web). Wired into
  the `spec-driver` Implementation phase.

### Changed

- Spec template (`templates/SPEC-template.md`, mirrored in `software-architect`
  and `product-manager`): stable IDs (`G-`, `NG-`, `US-`, `AC-`, `OQ-`) with
  each criterion citing its story, `[NEEDS CLARIFICATION: …]` markers instead
  of guessing, `Superseded` / `Deprecated` statuses, and a `Change Log` for
  edits after approval. `qa-engineer` test plans and coverage tables cite `AC-`
  IDs.
- `spec-driver` adds a consistency pass before the human gate (contradictions
  between design, infrastructure, and security; unresolved markers), a task
  breakdown (`SPEC-NNN-tasks.md`, contracts → tests → implementation, `[P]`
  parallel markers) at the start of Phase 5, an existing-spec update path
  (Change Log, re-approval, `Superseded`), and an optional `spec/NNN-slug`
  branch-and-PR convention.
- **BREAKING**: `spec-driver` workflow is now ten phases (0–9) and identical across the
  Claude Code agent, the Copilot skill, and the README. New Phase 6
  (Security & Code Review) runs `code-reviewer` and, when the spec exposes a
  reachable surface and the user confirms an authorised scope, `pentester`
  before QA. QA, sign-off, and release prep move to Phases 7–9.
- `spec-driver` now delegates the business sections of the spec to
  `product-manager` (Phase 1) and no longer asks `software-architect` to
  rewrite them.

### Fixed

- `spec-driver` never spawned `ai-engineer`; AI/LLM work now has an
  Implementation-phase branch.
- `spec-driver` front-matter description listed only backend, frontend, and
  platform engineers; it now lists every role in the workflow.
- Phase counts disagreed across the agent (0–8), the Copilot skill ("eight
  phases"), and the README ("nine phases").

## [1.0.0] - 2026-10-18

### Added

- `data-engineer` agent and Copilot Agent Skill: implements data pipelines
  (batch and streaming), warehouse/lakehouse models, orchestration, data
  quality checks, and data contracts from an approved spec. Wired into the
  `spec-driver` Implementation phase.
- `ml-engineer` agent and Copilot Agent Skill: implements feature pipelines,
  reproducible training, evaluation gates, model registry, batch/online
  serving, and drift monitoring from an approved spec. Complements
  `ai-engineer` (LLM systems). Wired into the `spec-driver` Implementation
  phase.
- **Git Commit Policy** section in every agent and skill: no `Co-authored-by:`
  trailers or "Generated with …" footers for Claude, Copilot, or any AI tool;
  commits authored only by the configured git identity; repository rules
  (Conventional Commits, DCO, signed commits) respected.
- `install.sh` disables Claude Code AI commit/PR attribution by default
  (`attribution` + legacy `includeCoAuthoredBy` in `settings.json`, merged with
  `jq`); opt out with `--keep-attribution`.
- `--project <repo>` option for all install/uninstall scripts to install into a
  repository (`.claude/agents/`, `.github/skills/`, `.claude/skills/`).
- Installers honor `CLAUDE_CONFIG_DIR`.
- Claude Code plugin and marketplace manifests (`.claude-plugin/`) so the repo
  can be installed with `/plugin install corespec@corespec` or allow-listed
  through managed settings.
- `enterprise/managed-settings.json` and `enterprise/vscode-settings.json`
  templates for organization-wide rollout.
- Skill frontmatter aligned with the Agent Skills specification: `license`,
  `metadata`, and `argument-hint` on every skill.
- README sections on commit attribution policy and enterprise deployment.
- `LICENSE` — MIT License.
- `SECURITY.md` — vulnerability disclosure policy covering both the install
  shell scripts and the agent/skill definitions (prompt-injection scope).
- `CONTRIBUTING.md` — contribution workflow and guidance for adding new roles.
- `.gitignore` — excludes OS files, editor files, and common secret file
  patterns.
- `.github/workflows/shellcheck.yml` — CI lint for all shell scripts on every
  push/PR.
- `.github/dependabot.yml` — automated updates for GitHub Actions dependencies.
- License, Security, and Contributing sections in README, plus License and
  ShellCheck status badges.

### Fixed

- Invalid YAML frontmatter in `agents/pentester.md` and the `backend-engineer`,
  `frontend-engineer`, and `spec-driver` skills (unquoted `: ` in
  `description`), which caused clients to skip or mis-read those files.

### Changed

- All agents use `model: inherit` instead of `model: sonnet`, so they follow
  the session model and the organization's `availableModels` / provider policy.
- `release-engineer` skill no longer suggests a `Co-Authored-By:` footer.
- **BREAKING**: `install-copilot.sh` / `uninstall-copilot.sh` no longer take a
  project path argument and no longer write to `.github/skills/` in a target
  repo. Skills are now installed globally at the user-profile level — mirroring
  how `install.sh` already installs Claude agents to `~/.claude/agents` — to
  `~/.copilot/skills/`, `~/.claude/skills/`, and `~/.agents/skills/`, so they
  are available in every project without a per-repo install step. Run
  `./uninstall-copilot.sh` once with the previous version of the script to
  clean up any existing `.github/skills/` installs before upgrading.
  Repository installs are available through the explicit `--project <repo>`
  flag.

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

[Unreleased]: https://github.com/Htunn/CoreSpec/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/Htunn/CoreSpec/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/Htunn/CoreSpec/compare/v0.2.0...v1.0.0
[0.2.0]: https://github.com/htunn/spec-driven-development/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/htunn/spec-driven-development/releases/tag/v0.1.0
