---
name: plan-execute
description: Opus plans + Gemini executes for cost-optimized task orchestration
trigger: /plan-execute
---

# Plan-Execute Skill

Orchestrates complex tasks using Opus for planning and Gemini for execution.

## Trigger

```bash
/plan-execute <task description>
```

## When to Use

- Complex multi-step tasks that benefit from strategic planning
- Tasks requiring both high-quality reasoning AND fast execution
- When you want Opus-level planning with Gemini-level speed for implementation
- Large refactors, feature implementations, research + action tasks

## How It Works

```
┌─────────────────────────────────────────────────────┐
│                    User Task                         │
└───────────────────────┬─────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────┐
│              OPUS 4.5 (Planner)                      │
│  - Analyzes task complexity                          │
│  - Creates detailed execution plan                   │
│  - Identifies dependencies                           │
│  - Defines success criteria                          │
└───────────────────────┬─────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────┐
│            GEMINI 3 FLASH (Executor)                 │
│  - Receives structured plan                          │
│  - Executes each step rapidly                        │
│  - Reports results back                              │
│  - Handles errors with retry                         │
└───────────────────────┬─────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────┐
│              OPUS 4.5 (Reviewer)                     │
│  - Validates execution results                       │
│  - Suggests corrections if needed                    │
│  - Synthesizes final output                          │
└─────────────────────────────────────────────────────┘
```

## Process

### Phase 1: Planning (Opus)

1. **Analyze Task**
   - Break down into atomic steps
   - Identify required tools and files
   - Estimate complexity per step

2. **Create Execution Plan**
   ```json
   {
     "task": "Original task description",
     "steps": [
       {
         "id": 1,
         "action": "Description of what to do",
         "tool": "Tool to use (Bash, Edit, etc.)",
         "inputs": {...},
         "depends_on": [],
         "complexity": "low|medium|high"
       }
     ],
     "success_criteria": ["Criteria 1", "Criteria 2"],
     "estimated_tokens": 5000
   }
   ```

3. **Route Decision**
   - Simple steps → Gemini Flash
   - Complex reasoning → Keep in Opus
   - Parallel steps → Batch to Gemini

### Phase 2: Execution (Gemini)

Execute via dispatcher:
```bash
gemini -y "Execute this plan step by step: <plan JSON>"
```

Gemini handles:
- File operations
- Code changes
- Running commands
- Basic validation

### Phase 3: Review (Opus)

1. Verify execution results
2. Check success criteria
3. Fix issues if found
4. Generate summary

## Example Usage

```bash
# Complex feature implementation
/plan-execute "Add user authentication with JWT tokens, including login/logout endpoints, middleware, and tests"

# Large refactor
/plan-execute "Migrate all class components to functional components with hooks"

# Research + Action
/plan-execute "Research best practices for error handling in this codebase and implement them"
```

## Configuration

Create `.claude/plan-execute.json` for customization:

```json
{
  "default_executor": "gemini",
  "opus_threshold": "high",
  "parallel_execution": true,
  "max_steps_per_batch": 5,
  "auto_review": true
}
```

## Cost Optimization

| Task Type | Tokens (Opus Only) | Tokens (Orchestrated) | Savings |
|-----------|-------------------|----------------------|---------|
| 10-step task | ~50,000 | ~15,000 | 70% |
| Code refactor | ~100,000 | ~35,000 | 65% |
| Feature build | ~80,000 | ~30,000 | 62% |

## Output

```markdown
## Plan-Execute Results

### Task
{original task}

### Plan (Opus)
{number} steps identified

### Execution (Gemini)
- Step 1: ✅ Completed
- Step 2: ✅ Completed
- Step 3: ⚠️ Warning (handled)

### Review (Opus)
All success criteria met.

### Summary
{concise summary of what was accomplished}
```

## Error Handling

- **Step fails**: Gemini retries once, then escalates to Opus
- **Plan insufficient**: Opus revises plan mid-execution
- **Gemini unavailable**: Falls back to Opus-only mode

## Limitations

- Requires `gemini` CLI installed
- Network latency between models
- Some tasks are faster Opus-only (single-shot answers)

## Usage

```bash
# Complex feature implementation
/plan-execute "Add user authentication with JWT tokens, including login/logout endpoints, middleware, and tests"

# Large refactor
/plan-execute "Migrate all class components to functional components with hooks"

# Research + Action
/plan-execute "Research best practices for error handling in this codebase and implement them"

# With explicit executor
/plan-execute "task" --executor opus  # Skip Gemini, all Opus
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Gemini unavailable | CLI not installed or network issue | Fall back to Opus-only mode |
| Step execution fails | Gemini error on step | Retry once, then escalate to Opus |
| Plan too complex | Too many steps or dependencies | Break into sub-plans |
| Success criteria not met | Execution incomplete | Opus revises plan, re-executes |

**Fallback**: If orchestration fails, complete entire task in Opus mode.

## Related

- `/ai-collab` - Get perspectives from all three AIs
- `dispatcher` agent - General-purpose routing
- `Plan` agent - Planning-only mode
