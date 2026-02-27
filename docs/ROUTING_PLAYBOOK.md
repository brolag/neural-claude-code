# Multi-AI Routing Playbook

Quick reference for optimal AI routing. Use `/route <task>` for detailed analysis.

## The 60-Second Decision

```
Is it...
├── Boilerplate/syntax/example? → Qwen (FREE)
├── DevOps/terminal/scripts?    → Codex (65% savings)
├── Security/architecture?      → Opus (stay here)
└── Multi-step complex task?    → Plan-Execute pattern
```

## Quick Commands

| Task Type | Command | Savings |
|-----------|---------|---------|
| Simple code | `ollama run qwen2.5-coder:7b "..."` | 100% |
| DevOps | `codex exec "..."` | 65% |
| Complex | `/plan-execute <task>` | 50-60% |
| Research | `/research <topic>` | Uses best per phase |

## When NOT to Route Away from Opus

1. **Security code** - Auth, encryption, data access
2. **Architecture decisions** - System design, trade-offs
3. **First-time patterns** - Novel implementations
4. **Financial/legal** - Payment flows, compliance
5. **Multi-file coordination** - Complex dependencies

**Rule**: If a bug costs more than token savings, use Opus.

## The Plan-Execute Pattern

For complex tasks with clear goals:

1. **Opus plans** (5-10% tokens)
2. **Codex executes** (70-80% tokens)
3. **Opus reviews** (10-20% tokens)

**Invoke**: `/plan-execute <task>`

**Savings**: 50-60% on multi-step implementations

## Model Strengths

| Model | Best At | SWE-bench | Cost |
|-------|---------|-----------|------|
| **Opus 4.6** | Accuracy, planning, security | 80.8% | $$ |
| **Codex** | Terminal, long sessions | #1 Terminal | $$ |
| **Qwen** | Boilerplate, explanations | Local | FREE |

## Daily Routing Habits

### Morning
- Use `/daily` (runs on Opus, that's fine)
- Route boilerplate generation to Qwen

### During Work
- DevOps automation → Codex
- Stay in Opus for architecture discussions

### End of Day
- Code review → Codex (fresh perspective)
- Documentation → Claude (accurate, thorough)

## Cost Tracking

Estimated monthly savings with proper routing:

| Spend Level | Without Routing | With Routing | Savings |
|-------------|-----------------|--------------|---------|
| Light ($20/mo) | $20 | $10 | $10 |
| Medium ($50/mo) | $50 | $22 | $28 |
| Heavy ($100/mo) | $100 | $42 | $58 |

## Remember

> "Pay architects to think, juniors to code, seniors to review."

Same principle: Pay Opus to plan, Codex to execute, Opus to review.
