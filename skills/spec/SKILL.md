---
name: spec
description: "Plan a non-trivial change BEFORE any code: research the context, decompose into testable subtasks, lock signatures, note CWE invariants, write executable acceptance, and surface contradictions. Produces an approvable plan artifact and STOPS for review. Does not write code. Pairs with /craft, which executes the plan. Don't use for trivial changes (<25 LOC) or pure conversation."
argument-hint: "[task description]"
allowed-tools: Read, Glob, Grep, Bash(git *), Bash(gh *), Write, AskUserQuestion
---

# /spec — Planning Gate

Turn a task into a reviewable plan before any code. The plan is the contract that `/craft` executes.
Planning is convergent judgment: do it once, well, get it approved. This skill never writes implementation code.

Four concepts shape the plan: signatures-first declarations, `requires`/`ensures` acceptance,
`@invariant` for security, and a contradiction scan.

## 0. Right-size (skip ceremony when trivial)

If the change fits in one sentence and is obvious (under 25 LOC, no new interface, no ambiguity),
say so and tell the user to implement directly or run `/craft` with an inline task. A plan for a one-line fix is waste.

## 1. Research the ground (no edits)

- Read CLAUDE.md, AGENTS.md, and the relevant existing code and patterns (Glob/Grep/Read).
- Note the conventions to match (naming, error handling, test style). Reuse beats new.
- Check related git history or issues if useful (`gh issue list`, recent merged PRs).

Do not propose new patterns when existing ones already work.

## 2. Clarify (interview, only if ambiguous)

If edge cases, scope, or tradeoffs are unclear, ask the user up to about 3 focused questions
(AskUserQuestion). Surface the hard parts now, not mid-build.

## 3. Decompose

Break the task into independent subtasks, each with a clear acceptance criterion. A subtask must be
executable on its own; that independence is what lets `/craft` execute them in any order (or in parallel
via subagents).

## 4. Lock signatures (signatures-first)

Declare every interface the change introduces or modifies BEFORE any body: name, parameter types,
return type, the file it lands in, and a `[reuse]` / `[adapt]` / `[new]` label. A `[new]` signature that
recreates existing logic is a defect; reference the existing symbol instead.
- Types: `type AccountRow = { id: string; name: string; status: PayerStatus }` [new] -> src/types/model.ts
- Functions: `async function listAccounts(): Promise<ActionResult<AccountRow[]>>` [new] -> src/lib/accounts.ts

## 5. Security invariants (CWE as @invariant)

Author posture: senior security engineer, OWASP-quality. Per feature, state the relevant CWE and the
boundary mitigation as an invariant that must hold:
- `@invariant`: all user-rendered content is escaped (CWE-79)
- `@invariant`: all DB access is parameterized (CWE-89)
- `@invariant`: file paths are validated against traversal (CWE-22)

## 6. Executable acceptance (when / requires / ensures)

Every subtask gets at least one machine-checkable criterion, shaped as when/requires/ensures and backed
by a command, a `must_include` / `must_not_include`, or a test path. No prose-only checkboxes.
- when: `ShipOrder(order, tracking)` / requires: `order.status = confirmed` / ensures: `order.status = shipped`
  - verify: `npm test -- ship-order`
- Tests pass -> verify: `npm test`
- No type errors -> verify: `npm run typecheck`

## 7. Contradiction scan (done by hand)

Before finalizing, scan the requirements for pairs that conflict: overlapping preconditions with
incompatible outcomes (e.g. "must be authenticated" vs "guest checkout allowed"), and states that can
never be reached or left. Flag and resolve them; do not let a contradiction sit silently.

## 8. Out of scope

State the explicit non-goals.

## 9. Write the plan and STOP

Write `plans/<YYYY-MM-DD-task-slug>/plan.md` with the frontmatter and sections below. `status` starts
`draft` and flips to `approved` only after the user approves; `modified` and `commits` start empty.
The plan is a living artifact; `/craft` updates its frontmatter and Amend log during the build.
Then STOP and present it for approval. Do NOT proceed to code. `/craft` consumes this file.

```markdown
---
project: [name]          # repo basename or CLAUDE.md title
created: YYYY-MM-DD
status: draft            # draft | approved | in-progress | done | blocked
modified: []             # append-only; /craft appends an ISO date each time it edits the plan
commits: []              # append-only; SHAs that implemented subtasks
---

# Plan: [project] / [task]

## Context
[codebase state, files, constraints, conventions to match]

## Signatures
- `sig` [new|reuse|adapt] -> file

## Security invariants
- @invariant: ... (CWE-XX)

## Subtasks
<!-- state legend: [ ] todo | [~] in-progress | [x] done | [!] blocked (reason inline) -->
- [ ] S1: [description] -- verify: `<command>` | must_include: `<string>` | test: `<path>`
- [ ] S2: ...

## Out of scope
- ...

## Open questions
- ...

## Notes
<!-- free-form: discoveries the rigid sections don't capture -->

## Amend log
<!-- append-only; post-approval changes: YYYY-MM-DD - what changed - why -->
```

## Composes with

- `/craft` reads the approved plan and executes it (then reviews with `/vet` + `/exercise`).

## Done when

`plan.md` is written with frontmatter, every section filled, signatures + CWE invariants + executable
acceptance present, contradictions scanned, and the plan presented for approval (no code written).
