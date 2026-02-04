# Lesson 1: The Reality Check

## Objective

Understand the true capabilities and limitations of AI coding assistants before diving in.

## The 70% Problem

Here's what nobody tells you upfront:

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   AI produces 70% of the code FAST                         │
│                                                             │
│   But the remaining 30% takes the same time as always:      │
│   - Edge cases                                              │
│   - Security hardening                                      │
│   - Integration with existing systems                       │
│   - Production-ready error handling                         │
│                                                             │
│   Total time saved: ~40-50%, not 90%                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Why This Matters

**Wrong expectation:**
> "AI will write everything, I just review"

**Right expectation:**
> "AI accelerates the routine, I focus on the hard parts"

## The Two Modes

```
VIBE CODING                    SPEC-DRIVEN DEVELOPMENT
─────────────────────────────────────────────────────────
"Fix this bug"                 Detailed specification
Quick back-and-forth           Plan before execute
Good for exploration           Good for production
Simple features                Complex features
```

## Mental Model

Think of AI coding like this:

```
You (Architect) ──────────────> AI (Builder)
     │                              │
     │ "Build a house with         │ Builds walls, floors
     │  3 bedrooms, modern         │ installs fixtures
     │  style, earthquake          │ paints rooms
     │  resistant"                 │
     │                              │
     └──────> Reviews, adjusts <───┘
```

The architect doesn't lay bricks. The builder doesn't design.

## Try It

Run this command to see how Claude handles ambiguity:

```bash
# Vague prompt - see what happens
"Add authentication to the app"

# Now try specific
"Add JWT authentication to src/api/auth.ts using jose library,
with 24h expiry, refresh tokens stored in httpOnly cookies"
```

Notice the difference in quality and accuracy.

## Check

Before continuing, confirm you understand:

1. AI speeds up ~40-50% of work, not 90%
2. The hard 30% (security, edge cases) still needs your brain
3. Specificity in prompts = better results

## Next

**Lesson 2: Mental Models** - Core frameworks for thinking about AI collaboration.

```bash
/course lesson 2
```

---
*Completion: Mark this lesson done and continue*
