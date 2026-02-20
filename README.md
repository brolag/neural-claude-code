# Neural Claude Code

<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-Plugin-6366f1?style=for-the-badge&logo=anthropic" alt="Claude Code Plugin">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
  <img src="https://img.shields.io/badge/Version-1.13.0-ec4899?style=for-the-badge" alt="Version">
</p>

<p align="center">
  <strong>Claude Code that learns and improves from every interaction.</strong>
</p>

<p align="center">
  <code>curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code/main/install.sh | bash</code>
</p>

---

## The Problem

Every Claude Code session starts from zero. You explain your project structure, conventions, and preferences... again and again.

## The Solution

Neural Claude Code remembers. It learns patterns, accumulates knowledge, and gets smarter over time.

```
Traditional: Execute -> Forget -> Repeat forever
Neural:      Execute -> Learn  -> Improve always
```

---

## Quick Start

**One command to install:**

```bash
curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code/main/install.sh | bash
```

The installer will:
- Clone the repository
- Configure your shell
- Register all commands
- Set up hooks
- Offer to install recommended skills

**Then run the guided tour:**

```bash
/onboard
```

<details>
<summary>Manual installation</summary>

```bash
# 1. Clone
git clone https://github.com/brolag/neural-claude-code ~/Sites/neural-claude-code

# 2. Setup
cd ~/Sites/neural-claude-code && ./scripts/setup-hooks.sh

# 3. Add to shell
echo 'export CLAUDE_PLUGIN_ROOT="$HOME/Sites/neural-claude-code"' >> ~/.zshrc
source ~/.zshrc

# 4. Guided tour
/onboard
```

</details>

**Already installed? Update to v1.13.0:**

```bash
/update
```

**[Full Installation Guide ->](docs/tutorials/01-installation.md)**

---

## Key Features

| Feature | What it does | Command |
|---------|--------------|---------|
| **Workflow Orchestration** | Pre-built chains for frontend, engineering, research, content — with smart skip logic | `workflow-frontend-design`, `workflow-engineering` |
| **Skills Map** | Lightweight 2KB index — Claude picks the right skill without loading 35 full files | `SKILLS_MAP.md` |
| **Agentic Course** | Interactive 13-lesson course for mastering agentic coding | `/course` |
| **Neural Squad** | Multi-agent orchestration with anti-slop enforcement | `/squad-init`, `/squad-status` |
| **CRAFT Framework** | Structured prompts for autonomous agents | `/craft` |
| **KPI Tracking** | Measure Plan/Review Velocity, Autonomy, Loop State | `/kpi` |
| **Skills Manager** | Install, enable/disable skills on demand | `/install-skills`, `/manage-skills` |
| **Self-Learning** | Expertise files that grow smarter each session | `/remember`, `/recall` |
| **Persistent Memory** | Facts and patterns that survive restarts | `/remember`, `/forget` |
| **Code Quality** | Detect and auto-fix technical debt | `/slop-scan`, `/slop-fix`, `/overseer` |
| **Neural Loops** | Autonomous coding sessions that iterate until done | `/loop` |
| **Multi-AI** | Route tasks to Claude, Codex, or Gemini | `/pv-mesh`, `/ai-collab` |

---

## Quick Commands

```bash
# First time? Start here
/onboard                     # Guided tour
/course                      # 13-lesson agentic coding course

# Workflows (new in v1.13.0)
workflow-frontend-design     # New component, page, or redesign
workflow-frontend-maintenance # CSS fix, copy edit, minor tweak
workflow-engineering         # Feature / bugfix / hotfix
workflow-research            # Research any topic
workflow-content             # Social post, newsletter, blog

# Install and manage skills
/install-skills              # Add new skills
/manage-skills               # Enable/disable/update
/update                      # Update plugin to latest version

# Memory
/remember The API uses JWT tokens
/recall database

# Development
/debugging                   # Root cause analysis
/tdd                         # Test-driven development
/slop-scan                   # Find technical debt
/overseer                    # Review PR quality
/git-save                    # Commit with Conventional Commits

# Autonomous work
/loop "Fix all tests" --max 10
/todo-new "Build feature"    # Plan first, then loop

# Multi-agent squad
/squad-init                      # Initialize 3-agent system
/squad-status                    # Check agents and tasks
/squad-task create "Feature"     # Create task for squad
/squad-standup                   # Daily standup report

# Agentic metrics
/kpi                             # Performance dashboard
/craft "Build auth system"       # Generate structured prompt

# Learning
/learn https://github.com/user/repo
/super-search "topic"            # Triple-engine research
```

**[All Commands ->](docs/reference/commands.md)**

---

## Learn More

| New here? | Know what you want? |
|-----------|---------------------|
| **[Tutorials](docs/tutorials/)** | **[How-to Guides](docs/how-to/)** |
| Step-by-step learning | Task-focused recipes |

| Need to look something up? | Want to understand? |
|---------------------------|---------------------|
| **[Reference](docs/reference/)** | **[Explanation](docs/explanation/)** |
| Commands, agents, config | Architecture, patterns |

**[Full Documentation ->](docs/index.md)**

---

## Contributing

Contributions welcome! [Open an issue](https://github.com/brolag/neural-claude-code/issues) or submit a PR.

---

## License

MIT - see [LICENSE](LICENSE)

---

<p align="center">
  <strong>Built with Claude Code</strong><br>
  <sub>Self-improving AI that learns from you</sub>
</p>
