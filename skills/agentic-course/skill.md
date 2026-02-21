---
name: agentic-course
description: Interactive terminal course for mastering agentic coding with Neural Claude Code. Progressive lessons from fundamentals to advanced multi-agent patterns.
trigger: /course, /agentic-course, "teach me agentic coding", "learn agentic"
allowed-tools: Read, Write, Edit, Glob, Grep, Task
---

# Agentic Coding Course

Interactive terminal course for mastering autonomous AI-assisted development.

## Course Structure

```
┌─────────────────────────────────────────────────────────────────┐
│           AGENTIC CODING MASTERY COURSE v2.2                   │
│           Neural Claude Code Interactive Learning              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  FOUNDATIONS (Start Here)                                       │
│  └── Lesson 0: How Agents Work (15 min)             ★ NEW      │
│                                                                 │
│  FUNDAMENTALS                                                   │
│  ├── Lesson 1: The Reality Check (10 min)                      │
│  ├── Lesson 2: Mental Models (15 min)                          │
│  └── Lesson 3: Your First Autonomous Task (20 min)             │
│                                                                 │
│  STRUCTURED PROMPTS                                             │
│  ├── Lesson 4: CRAFT Framework (15 min)                        │
│  ├── Lesson 5: 6 Core Areas (20 min)                           │
│  └── Lesson 6: 3-Tier Boundaries (15 min)                      │
│                                                                 │
│  AUTONOMOUS OPERATIONS                                          │
│  ├── Lesson 7: Loop Fundamentals (20 min)                      │
│  ├── Lesson 8: Circuit Breakers (15 min)                       │
│  └── Lesson 9: State Management (20 min)                       │
│                                                                 │
│  ORCHESTRATION                                                  │
│  ├── Lesson 10: Multi-Agent Orchestration (25 min)             │
│  └── Lesson 11: Pre-Design Workflow (20 min)                   │
│                                                                 │
│  ADVANCED PATTERNS                                              │
│  ├── Lesson 12: Context Engineering (20 min)                   │
│  └── Lesson 13: Compute Advantage (15 min)                     │
│                                                                 │
│  MASTERY                                                        │
│  ├── Lesson 14: Building Your System (30 min)                  │
│  ├── Lesson 15: Monitoring & Analytics (20 min)     ★ NEW      │
│  └── Lesson 16: Continuous Improvement (20 min)     ★ NEW      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Usage

```bash
# See course overview
/course

# Start from beginning
/course start

# Jump to specific lesson
/course lesson 4

# Check progress
/course progress

# Quick reference for any topic
/course ref <topic>

# Practice exercises
/course practice <lesson-number>
```

## Commands

| Command | Description |
|---------|-------------|
| `/course` | Show course menu and progress |
| `/course start` | Begin from lesson 1 |
| `/course lesson <n>` | Jump to lesson n |
| `/course progress` | Show completed lessons |
| `/course ref <topic>` | Quick reference card |
| `/course practice <n>` | Hands-on exercise for lesson |
| `/course reset` | Reset progress (start fresh) |

## Course Menu Display

When user runs `/course`, show:

```
╔═══════════════════════════════════════════════════════════════════╗
║              AGENTIC CODING MASTERY                               ║
║              Interactive Terminal Course                          ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  Your Progress: [████░░░░░░░░░░░░░░░░] 3/17 lessons (18%)        ║
║                                                                   ║
║  FOUNDATIONS                                                      ║
║  ✅ 0. How Agents Work                               ★ NEW       ║
║                                                                   ║
║  FUNDAMENTALS                                                     ║
║  ✅ 1. The Reality Check                                         ║
║  ✅ 2. Mental Models                                             ║
║  ✅ 3. Your First Autonomous Task                                ║
║                                                                   ║
║  STRUCTURED PROMPTS                                               ║
║  ⏳ 4. CRAFT Framework          ← Continue here                  ║
║  ○ 5. 6 Core Areas                                               ║
║  ○ 6. 3-Tier Boundaries                                          ║
║                                                                   ║
║  AUTONOMOUS OPERATIONS                                            ║
║  ○ 7. Loop Fundamentals                                          ║
║  ○ 8. Circuit Breakers                                           ║
║  ○ 9. State Management                                           ║
║                                                                   ║
║  ORCHESTRATION                                                    ║
║  🔒 10. Multi-Agent Orchestration                                ║
║  🔒 11. Pre-Design Workflow                                      ║
║                                                                   ║
║  ADVANCED PATTERNS                                                ║
║  🔒 12. Context Engineering                                      ║
║  🔒 13. Compute Advantage                                        ║
║                                                                   ║
║  MASTERY                                                          ║
║  🔒 14. Building Your System                                     ║
║  🔒 15. Monitoring & Analytics               ★ NEW               ║
║  🔒 16. Continuous Improvement               ★ NEW               ║
║                                                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║  Commands:                                                        ║
║  /course lesson 4  - Start lesson 4                              ║
║  /course practice 3 - Practice exercises                         ║
║  /course ref craft  - Quick reference                            ║
╚═══════════════════════════════════════════════════════════════════╝
```

## Lesson Format

Each lesson follows this structure:

```markdown
# Lesson N: [Title]

## Objective
What you'll learn in this lesson.

## Concept
Core teaching content (kept concise).

## Example
Real, working example in the terminal.

## Try It
Interactive exercise the user does right now.

## Check
Verify understanding before moving on.

## Next
Preview of next lesson + command to continue.
```

## Progress Tracking

Progress stored in `.claude/memory/course/progress.json`:

```json
{
  "started": "2026-02-03",
  "lessons_completed": [1, 2, 3],
  "current_lesson": 4,
  "exercises_done": {
    "1": true,
    "2": true,
    "3": false
  },
  "time_spent_minutes": 45
}
```

## Reference Cards

Quick reference for any topic:

```bash
/course ref craft     # CRAFT framework summary
/course ref loops     # Loop patterns cheat sheet
/course ref boundaries # 3-tier boundaries
/course ref kpi       # KPI definitions
```

## Execution Flow

1. **Check progress**: Read `.claude/memory/course/progress.json`
2. **Show menu**: Display course structure with progress
3. **Handle command**: Start/lesson/practice/ref as requested
4. **Deliver content**: Show lesson with interactive elements
5. **Track completion**: Update progress when lesson done
6. **Suggest next**: Always show what to do next

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Lesson not found | Invalid lesson number | Show valid range (1-14) |
| Prerequisites missing | Advanced lesson without basics | Suggest completing prerequisites first |
| Progress file missing | First time user | Create fresh progress file |

**Fallback**: If course files missing, regenerate from templates.

---

*Neural Claude Code - Learn by doing*
