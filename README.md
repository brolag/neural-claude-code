# Neural Claude Code Plugin

<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-Plugin-6366f1?style=for-the-badge&logo=anthropic" alt="Claude Code Plugin">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
  <img src="https://img.shields.io/badge/Version-1.7.1-ec4899?style=for-the-badge" alt="Version">
</p>

<p align="center">
  <strong>Transform Claude Code into a self-improving AI that learns from every interaction.</strong>
</p>

<p align="center">
  <a href="https://brolag.github.io/neural-claude-code-plugin">📚 Documentation</a> •
  <a href="#quick-start">🚀 Quick Start</a> •
  <a href="#features">✨ Features</a> •
  <a href="#tutorials">📖 Tutorials</a>
</p>

---

## 🧠 What is Neural Claude Code?

Neural Claude Code implements the **Agent Expert** pattern - AI agents that don't just execute tasks, but **learn and improve** from every interaction.

```
Traditional AI: Execute → Forget → Repeat explanations forever
Neural Claude:  Execute → Learn → Get smarter every session
```

### The Learning Loop

```
┌─────────────────────────────────────────────────────────┐
│                    ACT-LEARN CYCLE                       │
│                                                          │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐          │
│   │  READ    │ → │ EXECUTE  │ → │  LEARN   │ ──┐       │
│   │expertise │    │  task    │    │patterns  │   │       │
│   └──────────┘    └──────────┘    └──────────┘   │       │
│        ↑                                          │       │
│        └──────────────────────────────────────────┘       │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## ✨ Feature Highlights

<table>
<tr>
<td width="50%">

### 🧠 Self-Learning System
Agents that remember and improve from every interaction. No more repeating context.

</td>
<td width="50%">

### 🤖 Multi-AI Orchestration
Route tasks to Claude, Codex, or Gemini based on their strengths.

</td>
</tr>
<tr>
<td width="50%">

### 📺 YouTube Learning
Transform any video into structured knowledge notes with `/yt-learn`.

</td>
<td width="50%">

### 🎨 7 Output Styles
Switch between default, YAML, table, concise, TTS, HTML, and genUI modes.

</td>
</tr>
<tr>
<td width="50%">

### 💾 Persistent Memory
Facts, patterns, and preferences survive across sessions.

</td>
<td width="50%">

### 📊 Pattern Detection
`/evolve` analyzes workflows and suggests automations.

</td>
</tr>
<tr>
<td width="50%">

### 🔧 Meta-Agentics
Create custom agents and skills with `/meta:agent` and `/meta:skill`.

</td>
<td width="50%">

### 🗣️ Text-to-Speech
Audio summaries via ElevenLabs at task completion.

</td>
</tr>
<tr>
<td width="50%">

### 📝 Prompt Engineering
CRISP-E framework for prompt quality assessment and improvement.

</td>
<td width="50%">

### 🌳 Git Worktrees
Parallel development with `/wt-new`, `/wt-merge`, `/wt-clean`.

</td>
</tr>
<tr>
<td width="50%">

### 🔄 Neural Loop
Autonomous iteration with `/loop-start`. Run tasks for hours unattended.

</td>
<td width="50%">

### ✅ Test-on-Stop
Auto-run tests when Claude stops. Feed failures back into the loop.

</td>
</tr>
</table>

---

## 🚀 Quick Start

### Installation (2 minutes)

```bash
# 1. Clone the plugin
git clone https://github.com/brolag/neural-claude-code-plugin ~/Sites/neural-claude-code-plugin

# 2. Run setup
cd ~/Sites/neural-claude-code-plugin
chmod +x scripts/setup-hooks.sh
./scripts/setup-hooks.sh

# 3. Add to your shell profile (~/.zshrc or ~/.bashrc)
echo 'export CLAUDE_PLUGIN_ROOT="$HOME/Sites/neural-claude-code-plugin"' >> ~/.zshrc
source ~/.zshrc
```

### Project Setup

```bash
# In any project, create the Neural Claude structure
cd your-project
mkdir -p .claude/{expertise,memory/events,memory/facts,scripts,data}

# Start Claude Code - expertise will auto-load!
claude
```

> 📚 **Full installation guide:** [brolag.github.io/neural-claude-code-plugin](https://brolag.github.io/neural-claude-code-plugin/#installation)

---

## ✨ Features

### 🧠 Self-Learning Expertise

Claude automatically loads domain knowledge at session start and learns from every interaction.

**How it works:**
```yaml
# .claude/expertise/project.yaml
domain: my_project
version: 3  # Auto-incremented as Claude learns
last_updated: 2025-01-15

understanding:
  architecture: "React frontend, Node.js API, PostgreSQL"
  key_files:
    - src/App.tsx
    - api/routes/

patterns:
  - "Components use TypeScript with strict mode"
  - "API routes follow REST conventions"
  - "Tests go in __tests__ folders"

lessons_learned:
  - "User prefers functional components over classes"
  - "Always run tests before committing"

user_preferences:
  - "Spanish for content, English for code"
  - "Conventional commits with emoji"
```

### 🔄 Act-Learn Cycle

After significant work, Claude prompts you to capture learnings:

```
┌─────────────────────────────────────────────────────────┐
│ 📝 LEARNING CHECKPOINT                                   │
│                                                          │
│ You've completed 8 significant actions.                  │
│ Consider updating .claude/expertise/project.yaml with:   │
│                                                          │
│ • Patterns: Repeatable workflows that worked             │
│ • Lessons: Insights from this execution                  │
│ • Preferences: User behaviors learned                    │
└─────────────────────────────────────────────────────────┘
```

### 📊 Pattern Detection

The `/evolve` command analyzes your workflows to detect repeating patterns:

```bash
> /evolve

Analyzing 156 events from last 30 days...

Top Patterns Detected:
  [85%] Read → Edit → Bash (test)     - 12 occurrences
  [72%] Glob → Read → Edit            - 8 occurrences
  [65%] Task → Read → Write           - 6 occurrences

Recommendations:
  [HIGH] Create skill for: Read → Edit → Bash workflow
  [MED]  Pattern "Glob → Read → Edit" approach stable
```

### 💾 Persistent Memory

Facts, events, and session logs persist across conversations:

```bash
> /remember The API uses JWT tokens with 24h expiry
✓ Fact saved to memory

> /recall authentication
Found 3 relevant facts:
  • The API uses JWT tokens with 24h expiry
  • Auth middleware is in src/middleware/auth.ts
  • Refresh tokens stored in Redis
```

### 🤖 Multi-AI Collaboration

Route tasks to the best AI for the job:

| AI | Strength | Best For |
|-----|----------|----------|
| **Claude** | 80.9% SWE-bench | Architecture, accuracy, complex reasoning |
| **Codex** | Terminal-Bench #1 | DevOps, CLI, long autonomous sessions |
| **Gemini** | 1501 Elo algorithms | Competitive coding, math, free tier |

```bash
> /ai-collab Should we use REST or GraphQL for this API?

# Claude, Codex, and Gemini each analyze and provide perspectives
# Final synthesis with consensus recommendation
```

---

## 📖 Tutorials

### Tutorial 1: Creating Your First Expertise File

```bash
# Create expertise directory
mkdir -p .claude/expertise

# Create your first expertise file
cat > .claude/expertise/project.yaml << 'EOF'
domain: my_awesome_project
version: 1
last_updated: 2025-01-15

understanding:
  project_type: "web-app"
  tech_stack:
    - typescript
    - react
    - nodejs
  structure:
    frontend: "src/"
    backend: "api/"
    tests: "__tests__/"

patterns:
  - "Use functional components with hooks"
  - "API routes in api/routes/"
  - "Shared types in src/types/"

lessons_learned: []

open_questions:
  - "What testing framework does the user prefer?"

user_preferences: []
EOF
```

Now when you start Claude Code, this expertise is automatically loaded!

### Tutorial 2: Using Meta-Agents

Meta-agents are special agents that create other agents and components.

#### Creating a Custom Agent

```bash
> Create an agent for code review that checks for security issues

# Claude uses the meta-agent to create:
# .claude/agents/security-reviewer.md
```

The created agent will have:
- Clear purpose and triggers
- Tool permissions (Read, Grep, etc.)
- Domain expertise integration

#### Creating a Custom Skill

```bash
> Create a skill for database migrations

# Claude uses meta-skill to create:
# .claude/skills/db-migrations/skill.md
# .claude/skills/db-migrations/tests.json
```

### Tutorial 3: The /evolve Command

The `/evolve` command is your system's self-improvement engine:

```bash
> /evolve

# What happens:
# 1. Analyzes .claude/memory/events/*.jsonl
# 2. Detects repeating tool sequences
# 3. Calculates pattern confidence scores
# 4. Suggests skills to create
# 5. Updates expertise files
# 6. Prunes low-confidence patterns
```

**Run it weekly** to keep your system improving!

### Tutorial 4: Memory System

#### Saving Facts

```bash
> /remember The deployment script is in scripts/deploy.sh
> /remember Production uses AWS ECS with Fargate
> /remember Database backups run at 3am UTC
```

#### Recalling Facts

```bash
> /recall deployment
# Returns: The deployment script is in scripts/deploy.sh

> /recall AWS
# Returns: Production uses AWS ECS with Fargate
```

#### Forgetting Facts

```bash
> /forget deployment-script
# Removes the fact from memory
```

### Tutorial 5: Output Styles

Switch how Claude responds mid-session:

```bash
> /output-style yaml      # Structured YAML responses
> /output-style table     # Markdown tables
> /output-style concise   # Minimal, direct answers
> /output-style tts       # Audio summary at end
> /output-style html      # Generate HTML, open in browser
```

### Tutorial 6: Multi-AI Workflows

#### Quick Routing

```bash
# Route to Codex for DevOps tasks
> Ask Codex to set up the CI/CD pipeline

# Route to Gemini for algorithm problems
> Ask Gemini to optimize this sorting algorithm

# Get all perspectives
> /ai-collab What's the best caching strategy for this API?
```

#### Plan-Execute Pattern (Opus + Gemini)

For complex multi-step tasks, use orchestrated execution:

```bash
> /plan-execute Add user authentication with JWT tokens

# What happens:
# 1. Opus 4.5 analyzes and creates detailed plan
# 2. Simple steps routed to Gemini Flash (fast + cheap)
# 3. Complex steps kept in Opus (accuracy)
# 4. Opus reviews final results

# Cost savings: ~60-70% vs Opus-only
```

```
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│  OPUS 4.5      │     │  GEMINI FLASH  │     │  OPUS 4.5      │
│  (Planning)    │ ──▶ │  (Execution)   │ ──▶ │  (Review)      │
└────────────────┘     └────────────────┘     └────────────────┘
```

#### Intelligent Routing

The system automatically routes based on task type:

| Task Type | Routed To | Why |
|-----------|-----------|-----|
| Algorithm/math | Gemini | Highest Elo rating |
| Architecture | Claude | Best SWE-bench score |
| DevOps/CLI | Codex | Terminal-Bench leader |
| Complex multi-step | Opus→Gemini→Opus | Cost optimization |
| Critical decisions | All three | Maximum validation |

### Tutorial 7: Neural Loop (Autonomous Sessions)

Run tasks autonomously for hours using the Ralph Wiggum pattern.

#### Recommended: Use /loop-plan (Safest)

```bash
# Analyzes, plans, then executes with safety harnesses
> /loop-plan "Implement user authentication with JWT tokens"

# What happens:
# 1. Analyzes codebase and affected files
# 2. Creates structured todo.md with validations
# 3. Calculates safe max iterations
# 4. Asks for approval
# 5. Executes loop with proper exit criteria
```

#### Manual: Use /loop-start (Advanced)

```bash
# Direct loop - YOU must define safety constraints
> /loop-start "Fix all TypeScript errors. Run 'npm run typecheck' after each fix. Output TYPES_FIXED when 0 errors" --max 15 --promise "TYPES_FIXED"
```

**Safety Rules:**
- Always set `--max` to prevent runaway loops
- Include validation command in prompt
- Define measurable exit criteria
- Use TDD (write tests first)

**Todo-Driven Development:**

```bash
# Create structured todo for complex task
> /todo-new "Build REST API for user management"

# Creates todo.md with phases and validation steps
# Then start the loop:
> /loop-start "Follow todo.md step by step" --max 20 --promise "TASK_COMPLETE"
```

**Check progress anytime:**

```bash
> /loop-status
{
  "active": true,
  "iteration": 7,
  "max_iterations": 20,
  "completion_promise": "TYPES_FIXED"
}
```

---

## 🛠️ Commands Reference

### Core Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/evolve` | Self-improvement cycle | `/evolve` |
| `/remember <fact>` | Save to memory | `/remember API key rotates monthly` |
| `/recall <query>` | Search memory | `/recall database` |
| `/forget <id>` | Remove from memory | `/forget api-key-fact` |
| `/health` | System health check | `/health` |

### Prompt Engineering Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/prompt-review <file>` | Assess quality with CRISP-E framework | `/prompt-review prompts/research.md` |
| `/prompt-improve <file>` | Multi-AI review (Gemini + Codex) | `/prompt-improve prompts/research.md` |
| `/prompt-validate <file>` | Verify links and claims | `/prompt-validate results/output.md` |

### Meta Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/meta:agent <name>` | Create new agent | `/meta:agent security-checker` |
| `/meta:skill <name>` | Create new skill | `/meta:skill api-testing` |
| `/meta:prompt <name>` | Create new command | `/meta:prompt daily-standup` |
| `/meta:improve <name>` | Sync expertise | `/meta:improve project` |
| `/meta:eval` | Run tests | `/meta:eval` |
| `/meta:brain` | System dashboard | `/meta:brain` |

### Style Commands

| Command | Description |
|---------|-------------|
| `/output-style default` | Standard responses |
| `/output-style yaml` | Structured YAML |
| `/output-style table` | Markdown tables |
| `/output-style concise` | Minimal output |
| `/output-style tts` | With audio summary |
| `/output-style html` | Generate HTML |

### Learning Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/yt-learn <url>` | Extract YouTube video into knowledge note | `/yt-learn https://youtube.com/watch?v=abc` |

### Neural Loop Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/loop-plan "<task>"` | Plan + execute with safety harnesses | `/loop-plan "Add authentication"` |
| `/loop-start "<task>"` | Start autonomous loop | `/loop-start "Build API" --max 20 --promise "DONE"` |
| `/loop-cancel` | Stop active loop | `/loop-cancel` |
| `/loop-status` | Check loop status | `/loop-status` |
| `/todo-new "<task>"` | Create structured todo | `/todo-new "Implement auth"` |
| `/todo-check` | Check todo progress | `/todo-check` |

### AI Collaboration

| Command | Description |
|---------|-------------|
| `/ai-collab <problem>` | Get all AI perspectives |
| `/plan-execute <task>` | Opus plans + Gemini executes (60% cheaper) |
| `Ask Codex to...` | Route to Codex |
| `Ask Gemini to...` | Route to Gemini |

---

## 🏗️ Project Structure

```
your-project/
├── .claude/
│   ├── expertise/              # 🧠 Domain knowledge
│   │   ├── manifest.yaml       # Load order & dependencies
│   │   ├── project.yaml        # Project expertise
│   │   └── shared.yaml         # Cross-domain knowledge
│   │
│   ├── memory/                 # 💾 Persistent memory
│   │   ├── events/             # Daily event logs (JSONL)
│   │   ├── facts/              # Stored facts
│   │   ├── session_logs/       # Session history
│   │   └── pattern-index.json  # Detected patterns
│   │
│   ├── agents/                 # 🤖 Custom agents
│   ├── skills/                 # ⚡ Reusable skills
│   ├── commands/               # 📝 Slash commands
│   ├── scripts/                # 🔧 Hooks & utilities
│   │   └── neural-loop/        # 🔄 Autonomous iteration
│   ├── templates/              # 📋 Workflow templates
│   │
│   ├── settings.json           # Project settings
│   └── CLAUDE.md               # Project instructions
```

---

## 🔧 Configuration

### Expertise Manifest

Control how expertise is loaded:

```yaml
# .claude/expertise/manifest.yaml
version: 1
last_updated: 2025-01-15

load_order:
  - project          # Load first
  - frontend
  - backend
  - shared           # Load last

confidence:
  promotion_threshold: 0.7    # Patterns above this → shared
  deprecation_threshold: 0.3  # Patterns below this → pruned
  decay_rate: 0.05            # Weekly decay for unused patterns

auto_update:
  enabled: true
  triggers:
    - task_completion
    - evolve_command
```

### Environment Variables

```bash
# Required
export CLAUDE_PLUGIN_ROOT="$HOME/Sites/neural-claude-code-plugin"

# Optional - for TTS
export ELEVENLABS_API_KEY="your-key"

# Optional - for multi-AI
# (Codex and Gemini CLIs must be installed separately)
```

---

## 📚 Documentation

| Resource | Description |
|----------|-------------|
| [🌐 Landing Page](https://brolag.github.io/neural-claude-code-plugin) | Interactive guide with installation |
| [📖 Installation Guide](https://brolag.github.io/neural-claude-code-plugin/#installation) | Step-by-step setup |
| [🎯 Task Tool Guide](docs/TASK_TOOL_GUIDE.md) | When to use sub-agents vs direct tools |
| [📋 Changelog](CHANGELOG.md) | Version history |

---

## 🤝 Contributing

Contributions are welcome! See our [contribution guidelines](CONTRIBUTING.md).

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 👤 Author

**Alfredo Bonilla** ([@brolag](https://github.com/brolag))

---

<p align="center">
  <strong>🧠 Built with Claude Code • Self-improving AI that learns from you</strong>
</p>
