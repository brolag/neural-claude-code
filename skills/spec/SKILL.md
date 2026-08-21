---
name: spec
description: "Plan a non-trivial change before implementation. Use when work needs repository research, locked interfaces, security invariants, dependency-aware subtasks, executable acceptance criteria, and explicit approval. Consumes unknowns-map.md when available, writes plan.md, and stops without coding. Don't use for trivial changes (<25 LOC) or pure conversation."
trigger: /spec
argument-hint: "[task description] [--no-html]"
allowed-tools: Read, Glob, Grep, Bash(git *), Bash(rg *), Bash(fd *), Bash(gh *), Write, AskUserQuestion
---

# Spec

Turn intent and repository evidence into an approvable implementation contract. Never write implementation code.

This skill is the Claude Code port of the Neural Codex spec gate. Same contract, slash invocation.

## 1. Right-size and research

Skip ceremony for an obvious change under roughly 25 lines with no new interface, ambiguity, or risk.

Otherwise:

1. Find the newest related `plans/**/unknowns-map.md` and read it first.
2. Read repository guidance, the relevant code, tests, documentation, and useful history.
3. Reuse established patterns before proposing new ones.
4. If discovery was skipped, record that fact and clarify only architecture-changing ambiguity (AskUserQuestion, at most 3).

Treat resolved discovery decisions as inputs. Preserve unresolved blockers instead of guessing around them.

If the user cannot yet say what "good" looks like, route to `/discover` instead of guessing a plan.

## 2. Lock the contract

Declare every introduced or changed interface before implementation:

```text
name(parameters) -> result [new|adapt|reuse] -> path
```

Interfaces include functions, types, commands, files, routes, events, schemas, and durable artifact shapes. A new interface that duplicates an existing one is a planning defect.

For every relevant security or trust boundary, add an `@invariant` with its CWE and concrete mitigation. Cover path handling, secret exposure, command execution, authorization, destructive side effects, and validation integrity when applicable.

Keep every invariant testable at its boundary. Do not treat a general security promise as a replacement for a concrete mitigation and verification command.

## 3. Decompose and route

Give every subtask a stable ID and a `[tier:]` model-routing tag:

- `cheap`: mechanical edits, boilerplate, and narrow tests
- `mid`: normal implementation requiring local judgment
- `hard`: architecture, security, ambiguity, or tricky debugging
- `batch`: long-running multi-step or operational work

Add `[needs: S1, S2]` only for real dependencies. No dependency tag means the work may execute independently. Validate that every referenced ID exists and that the graph is acyclic.

A subtask that produces or consumes a signature should name it inline: `[produces: listAccounts]` / `[consumes: AccountRow]`. `[needs:]` gives order. `[produces:]`/`[consumes:]` give the contract a context-free executor needs.

## 4. Make acceptance executable

Every subtask must include:

- `when`: the triggering state or behavior
- `requires`: preconditions and boundaries
- `ensures`: observable postconditions
- `verify`: a safe command, test path, or deterministic assertion
- `must_include` or `must_not_include` when text contracts matter

State what each verification oracle proves and what it does not prove. A green unit test cannot substitute for behavioral or independent review when those gates are required.

These are acceptance failures, never write them:

- prose-only checkboxes with no command, `must_include`, or test path
- `TBD` / `TODO` signatures, or a `verify:` that names no real command or file
- a criterion that restates the subtask title instead of asserting an observable state change

## 5. Scan contradictions

Resolve incompatible requirements, unreachable states, naming collisions, and approval ambiguity. Validate the dependency graph. Record deliberate tradeoffs and residual questions rather than hiding them in implementation notes.

## 6. Write `plan.md` and stop

Normalize the task slug to lowercase letters, digits, and hyphens. Resolve the repository root and its `plans/` directory before creating anything. Resolve the candidate artifact path and require `os.path.commonpath([candidate, plans_root]) == plans_root`. Reject `../../outside/plan.md`, `plans/../outside/plan.md`, and `/tmp/external-plan.md`.

Write `plans/<YYYY-MM-DD-task-slug>/plan.md` with this frontmatter:

```yaml
---
project: <repo>
created: YYYY-MM-DD
status: draft
modified: []
commits: []
agents: []
related:
  back: []
  forward: []
---
```

Put a consumed `unknowns-map.md` path in `related.back`.

Include these sections:

1. Context and locked decisions
2. Signatures
3. Security invariants
4. Subtasks with state legend, dependencies, tiers, and executable acceptance
5. Contradiction scan
6. Out of scope
7. Open questions
8. Notes
9. Amend log

`plan.md` is the source of truth. Do not generate HTML; accept `--no-html` as a compatibility no-op. `/html` remains available on demand for a PlanViewer. Present the plan and STOP for approval. A later explicit `/craft` invocation that clearly refers to this reviewed draft counts as approval. Otherwise require an explicit approval before changing its status.

## Usage Examples

- `/spec implement the approved unknowns map for account export`
- `/spec plan the hook migration --no-html`
- `/spec turn this issue into a dependency-aware build contract`

## Done when

The draft plan has locked signatures, CWE invariants, executable acceptance, a valid dependency graph, explicit non-goals, and has been presented without implementation edits.
