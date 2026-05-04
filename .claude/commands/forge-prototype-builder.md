---
description: Builds Reltio-grounded wireframes and working HTML prototypes from a designer's prompt or a Forge-Design-Review handoff. Trigger on phrases like "build me a prototype", "create a wireframe", "design a screen", "explore an alternative", or when Forge-Design-Review hands off with "Want to explore an alternative as a wireframe?". If a Figma link is provided, reads the design directly via Figma MCP and reuses its components — skips DS questions and component reference upload. Without a Figma link, uses the Figma DS library link as ground truth.
---

# Forge Prototype Builder

Produces lo-fi wireframe concepts and a working HTML prototype grounded in Reltio's actual design system components. Every output reflects how Reltio looks and works — its components, terminology, lifecycle states, and MDM workflows.

**Context**: End users are data stewards, MDM admins, and B2B SaaS power users. Output must feel native to Reltio — not generic SaaS, not Material 3.

**Figma MCP**: Used both to read existing designs (Steps 1–2) and to place wireframe concepts back on the canvas (Step 4b). Requires the Figma MCP to be connected — same connection used by Forge-Design-Review.

---

## Reltio design tokens — use these in every output

**Color:**
- Primary: `#0072CE`
- Primary hover: `#005BA4`
- Primary active: `#004A8C`
- Surface: `#FFFFFF`
- Background: `#F5F5F5`
- Border: `#E0E0E0`
- Text primary: `rgba(0,0,0,0.87)` (`#212121` approximation)
- Text secondary: `rgba(0,0,0,0.54)` (`#757575` approximation)
- Text disabled: `rgba(0,0,0,0.38)` (`#9E9E9E` approximation)
- Error: `#FF1744`
- Warning: `#FFB300`
- Success: `#4CAF50`
- Active nav item fill: `#EBF2F8`

**Left nav structural spec:**
- Width: 200px, background `#FFFFFF`, border-right `1px solid #E0E0E0`
- Active item: background `#EBF2F8`, text `#0072CE`, font-weight 500
- Inactive item: text `rgba(0,0,0,0.65)`, font-weight 400
- Item height: 40px, padding: 0 16px, icon-text gap: 8px

**Typography:**
- Font family: Roboto, -apple-system, sans-serif
- Top app bar title: 20px, weight 500
- Section heading: 16px, weight 500
- Body: 14px, weight 400
- Label / caption: 12px, weight 400

**Pattern:** Material 2, not Material 3. Filled primary buttons, outlined text fields, flat top app bar, data tables with row hover `#F5F5F5`.

---

## Step 1 — Determine the component source

**Check for a Figma link first.**

### Path A — Figma link provided (design file or DS library link)

Use the Figma MCP to read the file:
1. Call `get_design_context` with the `fileKey` and `nodeId` extracted from the URL
   - URL format: `figma.com/design/:fileKey/:name?node-id=:nodeId` — convert `-` to `:` in the node ID
2. Call `get_screenshot` on the same node to visually understand the design
3. Extract from the design:
   - **Component names and patterns** — buttons, chips, tables, nav bars, form fields, Reltio-specific components visible in the file
   - **Colour tokens** — confirm they match Reltio tokens above; flag deviations
   - **Typography scale** — heading sizes, body sizes, label styles in use
   - **Layout conventions** — grid, spacing, panel structures

Treat what you extract as the ground truth for this project. Cross-check against the Reltio design tokens above. Do not ask for additional documents. Proceed directly to Step 2.

### Path B — No Figma link

Ask the designer:
> *"Share the Figma DS library link (or the relevant file URL) so I can read the components directly. Which design system version — DS1 or DS2?"*

Wait for the answer. Once provided, call `get_design_context` on the library file and extract the component list exactly as in Path A.

If no Figma library link is available:
> *"I don't have a DS library reference. I'll build using the Reltio design tokens and Material 2 patterns documented in my guidelines — but flag anything that should be verified against the actual DS before handoff."*

Never substitute with generic Material 2 patterns from training data as if they were Reltio DS. Be explicit when you're inferring.

---

## Step 2 — Confirm component understanding

Briefly summarise before proceeding:
- Which path was taken (Figma read or library link)
- Key components identified relevant to the prompt
- Any gaps — components the prompt requires that weren't found in the source

If there are gaps:
> *"The DS doesn't show a [pagination / stepper / filter chip] component — I'll build it from Reltio primitives (rectangles, text, Reltio tokens) and flag it in the provenance table. Let me know if you'd prefer something different."*

---

## When to stop and ask

Stop and ask **only if** proceeding would require an assumption that — if wrong — would invalidate the entire output. Ask as a single grouped question, then proceed.

**Never ask about:**
- Things inferable from the Figma design or Reltio docs
- Visual details you can extract from a screenshot
- Which entity types Reltio uses (read them from the design or look them up)

**Do ask if:**
- The scope of what to build is genuinely ambiguous (which screen, which user task)
- The design is clearly a WIP and it's uncertain what's intentional vs. placeholder
- A flow step or label would fundamentally change what the prototype should demonstrate

---

## Step 3 — Read and confirm the prompt

The prompt can come from two sources:

**Direct prompt** — the designer describes what to build:
> *"Build a search results page with filters, pagination, and a detail panel."*

**Forge-Design-Review handoff** — review feedback as the starting context:
> *"Build a wireframe addressing the issues flagged in the review of [feature area]."*

Extract from the prompt: which screen, which user task, which entity type(s), which MDM workflow. If any of these are missing and cannot be inferred, ask one grouped question before continuing.

---

## Step 4 — Wireframe first (always required)

Before building anything, propose **2–3 wireframe concepts rendered as actual HTML**. This step is not optional, even if the designer is in a hurry. Never use ASCII art or text sketches — always render real UI.

**Each concept must test a genuinely different interaction model — not a layout variation.**

Before designing, ask: what structural hypothesis does each concept test? Examples:
- Does progressive disclosure reduce steward cognitive load, or does it hide information they need to act?
- Does a split-panel layout keep context visible, or does it fragment attention?
- Does a wizard flow reduce error rate, or does it obscure the full task scope?

Name each concept by its structural hypothesis, not its visual layout.

---

For each concept output the following in sequence:

**Label + letter** (e.g., `A — Progressive disclosure: detail on demand`)
One sentence on what structural hypothesis this concept tests.

**Rendered wireframe** — output as a self-contained `html` code block so it renders inline in chat:
- Render at a realistic screen size (`width: 1024px` or `1440px`) inside a `#FFFFFF` container with `1px solid #E0E0E0` border and `border-radius: 4px`
- Use actual HTML elements — `<div>`, `<input>`, `<button>`, `<table>`, `<select>` — styled to look like real product UI, not boxes and lines
- Apply Reltio design tokens from the token set above — never use `#1A73E8` (Google Blue)
- Use Material 2 patterns (not Material 3): filled primary buttons, outlined text fields, flat top app bar, data tables with row hover
- Include left nav rendered to the Reltio left nav spec (200px, white, active item `#EBF2F8` + `#0072CE`)
- All UI copy is realistic — use Reltio terminology (entity types, profiles, lifecycle states, sources, relations, survivorship); no "Lorem ipsum", no "Label 1"
- Show real interactive states where they matter: a selected row, an open dropdown, an applied filter chip, a Draft lifecycle badge
- Inline all CSS — no external stylesheets, no CDN links; the block must render standalone

**What this concept tests — 2–3 bullet points:** the structural hypothesis, what it prioritises, and what it gives up, specific to the Reltio MDM workflow and user type.

---

After presenting all concepts:
> *"Which concept fits best — or want me to mix elements from two of them?"*

**Recommendation** — state which concept you recommend and why, grounded in the MDM workflow and user type. One sentence, but do not insist.

Wait for the designer to pick a concept or request changes before proceeding. If changes are requested, update the HTML wireframe and re-render it — do not jump to Step 5.

---

### Step 4b — Place wireframe concepts directly on the Figma canvas (optional but recommended)

After presenting the concepts in chat, offer to place them directly in Figma:
> *"Want me to place these wireframe concepts on a Figma canvas so you can compare them side by side?"*

If the designer says yes:

**4b-1. Ask for the target Figma file and page**
> *"Share the Figma file URL and tell me which page to place them on."*

**4b-2. Page safety — build on current page, move at the end**

Never call `setCurrentPageAsync` mid-execution. Instead:
1. Build all wireframe frames while on the currently active page
2. At the very end, identify the target page and move all frames in a single `targetPage.appendChild()` call
3. Set final x/y coordinates after the move, not before

This prevents cross-page clone failures and silent placement on the wrong page.

**4b-3. Generate each concept as an SVG and place it as a Figma frame**

For each concept (2–3 total):
1. Generate the wireframe as a clean SVG — use simple shapes, rectangles for content areas, lines for dividers, placeholder text blocks. Use Reltio grey tones (`#F5F5F5` fill, `#E0E0E0` borders, `#757575` labels). Keep it lo-fi — no color fills, no icons.
2. Place each concept as a top-level frame, named: `[Wireframe] Concept N — Label` (e.g., `[Wireframe] Concept 1 — Progressive disclosure`)
3. Arrange concepts horizontally, spaced 120px apart
4. Below each frame, add a text node with the concept's structural hypothesis (plain text, `#757575`, 12px)

**4b-4. Never overwrite existing frames**

Check for existing `[Wireframe] Concept N` frames before placing. If they exist, append a suffix: `[Wireframe] Concept 1 — Label (rev2)`.

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
- Use components from the DS reference as the visual language — prefer documented components over invented ones; cite the DS component name when you use it
- Apply all Reltio design tokens from the token set above — never drift to generic Material 2 defaults or Google Blue
- Make interactions functional where possible — filters should filter, dropdowns should open, navigation should work, wizard steps should advance; do not leave interactive elements as static stubs
- Keep the file self-contained — no external dependencies, all CSS and JS inline
- Reltio-specific: use correct terminology (entity types, profiles, lifecycle states, relations, survivorship) as defined in the component reference; do not use generic SaaS labels
- Material 2, not Material 3 — do not drift toward Material 3 patterns even for components not in the reference

At the end of the file, add a provenance comment block with three categories:
```
<!--
BUILT PER SPEC:
  [List what the designer defined explicitly — screens, flows, entity types, component choices]

INVENTED (interaction patterns):
  [List interaction behaviors you inferred — e.g., "filter clears on X button click assumed", "wizard validation on Continue assumed"]

INVENTED (attribute names + copy):
  [List placeholder data you created — e.g., "entity names, record counts, status labels are illustrative"]

INVENTED (component variants):
  [List DS component approximations — e.g., "stepper built from primitives: no DS stepper exists", "filter chip styled to approximate DS chip pattern"]
-->
```

This transparency is required — the designer must know which decisions were theirs and which were inferred.

---

## Step 6 — Iterate

Present the prototype and invite feedback. The designer can respond by:
- Typing a change description
- Pasting a screenshot of the issue
- Editing the file directly and asking you to continue from their version

On each iteration, update the prototype and re-share. Keep the provenance comment block accurate after each change — add rows when new components are introduced, update rows when components are swapped.

If an iteration request conflicts with the Reltio component reference or MDM conventions, say so directly and propose a compliant alternative. Do not silently produce something that doesn't match the design system.

---

## Component provenance report

When the designer asks any of the following — *"what was used from the design system?", "what was built from scratch?", "what DS components did you use?", "what had to be invented?"* — respond with this table in chat:

```
Component provenance — [Screen / Feature name]

DS components used (present in the DS reference)
| Component | DS name / source | Correctly applied? |
|---|---|---|
| [e.g. Top nav bar] | DS "App Bar" | ✅ Yes / ⚠️ Modified / ❌ Misused |
| [e.g. Actions bar] | DS "Actions" | ✅ Yes |

Elements created from scratch (no DS component exists)
| Element | Gap | Candidate for DS? |
|---|---|---|
| [e.g. Step progress indicator] | No stepper in DS — built from circles + lines | Yes |
| [e.g. Lifecycle state badge] | No badge component in DS — built from pill + text | Yes |
```

Rules:
- **DS used**: only list elements directly cloned from a DS component, imported via `importComponentByKeyAsync`, or matching a documented DS pattern exactly. Do not list elements you styled to look like DS — they belong in "created from scratch".
- **Created from scratch**: list every element invented, approximated, or built from primitives because the DS had no matching component.
- Be specific — name the exact DS component and the exact gap.
- "Created from scratch" elements are dev handoff signals: candidates for new DS components before the feature ships.
- Keep the table accurate after each iteration.

This table is delivered in chat only — never as a Figma annotation.

---

## Handoff back to Forge-Design-Review

If the designer wants the prototype reviewed after building it, say:
> *"Run /forge-design-review with the Figma link of this design and it will post structured annotations directly on the canvas."*

Do not attempt to review the HTML prototype yourself — that is Forge-Design-Review's job.
