# Neural Claude Code

Lightweight harness for Claude Code. Security hooks, dev pipeline, smart defaults.

```bash
curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code/main/install.sh | bash
```

## What You Get

**5 security hooks** (zero token cost — bash scripts, not rules):
- Block destructive commands (rm -rf, force push, DROP TABLE)
- Detect prompt injection attempts
- Warn on leaked secrets in output
- Block access to .env and credential files
- Preserve context before compaction

**5 skills** (on-demand, zero tokens when idle):
- `/forge` — dev pipeline: scan, plan, execute, review, ship
- `/init` — generate a project-specific CLAUDE.md
- `/git-save` — conventional commits workflow
- `/overseer` — code review before merge
- `/slop-scan` — detect tech debt and AI slop

**5 compact rules** (~135 tokens total overhead):
- verify-first, scope-lock, test-then-ship, no-slop, git-discipline

## Token Budget

```
Per-message overhead:  ~635 tokens
  CLAUDE.md template:  ~300 tokens
  5 compact rules:     ~135 tokens
  Auto-memory index:   ~200 tokens
```

Compare: a typical unoptimized setup costs 3000-5000 tokens/message in overhead.

## Quick Start

```bash
# 1. Install
curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code/main/install.sh | bash

# 2. Open Claude Code in your project
cd your-project

# 3. Generate project CLAUDE.md
/init

# 4. Use the dev pipeline
/forge "add user authentication"
```

## Forge: 2 Modes

**Simple** (default) — for most tasks:
```
/forge "add pagination to API"
  scan → plan → execute → review → ship
```

**Full** — for complex tasks (3+ files, auth, payments):
```
/forge --full "redesign auth system"
  scan → clarify → deliberate (3 agents) → plan → execute → review (4 checks) → ship
```

## Uninstall

```bash
bash ~/Sites/neural-claude-code/uninstall.sh
```

## Docs

- [Philosophy](docs/philosophy.md) — design principles and token optimization
- [Customization](docs/customization.md) — add your own hooks, skills, rules
- [Memory upgrade](docs/memory-upgrade.md) — optional Engram for cross-session memory

## License

MIT
