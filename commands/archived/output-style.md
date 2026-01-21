---
description: Switch output style for this session
allowed-tools: Read, Write, Glob
argument-hint: <style-name>
---

# /output-style - Switch Output Format

Change how Claude formats responses for the current session.

## Arguments
- `$ARGUMENTS` - Style name: `default`, `table`, `yaml`, `concise`, `tts`, `html`, `genui`

## Available Styles

| Style | Description |
|-------|-------------|
| `default` | Standard conversational responses |
| `table` | Organized tables for structured data |
| `yaml` | Highly structured YAML format (best for complex tasks) |
| `concise` | Minimal tokens, maximum signal |
| `tts` | Includes audio summary via ElevenLabs |
| `html` | Generates HTML documents, opens in browser |
| `genui` | Full generative UI with rich styling |

## Process

### Step 1: Validate Style
Check if style exists in `output-styles/` directory.

### Step 2: Update Session Config
Update `.claude/settings.local.json`:
```json
{
  "outputStyle": "<style-name>"
}
```

### Step 3: Load Style
Read and apply the style prompt from `output-styles/<style>.md`.

### Step 4: Confirm
Output: "Switched to **<style>** output style"

## Usage Examples

```bash
# Use YAML for structured responses
/output-style yaml

# Enable TTS summaries
/output-style tts

# Generate interactive HTML
/output-style genui

# Back to normal
/output-style default
```

## Output Format

```markdown
## Output Style Changed

**Previous**: [style]
**Current**: [style]

Style settings applied. All subsequent responses will use **[style]** formatting.
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Style not found | Invalid style name | Check available styles |
| Settings file missing | First run | Creates settings.local.json |
| Style file corrupt | Bad markdown | Reset style to default |

**Fallback**: If style can't be loaded, use default style.

## Notes

- Style persists for the session
- Use `yaml` for complex analysis tasks
- Use `genui` for research and reviews
- Use `concise` when you want quick answers
- Use `tts` when working with multiple instances
