---
description: Sync Neural Claude Code plugin to projects and update global hooks
allowed-tools: Bash, Read, Write
argument-hint: [hooks|project|status|all] [--force]
---

# /sync - Plugin Synchronization

Sync the Neural Claude Code plugin to projects and manage global hooks.

## Usage

```bash
/sync                            # Show sync status
/sync hooks                      # Update global hooks only
/sync project                    # Sync to current project
/sync all                        # Sync hooks + project
/sync project --force            # Overwrite existing files
/sync all --dry-run              # Preview changes
```

## Arguments

`$ARGUMENTS` - Command and options

| Command | Description |
|---------|-------------|
| `hooks` | Update global hooks in ~/.claude/settings.json |
| `project` | Sync plugin components to current project |
| `status` | Show sync status for current project |
| `all` | Sync hooks + current project |

| Option | Description |
|--------|-------------|
| `--force` | Overwrite existing files |
| `--dry-run` | Show what would change without making changes |

## Protocol

### Step 1: Determine Command

Parse `$ARGUMENTS` to determine what to sync:
- No args or `status` → Show current status
- `hooks` → Update global hooks only
- `project` → Sync to current project
- `all` → Do both

### Step 2: Execute Sync

Run the sync script:

```bash
bash ~/Sites/neural-claude-code-plugin/scripts/sync-plugin.sh $ARGUMENTS
```

### Step 3: Report Results

Show what was synced:
- Files created/updated
- Hooks configured
- Any warnings or errors

## What Gets Synced

### To Global (~/.claude/settings.json)
- SessionStart hook → session-start.sh
- PostToolUse hook → post-tool-use.sh
- Stop hook → stop-tts.sh

### To Project (.claude/)
- `commands/` → Slash commands
- `scripts/` → Utility scripts including index-learnings.sh
- `schemas/` → Validation schemas
- `memory/learnings/` → Learnings infrastructure
- `agents/AGENTS.md` → Shared agent instructions

## Examples

```bash
# Check current status
/sync status

# Update global hooks
/sync hooks

# Sync current project
/sync project

# Sync everything
/sync all

# Force overwrite existing files
/sync project --force

# Preview changes without applying
/sync all --dry-run
```

## After Syncing

1. Restart Claude Code to pick up new hooks
2. Run `/recall` to verify learnings work
3. Check `status` to confirm everything is synced

## Troubleshooting

**Hooks not working?**
- Check ~/.claude/settings.json has correct paths
- Ensure plugin path exists: ~/Sites/neural-claude-code-plugin

**Learnings not loading?**
- Run `bash .claude/scripts/index-learnings.sh` to rebuild index
- Check .claude/memory/learnings/summary.md exists

**Commands missing?**
- Run `/sync project --force` to refresh all commands

## Output Format

```markdown
## Sync Results

**Command**: [hooks|project|all]
**Status**: [Success|Partial|Failed]

### Updated
- [file1] - Created
- [file2] - Updated
- [file3] - Skipped (exists)

### Hooks Status
| Hook | Path | Status |
|------|------|--------|
| SessionStart | ~/.claude/... | Active |

### Next Steps
1. Restart Claude Code to pick up new hooks
2. Run `/recall` to verify learnings
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Plugin not found | Wrong path | Set CLAUDE_PLUGIN_ROOT env var |
| Permission denied | File permissions | Check write access to ~/.claude |
| File exists | Previous sync | Use `--force` to overwrite |
| Script missing | Incomplete plugin | Re-clone plugin repository |

**Fallback**: If script fails, show manual sync commands.
