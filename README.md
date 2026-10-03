# CoreSpec

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![ShellCheck](https://github.com/Htunn/CoreSpec/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/Htunn/CoreSpec/actions/workflows/shellcheck.yml)

**CoreSpec** — *The Core Spec-Driven Development Framework for AI Agents*

A set of shared role definitions implementing a spec-driven development workflow.
Supports two AI coding platforms: **Claude Code** (fully automated orchestration) and **GitHub Copilot** (manual checklist workflow).

## What is Spec-Driven Development?

Spec-Driven Development is a workflow discipline built on one rule: the specification is written and approved before a single line of production code is written.

The core idea is to separate the conversation about *what* to build from the act of *building it*. Before any engineer touches the codebase, three architects work in parallel to answer three different questions about the same feature:

- **Software architect** — What are the user stories, acceptance criteria, API contracts, and data model?
- **Platform architect** — How does this scale, where does it run, what are the SLOs, and what breaks under load?
- **DevSecOps architect** — What is the threat model, how is data classified, what compliance controls apply?

The result is a single spec file that captures all three views. A human reviews it and explicitly approves it. Only then do engineers implement — and QA validates against the spec, not against whatever was shipped.

This sequence matters because the cost of changing a spec is near zero; the cost of changing working code is not. The workflow forces the expensive decisions (scope, contracts, security posture, infrastructure choices) to happen when they are cheap to revisit.

## When to use it

**Use the full workflow when:**

- The feature touches more than one service, team, or codebase boundary. Parallel architects surface contradictions before they become bugs.
- There are security or compliance requirements. The devsecops-architect produces a structured threat model and compliance checklist as part of the spec, not as an afterthought.
- The feature involves new infrastructure — new cloud resources, containers, pipelines, or observability config. The platform-architect designs it alongside the software contract so the two are consistent.
- You need an audit trail. A signed-off spec file is a permanent record of what was agreed, who approved it, and what deviations were accepted during implementation.
- The work is non-trivial and will outlive the person who built it. Specs are the cheapest form of documentation because they are written before the implementation makes certain decisions feel obvious.

**Use individual agents directly when:**

- You need a quick architecture review, threat model, or test plan for an existing feature without running the full orchestrated flow.
- You have an approved spec and just want to hand it to a single engineer or QA agent.
- You want to generate a release changelog from a completed feature.

**Skip the workflow entirely when:**

- The change is a one-file fix, a typo, a dependency bump, or anything that takes less time to do than to specify. The workflow is not a gate for trivial changes — it is scaffolding for decisions that are hard to reverse.

## Roles

| Agent | Role | Responsibility |
|-------|------|----------------|
| `spec-driver` | Orchestrator | Runs the full workflow end-to-end |
| `product-manager` | Senior Product Manager | Problem statements, user personas, user stories, acceptance criteria, success metrics |
| `software-architect` | Software Architect | Feature specs, API contracts, ADRs, data models |
| `platform-architect` | Platform Architect | Infrastructure, SLOs, observability, deployment |
| `devsecops-architect` | DevSecOps Architect | Threat model, auth, compliance, CI/CD security gates |
| `backend-engineer` | Senior Backend SE | Implements server-side from approved spec |
| `frontend-engineer` | Senior Frontend SE | Implements UI from approved spec |
| `qa-engineer` | Senior QA Engineer | Test plans, spec validation, deviation reports |
| `release-engineer` | Senior Release Engineer | Conventional commits, changelog, SemVer, release notes, docs |
| `platform-engineer` | Senior Platform Engineer | Shell/PowerShell, Docker, Kubernetes, Helm, AWS/Azure/GCP CLI, ArgoCD, Grafana, Prometheus |
| `pentester` | Senior Penetration Tester | CVSSv3-scored findings, PoC, remediation — web, API, OAuth/OIDC/SAML, JWT, Chrome extensions |
| `code-reviewer` | Senior Code Reviewer | Security vulnerabilities, refactoring opportunities, and maintainability audit with severity-rated findings |
| `ai-engineer` | Senior AI Engineer | LLM system design and debugging across four layers: Prompt, Context, Harness, and Loop Engineering |

## Claude Code

### Requirements

- [Claude Code](https://claude.ai/code) installed
- SSH access to this repository (for install/updates)

### Install

```bash
git clone git@github.com:Htunn/CoreSpec.git
cd CoreSpec
chmod +x install.sh
./install.sh
```

Restart Claude Code. The agents are now available in every project.

### Update

```bash
cd CoreSpec
git pull
./install.sh
```

### Uninstall

```bash
./uninstall.sh
```

---

## GitHub Copilot

All roles are available as **GitHub Copilot Agent Skills** — invokable via `/skill-name` slash commands in Copilot Agent Mode. Skills are installed **globally** at the user-profile level, so they are available in every project without a per-repo install step. The install script writes each skill to the personal skill locations recognized across agent harnesses:

- `~/.copilot/skills/<name>/SKILL.md`
- `~/.claude/skills/<name>/SKILL.md`
- `~/.agents/skills/<name>/SKILL.md`

The `spec-driver` orchestrator (which auto-runs phases in Claude Code) becomes the `/spec-driver` skill — a phase-by-phase workflow guide you follow manually in Copilot Chat.

### Requirements

- GitHub Copilot subscription with Agent Mode enabled in VS Code

### Install

Run from the cloned repo — no project path needed, this installs once for your user account:

```bash
./install-copilot.sh
```

This creates `<name>/SKILL.md` for all 13 roles under each of the global skill directories listed above.

### Update

```bash
cd CoreSpec
git pull
./install-copilot.sh
```

### Uninstall

```bash
./uninstall-copilot.sh
```

### Usage

Invoke any role as a slash command in Copilot Agent Mode:

```
/spec-driver
Help me start a new feature.
```

```
/software-architect
#file:specs/SPEC-003-notifications.md
Fill in the full technical design for this feature.
```

```
/code-reviewer
Review src/auth/ for security vulnerabilities and maintainability issues.
```

```
/product-manager
I want to add a notification system. The affected users are...
```

```
/ai-engineer
#file:specs/SPEC-005-rag-pipeline.md
Diagnose why the retrieval recall is below 60%.
```

### Available skills

| Skill | Command | `context: fork` |
|-------|---------|----------------|
| Spec-Driven workflow guide | `/spec-driver` | No |
| Product Manager | `/product-manager` | No |
| Software Architect | `/software-architect` | Yes |
| Platform Architect | `/platform-architect` | Yes |
| DevSecOps Architect | `/devsecops-architect` | Yes |
| Backend Engineer | `/backend-engineer` | Yes |
| Frontend Engineer | `/frontend-engineer` | Yes |
| QA Engineer | `/qa-engineer` | Yes |
| Platform Engineer | `/platform-engineer` | No |
| Release Engineer | `/release-engineer` | No |
| Code Reviewer | `/code-reviewer` | Yes |
| AI Engineer | `/ai-engineer` | Yes |
| Pentester | `/pentester` | Yes |

Skills marked `context: fork` run in an isolated subagent — their output stays out of your main chat context, which keeps the session clean for heavy analysis or multi-file generation tasks.

### Limitations vs Claude Code

| Capability | Claude Code | GitHub Copilot |
|---|---|---|
| Parallel architect spawning | Automatic | Three manual `/skill` calls in separate tabs |
| Phase auto-progression | Automatic | Manual — one `/skill` call per phase |
| Enforced Phase 3 review gate | Orchestrator halts | Developer-enforced (stop before `/backend-engineer`) |
| Per-role model selection | `model:` frontmatter | Global VS Code setting only |
| Isolated subagent execution | `Agent` tool | `context: fork` in skills |

## Workflow (Claude Code)

### Full spec-driven flow (start here for any non-trivial feature)

Tell Claude in any project:

```
Use spec-driver to implement [feature description]
```

The `spec-driver` orchestrator will run through these phases automatically:

```
Phase 0  Requirements capture           — asks 5 clarifying questions
Phase 1  Spec file created              — specs/SPEC-NNN-{slug}.md
Phase 2  Architects work in parallel    — software + platform + devsecops
Phase 3  Human review gate             — you approve before any code is written
Phase 4  Test plan (optional)           — qa-engineer creates test cases from criteria
Phase 5  Implementation                 — backend + frontend + platform engineers in parallel
Phase 6  QA validation                  — qa-engineer produces deviation report
Phase 7  Spec signed off               — Status: Implemented
Phase 8  Release preparation            — release-engineer: SemVer, changelog, commit message, release notes
```

### Use individual agents directly

```
# Frame a problem and write the business sections of a spec
Use product-manager to gather requirements for the new notifications feature

# Write or update a spec
Use software-architect to design the authentication feature

# Review infrastructure requirements for an existing spec
Use platform-architect to review specs/SPEC-003-notifications.md

# Security review before implementation
Use devsecops-architect to threat-model specs/SPEC-003-notifications.md

# Implement from an approved spec
Use backend-engineer to implement specs/SPEC-003-notifications.md

# Validate implementation against spec
Use qa-engineer to validate the implementation against specs/SPEC-003-notifications.md

# Review code for security, refactoring needs, and maintainability
Use code-reviewer to review src/auth/

# Build or debug an LLM feature using the four-layer framework
Use ai-engineer to implement specs/SPEC-005-rag-pipeline.md
```

## Spec directory convention

```
{project-root}/
  specs/
    SPEC-001-{slug}.md          # feature spec (all architect sections)
    SPEC-001-test-plan.md       # test cases mapped to acceptance criteria
    SPEC-001-deviations.md      # QA deviation report
  docs/
    adr/
      ADR-001-{slug}.md         # Architecture Decision Records
```

## How the Workflow Works

The workflow has nine phases. The first three phases exist to make the last five cheaper and more predictable.

```
┌─────────────────────────────────────────────────────────────────┐
│  DEFINE                                                         │
│                                                                 │
│  Phase 0 ── Requirements capture (product-manager)             │
│  Phase 1 ── Spec stub created   (product-manager)             │
│                                                                 │
│  Phase 2 ── Architects in parallel ──────────────────────────┐ │
│               software-architect  (technical design)         │ │
│               platform-architect  (infrastructure & SLOs)    │ │
│               devsecops-architect (threat model & compliance) │ │
│             └──────────────────────────────────────────────  │ │
│  Phase 3 ── ⛔ HUMAN REVIEW GATE — spec approved or rework   │ │
├─────────────────────────────────────────────────────────────────┤
│  BUILD                                                          │
│                                                                 │
│  Phase 4 ── Test plan (qa-engineer, optional)                  │
│  Phase 5 ── Implementation in parallel ──────────────────────┐ │
│               backend-engineer   (API, DB, business logic)   │ │
│               frontend-engineer  (UI, state, API wiring)     │ │
│               platform-engineer  (infra, containers, CI/CD)  │ │
│             └──────────────────────────────────────────────  │ │
│  Phase 6 ── QA validation against spec (qa-engineer)           │
│  Phase 7 ── Spec signed off — Status: Implemented             │
├─────────────────────────────────────────────────────────────────┤
│  SHIP                                                           │
│                                                                 │
│  Phase 8 ── Release prep (release-engineer)                    │
└─────────────────────────────────────────────────────────────────┘
```

### What each role owns

| Phase | Role | Output |
|-------|------|--------|
| 0–1 | product-manager | Problem statement, user personas, user stories, acceptance criteria, success metrics |
| 2 | software-architect | Technical design, API contracts, data model, sequence diagrams |
| 2 | platform-architect | Infrastructure & Operations section: compute, SLOs, observability, deployment |
| 2 | devsecops-architect | Security Requirements section: STRIDE, auth, data classification, CI/CD gates |
| 3 | **You** | Review the completed spec and explicitly approve it |
| 4 | qa-engineer | Test plan mapping every acceptance criterion to test cases |
| 5 | backend / frontend / platform engineers | Implementation that matches the spec exactly |
| 6 | qa-engineer | Deviation report — Pass/Fail/Gap per acceptance criterion |
| 7 | **You** | Sign off: Status → Implemented |
| 8 | release-engineer | Conventional commit, CHANGELOG entry, SemVer bump, release notes |

### Why Phase 3 is non-negotiable

The review gate exists because this is the last moment when changes are cheap. Once engineers start, every contradiction in the spec becomes a context switch, a re-review, or a production incident. The gate is not bureaucracy — it is the point where the cost curve bends.

A spec that passes Phase 3 must have:
- No open questions
- All acceptance criteria in testable Given/When/Then form
- Infrastructure section present
- Security section present (threat model + auth + data classification)

If any of these are missing, the spec goes back. It does not proceed.

---

## How to Write a Spec

A spec is not a requirements dump. It is a contract between the person who defines the problem and the people who build the solution. A good spec makes implementation boring — engineers know exactly what to build and QA knows exactly what to verify.

### Step 1: Start with the problem, not the solution

The worst specs begin with "we need to build X." The best specs begin with "users are experiencing Y, which costs Z."

Write the Problem Statement first. A valid problem statement:
- Names the affected user and their context
- States the pain, gap, or unmet need
- Contains no proposed solution
- Is specific enough that you could validate or disprove it with real user data

**Bad:** "We need a reporting dashboard."
**Good:** "Admins export CSVs and process them in spreadsheets to track activity because no in-product reporting exists. This takes ~3 hours/week per admin and the data is already 24 hours stale by the time they use it."

### Step 2: Write goals as outcomes, not outputs

Goals answer "what changes in the world?" not "what do we ship?"

**Bad:** "Build a reporting dashboard with charts."
**Good:** "Reduce admin reporting time from ~3 hours/week to under 20 minutes. Deliver data that is no more than 5 minutes stale."

Write at least two explicit Non-Goals alongside each goal. Non-goals protect engineering scope. If you cannot write non-goals, your problem statement is too narrow.

### Step 3: Write acceptance criteria that QA can run without reading source code

Every user story needs at least one Given/When/Then criterion:

```
Given the user is logged in as an admin
When they open the Reports page
Then they see activity data no older than 5 minutes, confirmed by a "Last updated" timestamp
```

Rules:
- One observable outcome per criterion — no "and" compound criteria
- Use exact values where applicable ("within 2 seconds", "error reads exactly: …")
- If a QA engineer cannot verify the criterion from the UI or API alone, rewrite it

### Step 4: Fill in the spec in order — business first, then technical

```
1. product-manager fills:    Problem Statement, Goals, Non-Goals,
                             User Personas, User Stories,
                             Acceptance Criteria, Success Metrics

2. software-architect fills: Technical Design (component diagram,
                             data model, API contracts, sequence diagrams)

3. platform-architect fills: Infrastructure & Operations
                             (compute, SLOs, observability, deployment)

4. devsecops-architect fills: Security Requirements
                              (STRIDE, auth/authz, data classification,
                              compliance controls, CI/CD security gates)
```

Never fill in the technical sections before the business sections are complete. Technical decisions made before the problem is understood are guesses.

### Step 5: Resolve every open question before marking Approved

Open questions are debts. Each one is a decision deferred to the worst possible time — mid-implementation. The spec's `## Open Questions` section must be empty before Status changes to `Approved`.

Assign each open question an owner and a deadline. If a question cannot be resolved before the gate, scope it out as a Non-Goal and track it as a separate future spec.

### Step 6: The spec is the source of truth — always

After approval, any change to scope, API contracts, or acceptance criteria goes back through the review gate. Engineers document deviations in `## Implementation Notes`. QA validates against the approved spec, not against what was built. A working implementation that contradicts the spec is a deviation — not a success.

---

## How to Write an ADR

An Architecture Decision Record (ADR) captures a significant technical decision: what was chosen, why it was chosen, and what was explicitly rejected. ADRs exist so future engineers understand the *why* behind the system, not just the *what*.

### When to write an ADR

Write an ADR for any decision that is:
- **Hard to reverse** — changing it later would require significant rework (database choice, auth mechanism, messaging pattern, deployment target)
- **Non-obvious** — a reasonable engineer would look at the code and ask "why did they do it this way?"
- **Disputed** — multiple approaches were considered and one was chosen over objections
- **Cross-cutting** — the decision affects more than one service, team, or codebase

Do not write an ADR for implementation details, library version bumps, or decisions that can be freely changed without architectural impact.

### ADR file location and naming

```
docs/adr/ADR-001-{kebab-slug}.md
docs/adr/ADR-002-{kebab-slug}.md
```

The number is sequential. The slug describes the decision, not the system: `use-postgres-for-primary-store`, not `database`.

### ADR template

```markdown
# ADR-NNN: {Decision Title}

- **Status**: Proposed | Accepted | Deprecated | Superseded by ADR-NNN
- **Date**: YYYY-MM-DD
- **Authors**: [names or roles]
- **Deciders**: [who made the final call]

## Context

[What forces are in play — technical constraints, team constraints, product
requirements, deadline pressure, compliance requirements.
Write this as the situation a new engineer would need to understand to
evaluate the decision independently.]

## Decision

[The choice made, stated plainly.
"We will use X" — not "we considered using X."]

## Consequences

### Positive
- [What becomes easier or possible because of this decision]

### Negative
- [What becomes harder, slower, or constrained — be honest]

### Risks
- [What could go wrong, and how we plan to detect it]

## Alternatives Rejected

### Option: [Name]
- **Why considered**: [what made it a real candidate]
- **Why rejected**: [the specific reason it lost — be concrete, not vague]

### Option: [Name]
- **Why considered**: …
- **Why rejected**: …
```

### Writing a good Context section

The Context section is the most important part of the ADR. It must explain the situation well enough that someone reading it two years later — without access to the original conversations — can understand why the decision made sense at the time.

Include:
- The specific constraints that were true then (team size, scale, budget, deadline)
- The problem the decision was solving
- Any prior decisions that constrained the options

Do not include: speculation about future requirements, rationale for the decision (that belongs in the Decision section), or options considered (that belongs in Alternatives Rejected).

### Writing a good Consequences section

Most ADRs only list the positive consequences. This is the most common way ADRs become useless. The negative consequences are what future engineers actually need to know — they are the tradeoffs that future decisions will have to navigate.

Be specific: "we accept vendor lock-in to this managed service" is more useful than "there may be some lock-in concerns."

### ADR status lifecycle

```
Proposed  →  Accepted  →  Deprecated
                       →  Superseded by ADR-NNN
```

- **Proposed**: written but not yet agreed
- **Accepted**: the team has agreed this is the current approach
- **Deprecated**: no longer relevant (the system it described no longer exists)
- **Superseded**: a later ADR replaces this one — link to it

Always update the status. A stale ADR marked `Proposed` for two years is worse than no ADR because it implies nothing was ever decided.

### Example: good vs bad ADR title

| Bad | Good |
|-----|------|
| `database.md` | `ADR-001-use-postgres-as-primary-store.md` |
| `auth-decision.md` | `ADR-004-use-jwt-over-session-cookies.md` |
| `microservices.md` | `ADR-007-split-billing-into-separate-service.md` |

The title should describe the decision, not the topic. Someone scanning a list of ADRs should be able to understand the decision without opening the file.

---

## Files

```
agents/          # Claude Code agent definitions (YAML frontmatter + body)
copilot/
  skills/        # GitHub Copilot Agent Skills (SKILL.md per role directory)
    software-architect/SKILL.md
    platform-architect/SKILL.md
    devsecops-architect/SKILL.md
    product-manager/SKILL.md
    backend-engineer/SKILL.md
    frontend-engineer/SKILL.md
    qa-engineer/SKILL.md
    release-engineer/SKILL.md
    platform-engineer/SKILL.md
    code-reviewer/SKILL.md
    ai-engineer/SKILL.md
    pentester/SKILL.md
    spec-driver/SKILL.md

install.sh           # installs agents/ → ~/.claude/agents/
uninstall.sh         # removes agents from ~/.claude/agents/
install-copilot.sh   # installs copilot/skills/ → <project>/.github/skills/
uninstall-copilot.sh # removes skills from <project>/.github/skills/

LICENSE              # MIT License
SECURITY.md          # vulnerability disclosure policy
CONTRIBUTING.md      # contribution guidelines
.github/workflows/   # CI: ShellCheck on every push/PR touching *.sh
```

To update a role, edit the source file in `agents/` (Claude Code) or `copilot/skills/<name>/SKILL.md` (Copilot) and re-run the relevant install script.

---

## Contributing

Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) for the
development workflow, how to add a new role, and coding conventions for shell
scripts and agent/skill files.

## Security

This project takes security seriously for both its shell scripts and its
agent/skill definitions (which are loaded as instructions by AI coding
agents). See [SECURITY.md](SECURITY.md) for supported versions, scope, and
how to privately report a vulnerability. All shell scripts are linted with
[ShellCheck](https://www.shellcheck.net/) in CI.

## License

CoreSpec is licensed under the [MIT License](LICENSE).
