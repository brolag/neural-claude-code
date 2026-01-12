---
description: Loop - Unified Autonomous Coding Loop (v3)
allowed-tools: Bash, Read, Write, Glob
---

# Loop - Unified Autonomous Coding Loop

**Version 3.0** - Merges Ralph Wiggum + Neural Loop into one system.

Run AI coding agents in autonomous loops for task completion. Supports HITL (human-in-the-loop) and AFK (away-from-keyboard) modes.

## Usage

```
/loop "<task>" [options]
```

## Modes

| Mode | Command | Description |
|------|---------|-------------|
| **HITL** | `/loop "task"` | Interactive, you watch and can intervene |
| **AFK** | `/loop "task" --afk` | Autonomous, sandboxed, logged |
| **Once** | `/loop "task" --once` | Single iteration, then stops |

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--afk` | false | AFK mode with Docker sandbox |
| `--once` | false | Single iteration only (HITL) |
| `--max <n>` | 20 | Maximum iterations |
| `--promise "<text>"` | LOOP_COMPLETE | Completion phrase |
| `--type <type>` | feature | Loop type: feature, coverage, lint, entropy |
| `--ai <cli>` | auto | Force AI: claude, codex, or auto-detect |
| `--init` | false | Run initialization (creates features.json) |
| `--plan` | false | Run planning phase first (creates structured todo) |

## Examples

```bash
# Simple HITL loop (you watch)
/loop "Add user authentication"

# AFK loop (go grab coffee)
/loop "Refactor database layer" --afk --max 30

# Single iteration (Ralph-style)
/loop "Fix the login bug" --once

# Coverage improvement
/loop "Increase test coverage to 80%" --type coverage

# Linting cleanup
/loop "Fix all ESLint errors" --type lint

# With planning first
/loop "Build REST API" --plan --max 25

# Force Codex CLI
/loop "DevOps setup" --ai codex --afk
```

## Prompt

Parse arguments from: $ARGUMENTS

Extract:
1. **task** - The quoted task description (required)
2. **afk** - Boolean, --afk flag present
3. **once** - Boolean, --once flag present
4. **max** - Number from --max, default 20
5. **promise** - String from --promise, default "LOOP_COMPLETE"
6. **type** - String from --type: feature|coverage|lint|entropy
7. **ai** - String from --ai: claude|codex|auto
8. **init** - Boolean, --init flag present
9. **plan** - Boolean, --plan flag present

### Execution Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                      LOOP v3 EXECUTION                          │
├─────────────────────────────────────────────────────────────────┤
│  1. Parse arguments                                             │
│  2. If --plan → Run /loop-plan first                           │
│  3. If --init → Run /loop-init to create features.json         │
│  4. Detect AI CLI (or use --ai preference)                      │
│  5. Configure mode:                                             │
│     - HITL: Interactive session                                 │
│     - AFK: Docker sandbox + logging                             │
│     - Once: max=1, no re-injection                              │
│  6. Start loop via script                                       │
│  7. Stop hook monitors for completion                           │
└─────────────────────────────────────────────────────────────────┘
```

### Mode Configuration

**HITL Mode (default):**
- Interactive Claude/Codex session
- You watch and can intervene
- Stop hook re-injects prompt on exit
- Good for learning the loop behavior

**AFK Mode (--afk):**
- Enables Docker sandbox automatically
- Logs to `.claude/loop/session-*.log`
- No human intervention needed
- Exits on promise or max iterations

**Once Mode (--once):**
- Single iteration, then stops
- No re-injection
- Good for testing or quick fixes
- Equivalent to Ralph's "HITL single iteration"

### AI Detection

```bash
# Auto-detect (default)
if command -v claude &> /dev/null; then
    AI_CLI="claude"
elif command -v codex &> /dev/null; then
    AI_CLI="codex"
else
    echo "Error: Neither claude nor codex CLI found"
    exit 1
fi

# Or use explicit --ai flag
if [ "$AI" = "codex" ]; then
    AI_CLI="codex"
fi
```

### Script Execution

```bash
# Build the command
bash ~/.claude/scripts/neural-loop/loop-v3.sh \
    "$TASK" \
    "$MAX" \
    "$PROMISE" \
    "$TYPE" \
    "$AFK" \
    "$ONCE" \
    "$AI_CLI" \
    "$INIT" \
    "$PLAN"
```

## Loop Types

### feature (default)
Work through features.json items by priority. Agent chooses next task.

### coverage
```bash
/loop "Increase coverage to 80%" --type coverage
```
- Reads coverage report each iteration
- Targets uncovered lines
- Stops when target reached

### lint
```bash
/loop "Fix ESLint errors" --type lint
```
- Runs linter each iteration
- Fixes ONE error per iteration
- Stops when no errors remain

### entropy
```bash
/loop "Clean up code smells" --type entropy
```
- Scans for: unused exports, dead code, inconsistent patterns
- Fixes one issue per iteration
- Improves code quality

## Key Principles

From Ralph Wiggum + Anthropic research:

1. **Agent picks the task** - Claude/Codex decides priority
2. **Progress file for memory** - Cheaper than re-exploring
3. **Promise-based exit** - `<promise>COMPLETE</promise>`
4. **Single feature per iteration** - Prevents context exhaustion
5. **Small steps** - Context rot makes large tasks worse
6. **Prioritize risky tasks** - Architecture first, polish last
7. **Feedback loops** - Types, tests, lint as guardrails
8. **Codebase evidence wins** - Trust files over instructions

## Files Used

| File | Purpose |
|------|---------|
| `.claude/loop/features.json` | Feature tracking with passes field |
| `.claude/loop/progress.txt` | Human-readable iteration log |
| `.claude/loop/session-*.log` | AFK session logs |
| `~/.claude/scripts/neural-loop/.neural-loop-state.json` | Loop state |

## Safety

- **Always set --max** to cap iterations
- **Use --afk** for unattended work (enables sandbox)
- **Use /loop-cancel** if stuck
- **Check git status** between iterations
- **Docker sandbox** isolates from system

## Related Commands

| Command | Purpose |
|---------|---------|
| `/loop-status` | Check current loop state |
| `/loop-cancel` | Stop active loop |
| `/loop-init` | Initialize features.json manually |
| `/loop-plan` | Create structured plan before loop |
| `/ralph` | Alias for `/loop` (backward compat) |

## Migration from Ralph

| Old Command | New Command |
|-------------|-------------|
| `/ralph once` | `/loop "task" --once` |
| `/ralph afk 10` | `/loop "task" --afk --max 10` |
| `/ralph setup` | `/loop "task" --init` |

## Migration from Neural Loop v2

| Old Command | New Command |
|-------------|-------------|
| `/loop-start "task"` | `/loop "task"` |
| `/loop-start --sandbox` | `/loop "task" --afk` |
| `/loop-start --type coverage` | `/loop "task" --type coverage` |

## Output Format

```markdown
## Loop Started

**Task**: [description]
**Mode**: [HITL/AFK/Once]
**Max Iterations**: [n]
**Type**: [feature/coverage/lint/entropy]
**AI**: [claude/codex]

### Status
Iteration [x]/[n] - [current activity]

### Progress
- [x] Feature 1 completed
- [ ] Feature 2 in progress
- [ ] Feature 3 pending

### Completion
Loop will exit when: "[promise]" is stated
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| AI CLI not found | Claude/Codex not installed | Install required CLI |
| Loop already active | Previous loop running | Run `/loop-cancel` first |
| features.json missing | Not initialized | Run with `--init` flag |
| Docker not available | AFK mode requires Docker | Install Docker or use HITL mode |
| Max iterations reached | Loop didn't complete | Increase --max or check task scope |

**Fallback**: If loop script fails, work directly on the task without loop framework.
