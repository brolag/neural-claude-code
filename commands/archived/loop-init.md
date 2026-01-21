---
description: Loop Init - Create features.json and progress.txt for loops
allowed-tools: Read, Write, Glob, Bash
---

# Initialize Neural Loop

Create artifacts (features.json, progress.txt) before starting a Neural Loop.

Based on the Anthropic "Effective Harnesses for Long-Running Agents" pattern.

## Usage

```
/loop-init "<task description>" [--type <loop_type>]
```

## Arguments

- `task description` - High-level task to break into features
- `--type <type>` - Loop type: feature (default), coverage, lint, entropy

## Process

### 1. Analyze Task

Break the task into discrete features with:
- Unique ID
- Category (functional, test, refactor, docs, config)
- Description
- Verification steps
- Priority (high, medium, low)
- passes: false

### 2. Generate features.json

Create `.claude/loop/features.json`:

```json
{
  "version": "2.0",
  "task": "User's task description",
  "created_at": "ISO-8601 timestamp",
  "loop_type": "feature",
  "features": [
    {
      "id": "feat-001",
      "category": "functional",
      "description": "What this feature does",
      "steps": ["Step 1", "Step 2"],
      "priority": "high",
      "passes": false
    }
  ]
}
```

### 3. Generate progress.txt

Create `.claude/loop/progress.txt`:

```
# Neural Loop Progress
Task: <task description>
Started: <timestamp>
Type: <loop_type>

## Iterations

(empty - will be filled as work progresses)
```

### 4. Health Check

Verify:
- [ ] Git working directory is clean (or has only expected changes)
- [ ] No stale todo.md from previous sessions
- [ ] Required dependencies are available
- [ ] Test framework is runnable (if applicable)

### 5. Output Summary

```
Neural Loop Initialized!

Task: <task description>
Type: <loop_type>
Features: <count> items

Priority breakdown:
  - High: <n>
  - Medium: <n>
  - Low: <n>

Health check: PASSED/WARNINGS

Run /loop-start to begin autonomous iteration.
```

## Why JSON Over Markdown?

Per Anthropic's research:
- JSON is less prone to formatting errors during updates
- Structured data enables programmatic status checks
- `passes: true/false` is unambiguous
- Easier to parse in hooks and scripts

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Dirty git state | Uncommitted changes | Commit or stash first |
| Task too vague | Can't generate features | Ask for more detail |
| Directory exists | Previous loop artifacts | Use `--force` to overwrite |
| Health check fails | Missing dependencies | Install requirements first |

**Fallback**: If feature decomposition fails, create single-feature file for manual breakdown.
