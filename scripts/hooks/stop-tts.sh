#!/bin/bash
# Stop Hook - TTS Summary
# Extracts TTS summary from response and plays via ElevenLabs

# Don't use set -e as sourcing shell configs may have non-zero returns

# Source user's shell config to get API keys (just extract exports)
if [ -f "$HOME/.zshrc" ]; then
  export $(grep -E '^export\s+ELEVENLABS' "$HOME/.zshrc" 2>/dev/null | sed 's/export //' | xargs) 2>/dev/null || true
fi
if [ -f "$HOME/.bashrc" ]; then
  export $(grep -E '^export\s+ELEVENLABS' "$HOME/.bashrc" 2>/dev/null | sed 's/export //' | xargs) 2>/dev/null || true
fi

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code-plugin}"

# Get response from stdin
RESPONSE=$(cat 2>/dev/null || echo "")

# Check for TTS markers
if [[ "$RESPONSE" != *"---TTS_SUMMARY---"* ]]; then
  exit 0
fi

# Extract TTS summary
TTS_TEXT=$(echo "$RESPONSE" | sed -n '/---TTS_SUMMARY---/,/---END_TTS---/p' | sed '1d;$d' | tr '\n' ' ')

# Skip if empty
if [ -z "$TTS_TEXT" ]; then
  exit 0
fi

# Call ElevenLabs TTS script
if [ -x "$PLUGIN_ROOT/scripts/tts/elevenlabs.sh" ]; then
  echo "$TTS_TEXT" | "$PLUGIN_ROOT/scripts/tts/elevenlabs.sh"
fi

exit 0
