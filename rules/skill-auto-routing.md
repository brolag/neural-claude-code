# Skill Auto-Routing Rules

Automatic skill triggers based on context. FOLLOW THESE RULES — don't wait for explicit `/skill` invocations.

Skills are underused when routing is passive ("use when X"). This file makes routing **proactive** — when context signals match, trigger the skill automatically.

## Safety Guards (READ FIRST)

### Loop Prevention
Before auto-triggering any skill:
1. Is this skill already running in the current turn? → SKIP
2. Did this exact pipeline run in the last 15 minutes? → SKIP
3. Is the user inside an active `/loop`? → Don't trigger nested pipelines
4. Have we run the same skill 3+ times this session without user input? → PAUSE and ask

### Override / Interruption
IMMEDIATELY cancel the pipeline if user says:
- "stop", "cancel", "pause", "nevermind"
- "that's overkill", "too much", "simpler please"
- "just do it" (= skip ceremony, code directly)

After cancellation: save partial work, don't discard anything.

### DON'T Auto-Trigger When
- Task is trivially small (see Trivial Task Definition below)
- User explicitly says: "quick fix", "one-liner", "simple", "just do X", "don't overthink"
- Error recovery: revert, undo, rollback operations
- Exploratory work: "what does this do?", "explain", "show me"
- Already inside another skill's pipeline

### Trivial Task Definition
A task is trivial when ALL of these are true:
- Single file changed
- ≤ 15 lines added/modified
- No new functions or classes created
- No architectural impact
- No security implications

If ANY condition is false → use the routing rules below.

---

## Development Workflow Triggers

### Starting a Feature or Complex Task
**Signals**: "implement", "add feature", "build", "create endpoint", "new functionality" + task involves multiple files or new architecture
**DON'T trigger if**: Single-function edit, config change, adding a log line
**Action**: Run `/craft` to generate CRAFT spec BEFORE coding. Then `/todo-new` to break into steps.
**Why**: CRAFT specs prevent wasted iterations on ambiguous tasks.

### First Session in New Codebase
**Signals**: "new project", "onboarding", first time touching a repo, unfamiliar codebase
**Action**: Run `/discover-standards` to extract coding patterns and conventions.
**Why**: Establishes conventions before writing any code. Prevents style mismatches.

### Writing Code (Any Production Code)
**Signals**: About to write implementation code that has testable behavior
**DON'T trigger if**: Config files, env vars, markdown, CSS-only changes, scripts without logic
**Action**: Use TDD cycle — write failing test FIRST, then minimal code to pass, then refactor.
**Trigger skill**: `/tdd` (RED → GREEN → REFACTOR)
**Why**: Iron law — no production code without a failing test first.

### After Writing Code (Post-Implementation)
**Signals**: Feature complete, code changes committed, significant edit batch done (>3 files or >50 lines)
**DON'T trigger if**: Just added tests, just fixed formatting, trivial changes
**Action**: Run `/slop-scan` on changed files to detect over-engineering, dead code, poor naming.
**Follow-up**: If scan finds >3 quick-win issues, automatically run `/slop-fix`.
**Why**: Slop accumulates silently. Scanning after every significant change prevents debt.

### Before Creating PR / Merging
**Signals**: User says "PR", "merge", "ready to merge", "create pull request", branch is complete
**Action**: Run `/pr-review` for code review (dual-AI if multi-model setup available).
**Also run**: `/overseer` for quality score (8-10 auto-approve, 5-7 fix required, 1-4 block).
**Why**: Catches bugs that single-reviewer misses.

### Fixing a Bug
**Signals**: "fix", "bug", "broken", "not working", "regression", "error in..." + confirmed defect
**DON'T trigger if**: User is speculating ("might be broken"), asking about errors, reading logs
**Action**:
1. Run `/debugging` (systematic 4-phase: reproduce → isolate → identify → verify)
2. Write failing test that captures the bug (`/tdd` RED phase)
3. Minimal fix to pass test (GREEN phase)
4. Run `/overseer` for quality check
**Why**: Diagnose FIRST, then test, then fix. Prevents "fix one bug, create two" pattern.

### Hotfix (Production Emergency)
**Signals**: "urgent", "production down", "hotfix", "asap", "critical bug in prod"
**Action**:
1. `/debugging` — isolate root cause fast
2. Minimal fix (skip full TDD ceremony)
3. `/overseer` with reduced scope (security + correctness only)
4. Git save immediately
**Why**: Speed over ceremony. Full pipeline later via follow-up PR.

### Autonomous / Long-Running Tasks
**Signals**: "loop", "run autonomously", "work on this for a while", complex multi-file task
**Action**: `/craft` → `/todo-new` → `/loop --tdd` (autonomous loop with TDD enforcement).
**Why**: Autonomous loops without structure waste tokens. CRAFT + TODO provide rails.

---

## Knowledge Triggers

### Before Starting Complex Work
**Signals**: About to implement a feature, research a topic, make architecture decisions
**Action**: Run `/recall <topic>` proactively to check if this was solved before.
**Why**: Prevents re-researching and re-learning. Knowledge compounds across sessions.

### After Completing Significant Work
**Signals**: New insight discovered, pattern learned, architecture decision made
**Action**: Prompt: "Worth saving this with `/remember`?" — save key insights automatically.
**Why**: Unsaved lessons get lost between sessions.

---

## Quality Gate Triggers

### After Rapid Feature Additions
**Signals**: 3+ features added in a session, sprint end, "before release"
**Action**: Full `/slop-scan` on project, followed by `/slop-fix` for safe issues.

### Before Refactor Sprints
**Signals**: "refactor", "cleanup", "reduce tech debt"
**Action**: `/slop-scan` first to map all issues, then prioritize by severity.

### Complex Refactors with Uncertainty
**Signals**: Large refactor, "not sure if this works", "might break things", multiple valid approaches
**Action**: Run `/parallel-verification` (AlphaGo-style multi-hypothesis exploration).
**Why**: Explores multiple solutions simultaneously, picks the best one. Better than guessing.

### Content/Prose Writing
**Signals**: Writing docs, README, blog post, any prose content
**Action**: Run `/stop-slop` to remove AI writing patterns (filler words, hedging, predictable structures).
**Why**: AI-generated prose has detectable patterns. Stop-slop removes them.

---

## Evaluation Triggers

### After Completing a Significant Task
**Signals**: Task marked complete, user confirms done, loop finishes
**Action**: Run `/eval` against golden tasks if available for the project.
**Why**: Measures actual system quality, not vibes.

---

## Pipeline Summary

```
Feature:      /recall → /craft → /todo-new → /loop --tdd → /slop-scan → /slop-fix → /pr-review → /eval
Bugfix:       /recall → /debugging → /tdd → /overseer → git-save
Hotfix:       /debugging → minimal fix → /overseer (reduced) → git-save
Refactor:     /slop-scan → /parallel-verification → implement → /slop-scan (verify) → /pr-review
Content:      draft → /stop-slop → review
New Codebase: /discover-standards → /recall → proceed
```

---

## Enforcement

These are proactive rules — when the signals match, USE the skill without waiting for manual invocation.

But RESPECT the safety guards. Over-triggering is worse than under-triggering.
When in doubt about whether to trigger: trigger the lightweight version (single skill, not full pipeline).
