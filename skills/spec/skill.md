---
name: spec
description: Write a task specification for async agent delegation. Use when: task is complex and will be delegated to Codex/Gemini/async agent, before firing Tier 2+ tasks via /route, task requires autonomous execution without back-and-forth. Don't use when: task is simple enough for direct execution, interactive conversational work, quick fixes under 25 LOC.
trigger: write a spec, spec this out, delegate this task, /spec
allowed-tools: Write, Read
---

# Spec

Writes a CRAFT-structured specification for async agent delegation.

## Output Format

Creates a spec file at `specs/{project}-{task-slug}.md`:

```markdown
# Spec: [Task Title]

**Project**: [project name]
**Delegated to**: [Codex | Gemini | async agent]
**Priority**: [high | medium | low]
**Date**: [today]

## Context
[Codebase overview, relevant files, current state, constraints]

## Role
[What kind of agent should execute this — backend engineer, frontend dev, etc.]

## Action
[Specific tasks to complete, step by step]
- [ ] Task 1
- [ ] Task 2

## Format
[Expected output: files to create/modify, structure, naming conventions]

## Target (Done When)
- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2
- Tests pass
- No TypeScript errors
```

## Skip When

- Task is trivial (< 25 LOC, obvious implementation)
- User wants to execute it themselves right now
- Interactive work that needs conversation

## Done When

- [ ] Spec file created in `specs/`
- [ ] All sections filled with specific, actionable content
- [ ] Ready to pass to `/route` or async agent
