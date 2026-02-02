#!/bin/bash
# TTS Toggle - Quick control for text summaries and audio
# Usage:
#   tts-toggle.sh              # Show current status
#   tts-toggle.sh on           # Enable both
#   tts-toggle.sh off          # Disable both
#   tts-toggle.sh audio on     # Enable audio only
#   tts-toggle.sh audio off    # Disable audio only
#   tts-toggle.sh summary on   # Enable text summary only
#   tts-toggle.sh summary off  # Disable text summary only

CONFIG_FILE="$HOME/.claude/tts-config.json"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

# Create default config if missing
init_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        mkdir -p "$HOME/.claude"
        cat > "$CONFIG_FILE" << 'EOF'
{
  "audio_enabled": true,
  "summary_enabled": true
}
EOF
    fi
}

get_value() {
    jq -r ".$1 // true" "$CONFIG_FILE" 2>/dev/null
}

set_value() {
    local key="$1"
    local value="$2"
    local tmp=$(mktemp)
    jq ".$key = $value" "$CONFIG_FILE" > "$tmp" && mv "$tmp" "$CONFIG_FILE"
}

show_status() {
    local audio=$(get_value "audio_enabled")
    local summary=$(get_value "summary_enabled")

    echo ""
    echo -e "${BOLD}TTS Configuration${RESET}"
    echo ""

    if [ "$audio" = "true" ]; then
        echo -e "  Audio:   ${GREEN}ON${RESET}  (voice playback after each response)"
    else
        echo -e "  Audio:   ${RED}OFF${RESET}"
    fi

    if [ "$summary" = "true" ]; then
        echo -e "  Summary: ${GREEN}ON${RESET}  (text summary blocks in responses)"
    else
        echo -e "  Summary: ${RED}OFF${RESET}"
    fi

    echo ""
    echo -e "${BOLD}Quick toggles:${RESET}"
    echo "  tts-toggle.sh on            # Both on"
    echo "  tts-toggle.sh off           # Both off"
    echo "  tts-toggle.sh audio off     # Mute voice, keep summaries"
    echo "  tts-toggle.sh summary off   # No summaries, keep voice"
    echo ""
}

init_config

case "${1:-}" in
    on)
        set_value "audio_enabled" "true"
        set_value "summary_enabled" "true"
        echo -e "${GREEN}✓${RESET} TTS fully enabled (audio + summary)"
        ;;
    off)
        set_value "audio_enabled" "false"
        set_value "summary_enabled" "false"
        echo -e "${RED}✓${RESET} TTS fully disabled"
        ;;
    audio)
        case "${2:-}" in
            on)
                set_value "audio_enabled" "true"
                echo -e "${GREEN}✓${RESET} Audio enabled"
                ;;
            off)
                set_value "audio_enabled" "false"
                echo -e "${RED}✓${RESET} Audio disabled"
                ;;
            *)
                echo "Usage: $0 audio [on|off]"
                exit 1
                ;;
        esac
        ;;
    summary)
        case "${2:-}" in
            on)
                set_value "summary_enabled" "true"
                echo -e "${GREEN}✓${RESET} Text summary enabled"
                ;;
            off)
                set_value "summary_enabled" "false"
                echo -e "${RED}✓${RESET} Text summary disabled"
                ;;
            *)
                echo "Usage: $0 summary [on|off]"
                exit 1
                ;;
        esac
        ;;
    --help|-h)
        echo "TTS Toggle - Control text summaries and audio playback"
        echo ""
        echo "Usage:"
        echo "  $0              Show current status"
        echo "  $0 on           Enable both audio and summary"
        echo "  $0 off          Disable both"
        echo "  $0 audio on     Enable audio only"
        echo "  $0 audio off    Disable audio only"
        echo "  $0 summary on   Enable text summary only"
        echo "  $0 summary off  Disable text summary only"
        ;;
    "")
        show_status
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use --help for usage"
        exit 1
        ;;
esac
