# Post-Commit Auto-Improve Hook

Automatically updates expertise files when relevant code changes.

## Setup

Add to your project's `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/check-git-improve.sh",
            "timeout": 5000
          }
        ]
      }
    ]
  }
}
```

## Script: `.claude/scripts/check-git-improve.sh`

```bash
#!/bin/bash
set -e

# Check if this was a git commit
if [[ "$TOOL_INPUT" != *"git commit"* ]]; then
  exit 0
fi

# Get changed files from last commit
CHANGED_FILES=$(git diff --name-only HEAD~1 HEAD 2>/dev/null || echo "")

# Map file changes to expertise domains
DOMAINS_TO_UPDATE=""

for file in $CHANGED_FILES; do
  case "$file" in
    00_inbox/*|01_projects/*|02_areas/*|03_resources/*|04_archive/*)
      DOMAINS_TO_UPDATE="$DOMAINS_TO_UPDATE knowledge-management"
      ;;
    .claude/agents/*)
      DOMAINS_TO_UPDATE="$DOMAINS_TO_UPDATE second-brain"
      ;;
    .claude/skills/*)
      DOMAINS_TO_UPDATE="$DOMAINS_TO_UPDATE second-brain"
      ;;
    src/*|lib/*)
      DOMAINS_TO_UPDATE="$DOMAINS_TO_UPDATE project"
      ;;
  esac
done

# Deduplicate domains
DOMAINS_TO_UPDATE=$(echo "$DOMAINS_TO_UPDATE" | tr ' ' '\n' | sort -u | tr '\n' ' ')

# Output domains that need updating
if [ -n "$DOMAINS_TO_UPDATE" ]; then
  echo "EXPERTISE_UPDATE_NEEDED: $DOMAINS_TO_UPDATE"
fi
```

## Trigger Condition

The hook triggers when:
1. A `git commit` command completes
2. Changed files match expertise domain patterns
3. Expertise file exists for that domain

## Auto-Update Behavior

When triggered:
1. Identifies changed files
2. Maps to relevant expertise domains
3. Queues domains for `/meta/improve`
4. Updates incrementally (not full sync)

### Incremental Update

For performance, only update:
- `last_updated` timestamp
- `version` increment
- Add to `lessons_learned` if new pattern detected

```yaml
# Example incremental update
lessons_learned:
  - lesson: "User committed changes to 00_inbox/ structure"
    confidence: 0.5
    learned_on: "2024-12-18"
    context: "git commit detected inbox changes"
```

## Manual Trigger

You can also manually trigger:

```bash
# Trigger for specific domains
echo "EXPERTISE_UPDATE_NEEDED: knowledge-management" | claude

# Or use the command directly
/meta/improve knowledge-management
```

## Safety

- Hook has 5 second timeout
- Only reads, never modifies git state
- Skips if no expertise file exists
- Logs all updates to `.claude/logs/auto-improve.log`
