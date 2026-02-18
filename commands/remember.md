---
description: Save a fact to persistent memory
allowed-tools: Read, Write, Edit
---

# Remember

Save important facts, learnings, or context to the memory system.

## Usage
```
/remember <fact to remember>
```

## Examples
```
/remember The user prefers YAML output format for structured data
/remember Project uses PARA methodology: Projects, Areas, Resources, Archive
/remember API rate limit for external service is 100 requests/minute
```

## Process

1. **Parse the Fact**
   - Extract the key information from the input
   - Determine category (preference, learning, context, pattern)
   - Generate a unique ID

2. **Store in Memory**
   - Write to `.claude/memory/facts/` as JSON
   - Include metadata: timestamp, category, source, confidence

3. **Update Context Cache**
   - Add to hot_facts in `context-cache.json`
   - Ensure quick access in current session

4. **Confirm Storage**
   - Report back what was saved
   - Show the fact ID for future reference

## Fact Structure
```json
{
  "id": "fact-20241218-001",
  "content": "The fact content here",
  "category": "preference|learning|context|pattern",
  "confidence": 1.0,
  "source": "user",
  "created": "2024-12-18T10:00:00Z",
  "last_validated": "2024-12-18T10:00:00Z",
  "tags": ["relevant", "tags"]
}
```

## Categories
- **preference**: User preferences and settings
- **learning**: Discovered patterns or insights
- **context**: Project-specific information
- **pattern**: Repeated behaviors or workflows

## Storage Location
- Individual facts: `.claude/memory/facts/{id}.json`
- Hot cache: `.claude/memory/context-cache.json`

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Memory directory missing | `.claude/memory/facts/` not created | Run `/setup` or create directory manually |
| JSON write failed | Disk full or permissions issue | Check disk space and directory permissions |
| Duplicate fact detected | Similar fact already exists | Use `/recall` to find existing, or `/forget` old one first |
| Context cache corrupted | Invalid JSON in cache file | Delete `context-cache.json` and restart session |
| Empty fact provided | No content after `/remember` | Provide the fact to remember after the command |

**Fallback**: If memory system fails, facts can be manually added to `.claude/memory/facts/` as JSON files following the documented structure.

## Related Commands
- `/recall <query>` - Search and retrieve facts
- `/forget <id>` - Remove a fact from memory
