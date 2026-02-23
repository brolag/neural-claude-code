---
description: Plan-Execute - Opus plans, Codex executes for cost savings
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# /plan-execute Command

Orchestrate complex tasks with Opus planning and Codex execution.

## Usage

```bash
/plan-execute <task description>
```

## Arguments

- `task`: The complex task to plan and execute

## Process

You are the orchestrator. Follow these phases:

### Phase 1: Planning (You - Opus)

Analyze the task and create a detailed execution plan:

1. **Break down the task** into atomic, executable steps
2. **Identify dependencies** between steps
3. **Classify each step**:
   - `codex`: Fast execution tasks (file ops, simple code, commands)
   - `opus`: Complex reasoning tasks (architecture, debugging, synthesis)
4. **Create the plan** in this format:

```json
{
  "task": "Original task",
  "steps": [
    {
      "id": 1,
      "description": "What to do",
      "executor": "codex|opus",
      "tool": "Bash|Edit|Write|etc",
      "details": "Specific instructions",
      "depends_on": []
    }
  ],
  "success_criteria": ["What defines success"]
}
```

### Phase 2: Execution

For `codex` steps, use this pattern:

```bash
codex exec "
You are executing step {id} of a plan.

TASK: {description}
DETAILS: {details}

Execute this step now. Use the appropriate tool ({tool}).
Report what you did and the result.
"
```

For `opus` steps, execute them yourself.

### Phase 3: Review

After all steps complete:
1. Verify success criteria are met
2. Fix any issues found
3. Summarize results

## Example

User: `/plan-execute Add a dark mode toggle to the settings page`

**Phase 1 - Plan:**
```json
{
  "task": "Add dark mode toggle to settings page",
  "steps": [
    {"id": 1, "description": "Find settings component", "executor": "opus", "tool": "Grep"},
    {"id": 2, "description": "Create theme context", "executor": "codex", "tool": "Write"},
    {"id": 3, "description": "Add toggle component", "executor": "codex", "tool": "Write"},
    {"id": 4, "description": "Integrate into settings", "executor": "codex", "tool": "Edit"},
    {"id": 5, "description": "Add CSS variables", "executor": "codex", "tool": "Edit"},
    {"id": 6, "description": "Test and verify", "executor": "opus", "tool": "Review"}
  ],
  "success_criteria": ["Toggle visible in settings", "Theme persists on refresh"]
}
```

**Phase 2 - Execute:**
- Step 1 (opus): Search codebase...
- Step 2-5 (codex): `codex exec "Create theme context..."`
- Step 6 (opus): Review results...

**Phase 3 - Review:**
All criteria met. Dark mode functional.

## Output Format

```markdown
## Plan-Execute: {task}

### Plan
{N} steps created ({M} codex, {K} opus)

### Execution Log
- [1/N] ✅ {step description}
- [2/N] ✅ {step description}
...

### Result
{Success/failure summary}

### Files Changed
- path/to/file1
- path/to/file2
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Codex CLI not found | Not installed | Install codex CLI or route to Opus |
| Step fails | Codex error | Retry with Opus or skip |
| Plan too complex | Too many steps | Break into sub-plans |
| Dependency loop | Circular deps | Flatten dependencies |

**Fallback**: If Codex unavailable, execute all steps in Opus.

## Notes

- Codex excels at: file operations, simple code generation, running commands
- Opus excels at: architecture decisions, complex debugging, synthesis
- When in doubt, keep step in Opus
- Batch similar Codex steps when possible
