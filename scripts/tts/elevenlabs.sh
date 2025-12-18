#!/bin/bash
# Text-to-Speech Script
# Uses ElevenLabs API if available, falls back to macOS 'say' command

# Extract ELEVENLABS env vars from shell config (safer than full source)
if [ -f "$HOME/.zshrc" ]; then
  export $(grep -E '^export\s+ELEVENLABS' "$HOME/.zshrc" 2>/dev/null | sed 's/export //' | xargs) 2>/dev/null || true
fi
if [ -f "$HOME/.bashrc" ]; then
  export $(grep -E '^export\s+ELEVENLABS' "$HOME/.bashrc" 2>/dev/null | sed 's/export //' | xargs) 2>/dev/null || true
fi

# Configuration
VOICE_ID="${ELEVENLABS_VOICE_ID:-21m00Tcm4TlvDq8ikWAM}"  # Rachel voice
MODEL_ID="${ELEVENLABS_MODEL_ID:-eleven_monolingual_v1}"
API_KEY="${ELEVENLABS_API_KEY:-}"
TTS_LOG="${CLAUDE_TTS_LOG:-/tmp/claude-tts.log}"
USE_FALLBACK="${CLAUDE_TTS_FALLBACK:-true}"  # Use macOS say as fallback

# Logging function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$TTS_LOG"
}

# Get text from stdin or argument
TEXT="${1:-}"
if [ -z "$TEXT" ]; then
  TEXT=$(cat 2>/dev/null || echo "")
fi

# Skip if empty
if [ -z "$TEXT" ]; then
  log "No text provided, skipping TTS"
  exit 0
fi

log "TTS requested: ${TEXT:0:50}..."

# Truncate to 500 chars for API limits
TEXT=$(echo "$TEXT" | head -c 500)

# Try ElevenLabs first
if [ -n "$API_KEY" ]; then
  log "Using ElevenLabs API"

  # Create temp file for audio
  AUDIO_FILE=$(mktemp /tmp/claude-tts-XXXXXX.mp3)

  # Call ElevenLabs API
  HTTP_STATUS=$(curl -s -w "%{http_code}" -o "$AUDIO_FILE" \
    -X POST "https://api.elevenlabs.io/v1/text-to-speech/$VOICE_ID" \
    -H "Accept: audio/mpeg" \
    -H "Content-Type: application/json" \
    -H "xi-api-key: $API_KEY" \
    -d "{
      \"text\": $(echo "$TEXT" | jq -Rs .),
      \"model_id\": \"$MODEL_ID\",
      \"voice_settings\": {
        \"stability\": 0.5,
        \"similarity_boost\": 0.75
      }
    }" 2>/dev/null)

  # Check response
  if [ "$HTTP_STATUS" = "200" ]; then
    log "ElevenLabs success, playing audio"

    # Play audio (macOS) - use nohup to survive parent exit
    if command -v afplay &>/dev/null; then
      nohup afplay "$AUDIO_FILE" &>/dev/null &
      PLAY_PID=$!
    # Linux fallback
    elif command -v mpv &>/dev/null; then
      nohup mpv --no-video "$AUDIO_FILE" &>/dev/null &
      PLAY_PID=$!
    elif command -v play &>/dev/null; then
      nohup play "$AUDIO_FILE" &>/dev/null &
      PLAY_PID=$!
    fi

    # Clean up after playback (wait longer for audio to finish)
    (sleep 60 && rm -f "$AUDIO_FILE") &>/dev/null &
    exit 0
  else
    log "ElevenLabs API error: HTTP $HTTP_STATUS"
    rm -f "$AUDIO_FILE"
    # Fall through to fallback
  fi
fi

# Fallback to macOS 'say' command
if [ "$USE_FALLBACK" = "true" ] && command -v say &>/dev/null; then
  log "Using macOS 'say' fallback"
  # Use Samantha voice (good quality on macOS) - nohup to survive parent exit
  nohup say -v Samantha "$TEXT" &>/dev/null &
  exit 0
fi

log "No TTS method available (set ELEVENLABS_API_KEY or enable fallback)"
exit 0
