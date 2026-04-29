# Installation Guide

This repo provides two AI skills for the Reltio design workflow:

| Skill | What it does |
|---|---|
| **Forge Design Review** | Reads a Figma file and posts structured, severity-labeled annotations directly on the canvas — grounded in the live Reltio data model, Jira tickets, Confluence standards, and product docs. |
| **Forge Prototype Builder** | Takes a Figma link or a prompt and generates 2–3 wireframe layout concepts as renderable HTML, then builds a working self-contained HTML prototype using Reltio's design system (DS1/DS2). Optionally places wireframes back on the Figma canvas. |

Both skills are available in two flavors: **Cursor** (as slash commands) and **Claude Desktop** (as skill files). Pick the platform you use.

---

## Prerequisites

### 1. An AI client
Install one of:
- [**Cursor**](https://cursor.com) — recommended for repo-aware workflows
- [**Claude Desktop**](https://claude.ai/download) — for standalone skill use

### 2. MCP servers (required for Forge Design Review, recommended for Forge Prototype Builder)

The skills depend on these Model Context Protocol servers. Configure them in your AI client's MCP settings:

| MCP Server | Purpose | Required for |
|---|---|---|
| **Figma** | Read designs, take screenshots, place annotations on canvas | Both skills |
| **Atlassian** | Pull Jira tickets + Confluence design standards | Forge Design Review |
| **reltio-on-reltio** | Live Reltio data model (entity types, attributes, relations) | Forge Design Review |
| **Bitbucket** | Verify component existence in Reltio UI codebase | Forge Design Review (optional) |

**For Cursor:** edit `~/.cursor/mcp.json`
**For Claude Desktop:** edit `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS)

Example minimum config (Figma only):
```json
{
  "mcpServers": {
    "figma": {
      "url": "https://mcp.figma.com/mcp",
      "type": "http"
    }
  }
}
```

After adding MCP servers, **restart your AI client** so they load.

---

## Install — Cursor

Cursor uses slash commands stored in `.claude/commands/` at your project root.

### Option A — Per-project install (recommended)
Use this if you want the skills tied to a specific project workspace.

1. Clone or download this repo:
   ```bash
   git clone https://github.com/vedsarkar/AI-Design-SDLC.git
   cd AI-Design-SDLC
   ```
2. Open the repo in Cursor.
3. The slash commands `/forge-design-review` and `/forge-prototype-builder` are immediately available — they're already in `.claude/commands/`.

### Option B — Global install (available in every project)
Copy the command files into your global Cursor commands folder:

```bash
mkdir -p ~/.claude/commands
cp .claude/commands/forge-design-review.md ~/.claude/commands/
cp .claude/commands/forge-prototype-builder.md ~/.claude/commands/
```

Restart Cursor. Both commands are now available globally.

### How to invoke (Cursor)
In any Cursor chat, type:
```
/forge-design-review <Figma URL>
/forge-prototype-builder <Figma URL or prompt>
```

---

## Install — Claude Desktop

Claude Desktop loads skills from `~/Library/Application Support/Claude/skills/` (macOS) or `%APPDATA%\Claude\skills\` (Windows).

### Steps

1. Clone or download this repo:
   ```bash
   git clone https://github.com/vedsarkar/AI-Design-SDLC.git
   cd AI-Design-SDLC
   ```

2. Create the skills folder if it doesn't exist:
   ```bash
   # macOS
   mkdir -p ~/Library/Application\ Support/Claude/skills

   # Windows (PowerShell)
   New-Item -ItemType Directory -Force -Path "$env:APPDATA\Claude\skills"
   ```

3. Copy the skill files:
   ```bash
   # macOS
   cp Skills/Forge-Design-Review/Cursor/Forge-Design-Review.md ~/Library/Application\ Support/Claude/skills/
   cp Skills/Forge-Prototype-Builder/forge-prototype-builder.md ~/Library/Application\ Support/Claude/skills/

   # Windows (PowerShell)
   Copy-Item "Skills\Forge-Design-Review\Cursor\Forge-Design-Review.md" "$env:APPDATA\Claude\skills\"
   Copy-Item "Skills\Forge-Prototype-Builder\forge-prototype-builder.md" "$env:APPDATA\Claude\skills\"
   ```

   > The skill files use the same format for Cursor and Claude Desktop, so the Cursor version works on both platforms.

4. Restart Claude Desktop so it picks up the new skills.

### How to invoke (Claude Desktop)
Just describe what you want. The skills auto-trigger on relevant phrases:

| Phrase | Triggers |
|---|---|
| "Review this design: \<Figma URL\>" | Forge Design Review |
| "Critique these screens" | Forge Design Review |
| Pasting a Figma URL | Forge Design Review |
| "Show me a different layout for \<Figma URL\>" | Forge Prototype Builder |
| "Build a wireframe for \<feature\>" | Forge Prototype Builder |

---

## Verify the install

### Cursor
Type `/` in any chat. You should see:
- `forge-design-review`
- `forge-prototype-builder`

### Claude Desktop
Open Claude Desktop → check **Settings → Skills**. Both skills should be listed.

### Smoke test
Run this against any Figma file you have access to:

```
/forge-design-review https://www.figma.com/design/<fileKey>/<name>?node-id=<nodeId>
```

If the skill responds with "Figma file could not be accessed," your Figma MCP isn't connected. See the **MCP servers** section above.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `/forge-*` commands don't appear | Cursor hasn't reloaded | Restart Cursor |
| "Figma file could not be accessed" | Figma MCP not connected, or wrong account | Verify auth via `whoami` Figma MCP tool; confirm you have access to the file |
| "missing_scope" / Slack-style error | MCP token has wrong permissions | Re-auth the MCP with required scopes |
| Skill runs but feedback is generic | Reltio MCPs (`reltio-on-reltio`, `atlassian`) not connected | Add and authenticate those MCP servers |
| Annotations land on wrong Figma page | Plugin defaulted to last-active page | Skill auto-corrects via `setCurrentPageAsync`; if it still fails, open the target page in Figma before running |

---

## Updating the skills

Pull the latest from this repo:
```bash
cd AI-Design-SDLC
git pull origin main
```

Then re-copy the files if you used the global install path (Option B for Cursor, or the Claude Desktop install).

---

## File reference

```
AI-Design-SDLC/
├── .claude/commands/
│   ├── forge-design-review.md            # Cursor slash command
│   └── forge-prototype-builder.md        # Cursor slash command
└── Skills/
    ├── Forge-Design-Review/
    │   └── Cursor/
    │       └── Forge-Design-Review.md    # Skill file (works on Cursor + Claude Desktop)
    └── Forge-Prototype-Builder/
        └── forge-prototype-builder.md    # Skill file (works on Cursor + Claude Desktop)
```
