# Forge — Reltio Design Toolkit for Claude Desktop

A Claude Desktop plugin that turns Claude into an embedded design partner for Reltio's MDM platform. Three specialist skills cover the full design loop — research, review, and prototype — each grounded in the live Reltio data model, Jira tickets, Confluence standards, and real platform conventions.

> Built for designers, PMs, and engineers working on Reltio. All output is grounded in the actual data model and codebase, not generic UX opinion.

---

## What you get

Three skills, one plugin:

| Skill | Trigger phrases | What it does |
|---|---|---|
| **`/forge-design-researcher`** | "what do users think about", "challenge my assumption", "research this problem" | Senior UX researcher persona that pushes back on untested assumptions and synthesizes evidence from Jira, Confluence, and live schema |
| **`/forge-design-review`** | "review this design", "critique this Figma", any Figma URL | Severity-labeled UX review of Figma screens with one-click commenting straight onto the canvas |
| **`/forge-prototype-builder`** | "build a prototype", "create a wireframe", "design a screen" | Token-faithful wireframes and working HTML prototypes from a Figma link or component reference |

---

## The three skills in detail

### 🔬 `forge-design-researcher` — Challenge before you build

A senior mixed-methods UX researcher embedded in Reltio MDM teams. Not a template generator — an active research partner.

**What it does:**
- **Reframes the problem** from the outside in — what users are experiencing, not what the design is missing
- **Challenges assumptions** with verdicts (✅ Supported / ⚠️ Complicated / ❌ Unsupported / 🔁 Reframe needed) backed by evidence from Jira tickets, Confluence research, and the live Reltio schema
- **Synthesizes scattered signals** across bug reports, support escalations, and design history into a clear research position
- **Generates testable hypotheses** with belief + reason + observable test
- Carries **field notes for Reltio user types** — data stewards, MDM admins, data analysts — built from 200+ research sessions

**Use when:** A design rests on a strong bet about user behavior ("stewards want fewer fields", "admins want a wizard flow") and there's no research evidence yet.

**Example output:**
> *"You've described this as a navigation problem. But when I've watched stewards in this part of the product, they weren't lost — they were stalling. They'd arrive at the right screen and hesitate. That's not a wayfinding problem, that's a confidence problem. They needed information to make a decision and the screen wasn't giving it to them."*

---

### 🔍 `forge-design-review` — Review designs with one-click Figma commenting

Reltio-grounded UI/UX feedback delivered both in chat and as comments posted directly to the Figma file.

**What it does:**
- **Pulls live context first** — Jira tickets, Confluence design standards, Reltio data model attributes, codebase component existence — before opening the Figma file
- **Runs domain-specific checklists** — match/merge screens get survivorship + irreversibility + escalation checks; hierarchy screens get lifecycle state + version + profile count checks; import screens get job status + error report + record count checks
- **Three review lenses per frame** — schema fidelity, workflow fit, information architecture
- **Severity-labeled** — Critical (blocks task) / Major (worse decisions) / Suggestion (friction)
- **Three-button picker per comment** — **Add comment** / **Skip this** / **Stop review** — review keeps moving regardless of choice
- **One-click posting** — comments land in Figma silently after a single click, no second permission dialog, no curl flags or pin IDs leaking into any UI

**The dialog flow:**

```
1. /forge-design-review <Figma URL>
2. Screenshot of the design appears in chat
3. Picker shows: "Comment 1 of 4: <comment text>"
   → Add comment → posts silently to Figma, advances to next
   → Skip this   → no post, advances to next
   → Stop review → ends now, summary report
4. Step 5 summary: posted vs skipped vs not-asked
```

**Never flags cosmetic issues** (font sizes, padding, spacing, color mismatches) — those are design system concerns, not UX.

---

### 🎨 `forge-prototype-builder` — From Figma link to working HTML

Builds Reltio-grounded wireframes and interactive HTML prototypes.

**What it does:**
- **Reads existing Figma files directly** via Figma MCP — extracts the actual color tokens, fonts, and icons from the file (no approximations)
- **Without a Figma link**, uses the designer-provided component reference as ground truth
- **Produces working HTML/CSS/JS** that matches the design system, not visual approximations
- **Skips DS questions** when a Figma link is provided — the design system is right there in the file

**Use when:**
- Forge-Design-Review hands off with "Want to explore an alternative as a wireframe?"
- A designer wants to prototype a flow before investing in Figma fidelity
- A PM needs to demo a hypothetical interaction in a meeting

---

## Quick install

From inside the cloned `Forge/` folder:

```bash
./install.sh
```

That's the whole thing. The script:

1. Creates `~/.claude/scripts/` if missing
2. Copies `setup/figma-comment.sh` and `setup/figma-comment-hook.sh` there with executable bits
3. Reads your existing `~/.claude/settings.json` and **merges** (never replaces) these keys:
   - `permissions.allow` — adds `Bash(# figma_comment)` and `Write(/tmp/.claude-figma-comment)`
   - `env.FIGMA_ACCESS_TOKEN` — prompts for one if not already set
   - `hooks.PreToolUse[Bash]` — wires the absolute path to `figma-comment-hook.sh`
4. Writes a `.bak` of your original settings.json before touching it
5. Prints clear instructions for the one manual step (Claude Desktop's Plugins menu)

**Total time:** ~1 minute. **Restart required:** Claude Desktop must be fully quit (Cmd+Q) and reopened so the new hook block in `settings.json` registers.

### Or — let Claude install it for you

With Claude Desktop already running and this repo cloned, just say:

> *"Install Forge using the install.sh in this folder."*

Claude runs the script and walks you through the plugin step at the end.

---

## Manual install (if you don't want to run install.sh)

1. **Copy the scripts:**
   ```bash
   mkdir -p ~/.claude/scripts
   cp setup/figma-comment.sh      ~/.claude/scripts/
   cp setup/figma-comment-hook.sh ~/.claude/scripts/
   chmod +x ~/.claude/scripts/figma-comment*.sh
   ```

2. **Get a Figma personal access token** at Figma → Settings → Security → Personal access tokens (scope: `File comments: write`).

3. **Merge `setup/settings.snippet.json` into `~/.claude/settings.json`** — see the snippet for the exact keys. **Use the absolute path** for the hook command (tilde may not expand).

4. **Install the plugin:** Claude Desktop → Settings → Plugins → Install from file → select `Forge.plugin`.

5. **Restart Claude Desktop** (Cmd+Q and reopen). Hooks register only at session start.

---

## How the one-click comment flow works

Every comment goes through this sequence:

1. **Picker** (`AskUserQuestion`) shows the comment text + three buttons (Add comment / Skip this / Stop review)
2. **If Add:**
   - Claude writes `FILE_KEY\nNODE_ID\n\n<comment body>` to `/tmp/.claude-figma-comment` — auto-allowed by `Write(/tmp/.claude-figma-comment)`
   - Claude runs the bash command `# figma_comment` (a single-line comment, valid bash no-op) — auto-allowed by `Bash(# figma_comment)`
   - The PreToolUse hook intercepts that bash, reads the temp file, posts to `api.figma.com/v1/files/{FILE_KEY}/comments` via REST, deletes the temp file, and blocks bash execution with `{"continue": false}`
3. **If Skip / Stop:** queue advances or ends. No posting, no dialog ever.

The result: **one click per comment**, with no curl flags, no pin IDs, no severity tags, no second permission prompts visible anywhere in the UI. The Figma comment itself contains only the title and body.

---

## Folder structure

```
Forge/
├── README.md                       This file
├── install.sh                      Automated installer (the only script you run)
├── Forge.plugin                    Packaged Claude Desktop plugin (zip with .plugin extension)
└── setup/
    ├── figma-comment.sh            POSTs to api.figma.com/v1/files/.../comments
    ├── figma-comment-hook.sh       PreToolUse hook — intercepts the `# figma_comment` trigger
    └── settings.snippet.json       Reference settings to merge into ~/.claude/settings.json
```

---

## Verifying the install

After Claude Desktop restart, run:

```
/forge-design-review review the following screen <any Figma URL>
```

You should see:
1. The screenshot of the screen rendered inline in chat
2. A picker dialog for each issue with three labeled buttons
3. Comments appearing in your Figma file as you click "Add comment" — no further dialogs

If you see a permission prompt instead of silent posting, the settings haven't loaded yet — fully quit Claude Desktop and reopen.

---

## Troubleshooting

**Bash errors like `command not found: Import` when posting**
The PreToolUse hook isn't firing. Quit Claude Desktop fully (Cmd+Q) and reopen — hooks register only at session start.

**Permission dialog appears for `# figma_comment` after picking "Add comment"**
The `Bash(# figma_comment)` allowlist entry isn't loaded. Same fix: quit and reopen Claude Desktop.

**`figma-comment.sh` returns "FIGMA_ACCESS_TOKEN not set"**
The token isn't in `~/.claude/settings.json` `env` block. Re-run `./install.sh` and paste your token, or add it manually under `env.FIGMA_ACCESS_TOKEN`.

**Comment posts but contains stale data**
The temp file `/tmp/.claude-figma-comment` was reused before being deleted. The hook deletes it after every successful post; if you see this, manually `rm /tmp/.claude-figma-comment` and re-run.

**"Allow Claude to run Clean up pin file?" dialog appears**
You're on an old version of the skill. Reinstall `Forge.plugin` from this folder — the current version never runs cleanup bash; the hook handles it.

---

## Requirements

- **Claude Desktop** with cowork mode enabled
- **macOS** (paths are macOS-specific — Linux/Windows would need path adjustments)
- **Python 3** (used by `install.sh` and `figma-comment.sh` for safe JSON handling)
- **A Figma personal access token** with the `File comments: write` scope
- **Atlassian MCP** + **reltio-on-reltio MCP** + **bitbucket MCP** (optional but recommended — the review skill pulls deeper context when these are connected)

---

## Built by

Reltio Design — `Forge` plugin for Claude Desktop.