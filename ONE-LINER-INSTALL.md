# One-Liner Installation Guide

## The Command

```bash
curl -fsSL https://raw.githubusercontent.com/brolag/neural-claude-code-plugin/main/install.sh | bash
```

## What It Does

The installer automatically:

1. **Checks Prerequisites**
   - Verifies git is installed
   - Checks for jq (warns if missing)
   - Detects your shell (zsh/bash)

2. **Installs Plugin**
   - Clones repository to `~/Sites/neural-claude-code-plugin`
   - Or updates if already installed
   - Respects `$CLAUDE_PLUGIN_ROOT` if set

3. **Configures Shell**
   - Adds `CLAUDE_PLUGIN_ROOT` to your shell config
   - Auto-detects `.zshrc`, `.bashrc`, or `.bash_profile`
   - Sources immediately so you can use right away

4. **Sets Up Hooks**
   - Runs `setup-hooks.sh` automatically
   - Configures TTS, session tracking, etc.

5. **Offers Skill Installation**
   - Interactive mode (full menu)
   - Auto-install recommended bundle
   - Or skip for later

## User Experience

```
╔════════════════════════════════════════════════════════╗
║  Neural Claude Code - One-Line Installer              ║
║  v1.4.0                                                ║
╚════════════════════════════════════════════════════════╝

→ Installation directory: ~/Sites/neural-claude-code-plugin

→ Checking prerequisites...
✓ Prerequisites met

→ Cloning repository...
✓ Repository cloned

→ Detected shell: zsh (config: ~/.zshrc)

→ Adding to shell configuration...
✓ Added to ~/.zshrc

→ Setting up hooks...
✓ Hooks configured

═══════════════════════════════════════════════════════════
✓ Installation complete!
═══════════════════════════════════════════════════════════

Next step: Install skills

Would you like to install recommended skills now?
  1) Yes, install now (interactive)
  2) Install recommended bundle (auto)
  3) Skip (install later with /install-skills)

Select [1-3]: _
```

## Installation Options

The installer will automatically detect your bash version and show appropriate options:

### On macOS (bash 3.2):
```
  1) Install recommended bundle (auto) ⭐ Recommended
  2) Skip (install later with /install-skills)

  ℹ Interactive mode requires bash 4+. Install with: brew install bash
```

### On bash 4+ systems:
```
  1) Yes, install now (interactive)
  2) Install recommended bundle (auto) ⭐ Recommended
  3) Skip (install later with /install-skills)
```

### Option Details

**Auto-Install Bundle** (Recommended)
Installs these 6 essential skills to `~/.claude/skills/`:
- `debugging` - Systematic root cause analysis
- `tdd` - Test-driven development
- `deep-research` - Multi-phase research
- `slop-scan` - Detect technical debt
- `slop-fix` - Auto-fix safe issues
- `overseer` - Review PRs before merge

**Interactive Mode** (Requires bash 4+)
- Browse skills by category
- Multi-select which ones you want
- Choose installation scope (project/global/both)
- See dependencies automatically added

**Skip**
Install skills later with `/install-skills` command in Claude Code

## After Installation

```bash
# Reload your shell
source ~/.zshrc  # or ~/.bashrc

# Start using in any Claude Code session
/slop-scan       # Detect technical debt
/debug           # Systematic debugging
/tdd             # Test-driven development

# Manage your skills
/install-skills  # Add more skills
/manage-skills   # Enable/disable/update skills
```

## Customization

### Custom Install Directory

```bash
export CLAUDE_PLUGIN_ROOT="$HOME/custom/path"
curl -fsSL https://raw.githubusercontent.com/.../install.sh | bash
```

### Skip Skill Installation

The installer will ask, but you can also:
- Select option 3 (Skip)
- Install skills later with `/install-skills`
- Manually copy from `skills/` directory

## Troubleshooting

### "jq not found"

```bash
# Install jq first
brew install jq

# Then run installer
curl -fsSL https://raw.githubusercontent.com/.../install.sh | bash
```

### "git not found"

```bash
# Install git (if not already present)
brew install git

# Then run installer
curl -fsSL https://raw.githubusercontent.com/.../install.sh | bash
```

### Already Installed

If you already have the plugin installed:
```bash
# The installer will UPDATE it automatically
curl -fsSL https://raw.githubusercontent.com/.../install.sh | bash

# It will:
# - Pull latest changes
# - Update shell config if needed
# - Offer to update skills
```

## Manual Installation

If you prefer manual control:

```bash
# 1. Clone
git clone https://github.com/brolag/neural-claude-code-plugin \
  ~/Sites/neural-claude-code-plugin

# 2. Configure shell
echo 'export CLAUDE_PLUGIN_ROOT="$HOME/Sites/neural-claude-code-plugin"' >> ~/.zshrc
source ~/.zshrc

# 3. Setup hooks
cd ~/Sites/neural-claude-code-plugin
./scripts/setup-hooks.sh

# 4. Install skills
/install-skills
```

## What Gets Modified

The installer only modifies:

1. **File System**
   - Creates `~/Sites/neural-claude-code-plugin/` (or custom path)
   - Optionally creates `~/.claude/skills/` for global skills

2. **Shell Config**
   - Adds one line to `.zshrc` or `.bashrc`:
     ```bash
     export CLAUDE_PLUGIN_ROOT="/path/to/plugin"
     ```

3. **Nothing Else**
   - No system-wide changes
   - No sudo required
   - No binary installation
   - No PATH modifications

## Uninstallation

```bash
# 1. Remove directory
rm -rf ~/Sites/neural-claude-code-plugin

# 2. Remove from shell config
# Edit ~/.zshrc and remove the CLAUDE_PLUGIN_ROOT line

# 3. Remove global skills (optional)
rm -rf ~/.claude/skills
```

## Security

The install script:
- Uses HTTPS for all downloads
- No `sudo` required
- Only modifies files in your home directory
- Open source - you can inspect it first:
  https://github.com/brolag/neural-claude-code-plugin/blob/main/install.sh

## Support

- **Issues**: https://github.com/brolag/neural-claude-code-plugin/issues
- **Discussions**: https://github.com/brolag/neural-claude-code-plugin/discussions
- **Documentation**: https://github.com/brolag/neural-claude-code-plugin

---

**Happy coding! 🚀**
