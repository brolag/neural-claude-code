# Prompt Improve

Automatically improve prompts using multi-AI review (Codex + Claude).

## Trigger
- `/prompt-improve <file-path>`
- "improve this prompt with AI feedback"
- "get multi-AI review of this prompt"

## Process

### 1. Read the Prompt
Read the file at the specified path.

### 2. Parallel AI Review

Launch both agents simultaneously using Task tool:

**Codex Agent:**
```
Review this prompt and suggest specific improvements. Be critical and actionable.

File: [path]

Focus on:
1. What will cause AI to produce poor/inconsistent results?
2. What's missing that would improve output quality?
3. Specific edits (show before/after)

Be brutally honest - what would YOU need to produce great results?
```

**Claude Structure Reviewer:**
```
Review this prompt and suggest specific improvements. Be critical and actionable.

File: [path]

Focus on:
1. Structure and format: Is it clear, scannable, well-organized?
2. Missing sections or ambiguous instructions?
3. Specific edits (show before/after)

Be brutally honest - what would make this prompt produce consistently great results?
```

### 3. Synthesize Feedback

Categorize issues:
- **Critical** (both reviewers flagged): Must fix
- **Important** (one reviewer flagged): Should fix
- **Minor** (suggestions): Nice to have

### 4. Apply Fixes

Create new version:
- Filename: `{original}_v{N+1}.md`
- Apply critical fixes first
- Document all changes

### 5. Re-assess

Run CRISP-E on new version:
- Compare before/after scores
- Verify improvements addressed issues

## Output Format

```markdown
# Prompt Improvement Report

## Files
- Original: [filename]
- Improved: [filename_vN]

## AI Feedback Summary

### Critical Issues (Both Reviewers)
| Issue | Codex Said | Structure Review Said | Fix Applied |
|-------|------------|----------------------|-------------|

### Important Issues (One Reviewer)
| Issue | Source | Fix Applied |
|-------|--------|-------------|

## Changes Made
| Line | Before | After | Reason |
|------|--------|-------|--------|

## Score Comparison
| Dimension | Before | After | Change |
|-----------|--------|-------|--------|
| CRISP-E Total | X.X | X.X | +X.X |

## Validation
- [ ] All critical issues addressed
- [ ] New version runs without errors
- [ ] Output format preserved
```

## When to Use

- CRISP-E score below 4.0
- Prompt will be used repeatedly
- High-stakes output (production, grants, etc.)
- Want diverse perspectives on improvement

## Tips

- Run on prompts BEFORE heavy use
- Both reviewers often catch different issues
- Codex: Strong on executability/edge cases
- Structure Review: Strong on format/organization
