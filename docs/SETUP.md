# Complete Setup Guide

This guide walks you through setting up the Neural Claude Code Plugin from scratch.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Plugin Installation](#plugin-installation)
3. [Hook Setup](#hook-setup)
4. [Project Setup](#project-setup)
5. [Optional: ElevenLabs TTS](#optional-elevenlabs-tts)
6. [Optional: Ollama Agent Names](#optional-ollama-agent-names)
7. [Optional: Multi-AI Setup](#optional-multi-ai-setup)
8. [Verification](#verification)

---

## Prerequisites

### Required: Claude Code CLI

You need the Claude Code CLI installed. If you don't have it:

```bash
# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code
```

Verify installation:
```bash
claude --version
```

### Required: jq

`jq` is used for JSON processing in hooks and status lines.

**macOS:**
```bash
brew install jq
```

**Ubuntu/Debian:**
```bash
sudo apt-get install jq
```

**Windows (WSL):**
```bash
sudo apt-get install jq
```

Verify installation:
```bash
jq --version
# Should output: jq-1.7 or similar
```

---

## Plugin Installation

### Step 1: Add the Marketplace

```bash
claude plugin marketplace add brolag/neural-claude-code
```

Or via slash command in Claude Code:
```
/plugin marketplace add brolag/neural-claude-code
```

### Step 2: Install the Plugin

```bash
claude plugin install neural-claude-code@brolag --scope user
```

Or via slash command:
```
/plugin install neural-claude-code@brolag --scope user
```

**Scope options:**
| Scope | Location | Use Case |
|-------|----------|----------|
| `user` | `~/.claude/plugins/` | Available in all your projects |
| `project` | `.claude/plugins/` | Shared with team via git |
| `local` | `.claude/plugins/` (gitignored) | Project-specific, not shared |

---

## Hook Setup

Hooks enable TTS audio summaries and session tracking. This is a **one-time setup** that applies globally.

### Option A: Automated Setup (Recommended)

Run the setup script:

```bash
# Set the plugin location (adjust path if different)
export CLAUDE_PLUGIN_ROOT="$HOME/Sites/neural-claude-code"

# Run setup
bash "$CLAUDE_PLUGIN_ROOT/scripts/setup-hooks.sh"
```

The script will:
- Back up your existing settings
- Add TTS hooks to `~/.claude/settings.json`
- Verify your configuration

### Option B: Manual Setup

Edit `~/.claude/settings.json` and add the hooks section:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": {},
        "hooks": [
          {
            "type": "command",
            "command": "bash /path/to/neural-claude-code/scripts/hooks/stop-tts.sh",
            "timeout": 15000
          }
        ]
      }
    ]
  }
}
```

Replace `/path/to/neural-claude-code` with your actual plugin path.

### Verify Hook Setup

After setup, run in Claude Code:

```
/doctor
```

You should see no errors under "Invalid Settings". If you see hook-related errors, ensure:
- The hook format uses `matcher` and `hooks` arrays (Claude Code 2.0+ format)
- The script path is correct and executable

### Restart Required

**Important:** Restart Claude Code after setting up hooks for changes to take effect.

---

## Project Setup

After installing the plugin, you need to initialize it in each project you want to use it with.

### Step 1: Navigate to Your Project

```bash
cd /path/to/your/project
```

### Step 2: Initialize Claude Code Structure

In Claude Code, run:
```
setup claude
```

Or:
```
init project
```

This creates the following structure:

```
your-project/
├── .claude/
│   ├── data/                    # Session state (gitignored)
│   │   └── current-session.json
│   ├── expertise/               # Agent learning files
│   │   └── project.yaml
│   ├── memory/                  # Project memory
│   │   ├── facts/
│   │   └── events/
│   └── settings.local.json      # Local settings (gitignored)
```

### Step 3: Configure Status Line (Optional)

To enable status lines, create or edit `.claude/settings.local.json`:

```json
{
  "statusLine": "v3"
}
```

Available versions:
- `v1` - Basic: model, directory, git branch
- `v2` - + Last prompt with emoji
- `v3` - + Agent name (recommended)

---

## Optional: ElevenLabs TTS

Enable text-to-speech summaries when tasks complete.

### Step 1: Get API Key

1. Go to [ElevenLabs](https://elevenlabs.io/)
2. Create an account or sign in
3. Go to Profile Settings > API Keys
4. Create a new API key with **only** "Text to Speech: Access" permission

### Step 2: Set Environment Variable

**macOS/Linux - Add to `~/.zshrc` or `~/.bashrc`:**
```bash
export ELEVENLABS_API_KEY="your-api-key-here"
```

Then reload:
```bash
source ~/.zshrc  # or source ~/.bashrc
```

**Verify:**
```bash
echo $ELEVENLABS_API_KEY
# Should show your key
```

### Step 3: Test TTS

In Claude Code:
```
/output-style tts
```

Then ask Claude to do something. At the end of the response, you should hear an audio summary.

### Custom Voice (Optional)

By default, the plugin uses the "Rachel" voice. To use a different voice:

```bash
export ELEVENLABS_VOICE_ID="your-voice-id"
```

Find voice IDs at [ElevenLabs Voices](https://elevenlabs.io/voice-library).

---

## Optional: Ollama Agent Names

Generate creative agent names for identifying multiple Claude Code instances.

### Step 1: Install Ollama

**macOS:**
```bash
brew install ollama
```

**Linux:**
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

**Windows:**
Download from [ollama.com](https://ollama.com/download)

### Step 2: Start Ollama

```bash
ollama serve
```

Or on macOS, Ollama runs automatically as a service.

### Step 3: Pull the Model

```bash
ollama pull llama3.2:1b
```

This downloads a ~1.3GB model optimized for quick responses.

### Step 4: Verify

```bash
ollama run llama3.2:1b "Say hello"
```

**Note:** If Ollama isn't available, the plugin falls back to random names from a preset list (Nova, Cipher, Echo, etc.).

---

## Optional: Multi-AI Setup

Enable collaboration between Claude, Codex, and Gemini.

### Codex (OpenAI)

```bash
# Install Codex CLI
npm install -g @openai/codex

# Set API key
export OPENAI_API_KEY="your-openai-key"
```

### Gemini (Google)

```bash
# Install Gemini CLI
npm install -g @google/gemini-cli

# Set API key
export GOOGLE_API_KEY="your-google-key"
```

### Using Multi-AI

In Claude Code:
```
/ai-collab How should I structure the authentication system?
```

This queries all three AIs and synthesizes their responses.

---

## Verification

Run these checks to verify your setup:

### 1. Check Plugin Installation

```bash
claude plugin list
# Should show: neural-claude-code@brolag
```

### 2. Check Required Tools

```bash
jq --version
# Should output version
```

### 3. Check Optional Tools

```bash
# ElevenLabs
echo $ELEVENLABS_API_KEY
# Should show key (or empty if not configured)

# Ollama
ollama list
# Should show llama3.2:1b (or empty if not configured)
```

### 4. Test in a Project

```bash
cd /path/to/your/project
claude
```

In Claude Code:
```
> /meta/brain
```

This shows system health and what's configured.

---

## Troubleshooting

### Plugin Not Found

```
✘ Plugin "neural-claude-code" not found
```

**Fix:** Make sure you added the marketplace first:
```bash
claude plugin marketplace add brolag/neural-claude-code
```

### Invalid Settings / Hook Errors

```
Invalid Settings
└ hooks: Expected array, but received undefined
```

**Fix:** Claude Code 2.0+ requires a new hook format with `matcher` and `hooks` arrays:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": {},
        "hooks": [
          {
            "type": "command",
            "command": "bash /path/to/script.sh"
          }
        ]
      }
    ]
  }
}
```

Run the setup script to fix automatically:
```bash
bash "$CLAUDE_PLUGIN_ROOT/scripts/setup-hooks.sh"
```

### TTS Not Working

1. **Check hooks are set up:** Run `/doctor` - no errors should appear
2. **Check API key is set:** `echo $ELEVENLABS_API_KEY`
3. **Check script is executable:** `ls -la $CLAUDE_PLUGIN_ROOT/scripts/hooks/stop-tts.sh`
4. **Check audio output:** Ensure your system audio is working
5. **Restart Claude Code:** Hooks require a restart to take effect

### Agent Names Not Generating

1. Check Ollama is running: `ollama list`
2. Check model is installed: `ollama pull llama3.2:1b`
3. If Ollama fails, fallback names are used automatically

### Status Line Not Showing

1. Verify `.claude/settings.local.json` exists with `"statusLine": "v3"`
2. Restart Claude Code session

---

## Next Steps

- See [Fullstack App Example](../examples/fullstack-app-setup.md) for a real-world setup walkthrough
- Check the [README](../README.md) for feature documentation
- Run `/meta/brain` to see system status
