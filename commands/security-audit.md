---
description: Run a security audit on the current project (config, supply chain, code, AI risks)
allowed-tools: Read, Glob, Grep, Bash
---

Read the skill file at `~/.claude/skills/security-audit/skill.md` and follow its instructions exactly.

**Arguments**: $ARGUMENTS

**Project path**: Use the current working directory unless a path is provided in arguments.

Execute the audit, produce the scored report, and present findings sorted by severity.
