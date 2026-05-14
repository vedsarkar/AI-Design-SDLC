# Forge — Reltio Design Toolkit for Claude Code

A set of four Claude Code skills for Reltio designers. Each skill is distributed as a `.skill` file (a zip archive containing a `SKILL.md`). Install them into Claude Code's commands directory and invoke them with a slash command in the terminal.

## Skills

| Skill | Slash command | What it does |
|---|---|---|
| `forge-design-review.skill` | `/forge-design-review` | Severity-labeled UX review of Figma screens, grounded in the live Reltio data model, Jira requirements, and Confluence design standards. Posts structured annotations directly on the Figma canvas. |
| `forge-accessibility-check.skill` | `/forge-accessibility-check` | WCAG 2.1 AA audit of Reltio designs. Checks contrast, keyboard navigation, screen reader semantics, and Reltio-specific patterns (status badges, data tables, modal dialogs). Delivers findings as a spreadsheet or Figma comments. |
| `forge-design-researcher.skill` | `/forge-design-researcher` | Senior UX researcher persona that challenges design assumptions and synthesises evidence from Jira, Confluence, and the live Reltio data model. |
| `forge-prototype-builder.skill` | `/forge-prototype-builder` | Token-faithful wireframes and HTML prototypes from a Figma link or component reference. |

---

## Installation

For each skill:

```bash
# 1. Unzip the .skill file and copy SKILL.md into Claude Code's commands folder
unzip -p forge-design-review.skill SKILL.md > ~/.claude/commands/forge-design-review.md
unzip -p forge-accessibility-check.skill SKILL.md > ~/.claude/commands/forge-accessibility-check.md
unzip -p forge-design-researcher.skill SKILL.md > ~/.claude/commands/forge-design-researcher.md
unzip -p forge-prototype-builder.skill SKILL.md > ~/.claude/commands/forge-prototype-builder.md
```

Or tell Claude Code to install them:

> *"Install the Forge skills from this folder."*

---

## One-time setup — Figma token

`/forge-design-review` and `/forge-accessibility-check` post comments directly to Figma. Add your Figma personal access token to `~/.claude/settings.json`:

```json
{
  "env": {
    "FIGMA_ACCESS_TOKEN": "figd_your_token_here"
  },
  "permissions": {
    "allow": [
      "Bash(~/.claude/scripts/figma-post.sh)",
      "Write(/tmp/.claude-figma-comment)"
    ]
  }
}
```

Get a token at **Figma → Settings → Security → Personal access tokens**. Enable the `File comments: write` scope.

Also place `figma-post.sh` from the `setup/` folder into `~/.claude/scripts/`:

```bash
mkdir -p ~/.claude/scripts
cp setup/figma-post.sh ~/.claude/scripts/
chmod +x ~/.claude/scripts/figma-post.sh
```

---

## How the Figma comment pipeline works

When `/forge-design-review` or `/forge-accessibility-check` identifies an issue, each comment goes through this sequence:

1. **Picker dialog** (`AskUserQuestion`) — you see the comment text and choose **Add comment**, **Skip this**, or **Stop review**.
2. **If Add:**
   - Claude writes `FILE_KEY`, `NODE_ID`, and the comment body to `/tmp/.claude-figma-comment`.
   - Claude runs `~/.claude/scripts/figma-post.sh`, which reads the file, POSTs to `api.figma.com/v1/files/.../comments`, and deletes the temp file.
3. **If Skip / Stop:** queue advances or ends — nothing is posted.

Comments are pinned to the specific node that contains the issue, not the whole frame.

---

## File structure

```
Forge/
├── README.md                        # This file
├── forge-design-review.skill        # UX review skill
├── forge-accessibility-check.skill  # Accessibility audit skill
├── forge-design-researcher.skill    # Design research skill
├── forge-prototype-builder.skill    # Prototype builder skill
└── setup/
    ├── figma-post.sh                # Script that POSTs to Figma REST API
    └── settings.snippet.json        # Reference settings to merge into ~/.claude/settings.json
```

---

## Verifying the install

In the Claude Code terminal, run:

```
/forge-design-review <any Figma URL>
```

You should see the design screenshot rendered in chat, followed by a picker dialog for each issue. Approving one should post a pinned comment to your Figma file.
