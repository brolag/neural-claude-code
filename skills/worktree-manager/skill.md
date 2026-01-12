---
name: worktree-manager
description: Create, manage, and merge git worktrees for parallel development. Use when starting parallel features, running multiple Claude instances, or when user says "create worktree", "new workspace", "parallel development", or any /wt-* command.
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Worktree Manager

Manage git worktrees for parallel Claude Code development.

## Why Worktrees

- **Isolation**: Each worktree is a separate working directory
- **Parallelism**: Multiple Claude instances can work simultaneously
- **Clean Integration**: Feature branches merge cleanly to main
- **No Conflicts**: Work on multiple features without stashing

## Commands

### `/wt-new <feature-name>`
Create a new worktree for a feature.

**Process**:
1. Validate feature name (kebab-case)
2. Create branch: `git branch feature/<name>`
3. Create worktree: `git worktree add ../worktrees/<name> feature/<name>`
4. Copy minimal .claude/ structure
5. Initialize worktree memory
6. Output activation instructions

**Script**:
```bash
#!/bin/bash
FEATURE="$1"
BASE_DIR=$(dirname "$(pwd)")
WT_DIR="$BASE_DIR/worktrees/$FEATURE"

# Validate name
if [[ ! "$FEATURE" =~ ^[a-z0-9-]+$ ]]; then
    echo "Error: Feature name must be kebab-case"
    exit 1
fi

# Create branch and worktree
git branch "feature/$FEATURE" 2>/dev/null || true
git worktree add "$WT_DIR" "feature/$FEATURE"

# Initialize minimal .claude structure
mkdir -p "$WT_DIR/.claude/memory"
cp .claude/settings.local.json "$WT_DIR/.claude/" 2>/dev/null || true
echo "# Worktree: $FEATURE" > "$WT_DIR/.claude/CLAUDE.md"
echo "Created: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$WT_DIR/.claude/CLAUDE.md"

# Register in worktree registry
echo "{\"name\": \"$FEATURE\", \"path\": \"$WT_DIR\", \"created\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\", \"status\": \"active\"}" >> .claude/memory/worktrees.jsonl

echo "Created worktree at: $WT_DIR"
echo "To start: cd $WT_DIR && claude"
```

### `/wt-list`
List all active worktrees with status.

**Script**:
```bash
#!/bin/bash
echo "=== Active Worktrees ==="
git worktree list --porcelain | while read line; do
    if [[ "$line" == "worktree "* ]]; then
        path="${line#worktree }"
        echo ""
        echo "Path: $path"
    elif [[ "$line" == "branch "* ]]; then
        branch="${line#branch refs/heads/}"
        echo "Branch: $branch"
    fi
done
```

### `/wt-status <name>`
Show detailed status of a specific worktree.

### `/wt-merge <name>`
Merge worktree branch back to main and optionally cleanup.

**Script**:
```bash
#!/bin/bash
FEATURE="$1"
BASE_DIR=$(dirname "$(pwd)")
WT_DIR="$BASE_DIR/worktrees/$FEATURE"

if [ ! -d "$WT_DIR" ]; then
    echo "Worktree not found: $FEATURE"
    exit 1
fi

# Check for uncommitted changes
cd "$WT_DIR"
if [ -n "$(git status --porcelain)" ]; then
    echo "Warning: Uncommitted changes. Commit or stash first."
    exit 1
fi

# Return to main repo and merge
cd -
git checkout main
git merge "feature/$FEATURE" --no-ff -m "Merge feature/$FEATURE"

echo "Merged feature/$FEATURE into main"
echo "Run '/wt-clean $FEATURE' to remove the worktree"
```

### `/wt-clean [name|--stale]`
Remove worktree(s) and clean up branches.

**Script**:
```bash
#!/bin/bash
if [ "$1" == "--stale" ]; then
    echo "=== Cleaning Stale Worktrees ==="
    git worktree prune
    git branch --merged main | grep "feature/" | xargs -r git branch -d
else
    FEATURE="$1"
    BASE_DIR=$(dirname "$(pwd)")
    WT_DIR="$BASE_DIR/worktrees/$FEATURE"

    git worktree remove "$WT_DIR" --force
    git branch -d "feature/$FEATURE" 2>/dev/null || true

    # Update registry
    if [ -f .claude/memory/worktrees.jsonl ]; then
        grep -v "\"name\": \"$FEATURE\"" .claude/memory/worktrees.jsonl > /tmp/wt.tmp
        mv /tmp/wt.tmp .claude/memory/worktrees.jsonl
    fi

    echo "Removed worktree: $FEATURE"
fi
```

### `/wt-sync`
Sync memory and learnings between worktrees.

## Multi-Agent Worktree Pattern

For complex tasks, spawn specialized agents in separate worktrees:

```bash
# Create specialized worktrees
/wt-new backend-auth
/wt-new frontend-auth
/wt-new tests-auth

# Launch agents in each (separate terminals)
cd ../worktrees/backend-auth && claude -p "Implement auth API"
cd ../worktrees/frontend-auth && claude -p "Implement login UI"
cd ../worktrees/tests-auth && claude -p "Write auth tests"

# Merge in sequence
/wt-merge backend-auth
/wt-merge frontend-auth
/wt-merge tests-auth
```

## Usage

```bash
# Create new worktree
/wt-new auth-feature

# List active worktrees
/wt-list

# Check specific worktree status
/wt-status auth-feature

# Merge completed feature
/wt-merge auth-feature

# Clean up worktree
/wt-clean auth-feature

# Clean all stale worktrees
/wt-clean --stale

# Sync memory between worktrees
/wt-sync
```

## Output Format

```markdown
## Worktree: [action]

**Feature**: [name]
**Branch**: feature/[name]
**Path**: ../worktrees/[name]
**Status**: [created/merged/removed]

### Next Steps
[Action-specific instructions]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Invalid name | Not kebab-case | Use lowercase letters, numbers, hyphens |
| Worktree exists | Duplicate name | Choose different name or clean existing |
| Uncommitted changes | Dirty working tree | Commit or stash changes first |
| Branch exists | Previous incomplete cleanup | Delete branch manually or use --force |
| Merge conflict | Divergent branches | Resolve conflicts in worktree first |

**Fallback**: If worktree creation fails, fall back to regular branch workflow.

## Safety Constraints

- Never create worktrees inside existing worktrees
- Always check for uncommitted changes before operations
- Track all worktrees in memory registry
- Validate feature names (kebab-case only)
