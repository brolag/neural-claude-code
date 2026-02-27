---
description: Create a CRAFT-structured prompt for autonomous tasks
allowed-tools: Read, Write, Edit
---

# CRAFT Prompt Generator

Generate structured prompts using the CRAFT framework for autonomous agent tasks.

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

Every spec should cover:

| Area | What to Include |
|------|-----------------|
| **Commands** | `npm test`, `npm run lint`, etc. |
| **Testing** | Framework, location, coverage target |
| **Structure** | src/, tests/, docs/ purposes |
| **Code Style** | ONE real code snippet |
| **Git Workflow** | Branch naming, commit format |
| **Boundaries** | ✅ Always / ⚠️ Ask first / 🚫 Never |

## 3-Tier Boundary System

```
✅ ALWAYS DO    → Safe actions, no approval needed
⚠️ ASK FIRST    → High-impact, needs human review
🚫 NEVER DO     → Hard stops, forbidden actions
```

## Usage

```bash
# Interactive CRAFT prompt creation
/craft

# Generate from description
/craft "Add user authentication with NextAuth"

# Generate for loop
/craft "Refactor database layer" --for-loop

# Quick CRAFT (minimal)
/craft quick "Fix the login bug"
```

## Prompt

When user runs `/craft`, generate a CRAFT-structured prompt.

### Interactive Mode (`/craft`)

Ask these questions in sequence:

```markdown
## CRAFT Prompt Builder

### C - Context
What's the current state of the codebase/feature?
> [user input]

### R - Requirements
What exactly should be achieved? What does success look like?
> [user input]

### A - Actions
Any operations that are forbidden or required?
> [user input]

### F - Flow
Preferred order of steps? (or leave blank for agent to decide)
> [user input]

### T - Tests
How should completion be verified?
> [user input]
```

### With Description (`/craft "<task>"`)

Parse `$ARGUMENTS` and generate a CRAFT prompt automatically:

```markdown
## CRAFT Prompt: [Task Name]

### Context
Based on codebase analysis:
- Current state: [detected from files]
- Relevant files: [list from glob/grep]
- Constraints: [inferred]

### Requirements
**Objective**: [parsed from task description]

**Success Criteria**:
- [ ] [criterion 1]
- [ ] [criterion 2]
- [ ] [criterion 3]

**Out of Scope**:
- [inferred limitations]

### Actions
**Allowed**:
- Read/write project files
- Run tests
- Run linter

**Forbidden**:
- Breaking changes to public API
- Modifying CI/CD config
- Deleting files without confirmation

### Flow
1. Explore and understand current implementation
2. Plan changes with minimal surface area
3. Implement one change at a time
4. Validate with tests after each change
5. Confirm all success criteria met

### Tests
**Automated Checks**:
```bash
npm test
npm run lint
npm run typecheck
```

**Completion Promise**:
```
<promise>CRAFT_COMPLETE</promise>
```
```

### For Loop Mode (`--for-loop`)

Output a compact version suitable for `/loop`:

```bash
/loop "[task]" --promise "CRAFT_COMPLETE" --max 20
```

With the CRAFT prompt saved to `.claude/loop/craft-prompt.md` for reference.

### Quick Mode (`/craft quick "<task>"`)

Generate minimal CRAFT:

```markdown
## Quick CRAFT: [Task]

**Context**: [one line]
**Requirements**: [one line]
**Actions**: Follow existing patterns, run tests
**Flow**: Agent decides
**Tests**: Tests pass, lint clean
**Promise**: <promise>DONE</promise>
```

## Output Format

```markdown
## CRAFT Prompt Generated

### For Copy/Paste:
```
[full CRAFT prompt]
```

### For Loop:
```bash
/loop "[task]" --promise "CRAFT_COMPLETE"
```

### Saved To:
`.claude/loop/craft-prompt.md`
```

## Examples

### Example 1: Feature Implementation
```bash
/craft "Add dark mode toggle to the settings page"
```

Output:
```markdown
## CRAFT: Dark Mode Toggle

### Context
- Next.js app with Tailwind CSS
- Settings page at pages/settings.tsx
- No current theme system

### Requirements
- Toggle between light/dark themes
- Persist preference in localStorage
- Respect system preference initially

### Actions
- Create ThemeContext
- Add toggle component
- Update Tailwind config

### Flow
1. Add Tailwind dark mode config
2. Create theme context/provider
3. Add toggle to settings
4. Test theme switching

### Tests
- Visual test: themes switch correctly
- Persistence: survives page reload
<promise>CRAFT_COMPLETE</promise>
```

### Example 2: Bug Fix
```bash
/craft quick "Fix the infinite loop in useEffect"
```

Output:
```markdown
## Quick CRAFT: Fix Infinite Loop

**Context**: useEffect with missing deps causing re-renders
**Requirements**: Fix loop, no behavior change
**Actions**: Add correct deps, use useCallback if needed
**Flow**: Agent decides
**Tests**: No console warnings, tests pass
<promise>DONE</promise>
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No task provided | Empty `/craft` without arguments | Use interactive mode or provide task in quotes |
| Codebase not detected | Running outside project | Ensure you're in a project with package.json or similar |
| Invalid mode | Unknown flag | Use: --for-loop, quick, or no flag for interactive |

**Fallback**: If auto-detection fails, fall back to interactive mode and ask all questions manually.

## Integration

- **Loop**: Use `--for-loop` to generate loop-ready prompts
- **KPI**: CRAFT prompts improve Plan Velocity (clearer specs)
- **Compute Advantage**: Better prompts = higher autonomy duration

## References

- Template: `.claude/templates/craft.yaml`
- Resources: `resources/agentic-coding/`
