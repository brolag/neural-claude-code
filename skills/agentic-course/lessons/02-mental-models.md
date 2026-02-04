# Lesson 2: Mental Models

## Objective

Learn the core mental frameworks that make agentic coding effective.

## Model 1: Conductor → Orchestrator Evolution

Your role changes as you master agentic coding:

```
STAGE 1: Conductor                STAGE 2: Orchestrator
─────────────────────────────────────────────────────────
One task at a time               Multiple parallel tasks
Watching every step              Checking results
"Do this, now this, now this"    "Here are 5 tasks, report back"
Sync execution                   Async execution
```

## Model 2: Context as Currency

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  Context Window = Your Budget                           │
│                                                         │
│  Every token you spend on:                              │
│  - Long explanations                                    │
│  - Repeated instructions                                │
│  - Tool call results                                    │
│  - Error messages                                       │
│                                                         │
│  Is a token NOT available for:                          │
│  - Actual coding                                        │
│  - Complex reasoning                                    │
│  - Remembering earlier decisions                        │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**The 50-60% Rule:** Optimal context usage is 50-60% of max. Beyond that, quality degrades.

## Model 3: Delegation Levels

```
Level 1: Manual
────────────────
You: "Change line 45 to return null"
AI:  [Changes exactly that]


Level 2: Guided
────────────────
You: "Fix the null pointer bug in auth.ts"
AI:  [Finds bug, proposes fix, waits for approval]


Level 3: Autonomous
────────────────
You: "All tests should pass. Fix whatever is broken."
AI:  [Runs tests, fixes failures, iterates until green]


Level 4: Orchestrated
────────────────
You: "Build the user dashboard feature"
AI:  [Spawns sub-agents for frontend, backend, tests]
```

## Model 4: Act → Learn → Reuse

```
    ┌─────────┐
    │   ACT   │ ─────> Execute tasks
    └────┬────┘
         │
         ▼
    ┌─────────┐
    │  LEARN  │ ─────> Extract patterns
    └────┬────┘
         │
         ▼
    ┌─────────┐
    │  REUSE  │ ─────> Apply to future tasks
    └────┬────┘
         │
         └──────────────> Back to ACT
```

What you learn from each task makes future tasks easier.

## Try It

Observe the difference between delegation levels:

```bash
# Level 1: Manual
"Add 'use strict' to line 1 of app.js"

# Level 2: Guided
"Review app.js for best practices issues"

# Level 3: Autonomous
/loop "Make all files in src/ follow ES6+ best practices" --max 10
```

## Check

Confirm you understand:

1. You're evolving from conductor (micro) to orchestrator (macro)
2. Context is limited - spend it wisely
3. Higher delegation = more upfront specification needed
4. Learning from tasks compounds over time

## Next

**Lesson 3: Your First Autonomous Task** - Put these models into practice.

```bash
/course lesson 3
```

---
*Completion: Mark this lesson done and continue*
