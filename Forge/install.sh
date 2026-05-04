#!/bin/bash
# Forge installer — sets up the Figma comment pipeline used by forge-design-review.
#
# What this does:
#   1. Copies setup/figma-comment.sh and setup/figma-comment-hook.sh to ~/.claude/scripts/
#   2. Merges permissions, env, and hooks into ~/.claude/settings.json
#   3. Prompts for a Figma personal access token if one isn't already configured
#   4. Tells you how to install Forge.plugin in Claude Desktop
#
# Run from the Forge/ folder:
#   ./install.sh

set -e

cd "$(dirname "$0")"
FORGE_DIR="$(pwd)"
CLAUDE_DIR="$HOME/.claude"
SCRIPTS_DIR="$CLAUDE_DIR/scripts"
SETTINGS="$CLAUDE_DIR/settings.json"
SNIPPET="$FORGE_DIR/setup/settings.snippet.json"

bold() { printf "\033[1m%s\033[0m\n" "$1"; }
green() { printf "\033[32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
red() { printf "\033[31m%s\033[0m\n" "$1"; }

bold "Forge installer"
echo

# 1. Sanity checks
if [ ! -d "$CLAUDE_DIR" ]; then
  bold "Creating $CLAUDE_DIR"
  mkdir -p "$CLAUDE_DIR"
fi
mkdir -p "$SCRIPTS_DIR"

if ! command -v python3 >/dev/null 2>&1; then
  red "python3 is required for safe JSON merging — please install it and re-run."
  exit 1
fi

# 2. Copy the two scripts into ~/.claude/scripts/
bold "Installing scripts → $SCRIPTS_DIR"
cp "$FORGE_DIR/setup/figma-comment.sh"      "$SCRIPTS_DIR/figma-comment.sh"
cp "$FORGE_DIR/setup/figma-comment-hook.sh" "$SCRIPTS_DIR/figma-comment-hook.sh"
chmod +x "$SCRIPTS_DIR/figma-comment.sh" "$SCRIPTS_DIR/figma-comment-hook.sh"
green "  ✓ figma-comment.sh"
green "  ✓ figma-comment-hook.sh"
echo

# 3. Get / confirm Figma token
EXISTING_TOKEN=""
if [ -f "$SETTINGS" ]; then
  EXISTING_TOKEN=$(python3 -c "
import json, sys
try:
    with open('$SETTINGS') as f: s = json.load(f)
    print(s.get('env', {}).get('FIGMA_ACCESS_TOKEN', ''))
except Exception:
    print('')
")
fi

if [ -n "$EXISTING_TOKEN" ] && [ "$EXISTING_TOKEN" != "YOUR_FIGMA_TOKEN_HERE" ]; then
  bold "Existing FIGMA_ACCESS_TOKEN found in $SETTINGS — keeping it."
  TOKEN="$EXISTING_TOKEN"
else
  bold "Figma access token"
  echo "Get one at: Figma → Settings → Security → Personal access tokens"
  echo "(needs the 'File comments: write' scope)"
  printf "Paste your token (or leave blank to skip and configure later): "
  read -r TOKEN
fi
echo

# 4. Merge settings
bold "Merging settings → $SETTINGS"

# Resolve absolute hook path
HOOK_PATH="$SCRIPTS_DIR/figma-comment-hook.sh"

python3 - "$SETTINGS" "$SNIPPET" "$TOKEN" "$HOOK_PATH" <<'PYEOF'
import json, os, sys
target_path, snippet_path, token, hook_path = sys.argv[1:5]

# Load existing settings (or start from {})
if os.path.exists(target_path):
    with open(target_path) as f:
        try:
            target = json.load(f)
        except json.JSONDecodeError:
            print(f"  ⚠ {target_path} is not valid JSON — backing up and starting fresh.")
            os.rename(target_path, target_path + '.bak')
            target = {}
else:
    target = {}

with open(snippet_path) as f:
    snippet = json.load(f)
snippet.pop('_comment', None)

# Merge permissions.allow (union, dedupe)
target.setdefault('permissions', {})
target['permissions'].setdefault('allow', [])
for entry in snippet.get('permissions', {}).get('allow', []):
    if entry not in target['permissions']['allow']:
        target['permissions']['allow'].append(entry)

# Merge env
target.setdefault('env', {})
if token:
    target['env']['FIGMA_ACCESS_TOKEN'] = token

# Merge hooks.PreToolUse — replace the Bash matcher entry with our absolute-path version
target.setdefault('hooks', {})
target['hooks'].setdefault('PreToolUse', [])
new_pretooluse = []
already_added = False
for block in target['hooks']['PreToolUse']:
    if block.get('matcher') == 'Bash':
        # Check if any of the existing hooks already point at our hook script
        hooks = block.get('hooks', [])
        is_ours = any(
            isinstance(h, dict) and 'figma-comment-hook' in h.get('command', '')
            for h in hooks
        )
        if is_ours:
            # Update the path to the canonical absolute one
            block['hooks'] = [
                {'type': 'command', 'command': hook_path}
                if (isinstance(h, dict) and 'figma-comment-hook' in h.get('command', ''))
                else h
                for h in hooks
            ]
            already_added = True
    new_pretooluse.append(block)

if not already_added:
    new_pretooluse.append({
        'matcher': 'Bash',
        'hooks': [{'type': 'command', 'command': hook_path}],
    })

target['hooks']['PreToolUse'] = new_pretooluse

# Backup and write
if os.path.exists(target_path):
    import shutil
    shutil.copy(target_path, target_path + '.bak')

with open(target_path, 'w') as f:
    json.dump(target, f, indent=2)
    f.write('\n')

print(f"  ✓ permissions.allow: + Bash(# figma_comment), Write(/tmp/.claude-figma-comment)")
print(f"  ✓ env.FIGMA_ACCESS_TOKEN: {'set' if token else 'left empty (set later)'}")
print(f"  ✓ hooks.PreToolUse[Bash]: {hook_path}")
print(f"  ✓ backup written to {target_path}.bak")
PYEOF

echo
green "Settings, scripts, and token configured."
echo

# 5. Plugin install instructions
bold "Last step — install the plugin in Claude Desktop"
echo
echo "  1. Open Claude Desktop"
echo "  2. Settings → Plugins → Install from file"
echo "  3. Select:  $FORGE_DIR/Forge.plugin"
echo "  4. Quit Claude Desktop fully (Cmd+Q) and reopen"
echo "     (the hook in settings.json only loads on session start)"
echo
yellow "After restart, run /forge-design-review with any Figma URL — comments post"
yellow "with one click each, no second prompts."
echo
green "✓ Forge installed."
