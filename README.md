# Reltio Forge — AI Design Pipeline for Claude Desktop

> Three Claude skills that replace the manual Reltio design process end-to-end:  
> challenge assumptions → build concepts → review against the live data model.

---

## The Problem

Manual design at Reltio starts from zero — no schema context, no Jira synthesis, no component check. PMs wait days for a first wireframe. Edge cases surface in QA. Designs shift mid-sprint because nobody validated them against how Reltio actually works.

**Forge replaces that with a three-skill loop running inside Claude Desktop.**

---

## The Skills

### `/forge-design-researcher` — challenge the assumption before the design exists

Runs before any wireframe is built. Pulls signals from Jira tickets, Confluence research notes, and the live Reltio data model. Returns a research position — reframed problem, assumption verdict, testable hypothesis — so design has a sharp direction before a pixel is produced.

| Capability | What it does |
|---|---|
| **Problem reframe** | Identifies when the stated problem is a symptom of a deeper failure mode |
| **Assumption challenge** | Names every untested belief in the brief; verdicts: ✅ Supported / ⚠️ Complicated / ❌ Unsupported / 🔁 Reframe |
| **Evidence synthesis** | Pulls signals from Jira bug comments, Confluence session notes, and persona docs — never duplicates research already done |
| **Hypothesis generation** | Produces 3-part testable hypotheses: the belief, the reason, the test |
| **Live schema reality check** | Calls the live Reltio tenant: if a designer believes "users see too many fields" — checks how many fields actually exist |
| **Figma assumption extraction** | Reads an existing design not to critique it — but to surface the structural assumptions embedded in every layout decision |

**Output:** A research position with: reframed problem, assumption verdict with evidence, testable hypothesis, handoff offer to Forge Prototype Builder.

---

### `/forge-prototype-builder` — build concepts grounded in the Reltio DS and live data model

Runs during concept exploration. Takes a research position (or a review handoff) and builds 2–3 wireframe concepts testing genuinely different interaction models — not layout variations. Each concept is a structural hypothesis rendered in HTML and placed on the Figma canvas.

| Capability | What it does |
|---|---|
| **Figma DS reading** | Reads a DS library link or existing Figma file via MCP — extracts tokens, components, typography, layout conventions |
| **Reltio token system** | Applies the full Reltio token set: primary `#0072CE`, hover `#005BA4`, 9 semantic tokens, left nav spec (200px, active fill `#EBF2F8`) |
| **Interaction model differentiation** | Each concept tests a different structural hypothesis — progressive disclosure vs. full context, wizard vs. full-form, split-panel vs. drill-down |
| **HTML wireframe rendering** | Self-contained HTML concepts rendering inline in chat — real Reltio terminology, real interactive states, no ASCII art |
| **Figma canvas placement** | Places wireframes directly on the Figma page as named frames: `[Wireframe] Concept N — Label`, arranged with tradeoff notes below each |
| **Working HTML prototype** | Functional interactions — filters filter, wizards advance, dropdowns open — all CSS and JS inline |
| **Component provenance table** | On request: DS components used vs. elements built from scratch; flags DS gaps before the feature reaches dev |

**Output:** 2–3 HTML wireframe concepts with structural hypotheses and tradeoffs, placed on the Figma canvas, followed by a working HTML prototype once a direction is confirmed.

---

### `/forge-design-review` — review against the live schema before dev touches it

Runs after a design is produced. Reviews Figma screens against Reltio's live data model, Jira requirements, Confluence standards, and the actual UI codebase. Posts severity-labeled annotations directly onto the Figma canvas — one click per comment, no second prompts.

| Capability | What it does |
|---|---|
| **Jira requirements pull** | Fetches ticket description, acceptance criteria, linked issues; flags requirements the design doesn't address |
| **Confluence standards check** | Treats Confluence as authoritative — if it says a panel always shows a version badge, the design must too |
| **Live schema verification** | Checks every field against the live tenant: field shown in design that doesn't exist = **C** issue |
| **Component state checking** | Checks not just whether a component exists — but whether it supports the states the design requires |
| **Per-domain checklists** | Match/merge: confidence score, rule name, source badge, survivorship indicator, irreversibility warning. Hierarchy: lifecycle state, version indicator, profile count, breadcrumb. Import/export: job status, error count, rollback action |
| **Three review lenses** | Schema fidelity · Workflow fit · Information architecture — applied to every frame |
| **One-click Figma commenting** | Posts each issue as a Figma comment pinned to its node. Per-comment dialog: **Add / Skip / Stop** — no second prompts ever |
| **Severity labeling** | **C** (red) = cannot complete task · **M** (orange) = completes task but makes worse decisions · **S** (blue) = meaningful improvement |
| **Researcher escalation** | Flags structural assumptions before reviewing execution: recommends `/forge-design-researcher` when the design rests on an untested hypothesis |

**Output:** Severity-labeled Figma comments on the canvas + structured report: frames reviewed, annotation counts (C / M / S), schema gaps, requirements gaps, recommended next action.

---

## Skills in the SDLC

| Pipeline Stage | Skill | What it contributes |
|---|---|---|
| Brief / PRD received | **Forge Design Researcher** | Challenges untested assumptions; delivers a research position before any design work begins |
| First draft UX flow | **Forge Prototype Builder** | Builds 2–3 wireframe concepts testing different interaction models; places on Figma canvas |
| Concept iteration | **Forge Prototype Builder** | Iterates HTML prototype from designer feedback; maintains component provenance |
| Pre-stakeholder review | **Forge Design Review** | Reviews concepts against live schema, Jira requirements, and DS standards |
| Design freeze → hi-fi | **Forge Design Review** | Final pre-dev pass: C/M/S annotations on hi-fi; schema gaps and missing states surfaced |
| Hi-fi → dev handoff | **Forge Design Review** | Component state check confirms what dev needs to build vs. what already exists |

---

## Install

### 1. Clone the repo

```bash
git clone https://github.com/vedsarkar/AI-Design-SDLC.git
cd AI-Design-SDLC
```

### 2. Run the Forge installer

```bash
cd Forge
./install.sh
```

The installer:
1. Copies the Figma comment scripts into `~/.claude/scripts/`
2. Merges permissions, env vars, and the PreToolUse hook into `~/.claude/settings.json`
3. Prompts for your Figma personal access token (or skip to set later)
4. Tells you how to install `Forge.plugin` in Claude Desktop

### 3. Install the plugin in Claude Desktop

1. Open **Claude Desktop**
2. **Settings → Plugins → Install from file**
3. Select `Forge/Forge.plugin`
4. **Quit Claude Desktop fully (Cmd+Q) and reopen** — hooks only load on session start

### 4. Configure Figma access (if you skipped step 2)

Add your Figma personal access token to `~/.claude/settings.json`:

```json
{
  "env": {
    "FIGMA_ACCESS_TOKEN": "your-token-here"
  }
}
```

Token scope required: **File comments: write** (Figma → Settings → Security → Personal access tokens).

---

### MCP Servers Required

| Server | Used by | Purpose |
|---|---|---|
| `atlassian` | All three skills | Jira requirements · Confluence design standards |
| `reltio-on-reltio` | All three skills | Live Reltio data model — entity types, attributes, relations |
| `bitbucket` | Forge Design Review | Reltio UI codebase — component existence and state support |
| Figma MCP | Forge Prototype Builder · Forge Design Review | Read designs · annotate canvas · place wireframes |

---

## Verify the install

After restart, run any of these in Claude Desktop:

```
/forge-design-review review this screen https://figma.com/design/...
/forge-design-researcher what do users think about the import flow
/forge-prototype-builder build a prototype for the match review screen
```

---

## What's in this repo

```
AI-Design-SDLC/
├── README.md                           # This file
└── Forge/
    ├── Forge.plugin                    # Claude Desktop plugin — install via UI (bundles all three skills)
    ├── install.sh                      # Automated installer — run this first
    └── setup/
        ├── figma-comment.sh            # Posts comments to Figma REST API
        ├── figma-comment-hook.sh       # PreToolUse hook — intercepts figma_comment trigger
        └── settings.snippet.json       # Reference settings for ~/.claude/settings.json
```

---

*Built by the Reltio design team · Powered by Claude*
