---
description: Loop Lint - Fix linting errors iteratively
allowed-tools: Bash, Read, Write
---

# Loop Lint

Specialized Neural Loop for fixing linting errors.

Based on Ralph Wiggum's "Linting Loop" pattern.

## Usage

```
/loop-lint [--max <n>]
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--max <n>` | 50 | Maximum iterations |

## Examples

```bash
# Fix all ESLint errors
/loop-lint

# Quick fix with limit
/loop-lint --max 20
```

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    LINT LOOP                                 │
├─────────────────────────────────────────────────────────────┤
│  1. Run linter (eslint, tsc, ruff, etc.)                    │
│  2. Parse error output                                       │
│  3. Fix ONE error                                            │
│  4. Run linter again to verify fix                           │
│  5. Update progress.txt with error fixed                     │
│  6. Check if no errors remain → LOOP_COMPLETE                │
│  7. Repeat until clean or max iterations                     │
└─────────────────────────────────────────────────────────────┘
```

## Supported Linters

Automatically detected:
- **JavaScript/TypeScript**: ESLint, TSC
- **Python**: Ruff, Pylint, Flake8
- **Go**: golint, staticcheck
- **Rust**: clippy

## Best Practices

1. **One error per iteration** - Prevents cascading mistakes
2. **Verify before moving on** - Run linter after each fix
3. **Don't auto-fix everything** - Some rules need human judgment
4. **Commit frequently** - Easy rollback if something breaks

## Output Format

```markdown
## Lint Loop Progress

**Linter**: [eslint|tsc|ruff|...]
**Errors Remaining**: [n]
**Iteration**: [n] of [max]

### Fixed This Session
| File | Line | Rule | Fix |
|------|------|------|-----|
| src/app.ts | 42 | no-unused-vars | Removed unused import |

### Remaining Errors
- [file:line] - [rule] - [message]

### Status
[RUNNING | COMPLETE | MAX_ITERATIONS]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Linter not found | Not installed | Install linter package |
| Fix causes new error | Cascading issues | Revert, fix manually |
| Rule not auto-fixable | Needs human judgment | Skip or disable rule |
| Config missing | No .eslintrc/etc | Create config file |

**Fallback**: If linter detection fails, ask user which linter to use.

## Related

- `/loop-start` - General purpose loop
- `/loop-coverage` - Test coverage loop
- `/loop-entropy` - Code smell cleanup
