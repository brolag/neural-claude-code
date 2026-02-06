# Neural Claude Code v1.4.0 Release Summary

**Release Date**: 2026-02-01
**Tag**: v1.4.0
**GitHub**: https://github.com/brolag/neural-claude-code/releases/tag/v1.4.0

---

## What's New

### 🎯 5 New Skills

| Skill | Category | Description | Trigger |
|-------|----------|-------------|---------|
| **react-best-practices** | Development | React/Next.js optimization (40+ rules, 6 refs) | React code |
| **slop-scan** | Quality | Detect technical debt and code smells | `/slop-scan` |
| **slop-fix** | Quality | Auto-fix safe slop issues | `/slop-fix` |
| **overseer** | Quality | Review PRs/diffs before merge | `/overseer` |
| **knowledge-management** | Knowledge | PARA-based second brain | `/capture` |

### ⬆️ 3 Updated Skills

- **debugging**: Improved error handling and root cause analysis
- **tdd**: Better task decomposition and RED-GREEN-REFACTOR
- **deep-research**: Auto-recall from knowledge base

### 🚀 Interactive Installer

New `/install-skills` command with:

- Interactive menu system (pure bash, no dependencies)
- Multi-select skill selection
- Automatic dependency resolution
- Project/Global/Both installation scopes
- Recommended bundle one-click install
- Dry-run mode for preview
- Installation tracking and status

**Usage**:
```bash
/install-skills                 # Interactive mode
/install-skills --recommended   # Install recommended bundle
/install-skills --status        # View installation status
/install-skills --dry-run       # Preview changes
```

---

## File Changes

### Added (19 files)

**Skills (8 new/updated)**:
- `skills/react-best-practices/skill.md` + 6 references
- `skills/knowledge-management/skill.md`
- `skills/slop-scan/skill.md`
- `skills/slop-fix/skill.md`
- `skills/overseer/skill.md`
- Updated: `skills/debugging/skill.md`
- Updated: `skills/tdd/skill.md`
- Updated: `skills/deep-research/skill.md`

**Installer (3 new)**:
- `scripts/install-skills.sh` (~800 lines)
- `commands/install-skills.md` (~150 lines)
- `.claude/skills-registry.json` (~130 lines)

### Modified

- `.claude-plugin/plugin.json` (version bump + keywords)
- `CHANGELOG.md` (v1.4.0 entry)
- `README.md` (installer instructions)

---

## Commits

### Skill Migration
```
db5281d feat: add 5 new skills and update 3 existing (v1.4.0)
```
- Added 5 new skills
- Updated 3 existing skills
- Bumped version to 1.4.0
- Added keywords: react, nextjs, knowledge-management, slop, code-quality, anti-slop

### Installer Script
```
4a250a6 feat: add interactive skills installer
```
- Interactive menu system
- Skills registry with metadata
- Multi-select with dependency resolution
- Project/Global/Both scopes
- Recommended bundle
- Dry-run mode

### Documentation
```
caca9af docs: update README for v1.4.0 with installer instructions
```
- Added installer to Quick Start
- Updated Quick Commands with new skills
- Version badge update

---

## Statistics

- **Total files changed**: 19
- **Lines added**: ~3,000
- **New skills**: 5
- **Updated skills**: 3
- **New commands**: 1
- **New scripts**: 1

---

## Migration Guide

### For Users

**Update plugin**:
```bash
cd ~/Sites/neural-claude-code
git pull origin main
```

**Install skills**:
```bash
# Interactive mode
/install-skills

# Or recommended bundle
/install-skills --recommended
```

### For Contributors

**Registry format** (`.claude/skills-registry.json`):
```json
{
  "categories": {
    "development": {
      "skills": [
        {
          "id": "skill-name",
          "name": "skill-name",
          "description": "What it does",
          "trigger": "/trigger",
          "source": "skills/skill-name/skill.md",
          "dependencies": [],
          "recommended": true
        }
      ]
    }
  }
}
```

---

## Breaking Changes

**None**. Fully backward compatible.

---

## Known Issues

1. **Bash 4.0+ required**: macOS ships with bash 3.2, installer requires 4.0+
   - **Fix**: `brew install bash`
   - **Workaround**: Manual skill installation (copy from `skills/` to `.claude/skills/`)

2. **jq required**: Installer uses jq for JSON parsing
   - **Fix**: `brew install jq`

---

## Next Steps

Planned for v1.5.0:
- Enhanced slop detection patterns
- More React/Next.js patterns from Vercel
- Knowledge graph visualization
- Auto-learning from project patterns
- Agent templates for slop-detector/slop-fixer/overseer

---

## Credits

**Skills Sources**:
- `react-best-practices`: Vercel Engineering
- `stop-slop`: Hardik Pandya
- Anti-slop trilogy: Generated from agent templates

**Contributors**:
- Alfredo Bonilla (@brolag)
- Claude Opus 4.5 (co-author)

---

**Full Changelog**: https://github.com/brolag/neural-claude-code/blob/main/CHANGELOG.md
