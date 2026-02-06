---
description: Update Neural Claude Code plugin from GitHub and sync changes to projects
allowed-tools: Bash, Read, Write, Glob
argument-hint: [--sync] [--changelog] [--dry-run]
---

# /update - Neural Claude Code Update

Pull the latest changes from the Neural Claude Code plugin repository and optionally sync them to the current project.

## Usage

```bash
/update                   # Pull latest changes
/update --sync            # Pull + sync to current project
/update --changelog       # Show recent changes only
/update --dry-run         # Preview what would be updated
```

## Arguments

`$ARGUMENTS` - Options for the update

| Option | Description |
|--------|-------------|
| `--sync` | After pulling, sync changes to current project |
| `--changelog` | Show recent commits without pulling |
| `--dry-run` | Show what would be updated without making changes |

## Protocol

### Step 1: Check Plugin Directory

```bash
# Verify plugin exists
PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code}"

if [ ! -d "$PLUGIN_DIR" ]; then
  echo "Plugin not found at $PLUGIN_DIR"
  echo "Clone it: git clone https://github.com/brolag/neural-claude-code $PLUGIN_DIR"
  exit 1
fi
```

### Step 2: Check Current State

```bash
cd "$PLUGIN_DIR"

# Get current commit
BEFORE_COMMIT=$(git rev-parse --short HEAD)

# Check for uncommitted changes
git status --porcelain
```

### Step 3: Pull Changes

If not `--dry-run` or `--changelog`:

```bash
cd "$PLUGIN_DIR"
git fetch origin
git pull origin main
AFTER_COMMIT=$(git rev-parse --short HEAD)
```

### Step 4: Show Changes

```bash
# Show commits since last update
git log --oneline ${BEFORE_COMMIT}..HEAD

# Show changed files
git diff --stat ${BEFORE_COMMIT}..HEAD
```

### Step 5: Sync to Project (if --sync)

If `--sync` flag is present:
- Copy new/updated commands to `.claude/commands/`
- Copy new/updated skills to `.claude/skills/`
- Copy new/updated agents to `.claude/agents/`
- Update scripts if changed

## Output Format

```markdown
## Neural Claude Code Update

**Plugin**: ~/Sites/neural-claude-code
**Before**: {commit_before}
**After**: {commit_after}

### Changes Pulled

| Commits | Files | Insertions | Deletions |
|---------|-------|------------|-----------|
| {n}     | {n}   | +{n}       | -{n}      |

### Recent Commits
- {hash} {message}
- {hash} {message}
- ...

### New/Updated Components
- commands/{name}.md - NEW
- skills/{name}/skill.md - UPDATED
- agents/{name}.md - UPDATED

### Sync Status
{if --sync}: Synced to current project
{else}: Run `/update --sync` to sync to this project

### Next Steps
1. Review new features in CHANGELOG.md
2. Run `/sync project` if needed
3. Restart Claude Code if hooks changed
```

## Examples

```bash
# Basic update - just pull latest
/update

# Update and sync to current project
/update --sync

# Just see what changed recently
/update --changelog

# Preview update without applying
/update --dry-run
```

## What Gets Updated

### From GitHub
- `commands/` - New slash commands
- `skills/` - New and updated skills
- `agents/` - Agent definitions
- `scripts/` - Utility scripts
- `hooks/` - Hook configurations
- `output-styles/` - Output formatting
- `docs/` - Documentation

### Synced to Project (with --sync)
- `.claude/commands/` - Commands
- `.claude/skills/` - Skills
- `.claude/agents/` - Agents
- `.claude/scripts/` - Scripts

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Plugin not found | Directory missing | Clone plugin repo first |
| Git pull failed | Network/conflict | Check internet, resolve conflicts |
| Uncommitted changes | Local modifications | Stash or commit local changes |
| Permission denied | File access | Check directory permissions |

**Fallback**: If git pull fails, show manual instructions:
```bash
cd ~/Sites/neural-claude-code
git stash
git pull origin main
git stash pop
```

## Related Commands

| Command | Purpose |
|---------|---------|
| `/sync` | Sync plugin to project without pulling |
| `/install-skills` | Install specific skills |
| `/manage-skills` | Enable/disable skills |
| `/changelog-architect` | Analyze changelog for features |
