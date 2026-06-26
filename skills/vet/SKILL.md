---
name: vet
description: "Clean-context review gate. An independent reviewer (a fresh Agent, with no author context) challenges the diff for correctness, verifies it meets the approved spec's acceptance criteria, and checks project consistency. Verdict SHIP/HOLD/BLOCK. Use standalone before a PR/merge, or as craft's review phase. Don't use for trivial changes (<15 LOC) or docs-only edits."
argument-hint: "[--base <ref>] [--scope working-tree|branch] [--spec <path>] [focus area]"
allowed-tools: Bash(git *), Bash(codex *), Bash(npm *), Bash(pytest *), Read, Glob, Grep, Agent
---

# /vet — Clean-Context Review Gate

The single review gate before merge. An INDEPENDENT reviewer (a fresh Agent with no author context, never
the author's session) does three things in one pass:

1. Adversarial challenge: should this ship, and what will break?
2. Acceptance check: does the diff satisfy the approved spec's executable criteria?
3. Consistency: does it match project conventions, with tests present for new behavior?

The non-negotiable requirement is **context separation**: the reviewer must not share context with the
author. A fresh Agent already gives that — no second model or subscription is required.

## When to use

- Standalone before a PR or merge: `/vet`
- As `/craft`'s review phase (craft passes the diff plus the approved spec)
- NOT for trivial changes (<15 LOC), style-only edits, or docs

## Inputs

Parse `$ARGUMENTS`:
- `--base <ref>`: review branch diff vs ref. Default auto-detect: on a feature branch use `main`, else working tree.
- `--scope working-tree|branch`
- `--spec <path>`: the approved spec/plan that carries the acceptance criteria, so vet can verify them.
- trailing text = focus area

## Execution

### 1. Resolve target and gather diff

```bash
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != "main" ] && [ "$BRANCH" != "master" ]; then
  git diff --stat main...HEAD && git diff main...HEAD
else
  git diff --stat && git diff
fi
```

Honor `--base` / `--scope` if given. If the diff is empty, check `git status --short`; if there is nothing
to review, report and exit.

### 2. Load acceptance criteria (if `--spec` given)

Read the spec's acceptance section. Extract every machine-checkable assertion (a command, a
`must_include` / `must_not_include`, or a test path). These are the objective bar. Run the runnable ones;
reason from the diff for the rest. Each gets pass/fail.

### 3. Run the review in a clean context (a fresh Agent)

Launch a fresh Agent as the independent reviewer. It receives ONLY the diff, the acceptance criteria, and
the focus — never the author's session or reasoning.

```
Agent(subagent_type: "general-purpose", prompt: "<the review prompt below> + <diff> + <acceptance criteria>")
```

Review prompt:

```
<role>
You are the independent review gate for a code change. You did not write this code and have no stake in it shipping.
</role>

<task>
Review the repository diff under three lenses and return a single verdict.
Target: {{TARGET_LABEL}}
Focus: {{USER_FOCUS}}
Acceptance criteria to verify: {{ACCEPTANCE}}
</task>

<lens_A_adversarial>
Try to break confidence in the change. Default to skepticism; do not give credit for good intent or likely follow-up. Prioritize expensive, dangerous, or hard-to-detect failures:
- auth, permissions, tenant isolation, trust boundaries
- data loss, corruption, duplication, irreversible state changes
- rollback safety, retries, partial failure, idempotency gaps
- race conditions, ordering assumptions, stale state, re-entrancy
- empty-state, null, timeout, degraded-dependency behavior
- version skew, schema drift, migration hazards, compatibility regressions
- observability gaps that hide failure
Trace how bad inputs, retries, and concurrent or partial operations move through the code.
</lens_A_adversarial>

<lens_B_acceptance>
For each acceptance criterion, state PASS or FAIL with evidence from the diff (or the command result). A change that does not meet a stated criterion is a FAIL regardless of how clean the code looks. If no acceptance criteria were provided, say so and skip this lens.
</lens_B_acceptance>

<lens_C_consistency>
Check that the change matches the project conventions (CLAUDE.md and surrounding code), ships tests for new behavior, and does not introduce hardcoded secrets, leftover TODO/FIXME, or suppressed errors.
</lens_C_consistency>

<finding_bar>
Report only material findings. No style nits or speculation without evidence. Each finding answers: what can go wrong, why this path is vulnerable, the likely impact, and the concrete fix.
</finding_bar>

<calibration>
Prefer one strong finding over several weak ones. Stay grounded: every finding must be defensible from the provided diff; do not invent code paths. If the change is sound and meets acceptance, say so and return no findings.
</calibration>
```

Replace `{{TARGET_LABEL}}`, `{{USER_FOCUS}}` (or "general review"), and `{{ACCEPTANCE}}` (or "none provided").

### 4. Optional: a second model for diversity

If you have a second model available (e.g. the Codex CLI installed and logged in), you can run the same
prompt through it for added model diversity — it is an optional enhancement, never required, and the fresh
Agent above is always sufficient:

```bash
codex exec -c model_reasoning_effort="high" "$(cat <<'PROMPT'
<the same review prompt>
PROMPT
)" < /dev/null
```

The `< /dev/null` is required: `codex exec` reads stdin even when a prompt argument is given, and hangs on
"Reading additional input from stdin" if stdin is left open. If Codex is unavailable or hangs, the step 3
fresh Agent is the gate.

### 5. Output

```markdown
## Vet Review

**Target**: [working tree | branch vs main]
**Focus**: [user focus or "general"]
**Reviewer**: [fresh Agent | Codex (optional)]

### Verdict: [SHIP | HOLD | BLOCK]

### Acceptance (if a spec was provided)
| Criterion | Result | Evidence |
|-----------|--------|----------|
| ...       | PASS/FAIL | ... |

### Findings
#### [CRITICAL|HIGH|MEDIUM] Title
- **File**: path:lines
- **What can go wrong**: ...
- **Why vulnerable**: ...
- **Impact**: ...
- **Fix**: ...
- **Confidence**: 0.0-1.0

### Summary
[1-2 sentence ship/no-ship call]
```

Verdict:
- **SHIP**: no material findings AND every acceptance criterion passes.
- **HOLD**: addressable findings, or one or more acceptance criteria fail. Fix and re-vet.
- **BLOCK**: fundamental approach problem. Rethink before continuing.

No numeric quality score. A score with no behavioral anchor invites the scale trap; the verdict plus
findings is the signal.

## Active probing (agentic verification)

For changes with testable behavior, do not review statically only. Construct distinguishing inputs (edge
cases, boundary values, empty/null, adversarial inputs) and RUN them against the code to surface
behavioral divergence the diff hides. Where a runnable check exists (a test command, a CLI, a REPL),
execute it; report any input that breaks an invariant or contradicts an acceptance criterion. It is
cheaper to verify a candidate than to produce it, so spend the review budget on probing.

## Integration

- `/craft` calls `/vet` as its review phase, passing the diff and the approved spec.
- Complements, does not replace: `/slop-scan` (technical-debt scan). Run it separately when wanted.

## Error handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Empty diff | No changes | Check `git status`, ensure changes exist |
| Codex unavailable | Not installed / not logged in / not wanted | Use the fresh Agent (the default gate) |
| No material findings and acceptance passes | Change is sound | Return SHIP |
