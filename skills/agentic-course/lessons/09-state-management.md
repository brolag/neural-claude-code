# Lesson 9: State Management

## Objective

Learn how to persist progress across iterations and sessions.

## The Problem

```
Without state management:

Session 1: "I'll refactor the auth module"
           [Context expires]

Session 2: "What was I doing?"
           "Let me start fresh..."
           [Duplicates work]
```

## State Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                      STATE LAYERS                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  HOT (Context Window)                                           │
│  ├── Current conversation                                       │
│  ├── Recent tool results                                        │
│  └── Active decisions                                           │
│                                                                 │
│  WARM (Session Files)                                           │
│  ├── todo.md - Task checklist                                   │
│  ├── progress.txt - Iteration log                               │
│  └── .claude/memory/facts/*.json                                │
│                                                                 │
│  COLD (Persistent)                                              │
│  ├── CLAUDE.md - Project config                                 │
│  ├── Git commits - Code history                                 │
│  └── Archives - Past sessions                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Tool 1: Todo Files

Create structured task tracking:

```bash
/todo-new "Implement user authentication"
```

Creates:
```markdown
# User Authentication Implementation

## Tasks
- [ ] Create User model
- [ ] Implement login endpoint
- [ ] Implement register endpoint
- [ ] Add JWT token handling
- [ ] Create auth middleware
- [ ] Write tests

## Progress
- Started: 2026-02-03
- Current: 0/6 complete

## Notes
```

## Tool 2: Progress Files

Track what happened each iteration:

```
# progress.txt

## Iteration 1 - 2026-02-03 14:30
- Created User model in src/models/user.ts
- Status: SUCCESS

## Iteration 2 - 2026-02-03 14:35
- Started login endpoint
- Status: IN_PROGRESS

## Iteration 3 - 2026-02-03 14:42
- Login endpoint complete
- Added JWT generation
- Status: SUCCESS
```

## Tool 3: Memory Facts

For important decisions and context:

```bash
/remember "Auth uses JWT with 24h expiry, refresh tokens in httpOnly cookies"
```

Retrieves later:
```bash
/recall auth
```

## Checkpointing Pattern

```
┌─────────────┐
│  Start      │
│  Task       │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Complete   │──────> CHECKPOINT
│  Sub-task   │        ├── Update todo.md
└──────┬──────┘        ├── Commit code
       │               └── Log progress
       │
       ▼
┌─────────────┐
│  Next       │
│  Sub-task   │
└─────────────┘
```

Checkpoint after each meaningful unit of work.

## Git as State

Use commits to preserve progress:

```bash
# After each successful change
git add .
git commit -m "feat(auth): implement login endpoint

- Added POST /api/auth/login
- JWT token generation
- Basic validation

WIP: Register endpoint next"
```

If things go wrong, you can revert.

## Handover Files

For passing context to future sessions:

```markdown
# .claude/handover/auth-feature.md

## Current State
Login endpoint complete. Register in progress.

## Completed
- User model (src/models/user.ts)
- Login endpoint (src/api/auth/login.ts)
- JWT utilities (src/lib/jwt.ts)

## Next Steps
1. Complete register endpoint
2. Add password hashing
3. Create auth middleware

## Key Decisions Made
- JWT expiry: 24h (see /recall auth)
- Using bcrypt for passwords
- Refresh tokens in httpOnly cookies

## Blockers
None currently
```

## Try It

Set up state tracking for a task:

```bash
# 1. Create todo
/todo-new "Add form validation"

# 2. Remember key decisions
/remember "Using zod for form validation with custom error messages"

# 3. Check progress
/todo-check
```

## Check

Confirm you understand:

1. Three state layers: Hot (context), Warm (files), Cold (persistent)
2. todo.md tracks task completion
3. progress.txt logs each iteration
4. /remember saves important decisions
5. Git commits are checkpoints

## Next

**Lesson 10: Multi-Agent Orchestration** - Coordinate multiple agents for complex work.

```bash
/course lesson 10
```

---
*Completion: Mark this lesson done and continue*
