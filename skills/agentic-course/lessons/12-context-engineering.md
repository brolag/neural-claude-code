# Lesson 12: Context Engineering

## Objective

Optimize your context window usage for maximum AI performance.

## Context as Resource

```
┌─────────────────────────────────────────────────────────────────┐
│                   CONTEXT WINDOW = 200K tokens                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│  └──────────────────┘                                           │
│    Optimal: 50-60%                                              │
│                                                                 │
│  ████████████████████████████████████████████████████░░░░░░░░░  │
│  └──────────────────────────────────────────────────┘           │
│    Danger zone: >80%                                            │
│                                                                 │
│  ████████████████████████████████████████████████████████████   │
│  └──────────────────────────────────────────────────────────┘   │
│    Exhausted: Quality degrades                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## What Consumes Context

| Source | Token Impact | Strategy |
|--------|--------------|----------|
| Tool call results | HIGH | Summarize, don't dump |
| Full file reads | HIGH | Read relevant sections |
| Error stack traces | MEDIUM | Truncate to relevant |
| Long conversations | MEDIUM | Start fresh for new tasks |
| System prompts | LOW | Already optimized |

## The 50-60% Rule

```
At 50-60% context usage:
├── Fast responses
├── Accurate recall
└── Good reasoning

At 80%+ context usage:
├── Slower responses
├── "Forgets" earlier decisions
└── More hallucinations
```

## Context Management Strategies

### 1. Prompt Caching

Put static content FIRST, dynamic content LAST:

```
┌─────────────────────────────────────────────────────────────────┐
│  STATIC (cached, reused)                                        │
│  ├── System prompt                                              │
│  ├── CLAUDE.md                                                  │
│  └── Project context                                            │
├─────────────────────────────────────────────────────────────────┤
│  DYNAMIC (changes each request)                                 │
│  ├── Current task                                               │
│  └── Recent conversation                                        │
└─────────────────────────────────────────────────────────────────┘

Result: 90% cost savings on cached prefix
```

### 2. Sub-Agent Isolation

When context fills:
```bash
# Spawn fresh agent for specific task
# Returns only the result, not the full context
```

### 3. Hierarchical Summaries

Instead of full file:
```
README.md (full) → 2000 tokens
README.md (summary) → 200 tokens
```

### 4. One Feature Per Session

```
GOOD                           BAD
────────────────────────────────────────────────────────
Session 1: Auth feature        Session 1: Auth + Dashboard
Session 2: Dashboard           + User profile + Settings
Session 3: User profile        [Context exhausted at 70%]
```

## Context Fragmentation

As context grows, the AI "forgets" earlier parts:

```
Token 0-50K:     Remembers well
Token 50K-100K:  Remembers okay
Token 100K-150K: Starting to forget
Token 150K+:     Only remembers recent
```

**Solution:** Repeat key decisions in the current message.

## Progressive Disclosure

Structure information hierarchically:

```
CLAUDE.md
├── Quick summary (always loaded)
├── references/
│   ├── api-patterns.md (load when needed)
│   ├── testing-guide.md (load when needed)
│   └── architecture.md (load when needed)
```

AI loads details only when needed.

## When to Start Fresh

Signs you need a new session:
- Responses getting slower
- AI "forgets" earlier decisions
- Same mistakes repeated
- Confusion about what was already done

```bash
# Start fresh with handover
# 1. Save current state to handover file
# 2. Start new session
# 3. Load handover file
```

## Try It

Check your current context usage:

Notice how responses change speed as context grows.
When things slow down, consider starting fresh.

## Check

Confirm you understand:

1. 50-60% context is optimal
2. Static content first (caching)
3. Sub-agents have fresh context
4. One feature per session
5. Start fresh when quality degrades

## Next

**Lesson 13: Compute Advantage** - Measure your agentic leverage.

```bash
/course lesson 13
```

---
*Completion: Mark this lesson done and continue*
