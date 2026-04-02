# Philosophy

## Why This Exists

AI coding agents start every session from zero. They don't know your conventions, they don't enforce security, and they don't follow a structured workflow unless you tell them to.

Neural Claude Code fixes this with the minimum viable harness:

1. **Security hooks** prevent destructive actions and secret leaks (zero token cost)
2. **Forge pipeline** gives you a repeatable dev workflow (scan, plan, execute, review)
3. **Compact rules** guide behavior without burning tokens every message

## Design Principles

### Hooks enforce, CLAUDE.md guides
If something can be enforced with a hook (bash script, 0 tokens), don't write a rule for it. Rules cost tokens every message. Hooks are free.

### Every line pays a tax
CLAUDE.md and rules are loaded into context on every message. A 200-line CLAUDE.md costs thousands of tokens per session. Keep it under 30 lines.

### Skills are on-demand
Skills only load when invoked (/forge, /overseer, etc.). They cost zero tokens when idle. Put detailed instructions in skills, not in CLAUDE.md.

### Zero dependencies
Only requires bash and jq. No npm packages, no Go binaries, no Python dependencies. Engram memory is an optional upgrade, not a requirement.

## What This Is NOT

- Not a full IDE or agent framework
- Not a replacement for Claude Code itself
- Not an opinionated style guide
- Not bloatware with features you won't use

It's a starter kit. Install it, run /init, and start coding with guardrails.
