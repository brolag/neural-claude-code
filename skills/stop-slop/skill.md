---
name: stop-slop
description: Remove AI writing patterns from prose. Use when drafting, editing, or reviewing text to eliminate predictable AI tells.
trigger: Writing prose, editing drafts, reviewing content for AI patterns, after content generation
author: Based on hvpandya.com, adapted for Neural Claude Code
version: 1.0.0
---

# Stop Slop

Eliminate predictable AI writing patterns from prose.

## When to Use

- After generating any content (posts, articles, documentation)
- When editing drafts for publication
- Before finalizing any user-facing text
- As a quality gate in the content pipeline

## Core Rules

1. **Cut filler phrases.** Remove throat-clearing openers and emphasis crutches. See [references/phrases.md](references/phrases.md).

2. **Break formulaic structures.** Avoid binary contrasts, dramatic fragmentation, rhetorical setups. See [references/structures.md](references/structures.md).

3. **Vary rhythm.** Mix sentence lengths. Two items beat three. End paragraphs differently.

4. **Trust readers.** State facts directly. Skip softening, justification, hand-holding.

5. **Cut quotables.** If it sounds like a pull-quote, rewrite it.

## Quick Checks

Before delivering prose:

- Three consecutive sentences match length? Break one.
- Paragraph ends with punchy one-liner? Vary it.
- Em-dash before a reveal? Remove it.
- Explaining a metaphor? Trust it to land.
- Using "Here's the thing" or "Let that sink in"? Delete.

## Scoring

Rate 1-10 on each dimension:

| Dimension | Question |
|-----------|----------|
| Directness | Statements or announcements? |
| Rhythm | Varied or metronomic? |
| Trust | Respects reader intelligence? |
| Authenticity | Sounds human? |
| Density | Anything cuttable? |

**Below 35/50: revise.**

## Process

### 1. Scan for Banned Phrases
Check against [references/phrases.md](references/phrases.md):
- Throat-clearing openers
- Emphasis crutches
- Business jargon
- Filler adverbs
- Meta-commentary

### 2. Check Structures
Check against [references/structures.md](references/structures.md):
- Binary contrasts ("Not X. Y.")
- Dramatic fragmentation
- Rhetorical setups
- Formulaic constructions

### 3. Analyze Rhythm
- Count sentence lengths
- Check for three-item lists (prefer two)
- Look for metronomic endings
- Find em-dash reveals

### 4. Score and Revise
- Apply scoring rubric
- If below 35/50, revise
- Re-check after revisions

## Output Format

When reviewing text, output:

```
## Stop-Slop Analysis

**Score**: X/50

### Issues Found
- [Issue 1]: "quoted text" → suggested fix
- [Issue 2]: "quoted text" → suggested fix

### Revised Version
[Clean version with issues fixed]

### Score Breakdown
| Dimension | Score | Notes |
|-----------|-------|-------|
| Directness | X/10 | ... |
| Rhythm | X/10 | ... |
| Trust | X/10 | ... |
| Authenticity | X/10 | ... |
| Density | X/10 | ... |
```

## Examples

### Before
> "Here's the thing: building products is hard. Not because the technology is complex. Because people are complex. Let that sink in."

### After
> "Building products is hard. Technology is manageable. People aren't."

### Before
> "In today's fast-paced landscape, we need to lean into discomfort and navigate uncertainty with clarity."

### After
> "Move faster. Your competition is."

## Integration

This skill integrates with:
- `content-creation` - Run as post-processing step
- `deep-research` - Clean up research summaries
- Manual editing - Invoke directly on any text

## License

Based on MIT-licensed work from hvpandya.com.

## Usage

```bash
# Analyze and clean a draft
/stop-slop "Here's the thing: building products is hard. Not because..."

# Review a file for AI patterns
/stop-slop --file draft.md

# Score-only mode (no rewrites)
/stop-slop --score-only "In today's fast-paced landscape..."

# Strict mode (score must be 40+)
/stop-slop --strict "Your content here"

# Apply to generated content automatically
/content "Write about AI trends" | /stop-slop
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Score too low | Heavy AI patterns detected | Apply suggested fixes and re-run until score exceeds 35/50 |
| No issues found | Content already clean or too short | Review manually; skill works best on 50+ word passages |
| Reference files missing | `references/phrases.md` or `structures.md` not found | Restore from skill template or rebuild reference lists |
| Over-correction | Removing too much causes loss of meaning | Use `--preserve-meaning` flag or manually restore key phrases |
| False positives | Legitimate phrases flagged as slop | Add to `references/exceptions.md` whitelist |

**Fallback**: If the skill fails to process, manually review text against the Quick Checks list and apply the five core rules by hand.
