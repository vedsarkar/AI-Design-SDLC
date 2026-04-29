---
description: Builds Reltio-grounded wireframes and working HTML prototypes from a designer's prompt or a Forge-Design-Review handoff. Trigger on phrases like "build me a prototype", "create a wireframe", "design a screen", "explore an alternative", or when Forge-Design-Review hands off with "Want to explore an alternative as a wireframe?". If a Figma link is provided, reads the design directly via Figma MCP and reuses its components — skips DS1/DS2 questions and component reference upload. Without a Figma link, uses the designer-provided component reference as ground truth.
---

# Forge Prototype Builder

Produces lo-fi wireframe concepts and a working HTML prototype grounded in Reltio's actual design system components. Every output reflects how Reltio looks and works — its components, terminology, lifecycle states, and MDM workflows.

**Context**: End users are data stewards, MDM admins, and B2B SaaS power users. Output must feel native to Reltio — not generic SaaS, not Material 3.

**What the designer must have ready before starting:**
- **If a Figma link is provided** — nothing else needed. The skill reads the design directly and extracts the component language from it.
- **If no Figma link** — a Reltio component reference document (DS1 or DS2) and a prompt describing what to build.

**Figma MCP**: Used both to read existing designs (Steps 1–2) and to place wireframe concepts back on the canvas (Step 4b). Requires the Figma MCP to be connected — same connection used by Forge-Design-Review.

---

## Step 1 — Determine the component source

**Check for a Figma link first.**

### Path A — Figma link provided

Use the Figma MCP to read the file:
1. Call `get_design_context` with the `fileKey` and `nodeId` extracted from the URL
   - URL format: `figma.com/design/:fileKey/:name?node-id=:nodeId` — convert `-` to `:` in the node ID
2. Call `get_screenshot` on the same node to visually understand the design
3. Extract from the design:
   - **Component names and patterns** — buttons, chips, tables, nav bars, form fields, and any Reltio-specific components visible in the file
   - **Colour tokens** — dominant brand colours, surface colours, border colours
   - **Typography scale** — heading sizes, body sizes, label styles in use
   - **Layout conventions** — grid, spacing, panel structures

Treat what you extract as the ground truth for this project. Do not ask about DS1/DS2. Do not ask for a component reference document. Proceed directly to Step 3.

### Path B — No Figma link

Ask the designer upfront:
> *"Which Reltio design system should I use — DS1 or DS2?"*

Wait for the answer. Do not infer or guess — DS1 and DS2 have different components.

Once confirmed, ask them to share the component reference document for that system. Read the entire document and extract:
- The full list of available components and their names
- The HTML/CSS that produces each component
- Usage rules — when each component is appropriate and when it is not

If the component reference is unavailable, say so explicitly:
> *"I don't have the DS[1/2] component reference. Without it I can't produce grounded output — please share it before we continue."*

Never substitute with generic Material 2 patterns from training data.

---

## Step 2 — Confirm component understanding

Briefly summarise what you extracted or loaded before proceeding:
- Which path was taken (Figma read or component reference)
- Key components identified that are relevant to the prompt
- Any gaps — components the prompt requires that weren't found in the source

If there are gaps, flag them to the designer before building:
> *"The design doesn't show a [pagination / filter chip / detail panel] component — I'll use the closest Material 2 equivalent styled to match. Let me know if you'd prefer something different."*

This keeps the designer informed of inferred decisions before they appear in the wireframe.

---

## Step 3 — Read and confirm the prompt

The prompt can come from two sources:

**Direct prompt** — the designer describes what to build:
> *"Build a search results page with filters, pagination, and a detail panel."*

**Skill 1 handoff** — Forge-Design-Review passes its feedback as the starting context:
> *"Build a wireframe addressing the issues flagged in the review of [feature area]."*

If the prompt is ambiguous or missing critical scope — which screen, which user task, which entity type — ask one grouped clarifying question before continuing. Never ask piecemeal.

---

## Step 4 — Wireframe first (always required)

Before building anything, propose **2–3 wireframe concepts rendered as actual HTML**. This step is not optional, even if the designer is in a hurry. Never use ASCII art or text sketches — always render real UI.

For each concept output the following in sequence:

**Label + letter** (e.g., `A — List + Detail Split`)
One sentence on what this concept prioritises.

**Rendered wireframe** — output as a self-contained `html` code block so it renders inline in chat:
- Render it at a realistic screen size (e.g. `width: 800px`) inside a white `#FFFFFF` container with a `1px solid #E0E0E0` border and `border-radius: 4px`
- Use actual HTML elements — `<div>`, `<input>`, `<button>`, `<table>`, `<select>` — styled to look like real product UI, not boxes and lines
- Apply Reltio DS colours: primary `#1A73E8`, surface `#FFFFFF`, background `#F5F5F5`, border `#E0E0E0`, text `#212121` / `#616161`
- Use Material 2 patterns (not Material 3): filled buttons, outlined text fields, top app bar, data tables with row hover
- All UI copy is realistic — use Reltio terminology (entity types, profiles, lifecycle states, sources, relations); no "Lorem ipsum", no "Label 1"
- Show real interactive states where they matter: a selected row, an open dropdown, an applied filter chip
- Inline all CSS — no external stylesheets, no CDN links; the block must render standalone

**Tradeoffs** — 2–3 bullet points: what this concept prioritises and what it gives up, specific to the Reltio MDM workflow

After presenting all concepts:
> *"Which concept fits best — or want me to mix elements from two of them?"*

**Recommendation** — state which concept you recommend and why in one sentence, but do not insist.

Wait for the designer to pick a concept or request changes before proceeding. If changes are requested, update the HTML wireframe and re-render it — do not jump to Step 5.

---

### Step 4b — Place wireframe concepts directly on the Figma canvas (optional but recommended)

After presenting the concepts in chat, offer to place them directly in Figma:
> *"Want me to place these wireframe concepts on a Figma canvas so you can compare them side by side?"*

If the designer says yes:

**4b-1. Ask for the target Figma file and page**
> *"Share the Figma file URL and tell me which page to place them on."*

**4b-2. Set the correct page before placing anything**

The Figma MCP operates on the currently active page — it may not be the right one. Before placing any node:
1. Read the file metadata to confirm the page name and get its node ID
2. Switch to that page explicitly before creating any nodes
3. Never place wireframes on whichever page happens to be active

**4b-3. Generate each concept as an SVG and place it as a Figma frame**

For each concept (2–3 total):
1. Generate the wireframe as a clean SVG — use simple shapes, rectangles for content areas, lines for dividers, placeholder text blocks. Use Reltio grey tones (`#F5F5F5` fill, `#E0E0E0` borders, `#616161` labels). Keep it lo-fi — no color fills, no icons.
2. Place each concept as a top-level frame on the page, named: `[Wireframe] Concept N — Label` (e.g., `[Wireframe] Concept 1 — List + Detail Split`)
3. Arrange concepts horizontally, spaced 120px apart from each other
4. Below each frame, add a small text node with the concept's tradeoffs summary (plain text, `#757575`, 12px)

**4b-4. Never overwrite existing frames**

Check the page for existing frames before placing. If frames named `[Wireframe] Concept N` already exist, append a timestamp suffix rather than overwriting: `[Wireframe] Concept 1 — Label (rev2)`.

**4b-5. Report back after placing**
```
Wireframes placed — [File name / Page name]
Concepts added: N
Frames: [Concept 1 name], [Concept 2 name], [Concept 3 name]

Open Figma to compare. Pick a concept or request changes — I'll update the canvas and then build the HTML prototype.
```

---

## Step 5 — Build the HTML prototype

Once a wireframe direction is confirmed, produce a **single self-contained HTML file**.

Requirements:
- Use components from the reference document as the visual language — prefer documented components over invented ones; cite the component name when you use it
- Make interactions functional where possible — filters should filter, dropdowns should open, navigation should work; do not leave interactive elements as static stubs
- Keep the file self-contained — no external dependencies, all CSS and JS inline
- Reltio-specific: use correct terminology (entity types, profiles, lifecycle states, relations) as defined in the component reference; do not use generic SaaS labels
- Material 2, not Material 3 — do not drift toward Material 3 patterns even for components not in the reference

At the end of the file, add a brief comment block that distinguishes:
```
<!-- BUILT PER SPEC: [list what the designer defined explicitly] -->
<!-- INVENTED: [list placeholder copy, default values, or interactions you inferred] -->
```

This transparency is required — the designer must know which decisions were theirs.

---

## Step 6 — Iterate

Present the prototype and invite feedback. The designer can respond by:
- Typing a change description
- Pasting a screenshot of the issue
- Editing the file directly and asking you to continue from their version

On each iteration, update the prototype and re-share. Keep the `BUILT PER SPEC / INVENTED` comment block accurate after each change.

If an iteration request conflicts with the Reltio component reference or MDM conventions, say so directly and propose a compliant alternative. Do not silently produce something that doesn't match the design system.

---

## Handoff back to Forge-Design-Review

If the designer wants the prototype reviewed after building it, say:
> *"Run /forge-design-review with the Figma link of this design and it will post structured annotations directly on the canvas."*

Do not attempt to review the HTML prototype yourself — that is Skill 1's job.
