#!/bin/bash
# Stop Hook - TTS Summary
# Extracts TTS summary from transcript and plays via ElevenLabs
# Supports per-project voice assignment with bilingual support

# Source user's shell config to get API keys
if [ -f "$HOME/.zshrc" ]; then
  eval "$(grep -E '^export\s+ELEVENLABS' "$HOME/.zshrc" 2>/dev/null)" 2>/dev/null || true
fi

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code-plugin}"
DEBUG_LOG="/tmp/stop-tts-debug.log"
TTS_CACHE_DIR="/tmp/tts-cache"

log_debug() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$DEBUG_LOG"
}

# Read JSON metadata from stdin
HOOK_DATA=$(cat 2>/dev/null || echo "{}")

# Extract cwd from hook data for finding session file
CWD=$(echo "$HOOK_DATA" | jq -r '.cwd // empty' 2>/dev/null)
if [ -z "$CWD" ]; then
  CWD="$PWD"
fi

# Extract project name from directory path
PROJECT_NAME=$(basename "$CWD")
log_debug "Project: $PROJECT_NAME"

# Voice configuration
VOICE_CONFIG="$HOME/.claude/tts-voices.json"

# Create default config with bilingual voices if missing
if [ ! -f "$VOICE_CONFIG" ]; then
  mkdir -p "$HOME/.claude"
  cat > "$VOICE_CONFIG" << 'VOICES'
{
  "voice_pool": [
    {"id": "XB7hH8MSUJpSbSDYk0k2", "name": "Dorothy", "languages": ["en", "es"]},
    {"id": "oWAxZDx7w5VEj9dCyTzz", "name": "Grace", "languages": ["en", "es"]},
    {"id": "z9fAnlkpzviPz146aGWa", "name": "Glinda", "languages": ["en", "es"]},
    {"id": "21m00Tcm4TlvDq8ikWAM", "name": "Rachel", "languages": ["en", "es"]}
  ],
  "project_voices": {},
  "default_voice": "XB7hH8MSUJpSbSDYk0k2",
  "model": "eleven_multilingual_v2",
  "announce": true
}
VOICES
  log_debug "Created voice config with bilingual voices"
fi

# Priority: project_voices > default_voice > first in pool
VOICE_ID=$(jq -r --arg project "$PROJECT_NAME" '.project_voices[$project] // empty' "$VOICE_CONFIG" 2>/dev/null)

if [ -z "$VOICE_ID" ]; then
  # Try default voice
  VOICE_ID=$(jq -r '.default_voice // empty' "$VOICE_CONFIG" 2>/dev/null)
fi

if [ -z "$VOICE_ID" ]; then
  # Fallback to first voice in pool
  VOICE_ID=$(jq -r '.voice_pool[0].id' "$VOICE_CONFIG" 2>/dev/null)
fi

# Get voice name for announcement
VOICE_NAME=$(jq -r --arg id "$VOICE_ID" '.voice_pool[] | select(.id == $id) | .name // "Assistant"' "$VOICE_CONFIG" 2>/dev/null)
if [ -z "$VOICE_NAME" ] || [ "$VOICE_NAME" = "null" ]; then
  VOICE_NAME="Assistant"
fi

export ELEVENLABS_VOICE_ID="$VOICE_ID"
log_debug "Using voice: $VOICE_NAME ($VOICE_ID) for project: $PROJECT_NAME"

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

# Wait for transcript to be fully written (race condition fix)
# Try up to 3 times with increasing delays
TTS_TEXT=""
for i in 1 2 3; do
  sleep 1
  TTS_TEXT=$(grep 'TTS_SUMMARY' "$TRANSCRIPT_PATH" | \
    grep '"role":"assistant"' | \
    grep '"type":"text"' | \
    tail -1 | \
    jq -r '.message.content[] | select(.type=="text") | .text' 2>/dev/null | \
    awk '/---TTS_SUMMARY---/{flag=1; next} /---END_TTS---/{flag=0} flag' | \
    tr '\n' ' ' | \
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  if [ -n "$TTS_TEXT" ]; then
    log_debug "Found TTS text on attempt $i"
    break
  fi
  log_debug "Attempt $i: TTS text empty, retrying..."
done

log_debug "Extracted TTS text: $TTS_TEXT"

# Skip if empty
if [ -z "$TTS_TEXT" ]; then
  log_debug "TTS text is empty"
  exit 0
fi

# Deduplication: Check if this exact TTS was already played
mkdir -p "$TTS_CACHE_DIR"
TTS_CACHE="$TTS_CACHE_DIR/last-played-${PROJECT_NAME}.txt"
TTS_HASH=$(echo "$TTS_TEXT" | md5)
LAST_HASH=$(cat "$TTS_CACHE" 2>/dev/null || echo "")

if [ "$TTS_HASH" = "$LAST_HASH" ]; then
  log_debug "TTS already played (duplicate hash: $TTS_HASH), skipping"
  exit 0
fi

# Save hash for next time
echo "$TTS_HASH" > "$TTS_CACHE"
log_debug "New TTS hash saved: $TTS_HASH"

# Check if announcement is enabled
ANNOUNCE=$(jq -r '.announce // true' "$VOICE_CONFIG" 2>/dev/null)
if [ "$ANNOUNCE" = "true" ]; then
  TTS_TEXT="$VOICE_NAME reporting. $TTS_TEXT"
fi
log_debug "Final TTS text: $TTS_TEXT"

# Check if ElevenLabs is enabled (default: true for backwards compatibility)
USE_ELEVENLABS=$(jq -r '.use_elevenlabs // true' "$VOICE_CONFIG" 2>/dev/null)

# Call TTS
if [ "$USE_ELEVENLABS" = "true" ] && [ -x "$PLUGIN_ROOT/scripts/tts/elevenlabs.sh" ]; then
  log_debug "Calling ElevenLabs script with voice $ELEVENLABS_VOICE_ID"
  echo "$TTS_TEXT" | "$PLUGIN_ROOT/scripts/tts/elevenlabs.sh"
else
  log_debug "Using macOS say (ElevenLabs disabled or not available)"
  if command -v say &>/dev/null; then
    nohup say "$TTS_TEXT" &>/dev/null &
  fi
fi

exit 0
