# Explanation: Multi-AI Strategy

Why using Claude and Codex together produces better results.

---

## The Insight

Different AIs excel at different tasks:

| AI | Benchmark | Strength |
|----|-----------|----------|
| **Claude** | 80.8% SWE-bench (Opus 4.6) | Accuracy, edge cases, architecture |
| **Codex** | #1 Terminal-Bench | DevOps, long sessions, practical |

No single AI is best at everything.

---

## Why Diversity Helps

### Cognitive Diversity

Each AI has different:
- Training data
- Reasoning patterns
- Blind spots
- Strengths

### Error Reduction

When AIs agree: High confidence
When AIs disagree: Investigate further

### Complete Coverage

| Task | Best AI | Why |
|------|---------|-----|
| Security review | Claude | Thorough analysis |
| CI/CD setup | Codex | Terminal mastery |
| Code review | Claude | Accuracy critical |

---

## Two Collaboration Modes

### 1. Direct Routing

Route a task to the best AI:

```
Ask Codex to set up Docker

Ask Claude to review security
```

**When:** You know which AI is best for the task.

### 2. Sequential Collaboration

Get both perspectives in sequence:

```
/ai-collab Should we use microservices?
```

Claude → Codex → Synthesis

**When:** Important decisions needing multiple viewpoints.
**Time:** 45-60 seconds

---

## The Plan-Execute Pattern

For multi-step tasks, combine strengths optimally:

1. **Planning** — Opus 4.6 (5-10% tokens, accurate reasoning)
2. **Execution** — Codex GPT-5.2 (70-80% tokens, fast action)
3. **Review** — Opus 4.6 (10-20% tokens, accurate verification)

**Why it works:**
- Planning needs accuracy → Opus (expensive, best)
- Execution is often simple → Codex (fast, action-oriented)
- Review needs accuracy → Opus (expensive, best)

**Result:** 50-60% cost savings vs Opus-only

---

## Cost Optimization

| Approach | Cost | Quality |
|----------|------|---------|
| Opus only | $$$$  | Highest |
| Plan-Execute | $$ | High |
| Local (Qwen) | Free | Good for boilerplate |

---

## Smart Routing Decision Tree

```
Is it a terminal/DevOps task?
├─ Yes → Codex
└─ No
   Is it complex/architectural?
   ├─ Yes → Claude
   └─ No
      Is it multi-step?
      ├─ Yes → Plan-Execute
      └─ No → Claude (default)
```

---

## Real-World Examples

### Example 1: Add Authentication

```
/plan-execute Add JWT authentication to the API
```

- Opus plans: File structure, routes, middleware
- Codex executes: Simple implementations
- Opus reviews: Security verification

### Example 2: CI/CD Pipeline

```
Ask Codex to set up GitHub Actions with Docker
```

Codex excels at terminal commands and DevOps patterns.

### Example 3: Critical Decision

```
/ai-collab Should we migrate to microservices?
```

Both AIs analyze independently, then synthesize.

---

## Prerequisites

Multi-AI requires installing additional CLIs:

- **Codex:** `codex` CLI (OpenAI)
- **Claude:** Already using it!

---

## Related

- [How to: Multi-AI](../how-to/multi-ai.md) - Practical guide
- [Reference: Commands](../reference/commands.md) - AI commands
