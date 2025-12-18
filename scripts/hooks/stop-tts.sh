#!/bin/bash
# Stop Hook - TTS Summary
# Extracts TTS summary from transcript and plays via ElevenLabs

# Source user's shell config to get API keys
if [ -f "$HOME/.zshrc" ]; then
  export $(grep -E '^export\s+ELEVENLABS' "$HOME/.zshrc" 2>/dev/null | sed 's/export //' | xargs) 2>/dev/null || true
fi

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code-plugin}"
DEBUG_LOG="/tmp/stop-tts-debug.log"

log_debug() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$DEBUG_LOG"
}

# Read JSON metadata from stdin
HOOK_DATA=$(cat 2>/dev/null || echo "{}")

# Extract transcript_path from JSON
TRANSCRIPT_PATH=$(echo "$HOOK_DATA" | jq -r '.transcript_path // empty' 2>/dev/null)

if [ -z "$TRANSCRIPT_PATH" ]; then
  log_debug "No transcript_path in hook data"
  exit 0
fi

# Expand tilde if present
TRANSCRIPT_PATH="${TRANSCRIPT_PATH/#\~/$HOME}"

if [ ! -f "$TRANSCRIPT_PATH" ]; then
  log_debug "Transcript file not found: $TRANSCRIPT_PATH"
  exit 0
fi

log_debug "Reading transcript: $TRANSCRIPT_PATH"

# Find last assistant message with TTS markers in TEXT content (not tool_use)
# Filter: contains TTS_SUMMARY, is assistant role, has "type":"text" (not tool_use)
TTS_TEXT=$(grep 'TTS_SUMMARY' "$TRANSCRIPT_PATH" | \
  grep '"role":"assistant"' | \
  grep '"type":"text"' | \
  tail -1 | \
  jq -r '.message.content[] | select(.type=="text") | .text' 2>/dev/null | \
  awk '/---TTS_SUMMARY---/{flag=1; next} /---END_TTS---/{flag=0} flag' | \
  tr '\n' ' ' | \
  xargs)

log_debug "Extracted TTS text: $TTS_TEXT"

# Skip if empty
if [ -z "$TTS_TEXT" ]; then
  log_debug "TTS text is empty"
  exit 0
fi

# Call ElevenLabs TTS script
if [ -x "$PLUGIN_ROOT/scripts/tts/elevenlabs.sh" ]; then
  log_debug "Calling ElevenLabs script"
  echo "$TTS_TEXT" | "$PLUGIN_ROOT/scripts/tts/elevenlabs.sh"
else
  log_debug "ElevenLabs script not found, using say fallback"
  if command -v say &>/dev/null; then
    nohup say "$TTS_TEXT" &>/dev/null &
  fi
fi

exit 0
