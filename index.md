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

**22 files. ~635 tokens/message overhead. Zero external dependencies.**

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
| `/spec` | Plan a non-trivial change into an approvable artifact. Stops for review; writes no code |
| `/craft` | Build an approved `/spec` plan: baseline, execute, review, measure, stop for ship |
| `/vet` | Clean-context review gate (fresh reviewer). Verdict SHIP/HOLD/BLOCK |
| `/exercise` | Behavioral gate: run tests, drive the app as a user, report PASS/FAIL with evidence |
| `/git-save` | Conventional commits with safety checks |
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
/init                           # generate CLAUDE.md (Claude Code built-in)
/spec "add user auth"           # plan it (stops for approval)
/craft                          # build the approved plan, review, stop for ship
```

**Or install as a plugin** (native Claude Code — ships the hooks + skills):

```
/plugin marketplace add brolag/neural-claude-code
/plugin install neural@neural-claude-code
```

Skills are namespaced `/neural:spec`, `/neural:craft`, etc. Use one method, not both — the plugin and
the curl installer would double-fire the hooks. The plugin delivers hooks + skills; the curl installer
also adds the compact rules and CLAUDE.md template.

---

## Design Principles

**Hooks enforce, rules guide.** If it can be a hook (0 tokens), don't make it a rule.

**Every line pays a tax.** CLAUDE.md loads every message. Keep it under 30 lines.

**Skills are on-demand.** They cost zero tokens until invoked.

**Zero dependencies.** Only bash + jq. No npm, no Go, no Python.

---

## Dev Pipeline

Planning, building, and review are separate skills, each in a clean context:

**`/spec`** plans the change (signatures, CWE invariants, executable acceptance) into an approvable
`plans/<date-task>/plan.md` and stops. **`/craft`** executes the approved plan, then runs two independent
gates: **`/vet`** (code review by a fresh reviewer -> SHIP/HOLD/BLOCK) and **`/exercise`** (tests + drive
the app as a user -> PASS/FAIL). Both green, then it stops for human confirmation.

Everything runs on vanilla Claude Code; a second model (Codex) and browser/computer-use MCP are optional
enhancements, auto-detected and never required.

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
