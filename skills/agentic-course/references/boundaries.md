# Quick Reference: 3-Tier Boundaries

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  ✅ ALWAYS DO (Green Light)                                    │
│     No approval needed. Safe to execute.                        │
│                                                                 │
│  ⚠️ ASK FIRST (Yellow Light)                                   │
│     Stop and request approval before proceeding.                │
│                                                                 │
│  🚫 NEVER DO (Red Light)                                       │
│     Hard stop. Refuse even if asked.                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Common Examples

### ✅ ALWAYS DO
- Run tests before commits
- Run linter before commits
- Follow existing code patterns
- Add comments for complex logic
- Create feature branches

### ⚠️ ASK FIRST
- Adding new dependencies
- Changing database schema
- Modifying public API contracts
- Updating auth logic
- Deleting files

### 🚫 NEVER DO
- Commit secrets/API keys
- Push to main directly
- Delete production data
- Force push
- Bypass code review

## Template

```markdown
## Project Boundaries

### ✅ Always
- [Your safe actions]

### ⚠️ Ask First
- [Your risky actions]

### 🚫 Never
- [Your forbidden actions]
```

---
*Quick reference from /course ref boundaries*
