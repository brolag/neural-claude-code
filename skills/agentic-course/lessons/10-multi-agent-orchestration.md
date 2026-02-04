# Lesson 10: Multi-Agent Orchestration

## Objective

Coordinate multiple specialized agents for complex work using Neural Squad.

## Why Multiple Agents?

```
SINGLE AGENT                    MULTI-AGENT
─────────────────────────────────────────────────────────────
One context window              Fresh context each agent
Serial execution                Parallel execution
Context exhaustion              Isolated contexts
Jack of all trades              Specialized expertise
```

## Agent Types in Neural Claude Code

| Agent | Purpose | Context |
|-------|---------|---------|
| **Explore** | Read-only codebase search | Fresh |
| **Plan** | Architecture planning | Fresh |
| **General-purpose** | Full tool access | Inherits |
| **Claude-code-guide** | Documentation | Fresh |

## The Orchestrator Pattern

```
                    ┌───────────────┐
                    │  ORCHESTRATOR │
                    │   (Opus)      │
                    └───────┬───────┘
                            │
           ┌────────────────┼────────────────┐
           │                │                │
           ▼                ▼                ▼
    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
    │  FRONTEND   │  │   BACKEND   │  │    TESTS    │
    │   Agent     │  │    Agent    │  │    Agent    │
    └─────────────┘  └─────────────┘  └─────────────┘
           │                │                │
           └────────────────┼────────────────┘
                            │
                            ▼
                    ┌───────────────┐
                    │   INTEGRATOR  │
                    └───────────────┘
```

---

## Neural Squad: Production Multi-Agent System

Neural Squad is our implementation of secure multi-agent orchestration.

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              NEURAL SQUAD - Anti-Slop Edition               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   WORKFLOW: Architect → Dev → Critic (NO self-approval)    │
│                                                              │
│   ┌───────────┐     ┌───────────┐     ┌───────────┐        │
│   │ ARCHITECT │ ──▶ │    DEV    │ ──▶ │  CRITIC   │        │
│   │  (Specs)  │     │   (TDD)   │     │ (Review)  │        │
│   └───────────┘     └───────────┘     └───────────┘        │
│        │                                    │               │
│        └──────── REJECT loops back ─────────┘               │
│                                                              │
│   .claude/squad/              ← SHARED STATE (file-based)   │
│   ├── tasks/{status}/            Kanban queue (JSON)        │
│   ├── agents/*.json              Agent registry & status    │
│   └── activity/*.jsonl           Activity feed (append)     │
│                                                              │
│   ../worktrees/               ← AGENT ISOLATION             │
│   ├── squad-architect/           Specs, orchestration       │
│   ├── squad-dev/                 TDD implementation         │
│   └── squad-critic/              Slop detection, approval   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### The Three Agents

| Agent | Role | Can Do | Cannot Do |
|-------|------|--------|-----------|
| **Architect** | Write CRAFT specs | Create tasks, define interfaces | Write code, approve work |
| **Dev** | TDD implementation | Write code, write tests | Approve own work, merge |
| **Critic** | Anti-slop review | Approve/reject code | Write code, create tasks |

### The Anti-Slop Philosophy

"Slop" is code that nobody asked for. Critic rejects:

1. **Over-engineering** - Unnecessary abstractions
2. **Placeholder code** - TODOs, "implement later"
3. **Unrequested improvements** - Not in the spec? Don't add it
4. **Verbose comments** - Stating the obvious
5. **Scope creep** - Exceeding requirements
6. **Untested behavior** - Tests must verify actual behavior
7. **Non-minimal code** - More than necessary

**Default stance: REJECT until proven necessary.**

### Two-Stage Review

```
Stage 1: SPEC COMPLIANCE          Stage 2: CODE QUALITY
─────────────────────────────────────────────────────────
Does it meet requirements?        Is it minimal?
All acceptance criteria?          No slop detected?
Tests cover the spec?             Clean implementation?
```

Both stages must pass for approval.

---

## CRAFT Integration

Architect uses CRAFT framework for specs:

```
┌──────────────────────────────────────────────────────────┐
│  C = CONTEXT                                             │
│      Current state, tech stack, constraints              │
├──────────────────────────────────────────────────────────┤
│  R = REQUIREMENTS                                        │
│      Objective, success criteria, out of scope           │
├──────────────────────────────────────────────────────────┤
│  A = ACTIONS                                             │
│      Always do, ask first, never do                      │
├──────────────────────────────────────────────────────────┤
│  F = FLOW                                                │
│      Step-by-step execution plan                         │
├──────────────────────────────────────────────────────────┤
│  T = TESTS                                               │
│      Verification commands, completion promise           │
└──────────────────────────────────────────────────────────┘
```

Example spec:

```json
{
  "framework": "CRAFT",
  "context": {
    "current_state": "No greeting function exists",
    "tech_stack": "TypeScript",
    "constraints": "Minimal, no dependencies"
  },
  "requirements": {
    "objective": "Create hello world function",
    "success_criteria": [
      "Function returns 'Hello, World!'",
      "Has passing test"
    ],
    "out_of_scope": ["i18n", "logging"]
  },
  "actions": {
    "always": ["Run tests", "Follow patterns"],
    "ask_first": ["Create directories"],
    "never": ["Modify existing code"]
  },
  "flow": [
    "Create failing test",
    "Implement minimal function",
    "Refactor if needed"
  ],
  "tests": {
    "commands": ["npm test"],
    "promise": "CRAFT_COMPLETE"
  }
}
```

---

## Task Flow (Kanban)

```
inbox → assigned → in-progress → review → done
  │         │           │           │        │
  │         │           │           │        └─ APPROVED by Critic
  │         │           │           └─ Awaiting review
  │         │           └─ Dev implementing (TDD)
  │         └─ Has CRAFT spec from Architect
  └─ New task created
```

Tasks move automatically based on agent actions.

---

## Commands

```bash
# Initialize the squad system
/squad-init

# Check current status
/squad-status

# Create a new task
/squad-task create "Add user authentication"

# List tasks by status
/squad-task list inbox
/squad-task list all

# View task details
/squad-task show 20260203-143022

# Move task to different status
/squad-task move 20260203-143022 review

# Daily standup report
/squad-standup

# Setup automated heartbeats (macOS)
/squad-cron install
```

---

## Worktrees for Isolation

Each agent works in a separate git worktree:

```bash
# Squad worktrees are created automatically
../worktrees/
├── squad-architect/   # Architect's isolated environment
├── squad-dev/         # Dev's TDD workspace
└── squad-critic/      # Critic's review environment
```

Benefits:
- Each agent has own branch
- No merge conflicts between agents
- Easy to see changes per agent
- Clean git history

---

## Heartbeat Pattern

Agents don't run continuously. They "wake up" periodically:

```
┌─────────────────────────────────────────────────────────┐
│  HEARTBEAT CYCLE (every 15 minutes)                     │
├─────────────────────────────────────────────────────────┤
│  1. Wake up                                             │
│  2. Check for work (tasks in my queue?)                │
│  3. If work: Do one task, update status                │
│  4. If no work: Sleep                                   │
│  5. Exit (fresh context next time)                      │
└─────────────────────────────────────────────────────────┘
```

Staggered schedule prevents conflicts:
- Architect: :00, :15, :30, :45
- Dev: :02, :17, :32, :47
- Critic: :04, :19, :34, :49

---

## Try It

### Exercise 1: Initialize Neural Squad

```bash
# Initialize the system
/squad-init

# Check status
/squad-status
```

Expected output:
```
┌─────────────────────────────────────────────────────────┐
│                    NEURAL SQUAD                         │
│                  Status Dashboard                        │
├─────────────────────────────────────────────────────────┤
│  AGENTS                                                 │
│  ├── architect: idle                                    │
│  ├── dev: idle                                          │
│  └── critic: idle                                       │
├─────────────────────────────────────────────────────────┤
│  TASKS                                                  │
│  inbox: 0 | assigned: 0 | in-progress: 0 | review: 0   │
└─────────────────────────────────────────────────────────┘
```

### Exercise 2: Create and Process a Task

```bash
# Create a simple task
/squad-task create "Add greeting function"

# Check it's in inbox
/squad-task list inbox
```

### Exercise 3: Simulate Workflow

Open three terminals and observe the flow:

**Terminal 1 (Architect):**
```bash
cd ../worktrees/squad-architect
claude
# Architect creates CRAFT spec, moves task to "assigned"
```

**Terminal 2 (Dev):**
```bash
cd ../worktrees/squad-dev
claude
# Dev implements with TDD, moves task to "review"
```

**Terminal 3 (Critic):**
```bash
cd ../worktrees/squad-critic
claude
# Critic reviews, approves or rejects
```

---

## Check

Confirm you understand:

1. Neural Squad has 3 agents: Architect, Dev, Critic
2. Dev CANNOT approve own work (anti-slop enforcement)
3. Architect writes CRAFT specs before implementation
4. Two-stage review: spec compliance + code quality
5. Worktrees provide git isolation per agent
6. Heartbeats provide fresh context each cycle
7. File-based communication (no database needed)

---

## KPI Integration

Track multi-agent efficiency:

| KPI | Agent | Measures |
|-----|-------|----------|
| Plan Velocity | Architect | Minutes to write spec |
| Autonomy Duration | Dev | Minutes of uninterrupted work |
| Review Velocity | Critic | Minutes to review |

```bash
# After completing work
/kpi plan 8 "auth feature"
/kpi autonomy 45 "auth feature"
/kpi review 3 "auth feature"
```

---

## Next

**Lesson 11: Context Engineering** - Optimize your context window usage.

```bash
/course lesson 11
```

---
*Completion: Mark this lesson done and continue*
