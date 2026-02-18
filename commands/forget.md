---
description: Remove a fact from memory
allowed-tools: Read, Write, Bash
---

# Forget

Remove a stored fact from the memory system.

## Usage
```
/forget <fact-id>
```

## Examples
```
/forget fact-20241218-001
/forget fact-20241215-003
```

## Process

1. **Locate Fact**
   - Find the fact file in `.claude/memory/facts/`
   - Verify the fact exists

2. **Archive (Don't Delete)**
   - Move to `.claude/memory/archived/` instead of deleting
   - Preserve for potential recovery
   - Add deletion metadata

3. **Update Cache**
   - Remove from `context-cache.json` hot facts
   - Clear from active memory

4. **Confirm Removal**
   - Report what was removed
   - Show archive location

## Archive Structure
```json
{
  "original_id": "fact-20241218-001",
  "content": "The original fact content",
  "archived_at": "2024-12-18T12:00:00Z",
  "reason": "user_requested"
}
```

## Safety
- Facts are archived, not permanently deleted
- Can be recovered from `.claude/memory/archived/`
- Bulk deletion requires confirmation

## Related Commands
- `/remember <fact>` - Save a new fact
- `/recall <query>` - Search facts

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Fact not found | Provided fact-id doesn't exist | Use `/recall` to find the correct fact ID |
| Invalid fact ID format | ID doesn't match expected pattern | Use format `fact-YYYYMMDD-NNN` or check facts directory |
| Archive directory missing | `.claude/memory/archived/` doesn't exist | Create the directory before running forget |
| Permission denied | Cannot move or write files | Check file permissions on `.claude/memory/` |

**Fallback**: If automatic archiving fails, manually move the fact file from `.claude/memory/facts/` to `.claude/memory/archived/` and update `context-cache.json` manually.
