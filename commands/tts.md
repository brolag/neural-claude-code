---
description: Toggle TTS audio and text summary on/off
allowed-tools: Bash, Read, Write
---

# TTS Toggle

Control text-to-speech audio and text summaries.

## Usage

```bash
/tts              # Show current status
/tts on           # Enable both audio + summary
/tts off          # Disable both
/tts audio on     # Enable voice playback only
/tts audio off    # Mute voice only
/tts summary on   # Enable text summaries only
/tts summary off  # Disable text summaries only
```

## Implementation

When this command is invoked:

1. Run the toggle script with the provided arguments:

```bash
bash "$CLAUDE_PLUGIN_ROOT/scripts/tts-toggle.sh" <args>
```

Where `$CLAUDE_PLUGIN_ROOT` defaults to `~/Sites/neural-claude-code-plugin`.

2. Read and display the current config:

```bash
cat ~/.claude/tts-config.json
```

3. If `summary_enabled` is `false`, stop including `---TTS_SUMMARY---` blocks in responses for the rest of this session.

4. If `summary_enabled` is `true`, resume including `---TTS_SUMMARY---` blocks.

## Config File

Location: `~/.claude/tts-config.json`

```json
{
  "audio_enabled": true,
  "summary_enabled": true
}
```

| Setting | Effect |
|---------|--------|
| `audio_enabled: true` | Stop hook plays voice via ElevenLabs/macOS say |
| `audio_enabled: false` | Stop hook exits silently |
| `summary_enabled: true` | Claude adds TTS_SUMMARY blocks to responses |
| `summary_enabled: false` | Claude skips TTS_SUMMARY blocks |

## Output Format

```
TTS Configuration

  Audio:   ON  (voice playback after each response)
  Summary: OFF

Updated. Changes take effect immediately.
```

## Common Combinations

| Want | Command |
|------|---------|
| Full TTS experience | `/tts on` |
| Silent mode | `/tts off` |
| Read summaries but no voice | `/tts audio off` |
| Voice only (no text clutter) | `/tts summary off` |

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Config not found | First run | Auto-creates with defaults (both on) |
| jq not found | Missing dependency | Install: `brew install jq` |
| No audio | ElevenLabs key missing | Falls back to macOS `say` |

**Fallback**: Manually edit `~/.claude/tts-config.json`.
