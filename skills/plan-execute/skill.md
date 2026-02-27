---
name: plan-execute
description: Opus plans + Codex executes for cost-optimized task orchestration
trigger: /plan-execute
---

# Plan-Execute Skill

Orchestrates complex tasks using Opus for planning and Codex for execution.

## Trigger

```bash
/plan-execute <task description>
```

## When to Use

- Complex multi-step tasks that benefit from strategic planning
- Tasks requiring both high-quality reasoning AND fast execution
- Large refactors, feature implementations, research + action tasks

<instructions>
## Process

### Phase 1: Planning (Opus)

1. **Analyze Task** — break into atomic steps, identify tools and files, estimate complexity
2. **Create Execution Plan:**
   ```json
   {
     "task": "Original task description",
     "steps": [
       {
         "id": 1,
         "action": "Description of what to do",
         "tool": "Bash|Edit|Write|etc",
         "inputs": {"file": "path", "details": "specifics"},
         "depends_on": [],
         "complexity": "low|medium|high"
       }
     ],
     "success_criteria": ["Criteria 1", "Criteria 2"]
   }
   ```
3. **Route Decision** — simple steps → Codex, complex reasoning → keep in Opus, parallel steps → batch to Codex

### Phase 2: Execution (Codex)

Write the plan to `.claude/loop/plan.json`, then execute:

```bash
codex exec "Read .claude/loop/plan.json and execute each step in order. Report results per step."
```

Codex handles: file operations, code changes, running commands, basic validation.

### Phase 3: Review (Opus)

Verify execution results against success criteria. Fix issues if found. Generate summary.
</instructions>

## Example

```bash
/plan-execute "Add user authentication with JWT tokens, including login/logout endpoints, middleware, and tests"
/plan-execute "Migrate all class components to functional components with hooks"
/plan-execute "task" --executor opus  # Skip Codex, all Opus
```

## Cost Optimization

| Task Type | Tokens (Opus Only) | Tokens (Orchestrated) | Savings |
|-----------|-------------------|----------------------|---------|
| 10-step task | ~50,000 | ~20,000 | 60% |
| Code refactor | ~100,000 | ~40,000 | 60% |
| Feature build | ~80,000 | ~35,000 | 56% |

## Output Format

Structure results as: Task → Plan (N steps) → Execution log (per step with status) → Review (criteria met?) → Summary.

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Codex unavailable | CLI not installed or network issue | Fall back to Opus-only mode |
| Step execution fails | Codex error on step | Retry once, then escalate to Opus |
| Plan too complex | Too many steps or dependencies | Break into sub-plans |
| Success criteria not met | Execution incomplete | Opus revises plan, re-executes |

**Fallback**: If orchestration fails, complete entire task in Opus mode.

## Related

- `/ai-collab` - Get perspectives from both AIs
- `dispatcher` agent - General-purpose routing
