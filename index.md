---
layout: default
title: Neural Claude Code
---

# Neural Claude Code

**Lightweight harness for Claude Code. Security hooks, dev pipeline, smart defaults.**

```bash
curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code/main/install.sh | bash
```

---

## What's Inside

**21 files. ~635 tokens/message overhead. Zero external dependencies.**

### Security Hooks (0 tokens)

Bash scripts that run outside context. They enforce, not guide.

| Hook | Protection |
|------|-----------|
| Dangerous actions blocker | `rm -rf /`, force push main, `DROP TABLE` |
| Prompt injection detector | "ignore previous instructions", jailbreaks |
| Output scanner | Leaked API keys, tokens, private keys |
| Sensitive file guard | `.env`, credentials, SSH keys |
| Pre-compact | Saves context before compaction |

### Skills (on-demand)

| Skill | Purpose |
|-------|---------|
| `/forge` | Dev pipeline: scan, plan, execute, review, ship |
| `/forge --full` | Full pipeline with 3-agent deliberation + 4-layer review |
| `/init` | Auto-generate CLAUDE.md for your project |
| `/git-save` | Conventional commits with safety checks |
| `/overseer` | Code review (security + quality + consistency) |
| `/slop-scan` | Detect AI slop, tech debt, dead code |

### Rules (~135 tokens)

| Rule | One-liner |
|------|-----------|
| verify-first | Check before assuming. Local files, then docs, then act. |
| scope-lock | Do exactly what was asked. Don't expand scope. |
| test-then-ship | Tests pass before commit. No exceptions. |
| no-slop | No dead code, no over-abstraction, no vague TODOs. |
| git-discipline | Feature branches, conventional commits, never force-push. |

---

## Quick Start

```bash
# Install
curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code/main/install.sh | bash

# In your project
cd your-project
/init                           # generate CLAUDE.md
/forge "add user auth"          # run the pipeline
```

---

## Design Principles

**Hooks enforce, rules guide.** If it can be a hook (0 tokens), don't make it a rule.

**Every line pays a tax.** CLAUDE.md loads every message. Keep it under 30 lines.

**Skills are on-demand.** They cost zero tokens until invoked.

**Zero dependencies.** Only bash + jq. No npm, no Go, no Python.

---

## Forge Pipeline

**Simple mode** (default): scan, plan, execute, review, ship.

**Full mode** (`--full`): adds clarification, 3-agent deliberation, parallel execution, and 4-layer review (OWASP + quality + slop + overseer).

Use simple for most tasks. Use full for complex features (3+ files, auth, payments).

---

## Token Comparison

```
Typical setup:     3000-5000 tokens/message overhead
Neural v2:         ~635 tokens/message overhead
```

The difference compounds. Over a 50-message session, that's 120K-220K tokens saved.

---

## Docs

- [Philosophy](docs/philosophy.md) — why this exists and how it's designed
- [Customization](docs/customization.md) — add your own hooks, skills, rules
- [Memory Upgrade](docs/memory-upgrade.md) — optional Engram for cross-session persistence

---

## Links

- [GitHub Repository](https://github.com/brolag/neural-claude-code)
- [Install Script](https://raw.githubusercontent.com/brolag/neural-claude-code/main/install.sh)
- [MIT License](LICENSE)
