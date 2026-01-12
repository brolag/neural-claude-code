---
name: memory-system
description: Read and write to the memory system. Use when user says "remember this", "what do you know about", "forget", or when other skills need to persist information.
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Memory System

Manage persistent memory across sessions with tiered global + project architecture.

## Memory Architecture

### Scope Tiers

```
┌─────────────────────────────────────────────────┐
│                 GLOBAL MEMORY                    │
│            ~/.claude/memory/                     │
│  - User preferences across all projects          │
│  - Universal patterns and learnings              │
│  - Cross-project insights                        │
└─────────────────────────────────────────────────┘
                      ↓ inherits
┌─────────────────────────────────────────────────┐
│                PROJECT MEMORY                    │
│           .claude/memory/                        │
│  - Project-specific facts                        │
│  - Codebase patterns                             │
│  - Local context                                 │
└─────────────────────────────────────────────────┘
```

### Access Priority

1. **Project facts** - checked first (most specific)
2. **Global facts** - fallback (universal knowledge)
3. **Merged context** - combines both for full picture

## Temperature Tiers

### Hot Memory (Context Window)
- Current conversation
- Loaded at session start from `active_context.md`
- Fastest access
- Ephemeral (lost on session end unless saved)

### Warm Memory (JSON/JSONL)
- Recent events: `.claude/memory/events/`
- Cached context: `.claude/memory/context-cache.json`
- Facts: `.claude/memory/facts/`
- Access within seconds
- Persists across sessions

### Cold Memory (Archives)
- `CLAUDE.md` - Project instructions
- Session archives: `.claude/memory/session_logs/`
- Historical patterns
- Requires explicit retrieval

## Commands

### `/remember <fact>` or `/remember --global <fact>`
Save a fact to memory.

**Scope**:
- Default: Project memory (`.claude/memory/facts/`)
- `--global`: Global memory (`~/.claude/memory/facts/`)

**Process**:
1. Parse the fact
2. Generate unique ID
3. Categorize (preference, pattern, learning, etc.)
4. Write to `.claude/memory/facts/`
5. Update `active_context.md` if relevant

**Fact Schema**:
```json
{
  "id": "fact-uuid",
  "timestamp": "ISO-8601",
  "category": "preference|pattern|learning|context",
  "content": "The fact to remember",
  "source": "user|pattern-detector|session",
  "confidence": 1.0,
  "last_accessed": null,
  "access_count": 0
}
```

### `/recall <query>`
Search memory for relevant information.

**Process**:
1. Search facts by keyword
2. Search events for context
3. Check active_context.md
4. Return ranked results

### `/forget <fact-id|query>`
Remove information from memory.

**Process**:
1. Find matching facts
2. Confirm with user
3. Archive (don't delete)
4. Update active_context.md

## Event Logging

All significant events are logged to `.claude/memory/events/{date}.jsonl`:

```json
{"timestamp": "...", "event": "session_start", "data": {...}}
{"timestamp": "...", "event": "tool_use", "tool": "Edit", "file": "src/app.ts"}
{"timestamp": "...", "event": "pattern_detected", "pattern_id": "..."}
{"timestamp": "...", "event": "session_end", "summary": "..."}
```

## Active Context

The `active_context.md` file is loaded at session start:

```markdown
# Active Context

## Recent Learnings
- {Learning 1}
- {Learning 2}

## User Preferences
- Prefers TypeScript over JavaScript
- Uses pnpm as package manager

## Current Focus
- Working on authentication feature
- Last session: Implemented login UI

## Quick Notes
- {Note 1}
```

## Memory Maintenance

### Consolidation (Weekly)
- Merge similar facts
- Archive old events
- Update active_context.md

### Cleanup (Monthly)
- Remove stale facts (not accessed in 60 days)
- Compress event logs
- Update patterns

## Helper Scripts

### memory_read.py
```python
#!/usr/bin/env python3
import json
import sys
from pathlib import Path

def read_memory(query, memory_dir=".claude/memory"):
    results = []

    # Search facts
    facts_dir = Path(memory_dir) / "facts"
    for fact_file in facts_dir.glob("*.json"):
        fact = json.loads(fact_file.read_text())
        if query.lower() in fact["content"].lower():
            results.append(fact)

    return sorted(results, key=lambda x: x.get("access_count", 0), reverse=True)

if __name__ == "__main__":
    query = sys.argv[1] if len(sys.argv) > 1 else ""
    for result in read_memory(query):
        print(json.dumps(result))
```

### memory_write.py
```python
#!/usr/bin/env python3
import json
import sys
import uuid
from datetime import datetime
from pathlib import Path

def write_fact(content, category="learning", memory_dir=".claude/memory"):
    fact = {
        "id": f"fact-{uuid.uuid4().hex[:8]}",
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "category": category,
        "content": content,
        "source": "user",
        "confidence": 1.0,
        "access_count": 0
    }

    facts_dir = Path(memory_dir) / "facts"
    facts_dir.mkdir(parents=True, exist_ok=True)

    fact_file = facts_dir / f"{fact['id']}.json"
    fact_file.write_text(json.dumps(fact, indent=2))

    return fact

if __name__ == "__main__":
    content = sys.argv[1] if len(sys.argv) > 1 else ""
    category = sys.argv[2] if len(sys.argv) > 2 else "learning"
    fact = write_fact(content, category)
    print(json.dumps(fact))
```

## Usage

```bash
# Remember a fact (project scope)
/remember "User prefers dark mode themes"

# Remember globally
/remember --global "Always use TypeScript"

# Search memory
/recall "user preferences"

# Forget a fact
/forget fact-abc123

# Forget by query
/forget "outdated preference"
```

## Output Format

```markdown
## Memory: [action]

**Action**: [remembered/recalled/forgotten]
**Scope**: [project/global]

### Details
[Fact content or search results]

### Location
[File path where stored/found]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Memory dir not found | Not initialized | Run `/setup` to create structure |
| JSON parse error | Corrupted fact file | Repair or delete corrupted file |
| Duplicate fact | Already exists | Skip or update existing |
| Fact not found | Invalid ID or query | Check ID or broaden search |
| Write permission denied | File system issue | Check directory permissions |

**Fallback**: If structured memory fails, fall back to CLAUDE.md for critical facts.

## Safety Constraints

- Never store sensitive data (passwords, keys)
- Validate JSON before writing
- Maintain backup before bulk operations
- Respect .gitignore for local memory
