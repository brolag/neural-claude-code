# Neural Claude Code

<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-Plugin-6366f1?style=for-the-badge&logo=anthropic" alt="Claude Code Plugin">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
  <img src="https://img.shields.io/badge/Version-1.4.0-ec4899?style=for-the-badge" alt="Version">
</p>

<p align="center">
  <strong>Claude Code that learns and improves from every interaction.</strong>
</p>

---

## The Problem

Every Claude Code session starts from zero. You explain your project structure, conventions, and preferences... again and again.

## The Solution

Neural Claude Code remembers. It learns patterns, accumulates knowledge, and gets smarter over time.

```
Traditional: Execute → Forget → Repeat forever
Neural:      Execute → Learn  → Improve always
```

---

## Quick Start

```bash
# 1. Clone
git clone https://github.com/brolag/neural-claude-code-plugin ~/Sites/neural-claude-code-plugin

# 2. Setup
cd ~/Sites/neural-claude-code-plugin && ./scripts/setup-hooks.sh

# 3. Add to shell
echo 'export CLAUDE_PLUGIN_ROOT="$HOME/Sites/neural-claude-code-plugin"' >> ~/.zshrc
source ~/.zshrc

# 4. Install skills (interactive)
/install-skills
```

**[Full Installation Guide →](docs/tutorials/01-installation.md)**

---

## Key Features

| Feature | What it does |
|---------|--------------|
| **Self-Learning** | Expertise files that grow smarter each session |
| **Persistent Memory** | Facts and patterns that survive restarts |
| **Neural Loops** | Autonomous coding sessions that iterate until done |
| **Multi-AI** | Route tasks to Claude, Codex, or Gemini |
| **Research Swarm** | Parallel agents for comprehensive research |

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

**[Full Documentation →](docs/index.md)**

---

## Quick Commands

```bash
# Install skills interactively
/install-skills

# Remember something
/remember The API uses JWT tokens

# Run autonomous loop (unified command)
/loop "Fix all tests" --max 10

# Learn from any source (auto-detects type)
/learn https://github.com/user/repo

# Detect and fix slop
/slop-scan
/slop-fix

# Review PR before merge
/overseer

# Get multi-AI perspectives
/pv-mesh Should we use GraphQL?
```

**[All Commands →](docs/reference/commands.md)**

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
