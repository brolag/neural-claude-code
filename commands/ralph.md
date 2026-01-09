# Ralph - Alias for Loop v3

Backward compatibility alias for the unified Loop system. Based on Matt Pocock's Ralph Wiggum pattern.

## Usage

```
/ralph [subcommand] [options]
```

## Subcommands

| Command | Maps To | Description |
|---------|---------|-------------|
| `/ralph "task"` | `/loop "task" --once` | Single HITL iteration |
| `/ralph once "task"` | `/loop "task" --once` | Single HITL iteration (explicit) |
| `/ralph afk <n> "task"` | `/loop "task" --afk --max <n>` | AFK autonomous loop |
| `/ralph setup` | `/loop "task" --init` | Initialize loop files |

## Examples

```bash
# Single iteration (watch and learn)
/ralph "Fix the authentication bug"

# Explicit once mode
/ralph once "Add input validation"

# AFK mode for 10 iterations
/ralph afk 10 "Implement user dashboard"

# Initialize loop files
/ralph setup
```

## Prompt

Parse $ARGUMENTS to determine the subcommand:

### Case 1: `/ralph "task"` or `/ralph once "task"`
Single HITL iteration. Run:
```bash
bash ~/.claude/scripts/neural-loop/loop-v3.sh "$TASK" 1 "LOOP_COMPLETE" "feature" "false" "true" "auto" "false" "false"
```

### Case 2: `/ralph afk <n> "task"`
AFK autonomous loop. Extract iterations and task, then run:
```bash
bash ~/.claude/scripts/neural-loop/loop-v3.sh "$TASK" "$N" "LOOP_COMPLETE" "feature" "true" "false" "auto" "false" "false"
```

### Case 3: `/ralph setup`
Tell the user to use `/loop "task" --init` instead, or run:
```bash
# Create basic features.json template
mkdir -p .claude/loop
cat > .claude/loop/features.json << 'EOF'
{
  "version": "3.0",
  "task": "Your task here",
  "created_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "loop_type": "feature",
  "features": [
    {
      "id": "feat-001",
      "category": "functional",
      "description": "First feature to implement",
      "steps": ["Step 1", "Step 2"],
      "priority": "high",
      "passes": false
    }
  ]
}
EOF
echo "Created .claude/loop/features.json - edit with your features"
```

## Why This Alias Exists

Ralph Wiggum is the original autonomous coding loop pattern by Matt Pocock. Loop v3 is the unified implementation that incorporates:

- Ralph's simplicity and HITL/AFK modes
- Neural Loop's specialized types (coverage, lint, entropy)
- Anthropic's harness patterns for long-running agents
- Vercel v0's pipeline architecture

The `/ralph` command provides a familiar interface for users who learned the Ralph pattern, while routing to the unified Loop v3 system.

## Full Loop Features

For advanced features, use `/loop` directly:

```bash
# Specialized loop types
/loop "task" --type coverage
/loop "task" --type lint
/loop "task" --type entropy

# With planning
/loop "task" --plan

# Force specific AI
/loop "task" --ai codex
```

## See Also

- `/loop` - Main unified command
- `/loop-status` - Check loop state
- `/loop-cancel` - Stop active loop
