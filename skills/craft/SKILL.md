---
name: craft
description: "Build a planned change: take an approved /spec plan, capture a baseline, execute the subtasks, review with /vet and /exercise in a clean context, measure the delta, and stop for ship. If no approved plan exists, runs /spec first. Don't use for trivial changes (<25 LOC); edit directly."
argument-hint: "[--plan <path>] [task description if no plan]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(git *), Bash(npm *), Bash(npx *), Bash(pytest *), Bash(cargo *), Bash(go *), Agent, AskUserQuestion, Skill
---

# /craft — Build Orchestrator

Executes an approved plan into shipped code. Planning is `/spec`'s job; this skill builds.
It separates execution from review (independent, clean context via `/vet` and `/exercise`).

## 1. Get an approved plan

- `--plan <path>`: use it.
- Else: find the newest `plans/<...>/plan.md`.
- If none exists: run `/spec` on the task first, get the user's approval, THEN continue.

Never build without an approved plan that has locked signatures and executable acceptance. If the plan
is stale (code drifted from it), re-run `/spec` to refresh before building.

## 2. Capture baseline

Record the current state to `plans/<...>/baseline.md`: test count and pass/fail, coverage if available,
lint count, relevant perf if the task touches a hot path. A metric that cannot be captured cheaply gets
"n/a" and the reason. This is the "before" that step 6 proves against.

## 3. Execute against the locked signatures

Implement each subtask bound to the plan's signatures. Work directly, or spawn Claude subagents (the
`Agent` tool) for independent subtasks that can run in parallel — that is all you need; nothing here
requires an external model pool. (If you happen to have another runner wired up, you can route subtasks
there, but it is optional and never assumed.)

A signature change is a plan deviation, not a worker decision: it goes back to `/spec` (update the plan)
rather than being silently absorbed. Work in small reversible steps and run each subtask's acceptance
check (the `verify:` command / test) as you complete it. Address root causes, never suppress a failing
check. Keep state in the plan and files, not in context, and push heavy investigation into subagents so
the main context stays clean.

Update the plan live: flip each subtask `[ ]` -> `[~]` when you start it and `[~]` -> `[x]` when its
`verify` passes. Use `[!]` with a one-line reason ONLY for a genuine external blocker (missing dependency,
unavailable service), not a fixable failure; on a `[!]`, set the plan frontmatter `status: blocked` and
STOP for escalation instead of looping. Append today's ISO date to the plan's `modified:` list on your
first edit of it.

## 4. Review: /vet (code) + /exercise (behavior)

Run two independent gates in a clean context (never self-review — the reviewer must not share the
author's context):
- `/vet --spec plans/<...>/plan.md`: an independent reviewer (a fresh Agent) checks correctness, verifies
  the plan's acceptance criteria, and checks consistency.
- `/exercise --spec plans/<...>/plan.md`: runs the test suite and drives the running app as a real user to
  confirm the feature works end to end (the behavioral gate; catches "tests pass but it is broken for the
  user"). Skip only if there is nothing runnable to exercise.
- **SHIP** on both -> continue.
- **HOLD / BLOCK** from either -> fix the findings and re-run that gate. Cap at about 3 loops, then stop
  and escalate to the user.

## 5. Measure the delta

Re-measure against `baseline.md` (tests, coverage, lint, perf) and report the before -> after delta.
Turn "all green" into a proven improvement.

## 6. Stop for ship

Finalize the plan frontmatter: set `status: done`, append the implementing commit SHA(s) to `commits:`
(or note `pending commit` if not yet committed), and if the plan changed during the build append a dated
line to `## Amend log`. Summarize: subtasks done, `/vet` and `/exercise` verdicts, measured delta, files
changed. Then STOP for human review. Do NOT auto-commit; commit only when the user asks (use `/git-save`).

## Composes with

- `/spec` (produces the plan), `/vet` (code review) and `/exercise` (behavioral gate).

## Done when

Every subtask is implemented against its signature, `/vet` returns SHIP, the delta vs baseline is
measured and reported, the plan frontmatter is finalized (status, commits, amend log), and the result is
presented for ship (not committed).
