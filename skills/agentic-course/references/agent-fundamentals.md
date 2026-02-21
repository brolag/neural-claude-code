# Agent Fundamentals Quick Reference

## What Is an Agent?

```
AGENT = LLM + LOOP + TOOLS
```

---

## The Agent Loop (ReAct)

```
┌──────────────────────────────────────┐
│                                      │
│  PERCEIVE → REASON → ACT → OBSERVE   │
│      ↑                        │      │
│      └────────────────────────┘      │
│              REPEAT                  │
│                                      │
└──────────────────────────────────────┘
```

1. **Perceive**: Read current state
2. **Reason**: Decide what to do
3. **Act**: Execute tool or respond
4. **Observe**: See result
5. **Repeat**: Until done or stopped

---

## Context Window

```
┌─────────────────────────────────────┐
│ SYSTEM PROMPT                       │
│ (CLAUDE.md, instructions)           │
├─────────────────────────────────────┤
│ CONVERSATION HISTORY                │
│ (messages, tool results)            │
├─────────────────────────────────────┤
│ CURRENT TURN                        │
│ (user's latest request)             │
└─────────────────────────────────────┘

When full → old content dropped
```

| Model | Context | Pages |
|-------|---------|-------|
| GPT-4 | 128K | ~300 |
| Claude 3.5 | 200K | ~500 |
| Gemini 1.5 | 1M | ~2500 |

---

## Why Agents Fail

| Failure Mode | What Happens | Prevention |
|--------------|--------------|------------|
| **Hallucination** | Invents files/APIs | Read before edit, verify |
| **Context drift** | Loses focus | Clear goals, progress tracking |
| **Infinite loops** | Repeats failures | Max iterations, track attempts |
| **Overconfidence** | Claims false success | Verify with tests |
| **Tool misuse** | Wrong tool/params | Clear docs, validation |

---

## LLM Strengths & Weaknesses

**Good at:**
- Pattern recognition
- Following instructions
- Generating code
- Explaining/summarizing

**Bad at:**
- Math (predicts tokens, doesn't compute)
- Counting ("r's in strawberry")
- Memory (none between sessions)
- Real-time info (training cutoff)
- Consistency (same Q, different A)

---

## Key Mental Models

| Model | Meaning |
|-------|---------|
| **Stateless** | No memory; everything in context |
| **Probabilistic** | Same input ≠ same output |
| **Text in/out** | Never "sees" files directly |
| **Compute ≠ Intelligence** | Pattern matching, not reasoning |

---

## The Harness

Everything wrapping the LLM:

```
┌─────────────────────────────────┐
│ Context Management              │
│ (load files, manage history)    │
├─────────────────────────────────┤
│ Tool Execution                  │
│ (parse, validate, execute)      │
├─────────────────────────────────┤
│ Safety & Control                │
│ (permissions, limits, blocks)   │
├─────────────────────────────────┤
│ Loop Management                 │
│ (continue/stop, retries, state) │
└─────────────────────────────────┘
```

---

## Common Tools

| Tool | Purpose |
|------|---------|
| Read | View file contents |
| Write | Create/replace file |
| Edit | Modify existing file |
| Bash | Execute commands |
| Glob | Find files by pattern |
| Grep | Search file contents |

---

## Context Rot

As sessions grow longer:

```
Start → End
──────────────────────────
High accuracy → Lower
Fast → Slower
Clear focus → Drift
```

**Prevention**: Keep sessions focused, use progress files.

---

*"Stateless with injected context" - the key insight*
