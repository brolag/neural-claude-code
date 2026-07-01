---
name: spec
description: "Plan a non-trivial change BEFORE any code: research the context, decompose into testable subtasks, lock signatures, note CWE invariants, write executable acceptance, and surface contradictions. Produces an approvable plan artifact and STOPS for review. Does not write code. Pairs with /craft, which executes the plan. Don't use for trivial changes (<25 LOC) or pure conversation."
trigger: /spec
argument-hint: "[task description] [--no-html]"
allowed-tools: Read, Glob, Grep, Bash(git *), Bash(rg *), Bash(fd *), Bash(gh *), Write, AskUserQuestion
---

# /spec - Planning Gate

Turn a task into a reviewable plan before any code. The plan is the contract that `/craft` executes. Planning is convergent judgment: do it once, well, get it approved. This skill never writes implementation code.

Four concepts are borrowed from Allium (the spec language) without the dependency: signatures-first `contract`, `requires`/`ensures` acceptance, `@invariant` for security, and a contradiction scan.

By default, emit an HTML render of the plan (`plan.html`) alongside the markdown at step 9: a styled, well-explained view for easier reading. Suppress it only when the invocation passes `--no-html` (also accept a bare `no-html` / `skip-html` token in the args). Do not ask; the default is to render. `plan.md` is always the source of truth; the HTML is a generated, regenerable view, never hand-edited.

## 0. Right-size (skip ceremony when trivial)

If the change fits in one sentence and is obvious (under 25 LOC, no new interface, no ambiguity), say so and tell the user to implement directly or run `/craft` with an inline task. A plan for a one-line fix is waste.

## 1. Research the ground (no edits)

Before designing, gather context:
- Read CLAUDE.md, AGENTS.md, and the relevant existing code and patterns (Glob/Grep/Read).
- Note the conventions to match (naming, error handling, test style). Reuse beats new.
- Check related git history or issues if useful (`gh issue list`, recent merged PRs).

Do not propose new patterns when existing ones already work.

## 2. Clarify (interview, only if ambiguous)

If edge cases, scope, or tradeoffs are unclear, ask the user up to about 3 focused questions (AskUserQuestion). Surface the hard parts now, not mid-build.

## 3. Decompose

Break the task into subtasks, each with a clear acceptance criterion. Default to independent, parallelizable subtasks: that independence is what lets `/craft` fan out across the fleet. When a subtask genuinely depends on another's output, declare it with `[needs: S1, S2]` so `/craft` gates it behind those subtasks instead of running it early. No `needs` means "runs in parallel"; use `needs` only for real ordering, not for convenience. This gives sequential validation between dependent subtasks without losing fan-out on the independent ones.

## 4. Lock signatures (signatures-first)

Declare every interface the change introduces or modifies BEFORE any body: name, parameter types, return type, the file it lands in, and a `[reuse]` / `[adapt]` / `[new]` label. A `[new]` signature that recreates existing logic is a defect; reference the existing symbol instead.
- Types: `type AccountRow = { id: string; name: string; status: PayerStatus }` [new] -> src/types/model.ts
- Functions: `async function listAccounts(): Promise<ActionResult<AccountRow[]>>` [new] -> src/lib/accounts.ts

When `/craft` fans subtasks out across the fleet, each agent sees only its own subtask. A subtask that produces or consumes a signature should name it inline: `[produces: listAccounts]` / `[consumes: AccountRow]`. That is the interface handoff a context-free executor needs. `[needs:]` gives order, `[produces:]`/`[consumes:]` give the contract.

## 5. Security invariants (CWE as @invariant)

Author posture: senior security engineer, OWASP-quality. Framing the author as a security expert measurably reduces vulnerable output (Pearce 2022; rule `ai-security-framing-prompt-context`). Per feature, state the relevant CWE and the boundary mitigation as an invariant that must hold:
- `@invariant`: all user-rendered content is escaped (CWE-79)
- `@invariant`: all DB access is parameterized (CWE-89)
- `@invariant`: file paths are validated against traversal (CWE-22)

## 6. Executable acceptance (when / requires / ensures)

Every subtask gets at least one machine-checkable criterion, shaped as when/requires/ensures and backed by a command, a `must_include` / `must_not_include`, or a test path. No prose-only checkboxes.
- when: `ShipOrder(order, tracking)` / requires: `order.status = confirmed` / ensures: `order.status = shipped`
  - verify: `npm test -- ship-order`
- Tests pass -> verify: `npm test`
- No type errors -> verify: `npm run typecheck`

These are acceptance failures, never write them:
- Prose-only checkboxes ("works correctly", "handles errors gracefully") with no command, `must_include`, or test path
- `TBD` / `TODO` signatures, or a `verify:` that names no real command or file
- A criterion that restates the subtask title instead of asserting an observable state change
- An `ensures:` that no `verify:` actually checks

## 7. Final review: contradictions + coverage (done by hand)

Before finalizing, scan the requirements for pairs that conflict: overlapping preconditions with incompatible outcomes (e.g. "must be authenticated" vs "guest checkout allowed"), and states that can never be reached or left. Flag and resolve them; do not let a contradiction sit silently. Also validate the `[needs:]` graph: every referenced subtask ID must exist in this plan, and the graph must be acyclic (no `S1 -> S2 -> S1`). Resolve dangling references and cycles before finalizing.

Then re-read the original task/spec with fresh eyes and run a coverage pass: walk each requirement and point to the subtask that satisfies it. List any requirement with no subtask and add one. Walk each locked signature and confirm a subtask produces it and that the name and types match where later subtasks consume it (a `clearLayers()` produced in S2 but called as `clearFullLayers()` in S5 is a bug). Fix inline, no re-review needed.

## 8. Out of scope

State the explicit non-goals.

## 9. Write the plan and STOP

Write `plans/<YYYY-MM-DD-task-slug>/plan.md` with: Context, Signatures, Security invariants, Subtasks (each with executable acceptance), Out-of-scope, Open questions. Emit the YAML frontmatter (status starts `draft` and flips to `approved` only after the user approves; `modified`, `commits`, and `agents` start empty; `related.back` lists the source material this builds on). Use the task-state legend in Subtasks, and leave `## Notes` and `## Amend log` present (empty is fine). The plan is a living artifact; `/craft` updates its frontmatter and Amend log during the build. Set `project:` in the frontmatter to the project name (the repo basename, or the title from CLAUDE.md), and name both the project and the task in the `# Plan:` heading. Unless `--no-html` was passed, also write `plans/<...>/plan.html`: a self-contained, styled, well-explained render of the plan, leading with the project name and the task title in the header and color-coding subtasks by their state. Use the project's own color palette if it defines one (tailwind `theme.colors`, CSS `:root` custom properties, a brand or design doc, or package.json); otherwise the default dark palette. Mark it clearly as generated from `plan.md` (do not hand-edit; regenerate on demand). Then STOP and present it for approval. Do NOT proceed to code. `/craft` consumes this file.

## Plan artifact shape

```markdown
---
project: [name]          # the repo / project this plan belongs to (repo basename or CLAUDE.md title)
created: YYYY-MM-DD
status: draft            # draft | approved | in-progress | done | blocked
modified: []             # append-only; /craft appends an ISO date each time it edits the plan
commits: []              # append-only; SHAs that implemented subtasks
agents: []               # append-only; agent/model that built or edited the plan (traceability)
related:
  back: []               # plans / AI-docs this builds on (paths)
  forward: []            # plans that extend or supersede this (filled later)
---

# Plan: [project] / [task]

## Context
[codebase state, files, constraints, conventions to match]

## Signatures
- `sig` [new|reuse|adapt] -> file

## Security invariants
- @invariant: ... (CWE-XX)

## Subtasks
<!-- state legend: [ ] todo | [~] in-progress | [x] done | [!] blocked/failed (reason inline) -->
<!-- deps: append [needs: S1, S2] to gate a subtask; no needs = runs in parallel -->
<!-- contract: [produces: sig] / [consumes: sig] names the interface handoff for fleet agents that see only their subtask -->
- [ ] S1: [description] [produces: listAccounts] -- verify: `<command>` | must_include: `<string>` | test: `<path>`
- [ ] S2: [description] [needs: S1] [consumes: listAccounts] -- verify: `<command>`

## Out of scope
- ...

## Open questions
- ...

## Notes
<!-- free-form: agent/engineer discoveries the rigid sections don't capture -->

## Amend log
<!-- append-only; post-approval changes: YYYY-MM-DD - what changed - why -->
```

## Composes with

- `/craft` reads the approved plan and executes it (via the fleet pool plus `/vet` review).
- Supersedes the old prompt-only spec template; the planning phases of forge fold in here.

## Done when

- `plan.md` is written with YAML frontmatter (status, modified, commits, agents, related), every section filled, signatures + CWE invariants + executable acceptance present, subtask dependencies declared with `[needs:]` where real ordering exists, the `## Notes` and `## Amend log` sections present, contradictions and spec-coverage scanned, and the plan presented for approval (no code written).
