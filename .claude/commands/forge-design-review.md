---
description: Reltio-grounded UI/UX feedback and design suggestions for Figma screens and flows. Pulls live data model, Jira requirements, and Confluence standards before reviewing. Posts structured annotations directly on the Figma canvas.
---

# Forge Design Review

Provides Reltio-grounded UI/UX feedback and improvement suggestions for Figma designs. Posts structured, severity-labeled annotations directly on the canvas. Every suggestion is rooted in the live Reltio data model, Jira requirements, Confluence design standards, and real MDM platform conventions — not generic UX opinion.

**Context**: All reviews are for Reltio — an enterprise MDM / data unification platform. Users are data stewards, MDM admins, and B2B SaaS power users. Keep this mental model in mind throughout: **enterprise-grade, data-dense, workflow-driven**.

**MCP servers used by this skill:**
- `atlassian` — Jira ticket requirements + Confluence design guidelines
- `reltio-on-reltio` — live Reltio data model (entity types, attributes, relation types)
- `bitbucket` — Reltio UI codebase (component existence verification)
- Figma MCP — read and annotate Figma files

---

## Workflow

### Step 0 — Pull structured context before touching Figma

Do this before opening the Figma file. You will need this context to make the review specific, not generic.

**0a. Jira ticket (via `atlassian` MCP)**
- If the user provides a Jira ticket number (e.g. `PLAT-1234`), call `getJiraIssue` to fetch the full ticket: description, acceptance criteria, linked issues, labels, and sprint.
- If no ticket is given, call `searchJiraIssuesUsingJql` with the feature name or flow name from the Figma file title to find likely related tickets.
- Extract: what the feature is supposed to do, who the user is, edge cases mentioned, any explicit requirements the design must satisfy.
- If nothing matches, skip and continue — do not block on this.

**0b. Confluence design standards (via `atlassian` MCP)**
- Call `searchConfluenceUsingCql` with query: `text ~ "design" AND text ~ "[feature area]"` (substitute the feature area from the Figma file title).
- Also search for: `text ~ "component library" OR text ~ "design system" OR text ~ "UX guidelines"` in the Reltio Confluence spaces.
- Read any pages that describe Reltio's UX patterns, component library, or past design decisions for this feature area.
- Use these as an additional ground-truth layer — if Confluence says "the hierarchy panel always shows a version badge", the design must too.

**0c. Live Reltio data model (via `reltio-on-reltio` MCP)**
- Call `get_reltio_entity_types` to get all entity types defined in the tenant.
- For the entity type(s) the design is working with, call `get_reltio_entity_type_attributes` to get every attribute: name, type, cardinality, source constraints.
- If the design involves relations, call `get_reltio_relation_type_and_attributes` for the relevant relation types.
- This is the authoritative schema. If the design shows a field that doesn't exist in the real data model — or omits a field that is mandatory or commonly populated — that is a Critical (`C`) issue.

**0d. Component existence check (via `bitbucket` MCP)**
- Call `listRepositories` filtered to the Reltio UI / frontend repo (search for repos with "ui", "web", or "frontend" in the name).
- Use the repo to understand what component names exist — search for component files or a component index if one exists.
- Note: this is a lightweight check. The goal is to flag if the design relies on a component that clearly doesn't exist yet, so the reviewer can surface it before dev starts.

---

### Step 1 — Read the Figma file

Use the Figma MCP connector to load the file.

**1a. Get file structure**
- Fetch the file metadata to understand its pages and top-level frames
- Identify which page(s) and frames are in scope (a full feature area with multiple flows)
- If scope is unclear, ask: *"Which page or flows should I focus the review on?"*
**1b. Read each frame in scope**
For each frame:
- Get the frame's node tree (layers, components, text content, layout)
- Take a screenshot to visually understand the design
- Note: frame name, visible UI elements, text labels, interactive components, navigation cues, and any annotations
**1c. Map the flows**
Reconstruct the user journey across frames:
```
Flow: [Name]
Entry: [Frame / trigger]
Step 1 → Step 2 → Step 3 → [End state]
Decision points: [List any branching]
```
If something is ambiguous — e.g., a flow seems incomplete, an interaction is unclear, or a label's meaning is uncertain — ask the user before proceeding with review.

---

### Step 2 — Complete Reltio context with public documentation

By now you have live data model context from Step 0. Fill in the remaining gaps with public Reltio docs — product behavior, lifecycle rules, and community-known pain points that aren't in the raw schema.

**Always fetch:**
- `https://docs.reltio.com/` — navigate to the feature area being reviewed; follow links to the specific section (e.g. hierarchies, relations, profiles, search). Focus on: how the feature behaves, lifecycle states, user-facing workflows, and any constraints not visible from the schema alone.
- `https://community.reltio.com/browse/community-blogs` — scan for posts about the feature area; skim for known pain points, workarounds, and patterns that real data stewards have flagged.

**Fetch feature-specific pages** based on what you found in Step 1. Examples:
- Reviewing hierarchy screens → fetch the Hierarchies section of docs
- Reviewing search or entity listing → fetch the Search and Profile docs
- Reviewing relations or connections → fetch the Relations docs

**Cross-reference with what you already have from Step 0:**
- Does the public doc describe a lifecycle state (e.g. Draft → Active → Historical) that the live schema also reflects? If the design doesn't surface it, flag it.
- Does the doc describe a workflow that requires attributes you already know exist in the schema? If the design omits them, that's a gap.
- Does the community surface a known pain point that this design either solves or ignores?

**The goal**: by the time you start Step 3, you hold three layers of truth — Jira requirements, live schema, public behavior docs — and can make feedback that is precise, not generic.

---

### Step 3 — Analyze the design

**Before analyzing**, confirm you have done all of:
1. Pulled Jira requirements, Confluence standards, live schema, and component list (Step 0)
2. Read the Figma file and mapped the flows (Step 1) — you know what the design is trying to do, who does it, and in what workflow context
3. Loaded public Reltio documentation for this feature area (Step 2) — behavioral rules, lifecycle states, community pain points
**What counts as meaningful feedback:**
- Issues that would cause a data steward to make a wrong decision, lose context, or have to leave the page to find what they need
- Gaps between what the design shows and how Reltio's data model / feature actually works (e.g. a hierarchy in Reltio has versions with lifecycle states — does the design surface that correctly?)
- Missing states, flows, or affordances that would block real tasks in an MDM workflow
- Structural decisions (grouping, hierarchy, information architecture) that don't match how users think about the domain
**What does NOT count as meaningful feedback — never raise these:**
- Visual inconsistencies like font sizes, spacing, padding, color mismatches between components
- Component misuse (e.g. "FAB used as a button") unless it directly breaks a user task
- Anything that is purely a developer or design system concern, not a user experience concern
- Nitpicks about naming or labels unless the name is genuinely misleading vs Reltio's documented terminology
Evaluate across three lenses, but only flag issues that are substantive:

**3a. Does the design reflect how the feature actually works in Reltio?**
- Compare visible fields against the live schema from `reltio-on-reltio`. Are mandatory or commonly-populated attributes missing? Are fields shown that don't exist in the schema?
- Are lifecycle states (Active, Draft, Historical) or other domain concepts shown and actionable where they matter?
- Are relation types represented with the correct cardinality and directionality as defined in the live data model?
- Would a data steward looking at this screen understand the real state of their data?
**3b. Does the flow match the actual MDM workflow?**
- Does the task sequence reflect how data stewards actually work — search → find → act?
- Are there gaps where a user would need to go elsewhere to complete a task that should be doable here?
- Does the design handle the high-volume, high-frequency use cases (not just the ideal path)?
**3c. Does the information architecture serve the task?**
- Is the most important information for the task surfaced at the right level?
- Are there missing signals that would change a data steward's decision (e.g. missing status, count, ownership)?
- Does progressive disclosure work — is detail available when needed without cluttering the primary view?
---

### Step 4 — Add annotation nodes directly on the Figma canvas

Do not use Figma comments. Instead, create annotation nodes directly on the canvas using the Figma MCP tools (create_frame, create_text, create_rectangle, etc.).

**Before adding any annotation, run it through this filter:**

- Would a senior data steward or MDM admin care about this?
- Does fixing it change how someone does their job or the quality of their data decisions?
- Is it grounded in something specific to how Reltio works — not just a generic UX opinion?
If the answer to any of these is no, drop it. Every annotation must pass this filter. Annotate every issue that passes — do not cap or limit the number. Surface all real problems.

---

**Set the correct page before placing any annotations**

The Figma plugin runs on `figma.currentPage`, which is whatever page was last open in the desktop app — it may not be the page containing the designs. Before placing the first annotation:
1. Identify the page that contains the frames being reviewed (from the metadata or node ID)
2. Switch to it explicitly at the top of every annotation script:
```js
const targetPage = figma.root.children.find(p => p.name === 'PAGE NAME');
await figma.setCurrentPageAsync(targetPage);
```
3. Append all nodes to `targetPage`, not `figma.currentPage`

If this step is skipped, annotations will land on whichever page happened to be active — silently, on the wrong page.

---

**Frame-by-frame execution — complete one frame before moving to the next**

Process each frame individually in sequence:
1. Read the frame's node tree to get all child node IDs and their `absoluteBoundingBox` coordinates
2. Take a screenshot to visually confirm what's visible
3. Identify all issues that pass the quality filter for this frame
4. Place all annotation nodes for this frame, each inside the frame near its target element
5. Group all annotations for this frame into a single named group: `[Review] [Frame Name]`
6. Only then move to the next frame

Never batch annotations across frames. Finish one frame completely before starting the next.

---

**Structure: one group per frame — not one group for all frames**

Each frame gets its own top-level group named `[Review] [Frame Name]`. Do not create a single group for all frames combined. Each group is self-contained: deleting it removes only that frame's annotations, leaving the design and all other review groups untouched.

---

**Placement — annotations go INSIDE the design frame, near the component**

Annotations are placed as children of the design frame they belong to, positioned close to the UI element they reference. Never place annotation groups outside the design frame on the canvas.

To place an annotation accurately:
1. Find the target element in the frame's node tree and read its `absoluteBoundingBox`
2. Convert to frame-relative coordinates: `relX = element.absX - frame.absX`, `relY = element.absY - frame.absY`
3. Place the annotation in available space near the element — in the gray background area adjacent to the element (e.g. to the right of a centered dialog, in the empty area below a row, in the left margin of the screen). The annotation should be clearly near the issue without fully obscuring the referenced element.
4. If two annotations for nearby elements would overlap, offset the second one by the height of the first + 8px

Use this when placing nodes inside a frame:
```js
frame.appendChild(annotationNode);
annotationNode.x = relX;
annotationNode.y = relY;
```

Never estimate positions. Always derive coordinates from actual `absoluteBoundingBox` values.

**No connector lines** — proximity to the component is sufficient. Do not draw vector lines between annotations and elements.

---

**Annotation style — keep it minimal**

Each annotation is a small frame containing:
- A **severity badge**: a small filled rectangle (16×16) with a single letter — `C` (red `#FF3B30`), `M` (orange `#FF9500`), or `S` (blue `#007AFF`) — and white text at 9px
- A **title**: plain text, 12px, weight 500, color `#111111`, max ~200px wide
- A **body**: plain text, 11px, weight 400, color `#555555` — **hard limit: 100 words total across title + body**
The annotation frame itself:
- White fill `#FFFFFF`
- 1px border `#E0E0E0`
- Corner radius 4
- Padding: 8px
- Drop shadow: `0 1px 4px rgba(0,0,0,0.12)`
- Width: 260px, **height must be calculated precisely** — do not use auto-layout for the outer annotation frame; instead measure each text node's wrapped height explicitly before sizing the frame (see height calculation pattern below)
- No connector lines — placement near the element is sufficient

**Height calculation pattern** — prevents text getting cut off:
```js
// 1. Append text node to page temporarily to get real wrapped height
targetPage.appendChild(titleTxt);
titleTxt.resize(214, 100); titleTxt.textAutoResize = 'HEIGHT';
const titleH = titleTxt.height; // accurate wrapped height
titleTxt.remove(); // detach — will re-append to annotation frame

targetPage.appendChild(bodyTxt);
bodyTxt.resize(244, 100); bodyTxt.textAutoResize = 'HEIGHT';
const bodyH = bodyTxt.height;
bodyTxt.remove();

// 2. Create frame with exact height
const rowH = Math.max(16, titleH);
const totalH = 8 + rowH + 6 + bodyH + 8;
ann.resize(260, totalH);

// 3. Position children at absolute coordinates inside frame (no auto-layout)
badge.x = 8; badge.y = 8 + Math.floor((rowH - 16) / 2);
titleTxt.x = 30; titleTxt.y = 8 + Math.floor((rowH - titleH) / 2);
bodyTxt.x = 8; bodyTxt.y = 8 + rowH + 6;
```

---

**Annotation content format**
```
[badge] Title — problem in under 8 words
Body: what's wrong and what to fix. Max 100 words total across title + body.
Include context only if it helps understand the issue or the fix — skip it if it doesn't add value.
```

No bullet points. No bold inside body text. Be direct — one problem, one fix per annotation.

---

**Severity**
| Badge | Color | Meaning |
|---|---|---|
| C | Red `#FF3B30` | Blocks task or misrepresents how Reltio works |
| M | Orange `#FF9500` | Significant gap affecting most users of this task |
| S | Blue `#007AFF` | Meaningful improvement opportunity |

Never create an annotation that would be Minor — skip it entirely.

---

### Step 5 — Report back in conversation

After all annotation nodes are placed, summarize in the chat:
```
Design Review — [File/Flow Name]
Jira ticket: [Ticket ID + title, or "not found"]
Frames reviewed: [List]
Annotations added: N
C: N | M: N | S: N

Top issues:
[Frame] — [Issue title]
[Frame] — [Issue title]
[Frame] — [Issue title]

Schema gaps:
[Fields shown in design that don't exist in the live Reltio schema]
[Mandatory/common attributes omitted from the design]

Requirements gaps:
[Acceptance criteria from Jira not addressed in the design]

Key domain gaps:
[Any places where the design doesn't reflect how Reltio's feature actually works]
```
Each frame has its own `[Review] [Frame Name]` group inside the design frame — delete that group to remove its annotations cleanly without affecting other frames.

---

## Clarifying questions — when to ask

Ask **before reviewing** only if:
- The scope of frames/flows to review is unclear
- The design is clearly a WIP and it's uncertain what's intentional vs. placeholder
- A label or flow step is genuinely ambiguous and would change the nature of the feedback
Ask as a single grouped message, not one question at a time.

**Never ask** about things you can infer from the design itself or from Reltio docs.

---

## Tips

- **Read the design before the docs**: you'll pull the right resources once you know what you're actually looking at. Generic docs fetched upfront waste time and dilute focus.
- **Understand the feature before reviewing it**: after reading the Figma, fetch the Reltio docs for that specific feature area. A hierarchy in Reltio has specific concepts (versions, lifecycle states, entity types, profiles count) — feedback that ignores this is generic and not useful.
- **Data stewards are power users**: they know the platform. Don't flag things they can figure out. Flag things that are genuinely wrong or missing for their workflow.
- **Reltio's platform is interconnected**: consider how the flow connects to adjacent features — does this screen give enough context for the next action (e.g. viewing a hierarchy, comparing versions, acting on a Draft)?
- **Completeness matters**: surface every issue that passes the quality filter — don't self-limit. A thorough review with 10 real issues is better than an artificially short one.
- **Never flag cosmetic issues**: font sizes, spacing, component variants, button styles — these are design system concerns, not UX concerns. Skip them entirely.
- **Screenshots are ground truth**: always take a screenshot of each frame before analyzing it.
