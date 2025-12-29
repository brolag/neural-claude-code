# Task Tool Usage Guide

> **Platform**: Claude Code only. The Task tool is a Claude Code feature for launching sub-agents.

## What is the Task Tool?

The Task tool spawns **sub-agents** - separate Claude instances that run with their own context window. Results are returned to your main conversation.

### Invocation Syntax

```
Task(subagent_type) "prompt describing the task"
```

**Required parameters:**
- `subagent_type`: One of `Explore`, `Plan`, `general-purpose`, or custom agents
- `prompt`: Clear description of what the sub-agent should do

**Optional parameters:**
- `model`: `sonnet` (default), `opus`, `haiku`
- `run_in_background`: `true` to continue working while agent runs

### Example Invocations

```javascript
// Codebase exploration
Task(Explore) "How does the authentication system work?"

// Architecture planning
Task(Plan) "Design the implementation for user notifications"

// Complex multi-step task
Task(general-purpose) "Refactor all API endpoints to use async/await"

// Background execution
Task(Explore, run_in_background=true) "Analyze the test coverage"
```

## When to Use Task Tool

### Use Task When:

| Situation | Why Task Helps |
|-----------|----------------|
| Exploration (unknown structure) | Fresh context avoids pollution |
| 4+ sequential tool calls needed | Sub-agent handles complexity |
| Research requiring synthesis | Agent can read, analyze, summarize |
| Planning with many considerations | Isolated thinking space |

### Do NOT Use Task When:

| Situation | Why Direct is Better |
|-----------|---------------------|
| Single file read/edit | Task overhead not worth it |
| Known file path | Just use Read directly |
| Quick grep for a string | Grep is faster |
| Edits requiring your review | Keep in main context |
| Sequential dependent steps | Context continuity matters |
| Sensitive operations | Keep visible in main thread |

## Cost & Performance Considerations

| Factor | Task Tool | Direct Tools |
|--------|-----------|--------------|
| Latency | Higher (agent startup) | Lower |
| Token usage | Separate context window | Shared context |
| Visibility | Results summarized | Full detail visible |
| Control | Less (agent decides) | More (you decide) |

**Rule of thumb**: Task tool is worth the overhead when exploration would add 1000+ tokens of noise to your main context.

## Agent Types

### Built-in Agents

| Agent | Context | Best For |
|-------|---------|----------|
| `Explore` | Fresh (no history) | Codebase questions, file discovery |
| `Plan` | Full conversation | Architecture decisions |
| `general-purpose` | Full conversation | Complex multi-step tasks |

### When to Use Each

```
Need to understand code you haven't seen?
→ Task(Explore)

Need to plan something based on our discussion?
→ Task(Plan)

Need to execute a complex task with many steps?
→ Task(general-purpose)
```

## Parallel Execution

Launch multiple independent tasks in ONE message:

```javascript
// Both run concurrently
Task(Explore) "Analyze the auth module"
Task(Explore) "Analyze the payment module"
```

**Caveats:**
- Results return in arbitrary order
- You must synthesize/merge findings yourself
- Don't parallelize dependent tasks

## Decision Framework

```
Is it a single, known file operation?
├─ YES → Direct tool (Read, Edit, Write)
└─ NO ↓

Would exploration add 1000+ tokens of noise?
├─ YES → Task(Explore)
└─ NO ↓

Do you need the agent to make decisions?
├─ YES → Task(general-purpose)
└─ NO → Direct tools with your judgment

Is it architecture/planning based on our conversation?
├─ YES → Task(Plan)
└─ NO → Think in main context
```

## Troubleshooting

### Task returns low-quality results
- Make prompt more specific
- Add constraints ("focus on X, ignore Y")
- Use `opus` model for complex tasks

### Task takes too long
- Use `haiku` for simple explorations
- Break into smaller, parallel tasks
- Check if direct tools would be faster

### Task misses important context
- `Explore` has NO conversation history
- Use `general-purpose` if context matters
- Or provide context explicitly in prompt

### Results don't integrate well
- Ask task to output in specific format
- Request "bullet points" or "table format"
- Synthesize in main context after

## Measuring Success

Track these metrics (not just usage %):

| Metric | Good Sign |
|--------|-----------|
| Context saved | Task prevented 1000+ noise tokens |
| Time saved | Task faster than manual exploration |
| Quality | Task found things you'd have missed |
| Rework | Low need to redo Task's work |

## Add to Your CLAUDE.md

```markdown
## Task Tool Guidelines

Use Task for exploration/research, direct tools for known operations.

| Use Task | Use Direct |
|----------|------------|
| "How does X work?" | Single file read |
| Multi-file investigation | Known file path |
| Research + synthesis | Quick grep |
| Architecture planning | Edits needing review |

**Overhead check**: Is the exploration worth agent startup cost?
```

---

*Part of Neural Claude Code Plugin - For Claude Code users only*
