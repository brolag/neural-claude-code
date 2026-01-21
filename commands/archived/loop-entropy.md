---
description: Loop Entropy - Fight code entropy iteratively
allowed-tools: Bash, Read, Write
---

# Loop Entropy

Specialized Neural Loop for fighting code entropy.

Based on Ralph Wiggum's "Entropy Loop" pattern.

## Usage

```
/loop-entropy [--max <n>] [--focus <area>]
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--max <n>` | 30 | Maximum iterations |
| `--focus <area>` | all | Focus area: unused, dead, patterns, all |

## Examples

```bash
# Full entropy cleanup
/loop-entropy

# Focus on unused exports
/loop-entropy --focus unused --max 20

# Clean up dead code only
/loop-entropy --focus dead --max 15
```

## What Is Entropy?

Software entropy is the tendency of codebases to deteriorate over time:
- Unused exports that clutter the API
- Dead code that never executes
- Inconsistent patterns that confuse developers
- Outdated comments that mislead
- Duplicate code that diverges

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                  ENTROPY LOOP                                │
├─────────────────────────────────────────────────────────────┤
│  1. Scan for code smells (unused, dead, inconsistent)       │
│  2. Pick ONE issue to fix                                    │
│  3. Make the fix                                             │
│  4. Run tests to verify no regression                        │
│  5. Update progress.txt with improvement                     │
│  6. Commit the change                                        │
│  7. Check if codebase is clean → LOOP_COMPLETE               │
│  8. Repeat until clean or max iterations                     │
└─────────────────────────────────────────────────────────────┘
```

## Key Principle: Fight Entropy

From Ralph Wiggum:
> "Agents amplify what they see. Poor code leads to poorer code."

Every cleanup:
- Removes confusion for future developers (and agents)
- Reduces codebase surface area
- Improves maintainability
- Sets better patterns for AI to follow

## Output Format

```markdown
## Entropy Loop Progress

**Focus**: [unused|dead|patterns|all]
**Iteration**: [n] of [max]

### Cleaned This Session
| Type | Location | Description |
|------|----------|-------------|
| unused | src/utils.ts:15 | Removed unused export |

### Remaining Issues
- [type] - [file:line] - [description]

### Status
[RUNNING | COMPLETE | MAX_ITERATIONS]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Tests fail after fix | Removal broke something | Revert and skip that item |
| Can't detect dead code | Complex dependencies | Try different analyzer |
| False positive | Code used dynamically | Add to ignore list |
| No issues found | Codebase is clean | Nothing to do |

**Fallback**: If automated detection fails, use manual grep for common patterns.

## Related

- `/loop-start` - General purpose loop
- `/loop-coverage` - Test coverage loop
- `/loop-lint` - Linting cleanup loop
