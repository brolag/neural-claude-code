---
name: discover
description: "Surface hidden requirements and architectural unknowns before planning non-trivial work. Use when a request is ambiguous, spans unfamiliar code, has meaningful tradeoffs, or needs a grounded blindspot pass before /spec. Produces an unknowns-map.md artifact and stops without implementing. Don't use when you already know exactly what you want (go straight to /spec) or for trivial changes."
trigger: /discover
argument-hint: "[task or problem] [--no-html]"
allowed-tools: Read, Glob, Grep, Bash(git *), Bash(rg *), Bash(fd *), Bash(gh *), WebSearch, WebFetch, AskUserQuestion, Write
---

# Discover

Map the gap between the user's intent and the real repository before planning. Do not write implementation code.

Read `references/unknowns-framework.md` before running the workflow. It defines the four quadrants and artifact contract.

This skill is the Claude Code port of the Neural Codex discover gate. Same contract, slash invocation.

## 1. Right-size the gate

Skip discovery for an obvious, low-risk change with no architectural choice. Explain briefly that `/spec` or direct implementation is sufficient.

Use discovery when at least one is true:

- the relevant code or domain is unfamiliar
- the request hides product, data, security, or compatibility choices
- several references or systems must be reconciled
- a wrong assumption would make the later build expensive to undo

## 2. Ground the blindspot pass

Read repository guidance and the narrowest relevant implementation surface. Prefer `AGENTS.md` / `CLAUDE.md`, architecture docs, nearby tests, related history, and concrete `path:line` evidence. Check external sources only when the request or unstable facts require them.

Return findings in four groups:

1. prior decisions and why the system looks this way
2. hidden constraints and failure modes
3. the local quality bar and reusable patterns
4. expert questions the initial request did not expose

Do not replace repository evidence with generic best-practice lists.

## 3. Build the four-quadrant map

Classify the evidence as:

- **Known knowns:** explicit goals and constraints.
- **Known unknowns:** questions already visible to the user or agent.
- **Unknown knowns:** tacit preferences, conventions, and recognition criteria revealed by examples or existing code.
- **Unknown unknowns:** newly discovered risks, dependencies, or decisions.

For every material item, record its source, impact, and whether it blocks planning.

## 4. Resolve architecture-changing questions

Ask via **AskUserQuestion**, only for questions whose answers can change interfaces, data ownership, security boundaries, dependencies, rollout, or user-visible behavior. Ask a small focused batch (~4), explain the tradeoff, and recommend a default when evidence supports one.

Stop interviewing when remaining questions can be safely decided during planning or implementation. Never ask again for a decision already established by current evidence.

## 5. Pin references

Record the strongest available references in descending order:

1. existing source code or tests
2. live components or working examples
3. diagrams, specifications, or official documentation
4. screenshots or prose descriptions

State what each reference should influence. Never copy secrets, tokens, `.env` values, or sensitive output into the map.

## 6. Write the artifact and stop

Write only `plans/<YYYY-MM-DD-task-slug>/unknowns-map.md`. Constrain the slug to lowercase letters, digits, and hyphens. Resolve the repository root and its `plans/` directory first. Require the resolved path to stay inside `plans/` (`os.path.commonpath([candidate, plans_root]) == plans_root`). Reject `../../outside/unknowns-map.md`, `plans/../outside/unknowns-map.md`, `/tmp/external.md`, and equivalent traversal.

Include:

- task and repository context
- all four quadrants
- blindspot findings with evidence
- resolved decisions and their rationale
- pinned references
- remaining unknowns marked blocking or non-blocking
- recommended next step: `/spec`, a small prototype, or stop

Do not produce HTML (`--no-html` is a compatibility no-op). `/html` remains available on demand. Do not modify application code. Present the Markdown artifact and stop so the user can inspect it before `/spec`.

## Usage Examples

- `/discover map the unknowns in replacing our auth provider`
- `/discover inspect this repo before we plan the new billing flow`
- `/discover compare the local workflow with the published harness`

## Done when

The unknowns map is grounded in evidence, architecture-changing questions are resolved or explicitly blocking, references are pinned, and no implementation edits were made.
