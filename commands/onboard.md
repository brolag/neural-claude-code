---
description: Interactive onboarding guide for new users - discover and configure the plugin
allowed-tools: Bash, Read, Write
---

# Onboard

Interactive guided tour for new Neural Claude Code users. Walk through features, configure preferences, and learn what the plugin can do.

## Usage

```bash
# Full interactive onboarding
/onboard

# Quick overview (skip configuration)
/onboard --quick
```

## Behavior

When invoked, run this onboarding flow step by step. Wait for user input between steps.

### Step 1: Welcome

Display:

```
═══════════════════════════════════════════════════════════
  Welcome to Neural Claude Code!
  Your AI development system that learns and improves.
═══════════════════════════════════════════════════════════

Let me walk you through what this plugin can do and
help you configure it for your workflow.
```

### Step 2: System Check

Run diagnostics and display results:

```bash
# Check these and report status
command -v jq          # Required
command -v git         # Required
command -v python3     # Optional
command -v ollama      # Optional (local AI)
test -n "$ELEVENLABS_API_KEY"  # Optional (TTS)
test -n "$CLAUDE_PLUGIN_ROOT"  # Required
```

Display as:

```
System Check:
  ✓ git installed
  ✓ jq installed
  ✓ CLAUDE_PLUGIN_ROOT set
  ○ ElevenLabs API key (optional - for voice TTS)
  ○ Ollama (optional - for local AI routing)
```

### Step 3: Feature Discovery

Present features one by one, ask which interest the user:

```
Neural Claude Code has 6 feature areas. Which interest you?

  1. Memory System - Remember facts across sessions
  2. Skills - Specialized capabilities (debugging, TDD, research...)
  3. Autonomous Loops - Run tasks unattended for hours
  4. Multi-AI Collaboration - Route to Claude, Codex, or Gemini
  5. Text-to-Speech - Voice summaries after each response
  6. Code Quality - Detect and fix slop/technical debt

Enter numbers (comma-separated) or 'all': _
```

### Step 4: Skills Setup

Based on selected interests, recommend and install skills:

```
Based on your interests, here are recommended skills:

  Development:
    ✓ debugging    - Systematic root cause analysis
    ✓ tdd          - Test-Driven Development

  Code Quality:
    ✓ slop-scan    - Detect technical debt
    ✓ slop-fix     - Auto-fix safe issues
    ✓ overseer     - Review PRs before merge

  Research:
    ✓ deep-research - Multi-source investigation

Install these skills now? [Y/n]: _
```

If yes, run:
```bash
bash "$CLAUDE_PLUGIN_ROOT/scripts/install-skills.sh"
```

Or install the recommended bundle directly by copying skills to `~/.claude/skills/`.

### Step 5: TTS Configuration

```
Text-to-Speech lets Claude speak summaries after responses.

Options:
  1. Full TTS (voice + text summary)
  2. Text summary only (no voice)
  3. Off (silent mode)

Select [1-3]: _
```

Run the appropriate toggle:
```bash
bash "$CLAUDE_PLUGIN_ROOT/scripts/tts-toggle.sh" on      # Option 1
bash "$CLAUDE_PLUGIN_ROOT/scripts/tts-toggle.sh" audio off # Option 2
bash "$CLAUDE_PLUGIN_ROOT/scripts/tts-toggle.sh" off      # Option 3
```

### Step 6: Quick Command Reference

Show the commands relevant to what the user selected:

```
Here are your key commands:

  Getting Started:
    /help                # See all commands
    /onboard             # Run this guide again

  Memory:
    /remember <fact>     # Save something
    /recall <topic>      # Search memory

  Skills:
    /install-skills      # Add more skills
    /manage-skills       # Enable/disable skills
    /tts                 # Toggle voice/summary

  Development:
    /debug               # Start debugging
    /tdd                 # Test-driven development
    /slop-scan           # Find technical debt
    /overseer            # Review PR quality

  Autonomous:
    /loop "task"         # Run task autonomously
    /loop-status         # Check progress

  Learning:
    /learn <url>         # Learn from any source
    /research <topic>    # Deep research
```

### Step 7: First Task

Prompt the user to try something:

```
Ready to try? Pick one:

  1. /remember "My project uses TypeScript and React"
  2. /slop-scan (scan current project for issues)
  3. /debug (if you have a bug to solve)
  4. Just start coding - I'll help along the way!

What would you like to do? _
```

## Output Format

```markdown
## Onboarding Complete!

**Configured:**
- ✓ Skills installed: 6
- ✓ TTS: off
- ✓ Memory: ready

**Your top commands:**
- /debug, /tdd, /slop-scan
- /remember, /recall
- /manage-skills, /tts

**Need help?**
- /help - Full command list
- /onboard - Run this guide again
- https://github.com/brolag/neural-claude-code-plugin
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Plugin not found | CLAUDE_PLUGIN_ROOT not set | Run the install command first |
| jq missing | Not installed | `brew install jq` |
| Skills install fails | Permission or path issue | Try manual install |

**Fallback**: If interactive flow breaks, show the quick reference card and link to docs.
