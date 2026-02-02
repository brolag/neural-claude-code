# Neural Claude Code

<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-Plugin-6366f1?style=for-the-badge&logo=anthropic" alt="Claude Code Plugin">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
  <img src="https://img.shields.io/badge/Version-1.5.0-ec4899?style=for-the-badge" alt="Version">
</p>

<p align="center">
  <strong>Claude Code that learns and improves from every interaction.</strong>
</p>

<p align="center">
  <code>curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code-plugin/main/install.sh | bash</code>
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
curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code-plugin/main/install.sh | bash
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
git clone https://github.com/brolag/neural-claude-code-plugin ~/Sites/neural-claude-code-plugin

# 2. Setup
cd ~/Sites/neural-claude-code-plugin && ./scripts/setup-hooks.sh

# 3. Add to shell
echo 'export CLAUDE_PLUGIN_ROOT="$HOME/Sites/neural-claude-code-plugin"' >> ~/.zshrc
source ~/.zshrc

# 4. Guided tour
/onboard
```

</details>

**[Full Installation Guide ->](docs/tutorials/01-installation.md)**

---

## Key Features

| Feature | What it does | Command |
|---------|--------------|---------|
| **Skills Manager** | Install, enable/disable skills on demand | `/install-skills`, `/manage-skills` |
| **Self-Learning** | Expertise files that grow smarter each session | `/remember`, `/recall` |
| **Persistent Memory** | Facts and patterns that survive restarts | `/remember`, `/forget` |
| **Code Quality** | Detect and auto-fix technical debt | `/slop-scan`, `/slop-fix`, `/overseer` |
| **Neural Loops** | Autonomous coding sessions that iterate until done | `/loop` |
| **Multi-AI** | Route tasks to Claude, Codex, or Gemini | `/pv-mesh`, `/ai-collab` |
| **TTS Control** | Voice and text summaries, toggle anytime | `/tts on`, `/tts off` |
| **Onboarding** | Interactive guided setup for new users | `/onboard` |

---

## Quick Commands

```bash
# First time? Start here
/onboard                     # Guided tour

# Install and manage skills
/install-skills              # Add new skills
/manage-skills               # Enable/disable/update
/tts off                     # Toggle voice/summaries

# Memory
/remember The API uses JWT tokens
/recall database

# Development
/debug                       # Root cause analysis
/tdd                         # Test-driven development
/slop-scan                   # Find technical debt
/overseer                    # Review PR quality

# Autonomous work
/loop "Fix all tests" --max 10

# Learning
/learn https://github.com/user/repo
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

Contributions welcome! [Open an issue](https://github.com/brolag/neural-claude-code-plugin/issues) or submit a PR.

---

## License

MIT - see [LICENSE](LICENSE)

---

<p align="center">
  <strong>Built with Claude Code</strong><br>
  <sub>Self-improving AI that learns from you</sub>
</p>
