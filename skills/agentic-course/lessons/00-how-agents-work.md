# Lesson 0: How Agents Work Under the Hood

## Objective

Understand what AI coding agents actually are, how they work internally, and why they behave the way they do. This foundation explains the "why" behind every pattern in this course.

## What Is an LLM?

Before understanding agents, understand the engine underneath.

```
┌─────────────────────────────────────────────────────────────┐
│                    LARGE LANGUAGE MODEL                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Input: "The capital of France is"                          │
│                    ↓                                        │
│           ┌──────────────┐                                  │
│           │  Transformer │                                  │
│           │   Network    │                                  │
│           │              │                                  │
│           │ 100B+ params │                                  │
│           └──────┬───────┘                                  │
│                  ↓                                          │
│  Output: "Paris" (with 99.7% probability)                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Key insight**: LLMs are **next-token predictors**. Given text, they predict what comes next based on patterns learned from training data.

### What LLMs Are Good At

- Pattern recognition and completion
- Following instructions in natural language
- Generating code that follows conventions
- Explaining and summarizing
- Translating between formats

### What LLMs Are Bad At

- **Math**: They predict tokens, not compute results
- **Counting**: "How many r's in strawberry?" often fails
- **Memory**: No persistent memory between sessions
- **Real-time info**: Knowledge frozen at training cutoff
- **Consistency**: Same question can get different answers
- **Truth**: They predict plausible text, not verified facts

---

## From LLM to Agent

An LLM alone is a text-in, text-out function. An **agent** adds a loop and tools:

```
┌─────────────────────────────────────────────────────────────┐
│                        AGENT = LLM + LOOP + TOOLS           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                    ┌─────────────────┐                      │
│                    │                 │                      │
│  User Goal ───────►│      LLM        │                      │
│                    │   (Reasoning)   │                      │
│                    │                 │                      │
│                    └────────┬────────┘                      │
│                             │                               │
│                             ▼                               │
│                    ┌─────────────────┐                      │
│                    │  Tool Decision  │                      │
│                    │                 │                      │
│                    │  "I should run  │                      │
│                    │   this command" │                      │
│                    └────────┬────────┘                      │
│                             │                               │
│                             ▼                               │
│                    ┌─────────────────┐                      │
│                    │  Tool Execution │                      │
│                    │                 │                      │
│                    │  bash, read,    │                      │
│                    │  write, grep... │                      │
│                    └────────┬────────┘                      │
│                             │                               │
│                             ▼                               │
│                    ┌─────────────────┐                      │
│                    │  Observation    │──────┐               │
│                    │                 │      │               │
│                    │  Tool results   │      │               │
│                    └─────────────────┘      │               │
│                             ▲               │               │
│                             │               │               │
│                             └───────────────┘               │
│                                  LOOP                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### The Agent Loop

Every agent follows this cycle:

1. **Perceive**: Read the current state (user input, tool results, context)
2. **Reason**: Decide what to do next
3. **Act**: Execute a tool or respond
4. **Observe**: See the result
5. **Repeat**: Until goal is reached or stopped

This is called the **ReAct pattern** (Reasoning + Acting).

---

## The Context Window

The context window is the agent's "working memory":

```
┌─────────────────────────────────────────────────────────────┐
│                    CONTEXT WINDOW                            │
│                    (e.g., 200K tokens)                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ SYSTEM PROMPT                                       │   │
│  │ "You are Claude, an AI assistant..."               │   │
│  │ + CLAUDE.md                                         │   │
│  │ + Project context                                   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ CONVERSATION HISTORY                                │   │
│  │ User: "Fix the login bug"                          │   │
│  │ Assistant: [reads file]                            │   │
│  │ Tool Result: [file contents]                       │   │
│  │ Assistant: [edits file]                            │   │
│  │ ...                                                 │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ CURRENT TURN                                        │   │
│  │ "Now run the tests to verify the fix"              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Context Window Limits

| Model | Context Window | Equivalent |
|-------|---------------|------------|
| GPT-4 | 128K tokens | ~300 pages |
| Claude 3.5 | 200K tokens | ~500 pages |
| Gemini 1.5 | 1M tokens | ~2500 pages |

**Critical insight**: When context fills up, older content is dropped or compressed. This is why long sessions "forget" earlier decisions.

### Context Rot

As sessions grow longer, quality degrades:

```
Session Start                    Session End
────────────────────────────────────────────────
High accuracy ───────────────► Lower accuracy
Fast responses ──────────────► Slower responses
Clear focus ─────────────────► Drift and confusion
```

**This is why we teach context engineering** - managing what's in context is crucial for agent effectiveness.

---

## How Tool Use Works

Agents don't "run commands" - they generate text that the harness interprets as tool calls:

```
┌─────────────────────────────────────────────────────────────┐
│                    TOOL CALLING FLOW                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. LLM generates structured output:                        │
│     {                                                       │
│       "tool": "bash",                                       │
│       "command": "npm test"                                 │
│     }                                                       │
│                                                             │
│  2. Harness parses and validates                            │
│                                                             │
│  3. Harness executes tool (sandboxed)                       │
│                                                             │
│  4. Harness injects result back into context:               │
│     "Tool result: 5 tests passed, 2 failed"                │
│                                                             │
│  5. LLM sees result and continues reasoning                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Key insight**: The LLM never "sees" the terminal or files directly. It only sees text representations provided by the harness.

### Common Tools

| Tool | Purpose | Example |
|------|---------|---------|
| Read | View file contents | Read src/auth.ts |
| Write | Create/replace file | Write new file |
| Edit | Modify existing file | Change specific lines |
| Bash | Execute commands | Run tests, git operations |
| Glob | Find files by pattern | Find all *.ts files |
| Grep | Search file contents | Find "TODO" in codebase |

---

## Why Agents Fail

Understanding failure modes helps you prevent them:

### 1. Hallucination

**What**: Agent invents files, functions, or APIs that don't exist.

**Why**: LLMs predict plausible text, not verified facts. If a pattern is common in training data, it might be generated even if it doesn't exist in your codebase.

**Prevention**:
- Always read before editing
- Verify with tests
- Use type checking

### 2. Context Drift

**What**: Agent gradually moves away from the original goal.

**Why**: Each response is based on the entire context. Small tangents compound over time.

**Prevention**:
- Clear task definition
- Circuit breakers (max iterations)
- Progress tracking files

### 3. Infinite Loops

**What**: Agent keeps trying the same failing approach.

**Why**: LLMs have no persistent memory. They can "forget" they already tried something.

**Prevention**:
- Track attempted strategies
- Set maximum iterations
- Stop on repeated failures

### 4. Overconfidence

**What**: Agent claims success without verification.

**Why**: LLMs generate plausible-sounding completions. "I've fixed the bug" sounds like a natural response.

**Prevention**:
- Machine-verifiable success criteria
- Run tests before claiming done
- Don't trust self-assessment

### 5. Tool Misuse

**What**: Agent uses wrong tool or wrong parameters.

**Why**: Tool descriptions must be precise. Ambiguity leads to incorrect tool selection.

**Prevention**:
- Clear tool documentation
- Validation before execution
- Error handling

---

## The Agent Harness

The harness is everything that wraps the LLM to make it useful:

```
┌─────────────────────────────────────────────────────────────┐
│                      AGENT HARNESS                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ CONTEXT MANAGEMENT                                  │   │
│  │ - Load project files (CLAUDE.md)                   │   │
│  │ - Manage conversation history                       │   │
│  │ - Inject tool results                               │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ TOOL EXECUTION                                      │   │
│  │ - Parse tool calls                                  │   │
│  │ - Validate parameters                               │   │
│  │ - Execute safely (sandboxed)                        │   │
│  │ - Return results                                    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ SAFETY & CONTROL                                    │   │
│  │ - Permission checks                                 │   │
│  │ - Dangerous command blocking                        │   │
│  │ - Rate limiting                                     │   │
│  │ - Circuit breakers                                  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ LOOP MANAGEMENT                                     │   │
│  │ - Continue until done or max iterations             │   │
│  │ - Handle errors and retries                         │   │
│  │ - Manage session state                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Claude Code, Cursor, Copilot - they're all harnesses around the same core LLMs, differentiated by their harness design.

---

## Key Mental Models

### 1. "Stateless with Injected Context"

Agents have no memory between API calls. Everything they "know" must be in the current context window. This is why we:
- Write progress files
- Use structured JSON for state
- Front-load important context

### 2. "Probabilistic, Not Deterministic"

Same input can produce different outputs. This is why we:
- Verify with tests, not agent claims
- Use structured outputs when possible
- Don't rely on exact reproduction

### 3. "Text In, Text Out"

Agents don't "see" files or "run" commands. They generate text that harnesses interpret. This is why:
- Clear tool descriptions matter
- Validation is crucial
- Results must be injected back

### 4. "Compute vs Intelligence"

LLMs are pattern matchers, not reasoners. They can appear intelligent by matching training patterns. This is why:
- Complex logic should be in code, not prompts
- Multi-step tasks need decomposition
- Verification beats trust

---

## Try It

### Exercise 1: Observe the Loop

Run a simple agent task and count the cycles:

```bash
# Ask Claude to do something simple
"Create a file called test.txt with 'hello world'"
```

Count:
1. How many tool calls were made?
2. What was the sequence? (read → write → verify?)
3. Did it verify the result?

### Exercise 2: Context Experiment

Start a long conversation (20+ messages). Notice:
- Does response quality change?
- Does the agent "forget" earlier context?
- How does speed change?

### Exercise 3: Failure Mode Identification

Give an intentionally ambiguous task:
```
"Fix the bug"
```

Observe what happens:
- Does it ask for clarification?
- Does it guess?
- Does it hallucinate a bug?

---

## Check

Before continuing, you should understand:

1. **What's an LLM?**
   → A next-token predictor trained on text patterns

2. **What makes an agent?**
   → LLM + loop + tools

3. **What's the context window?**
   → Working memory, limited, drops old content

4. **Why do agents fail?**
   → Hallucination, drift, loops, overconfidence, tool misuse

5. **What's a harness?**
   → Everything wrapping the LLM (context, tools, safety, loop)

---

## Next

Now that you understand the foundations, you're ready to learn the reality of working with these systems day-to-day.

**Next lesson**: The Reality Check - setting expectations for agentic coding.

```bash
/course lesson 1
```

---

## Quick Reference

```
AGENT = LLM + LOOP + TOOLS

THE AGENT LOOP
══════════════
Perceive → Reason → Act → Observe → Repeat

CONTEXT WINDOW
══════════════
System Prompt + Conversation + Current Turn
Limited size → Old content dropped

WHY AGENTS FAIL
═══════════════
1. Hallucination (invents things)
2. Context drift (loses focus)
3. Infinite loops (repeats failures)
4. Overconfidence (claims success falsely)
5. Tool misuse (wrong tool/params)

KEY MENTAL MODELS
═════════════════
• Stateless with injected context
• Probabilistic, not deterministic
• Text in, text out
• Compute, not intelligence
```

---

*"To effectively use a tool, you must understand how it works." - Every engineer ever*
