# Continuous Improvement Quick Reference

## The Four Pillars

| Pillar | Principle | Action |
|--------|-----------|--------|
| **Kaizen** | Small, frequent improvements | One change at a time |
| **Poka-Yoke** | Error-proof by design | Fail fast, validate early |
| **Standardization** | Follow what works | Document successful patterns |
| **YAGNI** | Build only what's needed | Delete unused code |

---

## Kaizen: Small Improvements

```
❌ Big rewrites
✅ 1% better every day

37x improvement in a year from 1% daily gains
```

**Daily practice:**
- Fix one small issue per session
- Leave code better than you found it
- Never save "I'll fix it later"

---

## Poka-Yoke: Error-Proofing

```
PREVENTION LEVELS (best to worst)
─────────────────────────────────
1. IMPOSSIBLE  → Can't make the error
2. AUTOMATIC   → System catches immediately
3. OBVIOUS     → Error is visible
4. HIDDEN      → Discovered later
5. SILENT      → Corrupts undetected
```

**Implementation:**
- Validate at boundaries
- Use types to prevent invalid states
- Fail fast and loud
- Don't rely on documentation

---

## Standardization: Follow What Works

```
PATTERN → DOCUMENT → FOLLOW → IMPROVE
```

**What to standardize:**
- Commit message format
- Prompt structure (CRAFT)
- Error handling patterns
- Code review checklist

**What NOT to standardize:**
- Unproven approaches
- Solutions to non-problems
- Context-specific patterns

---

## YAGNI: Build Only What's Needed

**Delete:**
- Unused code
- Commented-out sections
- "Just in case" features
- Dead prompts and agents

**Don't add:**
- Features "in case"
- Premature abstractions
- Hypothetical scale
- Helpful options nobody asked for

---

## Iterative Refinement

```
Pass 1: Make it WORK   → Correct output only
Pass 2: Make it CLEAR  → Readable and maintainable
Pass 3: Make it EFFICIENT → Fast enough (if needed)

⚠️ NEVER all three at once!
```

---

## Self-Improvement Loop

```
WORK → REFLECT → EXTRACT → APPLY
  ↑                         │
  └─────────────────────────┘
```

**After each task ask:**
1. What worked well?
2. What was harder than expected?
3. What pattern can I extract?
4. What should I save?

---

## Daily Rhythm

### Start of Session
```
1. Review what worked yesterday
2. Identify ONE thing to improve
3. Set intention
```

### During Work
```
1. Notice friction
2. Fix small issues immediately
3. Leave code better
```

### End of Session
```
1. What did I learn?
2. What pattern emerged?
3. Save to memory
```

---

## Anti-Patterns

| Don't | Do Instead |
|-------|------------|
| Big rewrites | Incremental changes |
| Skip reflection | End-of-session review |
| Keep dead code | Delete ruthlessly |
| Be clever | Be simple |
| Optimize early | YAGNI |

---

## Quick Commands

```bash
# Save a learning
/remember "pattern: [what you learned]"

# Review patterns
/recall patterns

# Capture improvement
/remember "improvement: [what to change]"
```

---

*"1% better every day = 37x better in a year"*
