# Forge — Reltio Design Toolkit for Claude Desktop

A Claude Desktop plugin bundling three skills for Reltio designers:

- **`forge-design-review`** — severity-labeled UX review of Figma screens, posted as Figma comments with a 3-button picker (Add comment / Skip this / Stop review). One click per comment, no second prompts.
- **`forge-design-researcher`** — senior UX researcher persona that challenges design assumptions and synthesizes evidence from Jira, Confluence, and the live Reltio data model.
- **`forge-prototype-builder`** — token-faithful wireframes and HTML prototypes from a Figma link or component reference.

---

## Quick install

From this folder:

```bash
./install.sh
```

That script does everything except install the `.plugin` file itself in Claude Desktop (which has to go through the UI):

1. Copies `setup/figma-comment.sh` and `setup/figma-comment-hook.sh` into `~/.claude/scripts/`
2. Merges permissions, env vars, and the `PreToolUse` hook into `~/.claude/settings.json` (existing keys are preserved; a `.bak` is written)
3. Prompts for a Figma personal access token (skip with Enter to set later)
4. Tells you how to drop `Forge.plugin` into Claude Desktop and restart

Total time: ~1 minute.

---

## Or — let Claude install it for you

If you've cloned this repo and have Claude Desktop running, just say:

> *"Install Forge using the install.sh in this folder."*

Claude will run the script and walk you through the Claude Desktop plugin step at the end.

---

## What's in this folder

```
Forge/
├── README.md                       # This file
├── install.sh                      # Automated installer (the only script you run)
├── Forge.plugin                    # The packaged Claude Desktop plugin (zip with .plugin extension)
└── setup/
    ├── figma-comment.sh            # Wrapper that POSTs to api.figma.com/v1/files/.../comments
    ├── figma-comment-hook.sh       # PreToolUse hook — intercepts the `# figma_comment` bash trigger
    └── settings.snippet.json       # Reference settings to merge into ~/.claude/settings.json
```

---

## How the comment pipeline works

When `/forge-design-review` runs, every issue goes through this sequence:

1. **Picker dialog** (`AskUserQuestion`) — user sees the comment text and picks **Add comment**, **Skip this**, or **Stop review**.
2. **If Add:**
   a. Claude writes `FILE_KEY/NODE_ID + comment body` to `/tmp/.claude-figma-comment` (auto-allowed by `Write(/tmp/.claude-figma-comment)`).
   b. Claude runs `# figma_comment` as a single-line bash command (auto-allowed by `Bash(# figma_comment)`).
   c. The PreToolUse hook intercepts that bash call, reads the temp file, posts to Figma via REST, deletes the temp file, and blocks bash execution.
3. **If Skip / Stop:** queue advances or ends — no posting, no second dialog ever.

Result: **one click per comment**, no curl flags or pin IDs leaking into any UI.

---

## Manual install (if you don't want to run install.sh)

1. **Copy the scripts:**
   ```bash
   mkdir -p ~/.claude/scripts
   cp setup/figma-comment.sh ~/.claude/scripts/
   cp setup/figma-comment-hook.sh ~/.claude/scripts/
   chmod +x ~/.claude/scripts/figma-comment.sh ~/.claude/scripts/figma-comment-hook.sh
   ```

2. **Merge `setup/settings.snippet.json` into `~/.claude/settings.json`.** The keys you need are:
   - `permissions.allow` — add `Bash(# figma_comment)` and `Write(/tmp/.claude-figma-comment)`
   - `env.FIGMA_ACCESS_TOKEN` — your Figma personal access token (Figma → Settings → Security → Personal access tokens, with the `File comments: write` scope)
   - `hooks.PreToolUse` — add a Bash matcher pointing at `~/.claude/scripts/figma-comment-hook.sh` (use the absolute path; tilde may not expand)

3. **Install the plugin:** Claude Desktop → Settings → Plugins → Install from file → select `Forge.plugin`.

4. **Restart Claude Desktop** (Cmd+Q and reopen). Hooks only register on session start.

---

## Verifying the install

After restart, run:

```
/forge-design-review review the following screen <any Figma URL>
```

You should see:
1. The screenshot of the screen rendered inline in chat
2. A picker dialog for each issue with three labeled buttons
3. Comments appearing in your Figma file as you click "Add comment" — no further dialogs

If you see a permission prompt instead, the settings haven't loaded yet — fully quit Claude Desktop and reopen.

---

## Troubleshooting

**"command not found: Import" or similar bash errors when posting**
The PreToolUse hook isn't firing. Quit Claude Desktop fully (Cmd+Q) and reopen — hooks register only at session start.

**Permission dialog appears for `# figma_comment`**
The `Bash(# figma_comment)` allowlist entry isn't loaded. Same fix: quit and reopen Claude Desktop.

**`figma-comment.sh` returns "FIGMA_ACCESS_TOKEN not set"**
The token isn't in `~/.claude/settings.json` `env` block, or the env wasn't loaded. Re-run `./install.sh` and paste your token when prompted.

**Comment posts but contains the wrong file/node**
The temp file `/tmp/.claude-figma-comment` was stale. The hook deletes it after every successful post; if you see this, manually `rm /tmp/.claude-figma-comment` and re-run.

---

## Repository

Reltio Design — `Forge` plugin for Claude Desktop.
