---
description: Reltio-grounded UI/UX feedback and design suggestions for Figma screens and flows. Pulls live data model, Jira requirements, and Confluence standards before reviewing. Posts structured annotations directly on the Figma canvas.
---

# Forge Design Review

Provides Reltio-grounded UI/UX feedback and improvement suggestions for Figma designs. Posts structured, severity-labeled annotations directly on the canvas. Every suggestion is rooted in the live Reltio data model, Jira requirements, Confluence design standards, and real MDM platform conventions — not generic UX opinion.

**Context**: All reviews are for Reltio — an enterprise MDM / data unification platform. Users are data stewards, MDM admins, and B2B SaaS power users. Keep this mental model throughout: **enterprise-grade, data-dense, workflow-driven, high-stakes decisions**.

**MCP servers used:**
- `atlassian` — Jira ticket requirements + Confluence design guidelines
- `reltio-on-reltio` — live Reltio data model (entity types, attributes, relation types)
- `bitbucket` — Reltio UI codebase (component existence + state support verification)
- Figma MCP — read and annotate Figma files

**When to escalate to Forge-Design-Researcher first:**
Before reviewing, ask: does this design rest on an assumption about what users want that hasn't been tested? If the design makes a strong structural bet — "stewards want fewer fields", "admins want a wizard flow", "analysts navigate top-down" — and there is no research evidence in Jira or Confluence to support it, say:
> *"This design assumes [X]. I can review whether it's executed correctly, but I can't validate whether it's solving the right problem. Consider running `/forge-design-researcher` to challenge that assumption before I annotate the execution."*
Then continue with the review.

---

## Step 0 — Pull structured context before touching Figma

Do this before opening the Figma file. Context makes feedback specific, not generic.

**0a. Jira ticket (via `atlassian` MCP)**
- If a Jira ticket is provided, call `getJiraIssue`: fetch description, acceptance criteria, linked issues, labels, sprint.
- If no ticket is given, call `searchJiraIssuesUsingJql` using the feature name from the Figma file title.
- Extract: what the feature must do, who the user is, explicit edge cases, requirements the design must satisfy.
- Read Jira comments and linked tickets — user complaints embedded in bug reports are research signals.
- If nothing matches, skip and continue.

**0b. Confluence design standards (via `atlassian` MCP)**
- Search: `text ~ "design" AND text ~ "[feature area]"` and `text ~ "component library" OR text ~ "design system" OR text ~ "UX guidelines"`.
- Read pages describing Reltio UX patterns, component library, and past design decisions for this feature area.
- Treat Confluence as authoritative: if it says "the hierarchy panel always shows a version badge", the design must too.

**0c. Live Reltio data model (via `reltio-on-reltio` MCP)**
- Call `get_reltio_entity_types` for all entity types in the tenant.
- For each entity type the design works with, call `get_reltio_entity_type_attributes`: name, type, cardinality, source constraints.
- If the design involves relations, call `get_reltio_relation_type_and_attributes`.
- This is the authoritative schema. A field shown in the design that doesn't exist in the schema = **C** issue. A mandatory or commonly-populated attribute missing from the design = **C** issue.

**0d. Component existence and state check (via `bitbucket` MCP)**
- Call `listRepositories` to find the Reltio UI/frontend repo (names containing "ui", "web", or "frontend").
- For each component the design relies on: search for its directory, props interface, or Storybook story file.
- Specifically check: does the existing component support the states the design requires? (e.g., does the Table component support row selection with a checkbox column? Does the Button support a loading state?)
- A component that exists but doesn't support the required state = **M** issue (dev must extend it; flag before sprint planning).
- A component the design relies on that doesn't exist at all = **C** issue.

---

## Step 1 — Read the Figma file

**1a. Get file structure**
- Fetch file metadata: pages, top-level frames, scope.
- If scope is unclear: *"Which page or flows should I focus the review on?"*

**1b. Read each frame in scope**
For each frame: get node tree (layers, components, text, layout), take a screenshot, note UI elements, labels, interactive components, navigation cues, and existing annotations.

**1c. Map the flows**
```
Flow: [Name]
Entry: [Frame / trigger]
Step 1 → Step 2 → Step 3 → [End state]
Decision points: [Branching]
Missing states: [States not designed — empty, error, loading, zero-data]
```

**When to stop and ask:** Stop only if proceeding would require an assumption that — if wrong — would invalidate the entire review output. One grouped question, then proceed. Never stop for anything you can infer from the design or Reltio docs.

---

## Step 2 — Complete Reltio context with public documentation

Fill in behavioral gaps not covered by the live schema.

**Always fetch:**
- `https://docs.reltio.com/` — navigate to the feature area; read how it behaves, its lifecycle states, user-facing workflows, and constraints not visible from the schema.
- `https://community.reltio.com/browse/community-blogs` — scan for posts about the feature area; note known pain points and workarounds real stewards have flagged.

**Feature-specific targets:**
- Hierarchy screens → Hierarchies docs (versions, lifecycle states, profiles count per node)
- Match / merge screens → Match Rules and Survivorship docs (confidence thresholds, rule mechanics, conflict resolution)
- Search / entity listing → Search and Profile docs
- Import / export → Data Operations docs
- Relations / connections → Relations docs

**Cross-reference:** Does the doc describe a lifecycle state the live schema also reflects that the design doesn't surface? Does it describe a workflow requiring attributes the design omits? Does the community flag a pain point this design ignores or solves?

**Goal:** By Step 3 you hold three truth layers — Jira requirements, live schema, public behavior docs — and can make feedback that is precise and grounded.

---

## Step 3 — Analyze the design

**Before analyzing**, confirm: Step 0 context pulled ✓ · Figma read and flows mapped ✓ · Reltio docs loaded ✓

---

### What counts as meaningful feedback

**Flag these:**
- Issues that cause a data steward to make a wrong decision, lose context, or leave the screen to find what they need
- Gaps between what the design shows and how Reltio's data model or feature actually works
- Missing states, flows, or affordances that block real MDM tasks
- Structural decisions (grouping, hierarchy, IA) that don't match how users think about the domain
- Components that don't exist in the Reltio codebase or don't support the required states

**Never flag these:**
- Font sizes, spacing, padding, color mismatches between components
- Component misuse (e.g., "FAB as button") unless it directly breaks a user task
- Pure developer or design system concerns with no user experience consequence
- Label naming nitpicks unless the name is genuinely misleading vs. Reltio's documented terminology

---

### Per-domain required-element checks

Run the appropriate checklist for the feature area before open-ended analysis.

**Match / merge resolution screens — always check for:**
- [ ] Match confidence score visible and labelled (not just a number — label it)
- [ ] Match rule name that triggered the pair (stewards judge confidence differently per rule)
- [ ] Source system badge per attribute value (which CRM/ERP the value came from)
- [ ] Survivorship indicator — which value wins and why, if a merge would happen
- [ ] Irreversibility warning before merge commit (merge is hard to undo — steward must know)
- [ ] Escalate / Skip action always available (stewards must never be forced to decide)
- [ ] Queue position context visible ("Pair 12 of 247") — stewards track their session progress

**Hierarchy screens — always check for:**
- [ ] Lifecycle state (Active / Draft / Historical) visible and actionable per node
- [ ] Version indicator — which version of the hierarchy is displayed
- [ ] Profile count per node (how many entities roll up to each level)
- [ ] Relationship type label (parent-child directionality visible)
- [ ] Breadcrumb or path context (stewards investigate, not browse — they need to know where they are)

**Entity profile / search screens — always check for:**
- [ ] Source system badges on attributes that have competing values
- [ ] Lifecycle state badge on the entity
- [ ] Last updated timestamp and by whom
- [ ] Relation count summary (how many relations does this entity have)
- [ ] Data quality score or completeness indicator if available in schema

**Import / export screens — always check for:**
- [ ] Job status visibility (running / completed / failed) with timestamp
- [ ] Error count and ability to download error report
- [ ] Import mode label (Partial / Full update — must be visible, not buried)
- [ ] Record counts (total / processed / succeeded / failed)
- [ ] Rollback or cancel action for running jobs

---

### Three review lenses — apply to every frame

**3a. Schema fidelity — does the design reflect how the feature actually works?**
- Compare visible fields against the live schema. Fields shown that don't exist = **C**. Mandatory/common attributes missing = **C**.
- Are lifecycle states and domain concepts shown and actionable where they matter?
- Are relation types represented with correct cardinality and directionality?
- Would a data steward understand the real state of their data from this screen?

**3b. Workflow fit — does the flow match actual MDM work?**
- Does the task sequence reflect how stewards work — search → find → act?
- Are there gaps where a user must go elsewhere to complete a task that should be doable here?
- Does the design handle high-volume, high-frequency use cases — not just the ideal path?
- Are missing states designed? (empty queue, failed import, zero search results, Draft entity with no active version)

**3c. Information architecture — does the IA serve the task?**
- Is the most important information for the task surfaced at the right level?
- Are there missing signals that would change a steward's decision (status, count, ownership, confidence)?
- Does progressive disclosure work — detail available when needed without cluttering the primary view?
- Does the screen give enough context for the next action (e.g., does a hierarchy view prepare the steward to act on a Draft)?

---

## Step 4 — Add annotation nodes directly on the Figma canvas

Do not use Figma comments. Create annotation nodes using Figma MCP tools.

**Quality filter — before writing any annotation:**
- Would a senior data steward or MDM admin care about this?
- Does fixing it change how someone does their job or the quality of their data decisions?
- Is it grounded in something specific to how Reltio works — not just a generic UX opinion?

If any answer is no, drop it. Every annotation that passes must be placed — do not cap the number.

---

**Page safety — always build on the current page, move at the end**

Never call `setCurrentPageAsync` mid-execution. Instead:
1. Build all annotation frames while on the currently active page
2. At the very end of the script, identify the target section or page and move all annotation frames in a single `targetPage.appendChild()` or `section.appendChild()` call
3. Set final x/y coordinates after the move, not before

This avoids cross-page clone failures and silent placement on the wrong page.

---

**Frame-by-frame execution — complete one frame before the next**

1. Read the frame's node tree to get all child node IDs and `absoluteBoundingBox` coordinates
2. Take a screenshot to visually confirm what's visible
3. Identify all issues passing the quality filter for this frame
4. Place all annotation nodes for this frame
5. Group into a single named group: `[Review] [Frame Name]`
6. Only then move to the next frame

Never batch annotations across frames.

---

**Structure: one group per frame**

Each frame gets its own group `[Review] [Frame Name]`. Self-contained — deleting it removes only that frame's annotations.

---

**Annotation placement — deterministic spatial priority**

For each annotation, try positions in this order:
1. **Right** of the target element — preferred if frame width allows 280px to the right
2. **Below** the target element — if right is blocked
3. **Left** of the target element — if below is blocked
4. **Above** the target element — last resort

Maintain a placed-annotations registry per frame (track `{x, y, width, height}` of each placed annotation). Before placing, check for overlap with all previously placed annotations in the frame. If overlap: offset downward by the overlapping annotation's height + 8px.

Convert to frame-relative coordinates before placing:
```js
const relX = element.absoluteBoundingBox.x - frame.absoluteBoundingBox.x;
const relY = element.absoluteBoundingBox.y - frame.absoluteBoundingBox.y;
frame.appendChild(annotationNode);
annotationNode.x = relX + offsetX; // apply spatial priority offset
annotationNode.y = relY + offsetY;
```

Never estimate positions. Always derive from `absoluteBoundingBox`.

---

**Annotation style**

Each annotation is a small frame containing:
- **Severity badge**: filled rectangle 16×16, letter `C` / `M` / `S`, white text 9px
- **Title**: plain text, 12px, weight 500, `#111111`, max 200px wide
- **Body**: plain text, 11px, weight 400, `#555555` — **100 words max across title + body**

Frame:
- Fill `#FFFFFF`, border `1px #E0E0E0`, corner radius 4, padding 8px
- Drop shadow: `0 1px 4px rgba(0,0,0,0.12)`
- Width: 260px, height calculated precisely (never auto-layout on the outer frame)

**Height calculation — prevents text cutoff:**
```js
targetPage.appendChild(titleTxt);
titleTxt.resize(214, 100); titleTxt.textAutoResize = 'HEIGHT';
const titleH = titleTxt.height;
titleTxt.remove();

targetPage.appendChild(bodyTxt);
bodyTxt.resize(244, 100); bodyTxt.textAutoResize = 'HEIGHT';
const bodyH = bodyTxt.height;
bodyTxt.remove();

const rowH = Math.max(16, titleH);
const totalH = 8 + rowH + 6 + bodyH + 8;
ann.resize(260, totalH);

badge.x = 8; badge.y = 8 + Math.floor((rowH - 16) / 2);
titleTxt.x = 30; titleTxt.y = 8 + Math.floor((rowH - titleH) / 2);
bodyTxt.x = 8; bodyTxt.y = 8 + rowH + 6;
```

---

**Annotation content**
```
[badge] Title — problem in under 8 words
Body: what's wrong and what to fix. Max 100 words total.
```
One problem, one fix per annotation. No bullet points. No bold inside body text.

---

**Severity — precise behavioral definitions**

| Badge | Color | Meaning |
|---|---|---|
| C | Red `#FF3B30` | The user **cannot complete the task correctly** without guessing or leaving the screen. Blocks task or fundamentally misrepresents how Reltio works. |
| M | Orange `#FF9500` | The user **can complete the task but will make worse decisions** because of this gap — missing context, wrong mental model, or missing state. |
| S | Blue `#007AFF` | The user **can work around it** but this creates unnecessary friction, cognitive load, or an opportunity for meaningful improvement. |

Never annotate anything that would be below S — skip it entirely.

---

## Step 5 — Report back in conversation

```
Design Review — [File / Flow Name]
Jira ticket:    [ID + title, or "not found"]
Frames reviewed: [List]
Annotations:    N total — C: N | M: N | S: N

Top issues:
  [Frame] — [Issue title] (C)
  [Frame] — [Issue title] (M)
  [Frame] — [Issue title] (M)

Schema gaps:
  [Fields shown in design that don't exist in the live schema]
  [Mandatory/commonly-populated attributes the design omits]

Requirements gaps:
  [Acceptance criteria from Jira not addressed in the design]

Domain gaps:
  [Places where the design doesn't reflect how Reltio's feature actually works]

Recommended next action:
  [The single highest-leverage change to make before this design moves forward]
```

Each frame has its own `[Review] [Frame Name]` group — delete it to remove that frame's annotations without affecting others.

---

## Component provenance report

When the designer asks *"what was used from the design system?", "what was built from scratch?", "what DS components did you use?"*:

```
Component provenance — [Screen / Feature]

DS components (present in design, matching DS)
| Component | DS name | Correctly used? |
|---|---|---|
| [e.g. Actions bar] | DS "Actions" | ✅ Yes / ⚠️ Modified / ❌ Misused |

Elements not backed by a DS component
| Element | Gap |
|---|---|
| [e.g. Step indicator] | No stepper in DS — custom pattern |
```

Delivered in chat only — never as a Figma annotation.

---

## Clarifying questions — when to ask

Stop and ask only if proceeding would require an assumption that — if wrong — would invalidate the entire review. Ask as one grouped message. Never ask about things inferable from the design or Reltio docs.

---

## Tips

- **Read the design before the docs.** Pull the right resources once you know what you're looking at.
- **Understand the feature before critiquing it.** A hierarchy in Reltio has versions, lifecycle states, and profile counts — feedback that ignores these is generic.
- **Data stewards are power users.** Don't flag things they can figure out. Flag things that are wrong or missing for their workflow.
- **Reltio is interconnected.** Does this screen give enough context for the next action?
- **Surface everything that passes the filter.** A thorough review with 12 real issues beats an artificially short one.
- **Never flag cosmetic issues.** Font sizes, spacing, color mismatches — design system concerns, not UX concerns.
- **Screenshots are ground truth.** Always take a screenshot before analyzing a frame.
