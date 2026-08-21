---
name: craft
description: "Build a non-trivial change from an approved plan.md. Use after /spec to capture a baseline, execute dependency-aware subtasks, record evidence and deviations, run independent /vet and /exercise gates, measure the delta, and stop for human ship approval without committing or publishing automatically. Don't use for trivial changes (<25 LOC); edit directly."
trigger: /craft
argument-hint: "[--plan <path>] [task description if no plan]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(git *), Bash(npm *), Bash(npx *), Bash(pytest *), Bash(cargo *), Bash(go *), Agent, AskUserQuestion, Skill
---

# Craft

Execute an approved plan into verified work. Planning belongs to `/spec`. Review and behavior remain independent gates.

This skill is the Claude Code port of the Neural Codex craft gate. Same contract, slash invocation. Parallel work uses the native `Agent` tool. No external model pool is required.

## 1. Resolve and approve the plan

Use an explicit plan path when supplied. Otherwise select the newest related `plans/**/plan.md`.

Before reading or writing beside the plan, resolve the repository root, the repository's `plans/` directory, and the candidate file. Require `os.path.commonpath([candidate, plans_root]) == plans_root`, require a regular `plan.md`-style Markdown file, and reject symlinks that leave `plans/`. Reject `../../outside/plan.md`, `plans/../outside/plan.md`, `/tmp/external-plan.md`, and any equivalent traversal. Only after this check may `baseline.md` or evidence be written beside the plan.

If no plan exists and the change is still poorly understood, run `/discover` first. Otherwise run `/spec`, get approval, then continue.

Proceed only when:

- frontmatter is `status: approved`, or
- the user explicitly invokes `/craft` immediately after reviewing a specific draft, which counts as approval and must be recorded in the Amend log.

If the plan is missing, stale, blocked, or still ambiguous, stop and return to `/spec`. Validate that locked signatures still match the repository and the `[needs:]` graph is complete and acyclic. Inherit references from a sibling `unknowns-map.md` when one exists.

## 2. Capture the baseline before edits

Write `baseline.md` beside the plan. Record:

- branch, base commit, and pre-existing dirty files
- test pass/fail count and warnings
- lint, typecheck, coverage, documentation, or performance measures that apply
- unavailable metrics as `n/a` with a reason
- the observable before-state the change intends to improve

Never overwrite or discard user changes. If overlapping dirty work makes the build unsafe, stop with exact paths.

## 3. Execute the dependency graph

Set the plan to `in-progress`, append the date to `modified`, and mark a subtask `[~]` before editing it.

Execute locally by default. Spawn Claude `Agent` subagents only when subtasks are independent and parallel work is warranted (user request or a clear `[needs:]`-free batch). Treat `[tier:]` as routing guidance, not permission to change scope.

For each subtask:

1. implement against the locked signatures
2. run its acceptance commands
3. record evidence and relevant limitations
4. mark `[x]` only after its checks pass
5. block dependent subtasks after a prerequisite failure

Fix root causes rather than suppressing checks. Keep durable state in the plan and evidence files, not only in conversation context.

## 4. Control deviations

A locked signature, security invariant, or scope change is a plan deviation. Update the plan through `/spec`, append the reason to the Amend log, and obtain approval when the change materially alters behavior or side effects.

New evidence may refine implementation details without approval only when it preserves the contract. Never weaken acceptance criteria to make a failing build look green.

## 5. Run independent gates

After implementation checks pass:

1. Run `/vet --spec <plan>` in fresh context with a neutral change bundle.
2. Run `/exercise --spec <plan>` to drive the installed software, documentation, CLI, or application as a user.

Both gates are required when behavior is runnable. If a gate is unavailable, failed, or inconclusive, report that state and do not call the build complete. Fix addressable findings and rerun the affected gate, with roughly three loops before escalating.

## 6. Measure and stop for ship

Repeat the baseline commands and report before -> after:

- tests, warnings, and coverage where configured
- lint/type/doc validation
- relevant behavior or performance
- `/vet` verdict and `/exercise` verdict
- residual risk and unrun checks

When all required checks pass, set the plan to `done`, record `pending commit` unless a user-authorized commit already exists, and summarize changed files. STOP for human ship approval.

Do not commit, push, open or merge a pull request, deploy, or send an external message unless the user explicitly authorizes that separate side effect. Commit with `/git-save` only when asked.

## Usage Examples

- `/craft --plan plans/2026-07-12-hooks/plan.md`
- `/craft implement the plan we just approved`
- `/craft continue the approved plan after the blocker was resolved`

## Done when

Every subtask passes its acceptance checks, `/vet` and `/exercise` provide evidence-backed green verdicts, the delta is measured, the plan is current, and the result is waiting for human ship approval.
