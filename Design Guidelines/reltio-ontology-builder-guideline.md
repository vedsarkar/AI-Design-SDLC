# Reltio Ontology Builder — Component Guideline

> **Purpose:** This document is the canonical component reference for the Reltio Ontology Builder. It is intended to be consumed by `forge-prototype-builder` (and other prototype/build tooling) so that generated prototypes match the production designs exactly — using the same components, styles, tokens, and interaction patterns rather than approximations.
>
> **How to use this document:**
> - Treat every component entry as ground truth. Do not improvise styling or behavior beyond what is captured here.
> - When a component is referenced in a design or prompt, look it up in the **Component Index** below and use the documented anatomy, variants, states, and tokens.
> - If a needed component is not yet documented, flag it explicitly rather than approximating.

---

## Document Conventions

Each component is documented using the following template:

```
### <Component Name>

**Purpose:** What the component is for and when to use it.

**Visual Structure / Anatomy:**
- Layout, regions, slots, container hierarchy

**Variants:**
- Variant name — description

**States:**
- Default / Hover / Active / Focus / Disabled / Loading / Error / Selected / etc.

**Tokens:**
- Spacing: padding, margin, gap
- Sizing: width, height, min/max
- Color: background, border, text, icon (token names where available)
- Typography: font family, size, weight, line-height
- Radius / elevation / shadow

**Usage Notes & Constraints:**
- Do's and don'ts
- Accessibility considerations
- Composition rules (what it can/can't be nested in)
```

---

## Global Background — REQUIRED on Every Prototype

> **Rule:** Every Reltio Ontology Builder prototype **must** render the "Wave BG" SVG as a fixed, full-bleed background layer behind all UI. Do not omit it. Do not recolor it. Do not crop it.

**Asset:** [`assets/wave-bg.svg`](./assets/wave-bg.svg)
**Source of truth:** Figma node `1916:136858` ("Wave BG") in file `cWxrUkt9juy9IExIBHW94n` — Reltio Ontology Builder.
**Native size:** 1728 × 1117 (cover-fit; `preserveAspectRatio="xMidYMid slice"`).
**Status:** The current SVG in `assets/` is a high-fidelity approximation generated from the Figma screenshot. Replace it with the authoritative Figma export when available — the file path stays the same so no prototype code needs to change.

### Visual character
A soft, heavily-blurred horizontal wave anchored to the lower-right of the canvas. Palette runs cool purple → warm gold → pale blue → faint mint, washed over a near-white lavender base (`#F4F2FB`). Top-left of the canvas reads as nearly empty, giving content room to breathe.

### Implementation (HTML)

Place the SVG as a fixed background layer that sits behind all app chrome. The wave should always cover the full viewport, never tile, and never scroll with content.

```html
<body>
  <div class="app-bg" aria-hidden="true">
    <img src="./assets/wave-bg.svg" alt="" />
  </div>
  <!-- app shell / pages render above -->
</body>
```

```css
.app-bg {
  position: fixed;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  overflow: hidden;
  background: #F4F2FB; /* fallback base wash */
}
.app-bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  display: block;
}
/* All app content must establish its own stacking context above .app-bg */
.app-shell, main, .surface { position: relative; z-index: 1; }
```

### Constraints
- Background must remain fixed during scroll (`position: fixed`) so the wave does not move with content.
- Surfaces placed on top (cards, panels, modals) should be opaque or use a high-opacity translucent fill so legibility is preserved against the colored wave region.
- Do not apply additional filters (blur, hue-rotate, brightness) to the asset.
- Do not use the wave as a decorative element inside a card or panel — it is a global canvas only.
- The asset is decorative; expose it to assistive tech as `aria-hidden="true"` and use empty `alt=""`.

---

## Brand Assets

### Reltio Ontology Builder — Logo

**Figma Source:** File `cWxrUkt9juy9IExIBHW94n`, node `1919-138074`
**Figma URL:** https://www.figma.com/design/cWxrUkt9juy9IExIBHW94n/Reltio-Ontology-Builder?node-id=1919-138074
**Local asset path:** `assets/reltio-ontology-logo.svg` _(awaiting export — see note below)_

**Usage rules:**
- Use this logo as the primary product identifier in the top navigation bar / app header.
- Do not recolor, stretch, crop, or add effects to the logo.
- Always render on a background that provides sufficient contrast.
- Minimum clear-space: equal to the cap-height of the wordmark on all four sides.
- Do not place the logo over the wave BG's high-chroma color region (lower-right); prefer placing it in the near-white upper-left region or on an opaque surface.

**Implementation:**
```html
<img src="./assets/reltio-ontology-logo.svg" alt="Reltio Ontology Builder" class="app-logo" />
```

> ⚠️ **Asset pending:** The Chrome extension was not connected when this was logged. Export the logo from Figma node `1919-138074` as SVG (or PNG @2×) and save it to `assets/reltio-ontology-logo.svg` in the guideline folder. Once the file is in place, prototypes can reference `./assets/reltio-ontology-logo.svg` directly.

---

## Design Tokens (Global)

> _To be populated as global tokens (color palette, type scale, spacing scale, radii, elevation, motion) are shared._

### Color

| Token Name | Hex Value | Usage |
|------------|-----------|-------|
| `Brand/Reltio Aqua` | `#00ffff` | Primary accent — logo text, icon fills, CTA button backgrounds |
| `Brand/Reltio Blue` | `#000066` | Primary background — header bar, deep navy surfaces |
| `Fonts & Icons/Default` | `#0e0e25` | Default text and icon color on light/cyan surfaces |
| `Background/Forced White` | `#ffffff` | Forced white backgrounds |
| `Outline-Border/Transparent grey Strong` | `#a9a9d680` | Strong border/outline (50% opacity grey-blue) |
| `Outline-Border/Transparent grey light` | `#a9a9d64d` | Light border/outline (30% opacity grey-blue) |
| `Blue` | `#0000cc` | Interactive accent — count numbers, selected tab text |
| `Primary/Selected` | `#0000cc24` | Selected tab background (transparent blue tint) |
| `Fonts & Icons/Descriptions` | `#56568f` | Muted/secondary text and icons |
| `Fonts & Icons/Placeholder` | `#7070a9` | Input placeholder text |
| `Fonts & Icons/disabled` | `#babade` | Disabled text and icons |
| `Background/Surface 1` | `#ffffff` | Primary white surface |
| `Background/Base Section` | `#f5f5fa` | Light lavender-grey section background |
| `Background/Transparent surface 1` | `#4343701a` | Transparent overlay tint |
| `Background/Transparent White Strong` | `#ffffffb2` | Semi-transparent white (search bar, glass surfaces) |
| `Outline-Border/Surface Border 2` | `#e3e3f2` | Subtle component borders and dividers |
| `Outline-Border/Surface Border 3` | `#babade` | Stronger/disabled borders |
| `Shadow/Elevation 2` | `#43437026` | Drop shadow color |
| `Shadow/Dark` | `#43437080` | Strong drop shadow (popovers) |
| `Background/Surface 2` | `#f5f5fa` | Icon container backgrounds, hover rows |
| `Background/Surface 3` | `#e3e3f2` | Dividers, selected row background |
| `Background/Surface 4` | `#ffffff` | Popover / card surfaces |
| `Success/Transparent` | `#44997724` | High match badge background (≥80%) |
| `Green/Transparent Mild` | `#4499771a` | Green tint (mild) |
| `Green/Hover` | `#1f4737` | Green hover text |
| `Warning/Transparent` | `#ffcc0024` | Medium match badge background (40–79%) |
| `Warning Gold/Transparent Mild` | `#ffcc001a` | Warning tint (mild) |
| `Warning Gold/Hover` | `#9e4f00` | Amber/warning text on light background |
| `Error/Transparent` | `#ee333324` | Low match badge background (<40%) |
| `Error Reds/Transparent Mild` | `#ee33331a` | Error tint (mild) |
| `Error Reds/Border` | `#8e0b0b` | Red/error text on light background |
| `Fonts & Icons/Forced White` | `#ffffff` | White text/icons forced on dark surfaces (e.g. ghost button on navy) |
| `Fonts/Forced White 2` | `#ffffff` | Alias for forced white — same value, used for specific text layers |

### Typography

| Token Name | Value |
|------------|-------|
| `_font/family/body` | `Roboto` |
| `_font/weight/Medium` | `500` (Medium) |
| `font/size/24` | `24px` |
| `Numbers/16` | `16px` |
| `Typography/Headings/h6` | Roboto, Medium (500), 16px, lineHeight 24px, letterSpacing 0.15px |
| `Typography/Body/label` | Roboto, Medium (500), 14px, lineHeight 20px, letterSpacing 0.15px |
| `Typography/Body/body` | Roboto, Regular (400), 14px, lineHeight 20px, letterSpacing 0.17px |
| `Typography/Captions/helper-regular` | Roboto, Regular (400), 12px, lineHeight 16px, letterSpacing 0 |

### Spacing Scale

| Token Name | Value |
|------------|-------|
| `space_padding/2` | `2px` |
| `space_padding/4` | `4px` |
| `space_padding/6` | `6px` |
| `space_padding/8` | `8px` |
| `space_padding/12` | `12px` |
| `space_padding/16` | `16px` |
| `space_padding/20` | `20px` |
| `space_padding/24` | `24px` |

### Radius & Elevation

| Token Name | Value |
|------------|-------|
| `radius/4` | `4px` |
| `radius/8` | `8px` |
| `radius/12` | `12px` |
| `radius/16` | `16px` |
| `radius/20` | `20px` |
| `border/xs (half)` | `0.5px` | Hairline dividers |
| `radius/max` | `9999px` (pill shape) |
| `borderRadius` | `4px` |
| `Bg Blur/Strong` | `backdrop-filter: blur(72px)` |
| `Bg Blur/Extreme` | `backdrop-filter: blur(100px)` |
| `Shadows/Forms` | Drop shadow `#43437026` (0,1px,2px) + (0,1px,6px,−2px) |
| `Shadows/Inner Shadow` | Inner shadow `#4343701a` (0,0,14px) |
| `Shadows/Popovers` | Drop shadow `#43437080` (0,24px,48px,−16px) + Drop shadow `#43437026` (0,−2px,20px,−10px) |

### Iconography
_TBD — awaiting icon set / sizing rules._

### Motion
_TBD — awaiting motion tokens._

---

## Assets

### Reltio Ontology Logo

**Figma source:** Node `1919:138074` — file `cWxrUkt9juy9IExIBHW94n` (Reltio Ontology Builder)
**Asset file:** `assets/Reltio_Ontology_logo.svg` _(export from Figma node above)_

**Visual description:**
A two-part lockup rendered on a transparent background:
1. A vertical divider bar `|` in cyan
2. The wordmark **"Ontology Builder"** in the same bright cyan/teal color

**Color:** Bright cyan — `#00E5FF` or closest brand token (verify against Figma variable definitions)
**Usage rules:**
- Always use on the dark navy/translucent header bar — never on a white or light background without a dark backdrop
- Do not recolor, stretch, or apply opacity to the logo
- Maintain clear space of at least `16px` on all sides
- Use as-is from the SVG export; do not recreate in CSS text

**Placement:** Top-left of the app header (see [Header component](#header))

---

## Component Index

> _Components will be listed here as they are added, with a link to their entry below._

1. [Header — No Schema State / Schema Loaded State](#1-header--no-schema-state)
2. [Subheader](#2-subheader)
3. [Domain Selector Dropdown](#3-domain-selector-dropdown)

---

## Components

> _Each component will be appended below in the order received, using the template above._

<!-- COMPONENTS:START -->

---

### 1. Header — No Schema State

**Figma source:** Node `715:52779` — named `"Header"` in file `cWxrUkt9juy9IExIBHW94n`
**User label:** "Sub Header — used when no schema is uploaded"
**Context:** This is the application header rendered in its empty/pre-upload state — before any ontology schema has been loaded into the builder.

---

**Purpose:**
Provides the top-level navigation shell for the Ontology Builder when no schema is present. Anchors the product identity (logo) on the left and surfaces the primary action — uploading a schema — on the right.

---

**Visual Structure / Anatomy:**

```
┌─────────────────────────────────────────────────────────────────────┐
│  [RELTIO | Ontology Builder logo]          [⬆ Upload Schema button] │
└─────────────────────────────────────────────────────────────────────┘
```

| Region | Content | Alignment |
|--------|---------|-----------|
| Left slot | Reltio Ontology Builder logo lockup | Left-aligned, vertically centered |
| Right slot | "Upload Schema" CTA button | Right-aligned, vertically centered |
| Center | Empty / no navigation items | — |

---

**Dimensions:**
- Width: `1440px` (full-bleed, scales to viewport width)
- Height: `77px`

---

**Variants / States:**

| Variant | Figma Node | Description |
|---------|------------|-------------|
| **No Schema** | `715:52779` | Default empty state — logo left, single "Upload Schema" CTA right |
| **Schema Loaded** | `1937:139469` | Schema is active — logo left, "Clear Schema" + "Download Schema" buttons right |

---

**Tokens:**

| Property | Token | Value |
|----------|-------|-------|
| Background | `Brand/Reltio Blue` | `#000066` |
| Height | — | `77px` |
| Width | — | `100%` (full viewport) |
| Horizontal padding | `space_padding/20` | `20px` |
| Vertical alignment | — | `align-items: center` |
| Logo / accent color | `Brand/Reltio Aqua` | `#00ffff` |
| Backdrop blur | `Bg Blur/Strong` | `backdrop-filter: blur(72px)` |

---

**Upload Schema Button (right slot):**

| Property | Token | Value |
|----------|-------|-------|
| Label | — | "Upload Schema" |
| Icon | — | Cloud upload icon — left of label |
| Background | `Brand/Reltio Aqua` | `#00ffff` |
| Text color | `Fonts & Icons/Default` | `#0e0e25` |
| Border | `Outline-Border/Transparent grey Strong` | `#a9a9d680` |
| Border radius | `radius/12` | `12px` |
| Padding (vertical) | `space_padding/8` | `8px` |
| Padding (horizontal) | `space_padding/16` | `16px` |
| Font family | `_font/family/body` | `Roboto` |
| Font size | `Numbers/16` | `16px` |
| Font weight | `_font/weight/Medium` | `500` |
| Line height | `font/size/24` | `24px` |
| Letter spacing | `Typography/Headings/h6` | `0.15px` |
| State: Hover | — | TBD — confirm in Figma |
| State: Active | — | TBD — confirm in Figma |
| State: Disabled | — | N/A — always enabled in No Schema state |

---

---

**Right Slot — Schema Loaded Variant (`1937:139469`):**

When a schema is active, the right slot replaces "Upload Schema" with two side-by-side buttons:

```
[ ✕ Clear Schema ]   [ ⬇ Download Schema ]
   ghost/outline         filled cyan
```

**Clear Schema button (ghost/outline):**

| Property | Token | Value |
|----------|-------|-------|
| Label | — | "Clear Schema" |
| Icon | — | ✕ close icon — left of label |
| Background | — | Transparent |
| Text color | `Fonts & Icons/Forced White` | `#ffffff` |
| Border | `Outline-Border/Transparent grey Strong` | `#a9a9d680` |
| Border radius | `radius/12` | `12px` |
| Padding (vertical) | `space_padding/8` | `8px` |
| Padding (horizontal) | `space_padding/16` | `16px` |
| Font | `Typography/Headings/h6` | Roboto Medium 500, 16px, lh 24px |
| State: Hover | — | TBD — confirm in Figma |
| State: Active | — | TBD — confirm in Figma |

**Download Schema button (filled):**

| Property | Token | Value |
|----------|-------|-------|
| Label | — | "Download Schema" |
| Icon | — | Download/arrow-down icon — left of label |
| Background | `Brand/Reltio Aqua` | `#00ffff` |
| Text color | `Fonts & Icons/Default` | `#0e0e25` |
| Border | `Outline-Border/Transparent grey Strong` | `#a9a9d680` |
| Border radius | `radius/12` | `12px` |
| Padding (vertical) | `space_padding/8` | `8px` |
| Padding (horizontal) | `space_padding/16` | `16px` |
| Font | `Typography/Headings/h6` | Roboto Medium 500, 16px, lh 24px |
| Gap between buttons | `space_padding/8` | `8px` |
| State: Hover | — | TBD — confirm in Figma |
| State: Active | — | TBD — confirm in Figma |

---

**Usage Notes & Constraints:**
- The logo left slot is **identical across both header variants** — never alter it based on schema state.
- In the **No Schema** state: only "Upload Schema" (filled cyan) appears in the right slot.
- In the **Schema Loaded** state: "Clear Schema" (ghost) + "Download Schema" (filled cyan) appear side-by-side — in that order, left to right.
- Do not show both states simultaneously.
- Logo must use the `Reltio_Ontology_logo` asset (see [Assets](#assets)) — do not recreate in CSS text.
- Header sits at `z-index` above the Wave BG layer but below modals and overlays.
- Header background is opaque — it fully covers the wave background behind it.
- On viewports narrower than `1440px`, the header stretches to fill width; internal padding compresses before truncating content.

---

**Accessibility:**
- Header landmark: wrap in `<header role="banner">`
- Logo: `<img alt="Reltio Ontology Builder" />`
- All buttons: `<button>` with visible label — no icon-only fallback needed
- "Clear Schema" is a destructive action — consider `aria-label="Clear uploaded schema"` for extra context
- Ensure cyan buttons meet `4.5:1` contrast ratio; ghost button white text meets contrast against `#000066` background

---

---

### 2. Subheader

**Figma source:** Node `715:52782` — named `"Subheader"` in file `cWxrUkt9juy9IExIBHW94n`
**User label:** "Sub Header — shown when a schema is loaded"
**Context:** Sits directly below the Header bar. Provides schema-level identity (domain name + description), view-mode switching (Label / Diagram), entity-type counts, and a search field.

---

**Purpose:**
The Subheader contextualises the currently loaded ontology schema. It gives the user:
1. The active **domain name** with a dropdown to switch domains
2. A short **description** of the domain
3. **View mode toggles** (Label / Diagram) to switch the canvas rendering
4. At-a-glance **entity count stats** across all types
5. A **search input** to filter entities on canvas

---

**Visual Structure / Anatomy:**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  [🏢] B2C Data Domain ▼                          [≡ Label]  [⊞ Diagram]    │  ← Top row
│       Reltio Data Cloud customized for the consumer data industry           │
├─────────────────────────────────────────────────────────────────────────────┤  ← Divider
│  Entities: 3 | Relationship: 3 | Interactions: 12 | Reference Data: 12 |  Sources: 8       [🔍 Search]  │  ← Bottom row
└─────────────────────────────────────────────────────────────────────────────┘
```

| Region | Content | Alignment |
|--------|---------|-----------|
| Top-left | Domain icon + Domain name + dropdown chevron | Left, vertically centered |
| Top-left sub | Domain description (caption) | Below domain name |
| Top-right | Label / Diagram toggle tabs | Right, vertically centered |
| Divider | Full-width horizontal rule | — |
| Bottom-left | Entity type count stats | Left, vertically centered |
| Bottom-right | Search input field | Right, vertically centered |

---

**Dimensions:**
- Width: `1440px` (full-bleed)
- Height: `124px` total
- Top row: ~`64px`
- Bottom row: ~`60px`

---

**Variants / States:**

| Variant | Description |
|---------|-------------|
| **Label view (default)** | "Label" tab is selected; canvas shows label-mode diagram |
| **Diagram view** | "Diagram" tab is selected; canvas switches to diagram mode |

---

**Tokens — Container:**

| Property | Token | Value |
|----------|-------|-------|
| Background | `Background/Surface 1` | `#ffffff` |
| Bottom section background | `Background/Base Section` | `#f5f5fa` |
| Divider border color | `Outline-Border/Surface Border 2` | `#e3e3f2` |
| Horizontal padding | `space_padding/24` | `24px` |
| Top row vertical padding | `space_padding/12` | `12px` |
| Bottom row vertical padding | `space_padding/8` | `8px` |
| Backdrop blur (if glassmorphism) | `Bg Blur/Extreme` | `backdrop-filter: blur(100px)` |

---

**Domain Identity (top-left) — Clickable Trigger:**

> **Interaction:** The entire domain identity region (icon + name + chevron + description) is a single clickable trigger. Clicking it opens the [Domain Selector Dropdown](#3-domain-selector-dropdown) anchored below-left of the trigger.

| Property | Token | Value |
|----------|-------|-------|
| Icon container | `Background/Surface 2` | `#f5f5fa` circle, ~`40×40px` |
| Icon | — | Building/domain icon, ~`20×20px` |
| Icon color | `Fonts & Icons/Descriptions` | `#56568f` |
| Domain name font | `Typography/Headings/h6` | Roboto Medium 500, 16px, lh 24px, ls 0.15px |
| Domain name color | `Fonts & Icons/Default` | `#0e0e25` |
| Dropdown chevron | — | ▼ inline after name; same color as name |
| Gap: icon → name | `space_padding/8` | `8px` |
| Description font | `Typography/Captions/helper-regular` | Roboto Regular 400, 12px, lh 16px, ls 0 |
| Description color | `Fonts & Icons/Descriptions` | `#56568f` |
| Gap: name → description | `space_padding/2` | `2px` |
| State: Hover | — | Subtle background tint on trigger region (TBD) |
| State: Open | — | Chevron rotates 180°; dropdown appears below |
| Cursor | — | `pointer` |

---

**Label / Diagram Toggle — "M2R Tab Group" (Figma node `1940:267028`, 193×40px):**

| Property | Token | Value |
|----------|-------|-------|
| **Outer container background** | `Background/Surface 1` | `#ffffff` |
| **Outer container radius** | `radius/12` | `12px` |
| **Outer container padding** | `space_padding/4` | `4px` (inner padding around tabs) |
| **Outer shadow** | `Shadows/Forms` | Drop shadow `#43437026` (0,1px,2px) + (0,1px,6px,−2px) |
| **Outer inner shadow** | `Shadows/Inner Shadow` | Inner shadow `#4343701a` (0,0,14px) |
| Tab font | `Typography/Body/label` | Roboto Medium 500, 14px, lh 20px, ls 0.15px |
| Tab text color (unselected) | `Fonts & Icons/Descriptions` | `#56568f` |
| Tab text color (selected) | `Blue` | `#0000cc` |
| Tab background (unselected) | — | Transparent |
| Tab background (selected) | `Background/Base Section` | `#f5f5fa` |
| Tab border radius | `radius/8` | `8px` |
| Tab padding (vertical) | `space_padding/6` | `6px` |
| Tab padding (horizontal) | `space_padding/12` | `12px` |
| Icon → label gap | `space_padding/4` | `4px` |
| Label tab icon | — | Horizontal lines (list `≡`) |
| Diagram tab icon | — | Dot grid (3×3 dots) |
| State: Hover | — | `Background/Surface 2` bg + `Fonts & Icons/Default` text |

---

**Entity Count Stats (bottom-left):**

| Property | Token | Value |
|----------|-------|-------|
| Label font | `Typography/Body/body` | Roboto Regular 400, 14px, lh 20px, ls 0.17px |
| Label color | `Fonts & Icons/Default` | `#0e0e25` |
| Count font | `Typography/Body/label` | Roboto Medium 500, 14px, lh 20px, ls 0.15px |
| Count color | `Blue` | `#0000cc` |
| Separator `\|` color | `Outline-Border/Surface Border 2` | `#e3e3f2` |
| Gap between stat items | `space_padding/8` | `8px` |
| Stat types shown | — | Entities · Relationship · Interactions · Reference Data · Sources |

---

**Search Input (bottom-right):**

| Property | Token | Value |
|----------|-------|-------|
| Background | `Background/Transparent White Strong` | `#ffffffb2` |
| Border | `Outline-Border/Surface Border 2` | `#e3e3f2` |
| Border radius | `radius/max` | `9999px` (pill) |
| Box shadow | `Shadows/Forms` | Drop shadow `#43437026` (0,1,2) + (0,1,6,−2) |
| Inner shadow | `Shadows/Inner Shadow` | Inner shadow `#4343701a` (0,0,14) |
| Placeholder text | `Typography/Body/body` | Roboto Regular 400, 14px |
| Placeholder color | `Fonts & Icons/Placeholder` | `#7070a9` |
| Search icon color | `Fonts & Icons/Descriptions` | `#56568f` |
| Padding (vertical) | `space_padding/8` | `8px` |
| Padding (horizontal) | `space_padding/16` | `16px` |
| State: Focus | — | TBD — confirm in Figma |

---

**Usage Notes & Constraints:**
- This component is **only shown when a schema is loaded** — it never appears in the No Schema state (Header only).
- The domain name dropdown allows switching between ontology domains — clicking it should open a selection list (separate component, TBD).
- Label and Diagram are **mutually exclusive** toggles — only one can be active at a time. Use `aria-pressed` on each button.
- Entity count stats are **read-only** — they are not interactive links unless specified later.
- The search field filters the canvas in real time — it should debounce input (~300ms).
- Do not reduce the height below `124px` — both rows must always be fully visible.
- Subheader sits directly below Header (`z-index` same layer), above the Wave BG and canvas.

---

**Accessibility:**
- Domain name + dropdown: `<button aria-haspopup="listbox">B2C Data Domain</button>`
- Toggle tabs: `<button role="tab" aria-selected="true/false">Label</button>` inside a `role="tablist"`
- Entity counts: wrapped in `<dl>` (description list) with `<dt>` for label, `<dd>` for count
- Search: `<input type="search" aria-label="Search entities" placeholder="Search" />`

---

---

### 3. Domain Selector Dropdown

**Figma sources:**
- **No Schema variant:** Node `868:164927` — `"Header Dropdown_new"` (pre-upload)
- **Schema Loaded variant:** Node `1084:184134` — `"Header Dropdown_new"` (post-upload)

**Trigger:** Clicking the domain identity region (icon + name + chevron) in the [Subheader](#2-subheader)

---

**Purpose:**
A floating popover list for switching between available ontology domains. Each item shows the domain icon, name, and description. After a schema is uploaded, each item additionally shows a colour-coded match percentage indicating relevance to the uploaded schema.

---

**Variants:**

| Variant | Figma Node | When shown | Key difference |
|---------|------------|------------|----------------|
| **No Schema** | `868:164927` | Before any schema is uploaded | No match badges — right side of each row is empty |
| **Schema Loaded** | `1084:184134` | After a schema has been uploaded | Match percentage badge appears right-aligned on each row |

---

**Visual Structure / Anatomy:**

_No Schema variant (868:164927) — no badges:_
```
┌──────────────────────────────────────────┐
│  [icon]  B2C Data Domains                │
│           Reltio Data Cloud customized…  │
├──────────────────────────────────────────┤
│  [icon]  Financial Services              │
│           Reltio Data Cloud customized…  │
├──────────────────────────────────────────┤
│  [icon]  Healthcare                      │
│           Reltio Data Cloud customized…  │
└──────────────────────────────────────────┘
```

_Schema Loaded variant (1084:184134) — with match badges:_
```
┌──────────────────────────────────────────────────┐
│  [icon]  B2C Data Domains        [ 92% match ]   │
│           Reltio Data Cloud customized…           │
├──────────────────────────────────────────────────┤
│  [icon]  Financial Services      [ 82% match ]   │
│           Reltio Data Cloud customized…           │
├──────────────────────────────────────────────────┤
│  [icon]  Healthcare              [ 49% match ]   │
│           Reltio Data Cloud customized…           │
└──────────────────────────────────────────────────┘
```

---

**Dimensions:**

| Variant | Width | Height |
|---------|-------|--------|
| No Schema | `440px` | `396px` |
| Schema Loaded | `440px` | `492px` (taller — badge layout adds row height) |

Positioned: anchored `20–24px` from left of viewport, directly below the Subheader domain trigger. Scrollable if items exceed container height.

---

**Tokens — Container (both variants):**

| Property | Token | Value |
|----------|-------|-------|
| Background | `Background/Surface 1` | `#ffffff` |
| Border radius | `radius/16` | `16px` |
| Shadow | `Shadows/Popovers` | Drop shadow `#43437080` (0, 24px, 48px, −16px) + Drop shadow `#43437026` (0, −2px, 20px, −10px) |
| Item divider color | `Background/Surface 3` | `#e3e3f2` |
| Item divider thickness | `border/xs (half)` | `0.5px` |
| Item padding (vertical) | `space_padding/12` | `12px` |
| Item padding (horizontal) | `space_padding/12` | `12px` |
| Gap: icon → text block | `space_padding/8` | `8px` |

---

**Domain List Item (both variants):**

| Property | Token | Value |
|----------|-------|-------|
| Icon container shape | `radius/max` | `9999px` (circle) |
| Icon container background | `Background/Surface 2` | `#f5f5fa` |
| Icon container size | — | ~`40×40px` |
| Domain name font | `Typography/Body/body` | Roboto Regular 400, 14px, lh 20px, ls 0.17px |
| Domain name color | `Fonts & Icons/Default` | `#0e0e25` |
| Description font | `Typography/Captions/helper-regular` | Roboto Regular 400, 12px, lh 16px, ls 0 |
| Description color | `Fonts & Icons/Descriptions` | `#56568f` |
| Gap: name → description | `space_padding/2` | `2px` |
| State: Hover | `Background/Surface 2` | `#f5f5fa` full-width row background |
| State: Selected/Active | `Background/Surface 3` | `#e3e3f2` full-width row background |
| Cursor | — | `pointer` |

---

**Match Percentage Badge (Schema Loaded variant only):**

> **Not rendered in the No Schema variant.** The right side of each row is completely empty before a schema is uploaded — do not show placeholder dashes or empty badge shells.

Badge is a pill (`radius/max`) coloured by match score threshold:

| Score Range | Background Token | Background Hex | Text Token | Text Hex |
|-------------|-----------------|----------------|------------|----------|
| ≥ 80% | `Success/Transparent` | `#44997724` | — | Dark green |
| 40–79% | `Warning/Transparent` | `#ffcc0024` | `Warning Gold/Hover` | `#9e4f00` |
| < 40% | `Error/Transparent` | `#ee333324` | `Error Reds/Border` | `#8e0b0b` |

| Property | Token | Value |
|----------|-------|-------|
| Shape | `radius/max` | `9999px` (pill) |
| Font | `Typography/Captions/helper-regular` | Roboto Regular 400, 12px, lh 16px |
| Padding (vertical) | `space_padding/2` | `2px` |
| Padding (horizontal) | `space_padding/8` | `8px` |
| Label format | — | `"XX% match"` — always include the word "match" |

---

**Behaviour & Interaction:**
- Opens on click of the domain identity trigger; closes on outside click or `Escape`
- Selecting a domain closes the dropdown and updates the Subheader (name, description, entity counts)
- Match percentages are dynamic — driven by backend relevance scoring against the uploaded schema, never hardcoded
- The currently active domain shows the selected row state (`Background/Surface 3`)
- Scroll enabled if domain list exceeds container height

---

**Usage Notes & Constraints:**
- Render as a floating popover (`position: absolute` or `fixed`) — never inline
- `Shadows/Popovers` provides elevation — do not add extra borders to the container
- Minimum width: `440px` — do not shrink on narrow viewports
- Domain icons are unique per domain type — do not reuse the same icon across domains
- Badge thresholds are fixed: ≥80% green / 40–79% amber / <40% red — do not invent intermediate colours
- **Never show match badges before a schema is uploaded** — their absence is meaningful

---

**Accessibility:**
- Trigger button: `aria-haspopup="listbox"` + `aria-expanded="true/false"`
- Dropdown: `role="listbox"`
- Each item: `role="option"` + `aria-selected="true/false"`
- Close on `Escape`; trap focus within the open dropdown
- Match badge: expose full text `"XX% match"` to screen readers — never colour-only signalling

---

<!-- COMPONENTS:END -->

---


---

### Table — Section Header

**Purpose:** Groups a set of entity type rows under a collapsible section. Communicates the entity type name, total item count, and provides a collapse/expand affordance. Always the first row inside a schema table section.

**Figma source:** Node `1948:142104` ("Section Header") in file `cWxrUkt9juy9IExIBHW94n`

**Visual Structure / Anatomy:**
```
┌─────────────────────────────────────────────────────────────────────────┐
│  [entity-icon]  Entity Type  │  3 items                       [▲ arrow] │  48px
└─────────────────────────────────────────────────────────────────────────┘
```
- **Left group** (flex row, gap 8px, padding-left 16px): entity type icon (20×20) + entity type name + **vertical divider** (1px × 24px, `#E3E3F2`, 2px top/bottom padding) + item count ("N items")
- **Right**: collapse/expand arrow icon (24×24 PNG, `keyboard arrow - up.png`), padding-right 28px
- **Bottom border**: 1px solid `Outline-Border/Surface Border 2` (`#e3e3f2`)
- Full width (100%), height 48px

**Variants:**
- Expanded (default) — arrow points up, content rows visible below
- Collapsed — arrow rotates 180° (points down), content rows hidden

**States:**
- Default — white background (`Background/Surface 1`)
- Hover — subtle highlight; cursor pointer on the collapse arrow
- Collapsed — `aria-expanded="false"` on the toggle button

**Tokens:**

| Property | Token | Value |
|----------|-------|-------|
| Height | — | `48px` |
| Background | `Background/Surface 1` | `#ffffff` |
| Padding left | `space_padding/16` | `16px` |
| Padding right | `space_padding/28` | `28px` |
| Gap (icon→name→count) | `space_padding/8` | `8px` |
| Entity name font | `Typography/Headings/h6` | Roboto Medium 16px, lh 24px, ls 0.15px |
| Entity name color | `Fonts & Icons/Default` | `#0e0e25` |
| Divider | `Outline-Border/Surface Border 2` | `1px × 24px`, color `#E3E3F2`, 2px padding top/bottom |
| Count font | `Typography/Body/body` | Roboto Regular 14px, lh 20px, ls 0.17px |
| Count color | — | `#7070A9` |
| Bottom border | `Outline-Border/Surface Border 2` | `1px solid #e3e3f2` |
| Icon size | — | `20×20px` |
| Arrow size | — | `24×24px` |

**Icon assets:**
- Entity type icon: `icons/entity type/IDN.png` (20×20) — use the matching domain icon per entity type
- Collapse arrow: `icons/keyboard arrow - up.png` (24×24) — rotate 180° when collapsed via CSS `transform: rotate(180deg)`

**Interaction:**
- Click anywhere on the section header row (or just the arrow) toggles collapsed/expanded
- Transition: `transform 0.2s ease` on the arrow rotation; rows fade/slide out below
- Collapsed state hides the column sub-header row and all data rows for that section

**Usage Notes & Constraints:**
- Never omit the item count — "N items" must always reflect the actual row count in the section
- Entity icon must match the entity type displayed — do not reuse a generic icon
- Use one Section Header per entity type group in the table

**Accessibility:**
- Arrow button: `aria-expanded="true/false"`, `aria-controls="section-{id}-rows"`
- Section: `role="rowgroup"` on the containing wrapper
- Count text: readable as-is; no special ARIA needed

---

### Table — Column Sub-header Row

**Purpose:** Labels the data columns within an entity type section. Appears immediately below the Section Header and above the first data row. Uses "mini-header" typography with strong letter-spacing to visually separate it from data rows.

**Figma source:** Node `1948:142105` ("Frame 2147238882") — child frame of `1948:142160`

**Visual Structure / Anatomy:**
```
┌────────────────────────────────────────────────────────── ─────────────────┐
│  NAME                                                           ATTRIBUTES │  40px
└─────────────────────────────────────────────────────────────────────────────┘
```
- **NAME cell** (~78% width, 796/1024px): left-aligned text, padding-left 16px
- **ATTRIBUTES cell** (~22% width, 228/1024px): right-aligned text, padding-right 28px
- Both cells use `Typography/Captions/mini-header` typography

**Variants:**
- Standard (this component has no additional variants — always the same two-column layout)

**States:**
- Static — no hover, active, or focus states

**Tokens:**

| Property | Token | Value |
|----------|-------|-------|
| Height | — | `40px` |
| Background | `Background/Surface 2` | `#f5f5fa` |
| Font | `Typography/Captions/mini-header` | Roboto Medium 12px, lh 16px, ls 0.60px |
| Color | `Fonts & Icons/Descriptions` | `#56568f` |
| NAME padding-left | `space_padding/16` | `16px` |
| ATTRIBUTES padding-right | `space_padding/28` | `28px` |
| Bottom border | `Outline-Border/Surface Border 2` | `1px solid #e3e3f2` |
| NAME column width | — | `~78%` (flex 1) |
| ATTRIBUTES column width | — | `~22%` (fixed or flex-shrink: 0) |

**Text:**
- Column labels are always UPPERCASE — apply `text-transform: uppercase` in CSS, never hardcode uppercase text
- Labels must exactly match the data below: `NAME` maps to the entity name field, `ATTRIBUTES` maps to the attribute count/list

**Usage Notes & Constraints:**
- Always rendered inside a collapsed/expanded section — never free-floating
- Must be hidden when the Section Header is in collapsed state
- Do not add additional column headers beyond NAME and ATTRIBUTES without a design change
- Letter-spacing of 0.60px is intentional — do not alter it

**Accessibility:**
- Render column labels as `<th scope="col">` inside a `<thead>` if using semantic table markup
- Or as `role="columnheader"` if using div-based layout


---

### Table — Name Column Row Cell

**Figma node:** `1949:142175`

**Purpose:** Represents a single entity type row in the ontology table. The name cell is the primary identifier, combining a colored avatar, entity name, and a short description. The attributes column shows a numeric count right-aligned.

**Anatomy:**

```
[ Row — 44px min-height, white bg, 1px border-bottom #E3E3F2 ]
  [ Name Cell — flex:1, padding 10px 0 ]
    [ Avatar Circle — 24×24px, border-radius 50% ]
      [ Entity Icon — 14×14 SVG, fill = entity color ]
    [ Text Stack ]
      [ Entity Name — 14px / 400 / #0E0E25 / ls 0.17px ]
      [ Description  — 12px / 400 / #56568F / ls 0px ]
  [ Attributes — 228px fixed-width, right-aligned ]
      [ Count — 14px / 400 / #56568F / ls 0.17px ]
```

**Layout & Spacing:**
- Row: `min-height: 44px`, `padding: 2px 16px 2px 28px`, `display: flex; align-items: center`
- Column subheader NAME: `padding-left: 28px; padding-right: 28px`
- Column subheader ATTRS: `padding-left: 16px; padding-right: 16px; text-align: right`
- Last row in a section has no bottom border
- Hover state: `background: #F5F5FA`

**Avatar Circle:**
- Size: `24×24px`, `border-radius: 9999px` (full circle)
- Background: tinted version of entity color at 12% opacity — e.g., `rgba(255, 68, 170, 0.12)` for Individual
- Icon: 14×14 SVG with `fill` set to the entity color (not `currentColor`)

**Entity Type Color Palette:**

| Entity Type  | Icon color  | Avatar background        |
|--------------|-------------|--------------------------|
| Individual   | `#FF44AA`   | `rgba(255, 68, 170, 0.12)` |
| Estate       | `#EE6611`   | `rgba(238, 102, 17, 0.12)` |
| Location     | `#449977`   | `rgba(68, 153, 119, 0.12)` |

**Typography:**

| Element       | Size | Weight | Color    | Line-height | Letter-spacing |
|---------------|------|--------|----------|-------------|----------------|
| Entity name   | 14px | 400    | `#0E0E25`| 20px        | 0.17px         |
| Description   | 12px | 400    | `#56568F`| 16px        | 0px            |
| Attribute count | 14px | 400  | `#56568F`| 20px        | 0.17px         |

**Usage rules:**
- Description text may wrap — allow `word-wrap: break-word` and do not truncate
- Attribute count shows a plain number only — no "attributes" label suffix
- Avatar icon SVG must use hard-coded `fill` color matching the entity type, not `currentColor`
- Do not reuse the same color for two different entity types in the same ontology

**Accessibility:**
- Each row should be `role="row"` with cells as `role="gridcell"` if using ARIA grid pattern
- Avatar is decorative — `aria-hidden="true"` on the icon wrapper
- Entity name and description should be in a single labelled region for screen readers

---

---

### 4. Reference Type Row (Tree / Expandable)

**Figma source:** Table section within `cWxrUkt9juy9IExIBHW94n` — Reference Data section
**Context:** Used for Reference Data entity rows that can be expanded to show child items (nested tree). Differs from the standard entity row by replacing the plain left-padding with a filled-triangle expand/collapse control.

**Visual Structure / Anatomy:**
```
[ Row — 44px min-height, white bg, 1px border-bottom #E3E3F2 ]
  [ Expand button — 20×20px filled triangle ]  [ Avatar ]  [ Name + Description ]  [ Attrs count ]
    ↳ on expand: child rows indent 36px with ├─ tree connector
      ↳ grandchild rows indent 64px with └─ tree connector
```

**Expand / Collapse Control:**
- Icon: filled downward-pointing triangle (`▼` SVG, 20×20px)
- Collapsed state: icon rotates -90° (`transform: rotate(-90deg)`) via CSS transition
- Expanded state: no rotation (default 0°)
- Rows without children: button is `visibility: hidden` (preserves layout)
- Transition: `transform 0.2s ease`

**Tree Connector Lines (child rows):**
The `├─` and `└─` tree indicators are pure CSS — no extra markup needed beyond the `.ref-tree-indicator` div:

| Property | Value |
|----------|-------|
| Width | `20px` |
| Vertical line | `left: 8px`, `1px` wide, color `rgba(0,0,204,0.14)` (runs full height) |
| Horizontal branch | `left: 8px`, `top: 50%`, `10px` wide, `1px` tall, same color |
| Last child (`└─`) | Vertical line stops at midpoint: `bottom: 50%` on the `::before` pseudo |

**Row Indent Levels:**

| Level | Padding-left | Background |
|-------|-------------|------------|
| Root row | `8px` (tight — tree control present) | `#ffffff` |
| Child row | `36px` | `#FAFAFA` |
| Grandchild row | `64px` | `#F5F5FA` |
| Child hover | — | `#F0F0F8` |
| Grandchild hover | — | `#EBEBF5` |

**Usage Notes:**
- Use this row type only in the Reference Data section — not for Entity, Relationship, or Source sections
- The expand triangle is the same icon used in the Entity Detail Panel attribute row — keep them consistent
- Do not show the tree indicator div on leaf rows; use `visibility: hidden` rather than `display: none` to preserve column alignment

---

### 5. Relationship Type Row

**Context:** Used in the Relationship section of the main table. Shows two entity types connected by a named relationship, with a bidirectional arrow tooltip.

**Visual Structure / Anatomy:**
```
[ Row — 7px top/bottom padding, align-items: flex-start ]
  [ Avatar stack — two overlapping circles, -4px offset ]   [ Relationship name chip ]  [ ↔ bidir arrow ] [ Entity A label ] [ Entity B label ]
  [ Description — 12px, #56568F, wraps below ]
```

**Avatar Stack:**
- Two `.row-avatar` circles placed with `margin-left: -4px` on the second circle
- Each circle has `outline: 1px solid #fff` to separate overlapping circles visually
- Colors follow the entity type color palette (see Table — Name Column Row Cell)

**Relationship Name Chip:**

| Property | Value |
|----------|-------|
| Background | `#F5F5FA` |
| Border radius | `4px` |
| Padding | `4px 12px` |
| Font | Roboto Regular 400, 12px, lh 16px, color `#0E0E25` |

**Bidirectional Arrow Tooltip:**
- Trigger: hover over the `↔` arrow icon (16×16px)
- Tooltip background: `rgba(14,14,37,0.70)` with `backdrop-filter: blur(4px)`
- Tooltip radius: `4px`, padding: `12px 16px`, gap between rows: `4px`
- Tooltip caret: CSS border trick, `5px solid transparent`, top-color matches tooltip bg
- Tooltip text: Roboto Medium 500, 12px, white, shows direction labels (e.g. "Belongs to → Location")
- Back arrow: `transform: scaleX(-1)` on the same arrow SVG

---

## Patterns & Compositions

---

### Entity Detail Panel

**Overview:**
A slide-out panel (right-anchored drawer) that opens when a user clicks an entity row in the main table. It provides the full attribute list, derived attributes, match rules, survivorship strategy, cleansers, and validation rules for a selected entity type. It overlays the canvas with a semi-transparent backdrop.

**Panel dimensions:** `540px` wide, full viewport height
**Animation:** `transform: translateX(100%)` → `translateX(0)` with `cubic-bezier(0.22, 1, 0.36, 1)`, duration `0.28s`
**Backdrop:** `rgba(14,14,37,0.30)`, `opacity` transition `0.25s`, closes panel on click

---

#### Panel Layout Structure

The panel has a horizontal flex layout with two regions:

```
┌──────────────────────────────────────────┬─────────┐
│              ep-main (492px)             │ sidebar │
│  header / tabs / col-header / attr-list  │  48px   │
└──────────────────────────────────────────┴─────────┘
```

**Sidebar is on the right** — this is a deliberate decision (not the standard left placement). The sidebar strip sits between the panel content and the viewport edge.

| Region | CSS class | Width | Background |
|--------|-----------|-------|------------|
| Main content | `.ep-main` | `flex: 1` | `#ffffff` |
| Sidebar strip | `.ep-sidebar` | `48px` | `#ffffff` |

**Sidebar border:** `border-left: 1px solid #E3E3F2` (separates sidebar from main)
**Panel shadow:** `box-shadow: -4px 0 32px rgba(67,67,112,0.24)` on the outer panel

---

#### Panel Header

```
┌────────────────────────────────────────────────┐
│  [ Avatar ]  Individual • Contact         [✕]  │  ← ep-header-row
│              Consumer identity and personal…   │  ← ep-desc
│  [Attributes] [Derived]         [🔍]           │  ← ep-tabs
└────────────────────────────────────────────────┘
```

**Entity name + type label inline pattern:**
The header shows `Entity Name • Type Label` on a single line using three spans:

```html
<span class="ep-name">Individual</span>
<span class="ep-name-sep"> • </span>
<span class="ep-type-label">Contact</span>
```

| Element | Font | Weight | Color |
|---------|------|--------|-------|
| Entity name (`.ep-name`) | 16px | 600 | `#0E0E25` |
| Separator (`.ep-name-sep`) | 16px | 400 | `#A9A9D6` — muted mid-tone |
| Type label (`.ep-type-label`) | 14px | 400 | `#56568F` |

**Entity avatar (`.ep-avatar`):**
- Size: `40×40px`, `border-radius: 9999px`
- Background: entity color at 12% opacity (same as table row avatars)
- Icon: `20×20px` SVG, hard-coded fill to entity color

**Close button (`.ep-close`):**
- Size: `32×32px`, `border-radius: 9999px`
- Background: `#F5F5FA` default, `#E3E3F2` on hover
- Margin-top: `4px` (optical alignment with top of name block)

**Description (`.ep-desc`):**
- Font: Roboto Regular 12px, color `#56568F`, lh 16px
- Margin-bottom: `10px` before tabs
- `max-width: 420px`

**Header padding:** `16px 16px 0` (no bottom padding — tabs sit flush against the border)
**Header bottom border:** `1px solid #E3E3F2`

---

#### Panel Tabs (`.ep-tabs`)

Two variants of the tab bar exist, controlled by which sidebar icon is active:

**Attributes view tabs:**
```
[ Attributes ]  [ Derived ]      [🔍]
```

**Relationship view tabs:**
```
[ Match ]  [ Survivorship ]  [ Cleansers ]  [ Validation ]      [🔍]
```

**Tab token spec:**

| State | Color | Underline indicator |
|-------|-------|---------------------|
| Default | `#56568F` | None |
| Active | `#0000CC` | 2px solid `#0000CC` bar, `border-radius: 2px 2px 0 0`, pinned to bottom |

**Tab search button (`.ep-tab-search`):**
- `margin-left: auto` — always pushed to far right
- Size: `30×30px`, `border-radius: 9999px`
- Background: `rgba(0,0,204,0.08)`, hover: `rgba(0,0,204,0.14)`

**Tab switch animation:**
On tab change, the content area (`.ep-attr-list`) transitions out with `opacity: 0 + translateY(6px)` then in from `opacity: 0 + translateY(-6px)`. A `setTimeout` of ~180ms separates exit from entry. This requires a forced reflow (`list.offsetHeight`) between adding exit and entry classes.

---

#### Panel Column Header (`.ep-col-header`)

Shown only in the Attributes view (hidden in Relationship view).

| Property | Value |
|----------|-------|
| Background | `#F5F5FA` |
| Border-bottom | `1px solid #E3E3F2` |
| Padding | `8px 16px` |
| Font | Roboto Medium 500, 11px, lh 16px |
| Color | `#56568F` |
| Letter-spacing | `0.8px` |
| Text-transform | `uppercase` |

---

#### Panel Sidebar (`.ep-sidebar`)

Three icon buttons stacked vertically on the right edge of the panel.

| Property | Value |
|----------|-------|
| Width | `48px` |
| Background | `#ffffff` |
| Border-left | `1px solid #E3E3F2` |
| Padding | `12px 0` |
| Gap | `4px` |

**Sidebar icon button (`.ep-sidebar-btn`):**

| State | Background | Icon color |
|-------|------------|------------|
| Default | `none` | `#56568F` |
| Hover | `rgba(0,0,102,0.08)` | `#000066` (Primary/Base) |
| Active / selected | `rgba(0,0,102,0.12)` | `#000066` (Primary/Base) |

**Icon colour technique:** Icon SVGs use `fill="currentColor"` so the icon colour is driven entirely by the CSS `color` property on `.ep-sidebar-btn`. This means a single SVG works across all states with no duplication.

**Icon buttons (in order, top to bottom):**
1. Attributes — list/configure-UI icon (`20×20px`)
2. Relationship — connecting nodes icon (`20×20px`)
3. Schema — document/reference icon (`20×20px`)

**Active state persistence:** The active sidebar button ID is controlled by `activateSidebarBtn(id)`. The currently selected entity is stored in `panel.dataset.entityKey` so the sidebar can access the correct data when switching independently of panel open/close.

---

#### Attribute Row (`.ep-attr-row`)

The core list item in the Attributes and Derived tabs.

**Anatomy:**
```
[ Expand chevron 16px ]  [ Type badge 24×24 ]  [ Name + Tag chips + Subtitle ]
```

**Row container:**

| Property | Value |
|----------|-------|
| Display | `flex; align-items: flex-start` |
| Padding | `10px 16px` |
| Gap | `8px` |
| Min-height | `48px` |
| Border-bottom | `1px solid #E3E3F2` |
| Background | `#ffffff` default, `#F5F5FA` on hover |

**Expand chevron (`.ep-expand`):**
- Size: `16×16px`
- Same filled-triangle icon as Reference Type table expand control — keeps visual language consistent
- Collapsed: `transform: rotate(-90deg)` → Expanded: `rotate(0deg)`
- Rows without children: `.ep-expand.placeholder` sets `visibility: hidden`
- `margin-top: 2px` for optical alignment

**Type badge (`.ep-type-badge`):**
- Padding: `4px` (creates `24×24` effective size around a `16×16` icon)
- `border-radius: 8px`
- `outline: 1px solid #E3E3F2; outline-offset: -1px`
- Background: `#ffffff`
- `margin-top: 1px`
- Icon: 16×16 SVG representing the attribute data type (`abc` for text, `num` for number)

**Attribute name (`.ep-attr-name`):**
- Font: Roboto Regular 400, 14px, lh 20px, letter-spacing 0.17px, color `#0E0E25`

**Subtitle (`.ep-attr-subtitle`):**
- Font: Roboto Regular 400, 11px, lh 16px, color `#7070A9`
- `min-height: 16px` — ensures consistent row height even when empty
- **Critical:** Always render with `attr.subtitle || '&nbsp;'` — an empty string collapses the div and misaligns rows. The `&nbsp;` fallback preserves the line-height without visible content.

---

#### Inline Attribute Tag Chips (`.ep-attr-tag`)

Small chips that appear inline next to the attribute name. Two variants:

| Variant | CSS class | Background | Text | Border |
|---------|-----------|------------|------|--------|
| Reference | `.ep-attr-tag.ref` | `rgba(0,0,204,0.07)` | `#0000CC` | `1px solid rgba(0,0,204,0.14)` |
| Enhanced | `.ep-attr-tag.enhanced` | `rgba(68,153,119,0.10)` | `#2E7D55` | `1px solid rgba(68,153,119,0.22)` |

Shared styling: `padding: 0 6px`, `border-radius: 4px`, `font-size: 11px`, `font-weight: 500`, `line-height: 18px`

---

#### Attribute Child Rows (`.ep-attr-child-row`)

When an attribute row has children, expanding it reveals nested child rows. They follow the same tree connector pattern as Reference Type rows.

| Property | Value |
|----------|-------|
| Padding | `0 16px`, gap `24px` |
| Background | `#F9F9FD` default, `#F0F0F8` hover |
| Min-height | `36px` |
| Border-bottom | `1px solid #E3E3F2` |

**Tree connector (`.ep-tree-indicator`):**
Pure-CSS `├─` / `└─` lines, identical to Reference Type tree indicator:
- Vertical line: `left: 8px`, 1px wide, `rgba(0,0,204,0.14)`
- Horizontal branch: `left: 8px`, `top: 50%`, 10px wide, same color
- Last child: vertical line stops at midpoint (`bottom: 50%`)

---

#### Match Rules Tab

Shown when **Relationship** sidebar icon is active and **Match** tab is selected.

**Row anatomy:**
```
[ expand col 16px ] [ status icon 24px ] [ name + sub-text ] [ outcome badge ]
```

**Match row container (`.match-row`):**

| Property | Value |
|----------|-------|
| Display | `flex; align-items: center; justify-content: space-between` |
| Padding | `0 16px` |
| Gap | `8px` |
| Border-bottom | `1px solid #E3E3F2` |

**Status icons:**

| Status | Icon | Color |
|--------|------|-------|
| `exact` | check-circle SVG (16×16) | `#2F6A52` (green) |
| `fuzzy` | warning/triangle SVG (16×16) | `#CC7700` (amber) |

**Match title (`.match-title`):** Roboto Regular 400, 14px, lh 20px, ls 0.17px, color `#0E0E25`

**Expand/collapse arrow (`.match-title-arrow`):**
- Inline 12×12px arrow SVG
- Collapsed (default): `transform: rotate(-90deg)`
- Expanded: `transform: rotate(0deg)` via `.match-row.expanded .match-title-arrow svg`
- Transition: `0.2s ease`

**Sub-text (`.match-sub-text`):**
- `display: none` by default; `display: block` when `.match-row.expanded`
- Font: Roboto Regular 400, 12px, lh 16px, color `#56568F`
- Content: criteria lines joined with `<br/>` + description on last line

**Outcome badges (`.match-badge`):**

| Variant | CSS class | Background | Text | Border |
|---------|-----------|------------|------|--------|
| Auto-merge | `.match-badge.auto` | `rgba(68,153,119,0.14)` | `#2F6A52` | `outline: 1px solid rgba(68,153,119,0.14)` |
| Steward reviews | `.match-badge.steward` | `rgba(255,204,0,0.18)` | `#9E4F00` | `border-color: transparent` |

Shared badge styling: `padding: 4px 12px`, `border-radius: 4px`, font-weight: 500, 12px, lh 16px

---

#### Survivorship Tab

Shown when **Relationship** sidebar icon is active and **Survivorship** tab is selected.

**Layout:** Two-column table — ATTRIBUTE column | RELTIO column — equal width (`flex: 1` each).

**Column header row (`.surv-header`):**

| Property | Value |
|----------|-------|
| Background | `#F5F5FA` |
| Border-bottom | `1px solid #E3E3F2` |
| Padding | `0 16px` |
| Cell font | Roboto Medium 500, 11px, lh 16px, ls 0.8px, `text-transform: uppercase` |
| Cell color | `#56568F` |
| Cell padding | `8px 0` |

**Data rows (`.surv-row`):**

| Property | Value |
|----------|-------|
| Min-height | `44px` |
| Padding | `0 16px` |
| Border-bottom | `1px solid #E3E3F2` |
| Background | `#ffffff` |

**Attribute cell (`.surv-cell-attr`):** Roboto Regular 400, 14px, lh 20px, color `#0E0E25`

**Reltio/strategy cell (`.surv-cell-reltio`):** Roboto Regular 400, 14px, lh 20px, color `#56568F`, flex with `gap: 8px` to accommodate the Enhanced badge

**Enhanced badge (`.surv-badge-enhanced`):**

| Property | Value |
|----------|-------|
| Background | `rgba(255,153,0,0.14)` |
| Text color | `#9E4F00` |
| Border | `1px solid rgba(255,153,0,0.22)` |
| Padding | `1px 6px` |
| Border-radius | `4px` |
| Font | Roboto Medium 500, 11px, lh 18px |

The Enhanced badge indicates that a survivorship strategy uses Reltio Enhanced processing (e.g. address standardisation before aggregation). Not all attributes have it — only render the badge when the data object has `enhanced: true`.

---

#### Data Model for Entity Panel

Each entity panel is driven by a `ENTITY_PANEL_DATA` keyed object. The schema for each entity entry:

```javascript
{
  name: String,          // Display name, e.g. 'Individual'
  icon: String,          // Icon key: 'individual' | 'estate' | 'location'
  typeLabel: String,     // Type label shown after separator: e.g. 'Contact'
  color: String,         // Entity brand color hex: e.g. '#FF44AA'
  bg: String,            // Avatar background: e.g. 'rgba(255,68,170,0.12)'
  desc: String,          // Short description shown in panel header

  attrs: [               // Attributes tab
    {
      name: String,
      type: 'abc' | 'num',
      tag: null | 'ref' | 'enhanced',
      tagLabel: String,  // Label text on the chip (only when tag is set)
      subtitle: String,  // Category label — ALWAYS provide; use ' ' if no category
      children: [        // Optional nested attributes
        { name: String, type: 'abc' | 'num' }
      ]
    }
  ],

  derivedAttrs: [...],   // Same schema as attrs — shown in Derived tab

  matchRules: [          // Match tab
    {
      name: String,       // Rule display name
      status: 'exact' | 'fuzzy',  // Controls icon colour
      criteria: String[], // List of rule criteria lines
      desc: String,       // Sentence describing outcome
      outcome: 'auto' | 'steward',
      badgeLabel: String  // Optional override (default: 'Auto-merges' / 'Steward reviews')
    }
  ],

  survivorshipRules: [   // Survivorship tab
    {
      attr: String,       // Attribute name
      strategy: String,   // e.g. 'Recency', 'Source System', 'Aggregation', 'Frequency'
      enhanced: Boolean   // Optional — shows Enhanced badge when true
    }
  ]
}
```

---

## Open Questions / TBD

> _Gaps, ambiguities, or items to confirm with the design source will be tracked here._

- **Wave BG asset** — current `assets/wave-bg.svg` is an SVG approximation derived from the Figma screenshot (Dev Mode MCP was unavailable). Replace with the authoritative SVG export from Figma node `1916:136858` when possible. File path should remain the same.
- **Cleansers tab** — content design not yet defined. Renders empty for now.
- **Validation tab** — content design not yet defined. Renders empty for now.
- **Panel hover/focus states for attribute rows** — confirmed as `#F5F5FA` background; full keyboard-navigation ARIA pattern TBD.
- **Schema sidebar icon** — schema/document action not yet implemented. Icon present; click does nothing in current prototype.

---

_Last updated: 2026-05-11 — Added: Reference Type Row (expandable tree), Relationship Type Row, Entity Detail Panel (layout, header, tabs, sidebar, attribute rows, child rows, inline tag chips, match rules, survivorship table), Entity Panel data model_
