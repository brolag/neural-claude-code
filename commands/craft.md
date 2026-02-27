---
description: Create a CRAFT-structured prompt for autonomous tasks
allowed-tools: Read, Write, Edit
---

# CRAFT Prompt Generator

Generate structured prompts using the CRAFT framework for autonomous agent tasks.

<context>
## Framework

```
CRAFT = Context + Requirements + Actions + Flow + Tests
```

| Letter | Purpose | Key Question |
|--------|---------|--------------|
| **C** | Context | What's the current situation? |
| **R** | Requirements | What exactly needs to be achieved? |
| **A** | Actions | What operations are allowed/forbidden? |
| **F** | Flow | What are the execution steps? |
| **T** | Tests | How do we verify completion? |

## 6 Core Areas Checklist

| Area | What to Include |
|------|-----------------|
| **Commands** | Test, lint, build commands (detect from project) |
| **Testing** | Framework, location, coverage target |
| **Structure** | Directory purposes |
| **Code Style** | ONE real code snippet from the project |
| **Git Workflow** | Branch naming, commit format |
| **Boundaries** | ✅ Always / ⚠️ Ask first / 🚫 Never |

## 3-Tier Boundary System

```
✅ ALWAYS DO    → Safe actions, no approval needed
⚠️ ASK FIRST    → High-impact, needs human review
🚫 NEVER DO     → Hard stops, forbidden actions
```
</context>

## Usage

```bash
/craft                                    # Interactive mode
/craft "Add user authentication"          # Auto-generate from description
/craft "Refactor database layer" --for-loop  # Generate for /loop
/craft quick "Fix the login bug"          # Minimal CRAFT
```

<instructions>
## Prompt

When user runs `/craft`, generate a CRAFT-structured prompt.

### Interactive Mode (`/craft`)

Ask these questions in sequence using AskUserQuestion:

1. **C - Context**: What's the current state of the codebase/feature?
2. **R - Requirements**: What exactly should be achieved? What does success look like?
3. **A - Actions**: Any operations that are forbidden or required?
4. **F - Flow**: Preferred order of steps? (or leave blank for agent to decide)
5. **T - Tests**: How should completion be verified?

### With Description (`/craft "<task>"`)

Parse `$ARGUMENTS` and generate a CRAFT prompt automatically. Detect project context from files (package.json, pyproject.toml, Cargo.toml, etc.). If codebase analysis cannot determine context, ask the user rather than guessing.

Output template:

```markdown
## CRAFT Prompt: [Task Name]

### Context
- Current state: [detected from files]
- Relevant files: [list from glob/grep]
- Constraints: [inferred from project config]

### Requirements
**Objective**: [parsed from task description]
**Success Criteria**:
- [ ] [criterion 1]
- [ ] [criterion 2]
**Out of Scope**: [inferred limitations]

### Actions
**Allowed**: Read/write project files, run tests, run linter
**Forbidden**: Breaking public API, modifying CI/CD, deleting files without confirmation

### Flow
1. Explore and understand current implementation
2. Plan changes with minimal surface area
3. Implement one change at a time
4. Validate with tests after each change
5. Confirm all success criteria met

### Tests
[Detected test commands from project — e.g., npm test, pytest, cargo test]
<promise>CRAFT_COMPLETE</promise>
```

### For Loop Mode (`--for-loop`)

Output a compact version and save to `.claude/loop/craft-prompt.md`:

```bash
/loop "[task]" --promise "CRAFT_COMPLETE" --max 20
```

### Quick Mode (`/craft quick "<task>"`)

```markdown
## Quick CRAFT: [Task]

**Context**: [one line]
**Requirements**: [one line]
**Actions**: Follow existing patterns, run tests
**Flow**: Agent decides
**Tests**: Tests pass, lint clean
<promise>DONE</promise>
```
</instructions>

## Examples

### Feature Implementation
```bash
/craft "Add dark mode toggle to the settings page"
```
→ Generates full CRAFT with detected Next.js/Tailwind context, ThemeContext requirements, test criteria.

### Bug Fix
```bash
/craft quick "Fix the infinite loop in useEffect"
```
→ Quick CRAFT: one-line context, deps fix, tests pass promise.

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No task provided | Empty `/craft` | Fall back to interactive mode |
| Codebase not detected | No project config found | Ask user for context |
| Invalid mode | Unknown flag | Use: --for-loop, quick, or no flag |

## Integration

- **Loop**: `--for-loop` generates loop-ready prompts
- **KPI**: Clearer specs improve Plan Velocity

## References

- Template: `.claude/templates/craft.yaml`
- Resources: `resources/agentic-coding/`
