# Prompt Validate

Verify research results, links, and claims from AI-generated outputs.

## Trigger
- `/prompt-validate <file-path>`
- "verify these results"
- "check if these links work"
- "validate this research"

## Process

### 1. Extract Items to Verify

Parse the input file for:
- URLs/links
- Organization/company names
- Specific claims with dates
- Statistics or numbers

### 2. Verification Loop

For each item:

```
1. WebSearch: "[item] official website 2025"
2. WebFetch: Check official URL for current info
3. Assess: Does current source confirm the claim?
4. Mark status:
   - [V] Verified - Confirmed on official source
   - [?] Uncertain - Found but couldn't fully confirm
   - [X] Not Found - No current evidence
```

### 3. Generate Report

```markdown
# Verification Report

## Summary
| Status | Count |
|--------|-------|
| [V] Verified | X |
| [?] Uncertain | Y |
| [X] Not Found | Z |
| **Total** | N |

## Verified Items [V]
| Item | Source | Verified Date | Notes |
|------|--------|---------------|-------|

## Uncertain Items [?]
| Item | Issue | Recommendation |
|------|-------|----------------|

## Not Found [X]
| Item | Search Attempted | Recommendation |
|------|------------------|----------------|

## Recommendations
1. Use only [V] items in final output
2. Investigate [?] items manually before using
3. Remove [X] items entirely
```

### 4. Optional: Update Source

If requested, modify original file:
- Add verification markers
- Remove unverified items
- Add verification timestamp

## Verification Standards

### For URLs:
- Page loads successfully
- Content matches expected topic
- Last updated within 12 months

### For Organizations:
- Official website exists
- Still active/operating
- Offers what's claimed (grants, services, etc.)

### For Claims/Stats:
- Primary source identifiable
- Date is current (2024 or later preferred)
- Numbers match source exactly

### For Deadlines:
- Confirmed on official site
- Not expired
- Matches claimed date

## Common Issues

| Issue | Action |
|-------|--------|
| Link 404s | Mark [X], search for updated URL |
| Outdated info | Mark [?], note last confirmed date |
| Redirects | Follow redirect, verify final destination |
| Paywalled | Mark [?], note paywall limitation |
| Different language | Use translate, verify key facts |

## When to Use

- After AI research/deep research output
- Before sharing results with stakeholders
- When accuracy is critical
- Periodic re-verification of stored data
