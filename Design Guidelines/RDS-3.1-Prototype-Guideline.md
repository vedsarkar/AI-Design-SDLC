# Reltio Design System 3.1 (RDS 3.1) — Prototype Building Guideline

> **Purpose:** This document is an instruction set for **Claude** when asked to build a design prototype for any Reltio product (web app or marketing surface). Every prototype Claude generates should look and behave as if it were lifted directly from the Reltio Design System 3.1 Figma library.
>
> **Source:** [Reltio Design System 3.1 (LTS)](https://www.figma.com/design/tu2YE7Y6bmgkmcdIqCJpLk/branch/ZWKDuZCQgNMyOl8afscgw0/Reltio-Design-System-3.1--LTS-?m=auto&node-id=18-231)
>
> **Themes:** Light (default) and Dark — every prototype must support both unless the prompt is explicit about which one.

---

## 0. How to use this document

When a user asks for a prototype:

1. **Default to Light theme** unless they say otherwise. Build the markup so theme can swap by toggling `data-theme="dark"` on `<html>` (see §2).
2. **Always include the wave background** on the outermost app-shell container (see §9). The wave is part of Reltio's visual identity — products without it look "off-brand."
3. **Only use the tokens defined here.** Never invent colors, font sizes, or spacing values. If something isn't covered, fall back to the closest token in the scale.
4. **Use Material Symbols Rounded** for icons by default (see §10). The Reltio icon set is heavily aligned with it, so name parity is high.
5. **Type families:** `Libre Franklin` for headings/titles, `Roboto` for body and UI text. Both available on Google Fonts.
6. **Accessibility is non-negotiable.** WCAG 2.1 AA contrast for text, visible focus, semantic HTML.
7. **Density is high.** Reltio products are data-dense; avoid the loose, marketing-page padding common in consumer apps.

---

## 1. Brand & Visual Identity

| Attribute | Value |
|---|---|
| Brand color (primary) | **Reltio Blue** `#000066` |
| Brand color (deep) | **Midnight** `#000033` |
| Brand color (accent) | **Bright Blue** `#0000CC` |
| Heading typeface | **Libre Franklin** |
| Body typeface | **Roboto** |
| Signature visual | The **Reltio Wave** — a directional gradient streak applied as a full-bleed page background |
| Tone | Confident, technical, calm; data-product feel — not playful |

The wave + dark navy + crisp white-or-deep-navy surface combination is the look. Products feel **"premium enterprise"** — closer to Datadog or Linear than Salesforce, but with Reltio's signature midnight + bright-blue accent.

---

## 2. Theming — CSS Variables

Drop this `:root` and `[data-theme="dark"]` block into every prototype's `<style>`. All component recipes below reference these variables.

```css
:root,
[data-theme="light"] {
  /* ─── Brand ─── */
  --reltio-blue: #000066;
  --reltio-midnight: #000033;
  --reltio-bright-blue: #0000CC;

  /* ─── Primary / Action ─── */
  --color-primary: #0000CC;          /* primary buttons, focus, links */
  --color-primary-hover: #000099;
  --color-primary-active: #000066;
  --color-secondary: #000066;        /* outlined / secondary */
  --color-secondary-hover-bg: #0000660A;
  --color-secondary-selected-bg: #00006614;

  /* ─── Action (interaction surfaces) ─── */
  --action-active: #000033CC;        /* icon buttons, toolbar default */
  --action-hover-bg: #0000330A;
  --action-selected-bg: #00006614;
  --action-disabled: #00000040;

  /* ─── Text ─── */
  --text-primary: #0E0E25;           /* "Fonts & Icons / Default" */
  --text-secondary: #00000099;
  --text-disabled: #00000080;
  --text-inactive: #000000;
  --text-on-primary: #FFFFFF;

  /* ─── Background & Surface ─── */
  --bg-page: #FFFFFF;                /* app body */
  --surface-1: #FFFFFF;              /* cards, modals (default) */
  --surface-2: #F6F6FA;              /* slightly recessed (subtle wash) */
  --surface-3: #E3E3F2;              /* sunken / muted blocks */
  --surface-elevated: #FFFFFF;       /* popovers, dropdowns */

  /* ─── Borders ─── */
  --border-subtle: #E3E3F2;
  --border-default: #BABADE;         /* "Surface Border 3" */
  --border-strong: #000033;

  /* ─── Status ─── */
  --status-error: #E33;
  --status-error-bg: #FFE5E5;
  --status-warning: #F39C12;
  --status-warning-bg: #FFF4E5;
  --status-success: #2BAE66;
  --status-success-bg: #E6F7EE;
  --status-info: #0000CC;
  --status-info-bg: #E5E5FA;

  /* ─── Radius ─── */
  --radius-xs: 2px;
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
  --radius-pill: 9999px;

  /* ─── Spacing (px) ─── */
  --space-0: 0;
  --space-1: 2px;
  --space-2: 4px;
  --space-3: 6px;
  --space-4: 8px;
  --space-5: 12px;
  --space-6: 16px;
  --space-7: 24px;
  --space-8: 32px;
  --space-9: 48px;
  --space-10: 64px;
  --space-11: 80px;

  /* ─── Sizing (icon container / control heights) ─── */
  --size-xs: 16px;
  --size-sm: 20px;
  --size-md: 24px;
  --size-lg: 32px;
  --size-xl: 40px;
  --size-2xl: 48px;
  --size-3xl: 56px;
  --size-4xl: 64px;

  /* ─── Typography ─── */
  --font-title: 'Libre Franklin', system-ui, sans-serif;
  --font-body: 'Roboto', system-ui, sans-serif;

  --fs-xs: 12px;
  --fs-sm: 13px;
  --fs-base: 14px;     /* default UI text */
  --fs-md: 16px;
  --fs-lg: 18px;
  --fs-xl: 20px;
  --fs-2xl: 24px;
  --fs-3xl: 32px;
  --fs-4xl: 40px;
  --fs-display: 48px;

  --fw-regular: 400;
  --fw-medium: 500;
  --fw-semibold: 600;

  --lh-tight: 1.2;
  --lh-snug: 1.35;
  --lh-normal: 1.5;

  /* ─── Elevation / Shadow ─── */
  --shadow-1: 0 1px 2px rgba(0, 0, 51, 0.06), 0 1px 1px rgba(0, 0, 51, 0.04);
  --shadow-2: 0 2px 6px rgba(0, 0, 51, 0.08), 0 1px 3px rgba(0, 0, 51, 0.05);
  --shadow-3: 0 8px 24px rgba(0, 0, 51, 0.12), 0 2px 6px rgba(0, 0, 51, 0.06);
  --shadow-overlay: 0 16px 48px rgba(0, 0, 51, 0.20);

  /* ─── Focus ring ─── */
  --focus-ring: 0 0 0 2px #FFFFFF, 0 0 0 4px var(--color-primary);

  /* ─── Layout chrome ─── */
  --topbar-height: 56px;
  --sidenav-width: 240px;
  --sidenav-collapsed: 64px;
  --rightpanel-width: 360px;

  color-scheme: light;
}

[data-theme="dark"] {
  --color-primary: #4D4DFF;
  --color-primary-hover: #6E6EFF;
  --color-primary-active: #3333E6;
  --color-secondary: #8E8EFF;
  --color-secondary-hover-bg: #4D4DFF1A;
  --color-secondary-selected-bg: #4D4DFF26;

  --action-active: #FFFFFFE0;
  --action-hover-bg: #FFFFFF0F;
  --action-selected-bg: #4D4DFF1F;
  --action-disabled: #FFFFFF40;

  --text-primary: #F2F2F7;
  --text-secondary: #FFFFFFB3;
  --text-disabled: #FFFFFF66;
  --text-inactive: #FFFFFF;
  --text-on-primary: #FFFFFF;

  --bg-page: #08081A;                /* near-black with brand undertone */
  --surface-1: #12122B;
  --surface-2: #1A1A38;
  --surface-3: #232347;
  --surface-elevated: #1A1A38;

  --border-subtle: #232347;
  --border-default: #3A3A66;
  --border-strong: #6E6EFF;

  --status-error: #FF5C5C;
  --status-error-bg: #3A1A1A;
  --status-warning: #FFB84D;
  --status-warning-bg: #3A2C12;
  --status-success: #5BD68A;
  --status-success-bg: #143025;
  --status-info: #6E6EFF;
  --status-info-bg: #1F1F45;

  --shadow-1: 0 1px 2px rgba(0, 0, 0, 0.40);
  --shadow-2: 0 2px 6px rgba(0, 0, 0, 0.50);
  --shadow-3: 0 8px 24px rgba(0, 0, 0, 0.60);
  --shadow-overlay: 0 16px 48px rgba(0, 0, 0, 0.70);

  --focus-ring: 0 0 0 2px var(--bg-page), 0 0 0 4px var(--color-primary);

  color-scheme: dark;
}
```

> **Note:** The dark-theme values for surfaces, borders, and accent are interpolated to maintain RDS 3.1's brand identity (midnight base, bright-blue accent that shifts up the value scale to remain accessible on a dark background). Confirm against Figma when working from a specific dark-mode Figma frame.

---

## 3. Color Token Reference

### Brand
| Token | Hex | Use |
|---|---|---|
| `--reltio-blue` | `#000066` | Logo, anchor brand color, secondary buttons |
| `--reltio-midnight` | `#000033` | Deep brand surfaces, footers, hero overlays |
| `--reltio-bright-blue` | `#0000CC` | Primary action, links, focus, charts highlight |

### Action / Interaction
| Token | Use |
|---|---|
| `--color-primary` | Primary CTA fill |
| `--color-secondary` | Outlined / secondary CTA stroke + label |
| `--action-active` | Icon button default color |
| `--action-hover-bg` | Hover wash for icon buttons, list rows, menu items |
| `--action-selected-bg` | Selected wash for nav items, tabs, segmented controls |

### Text
| Token | Min contrast on `--surface-1` (light) |
|---|---|
| `--text-primary` (`#0E0E25`) | 17.0:1 — passes AAA |
| `--text-secondary` (`#00000099`) | ~9.0:1 — passes AAA |
| `--text-disabled` | non-essential text only |
| `--text-on-primary` | white text on primary |

### Surface (Light)
| Token | Hex | Use |
|---|---|---|
| `--bg-page` | `#FFFFFF` | App body |
| `--surface-1` | `#FFFFFF` | Default card / panel |
| `--surface-2` | `#F6F6FA` | Subtle row striping, secondary panels |
| `--surface-3` | `#E3E3F2` | Sunken / disabled / muted blocks |

### Borders (Light)
| Token | Hex |
|---|---|
| `--border-subtle` | `#E3E3F2` |
| `--border-default` | `#BABADE` |
| `--border-strong` | `#000033` |

---

## 4. Typography

### Font setup

Always import both faces in the prototype's `<head>`:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Libre+Franklin:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
```

### Type ramp

| Role | Class / Style | Family | Size | Weight | Line height |
|---|---|---|---|---|---|
| Display | `.t-display` | Libre Franklin | 48px | 600 | 1.2 |
| H1 / Page title | `.t-h1` | Libre Franklin | 32px | 600 | 1.2 |
| H2 / Section title | `.t-h2` | Libre Franklin | 24px | 600 | 1.25 |
| H3 | `.t-h3` | Libre Franklin | 20px | 600 | 1.3 |
| H4 / Card title | `.t-h4` | Libre Franklin | 16px | 600 | 1.35 |
| Body large | `.t-body-lg` | Roboto | 16px | 400 | 1.5 |
| Body (default UI) | `.t-body` | Roboto | 14px | 400 | 1.5 |
| Body small | `.t-body-sm` | Roboto | 13px | 400 | 1.45 |
| Caption / micro | `.t-caption` | Roboto | 12px | 400 | 1.4 |
| Overline | `.t-overline` | Roboto | 12px | 500, uppercase, 0.06em tracking | 1.3 |
| Code / mono | `.t-mono` | `'JetBrains Mono', ui-monospace` | 13px | 400 | 1.5 |

```css
body { font-family: var(--font-body); font-size: var(--fs-base); color: var(--text-primary); line-height: var(--lh-normal); }
h1,h2,h3,h4,h5,h6, .t-display, .t-h1, .t-h2, .t-h3, .t-h4 { font-family: var(--font-title); color: var(--text-primary); margin: 0; }
.t-display { font-size: var(--fs-display); font-weight: 600; line-height: var(--lh-tight); letter-spacing: -0.01em; }
.t-h1 { font-size: var(--fs-3xl); font-weight: 600; line-height: var(--lh-tight); letter-spacing: -0.005em; }
.t-h2 { font-size: var(--fs-2xl); font-weight: 600; line-height: 1.25; }
.t-h3 { font-size: var(--fs-xl); font-weight: 600; line-height: 1.3; }
.t-h4 { font-size: var(--fs-md); font-weight: 600; line-height: var(--lh-snug); }
.t-body-lg { font-size: var(--fs-md); }
.t-body    { font-size: var(--fs-base); }
.t-body-sm { font-size: var(--fs-sm); }
.t-caption { font-size: var(--fs-xs); color: var(--text-secondary); }
.t-overline{ font-size: var(--fs-xs); font-weight: 500; text-transform: uppercase; letter-spacing: 0.06em; color: var(--text-secondary); }
```

**Rules**
- Headings always Libre Franklin. UI text always Roboto.
- Never mix in another typeface (no Inter, no SF Pro substitutions).
- Numbers in tables/metrics: prefer `font-variant-numeric: tabular-nums` for column alignment.

---

## 5. Spacing scale

Single 12-step scale. Use semantically; don't free-style px values.

| Token | Value | Common use |
|---|---|---|
| `--space-0` | 0 | No gap |
| `--space-1` | 2 | Hairline gap, icon dot offset |
| `--space-2` | 4 | Tight inline gap (icon ↔ label inside compact button) |
| `--space-3` | 6 | Compact stack |
| `--space-4` | 8 | Default inline gap, small padding |
| `--space-5` | 12 | Form field internal padding (Y) |
| `--space-6` | 16 | Standard component padding, list-item padding |
| `--space-7` | 24 | Section gap inside a card |
| `--space-8` | 32 | Card-to-card gap |
| `--space-9` | 48 | Page section gap |
| `--space-10` | 64 | Hero / large section padding |
| `--space-11` | 80 | Marketing-style hero |

**Rule of thumb:** inside a single component use `4 / 8 / 12 / 16`. Between components use `16 / 24 / 32`. Page-level gaps use `48 / 64`.

---

## 6. Sizing scale (icon containers, control heights)

The RDS Icon Container component defines this scale exactly:

| Token | Value | Use |
|---|---|---|
| `--size-xs` | 16 | Inline-text icon, dense table icon |
| `--size-sm` | 20 | Default icon-button glyph |
| `--size-md` | 24 | Toolbar icon |
| `--size-lg` | 32 | Avatar (sm), badge button |
| `--size-xl` | 40 | Avatar (md), large icon button, **default control height (input/button)** |
| `--size-2xl` | 48 | Avatar (lg), feature tile |
| `--size-3xl` | 56 | App icon, marketplace tile |
| `--size-4xl` | 64 | Hero avatar, empty-state illustration |

**Control heights:** form inputs and primary buttons default to **40px** (`--size-xl`). Compact density variant: 32px (`--size-lg`).

---

## 7. Border radius

| Token | Value | Use |
|---|---|---|
| `--radius-xs` | 2 | Inline pill micro |
| `--radius-sm` | 4 | Inputs, small buttons, tags |
| `--radius-md` | 8 | **Default** — buttons, cards, panels |
| `--radius-lg` | 12 | Large cards, modals |
| `--radius-xl` | 16 | Hero cards, marketing surfaces |
| `--radius-pill` | 9999 | Pills, status chips, avatars, notification dots |

---

## 8. Elevation / Shadow

Three steps + an overlay tier. Reltio surfaces stay relatively flat — heavy drop shadows are off-brand.

| Token | When |
|---|---|
| `--shadow-1` | Resting card, toolbar |
| `--shadow-2` | Hovered card, elevated panel |
| `--shadow-3` | Popover, dropdown menu, toast |
| `--shadow-overlay` | Modal, drawer over scrim |

Modal/drawer scrim: `rgba(0, 0, 51, 0.5)` (light) / `rgba(0, 0, 0, 0.7)` (dark).

---

## 9. The Reltio Wave (background)

The wave is **always present** on the outermost app shell or page background. Two variants:

- **Light wave:** [Figma node 11224-3093](https://www.figma.com/design/tu2YE7Y6bmgkmcdIqCJpLk/Reltio-Design-System-3.1--LTS-?node-id=11224-3093) — soft pale-blue gradient streaks on white
- **Dark wave:** [Figma node 11224-3099](https://www.figma.com/design/tu2YE7Y6bmgkmcdIqCJpLk/Reltio-Design-System-3.1--LTS-?node-id=11224-3099) — bright-blue + warm-gold streaks emerging from black

### Where to apply

- **App shell:** the body/`<html>` background, behind everything.
- **Login / auth screens:** full-bleed.
- **Marketing or splash overlays:** full-bleed.
- **Empty states / agent welcome:** as a softer overlay (lower opacity), behind the headline area only.

### Implementation

Save the wave as `wave-light.svg` / `wave-dark.svg` next to the prototype, or use the inline CSS gradient fallback below if the SVG isn't available.

```css
body {
  background: var(--bg-page);
  background-image: url('wave-light.svg');
  background-repeat: no-repeat;
  background-position: bottom right;
  background-size: 100% auto;       /* let it stretch the full width */
  background-attachment: fixed;     /* stays in place when scrolling */
  min-height: 100vh;
}

[data-theme="dark"] body {
  background-image: url('wave-dark.svg');
}
```

**Inline-CSS fallback** (when no SVG file is available — approximates the gradient):

```css
/* Light fallback */
body.wave-fallback {
  background:
    radial-gradient(60% 50% at 90% 95%, rgba(174, 215, 255, 0.55) 0%, transparent 60%),
    radial-gradient(50% 40% at 70% 90%, rgba(176, 196, 255, 0.45) 0%, transparent 60%),
    radial-gradient(40% 30% at 95% 80%, rgba(255, 220, 160, 0.30) 0%, transparent 60%),
    var(--bg-page);
}

/* Dark fallback */
[data-theme="dark"] body.wave-fallback {
  background:
    radial-gradient(60% 50% at 90% 95%, rgba(80, 100, 255, 0.50) 0%, transparent 60%),
    radial-gradient(45% 35% at 80% 92%, rgba(120, 140, 255, 0.40) 0%, transparent 60%),
    radial-gradient(35% 28% at 95% 80%, rgba(255, 180, 80, 0.25) 0%, transparent 60%),
    var(--bg-page);
}
```

**Rules**
- The wave anchors **bottom-right** of the viewport.
- Don't tile, don't mirror, don't recolor.
- Content surfaces (cards, panels, sidebars) sit **on top** of the wave on `--surface-1` so legibility stays high.

---

## 10. Iconography

Reltio ships a 300+ icon set in `Libre Franklin` (line, 20×20 base). The set includes:

- **Action/info icons** (Material-aligned): `add`, `close`, `check`, `cancel`, `delete`, `edit`, `search`, `send`, `settings`, `refresh`, `arrow-*`, `keyboard-arrow-*`, `more-vert`, `more-horiz`, `info`, `warning`, `visibility`, `download`, `play`, `pause`, `replay`…
- **Reltio domain icons:** `match-rule`, `merge`, `unmerge`, `survivorship`, `dcr-comment`, `lookup-type`, `attribute / complex|nested|simple|derived`, `entity-type / *`, `application / *`, `velocity-pack / *`, `agent_*`…
- **Agentflow-specific:** `Acess Conversations`, `Manage agent`, `Side Nav`, `Pin`, `Explore`, `Group`, `Dev`, `Workflow`, `Skip`, `Indicator`, `Archive`, `Format Bold/Italic/Underline`, `Mic`, `Share`, `Attachment`, `Link`, `task List`…

### Implementation in HTML prototypes

**Default approach — Material Symbols Rounded** (simplest; ~95% of action icons map by name):

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0">

<span class="material-symbols-rounded">search</span>
<span class="material-symbols-rounded">settings</span>
<span class="material-symbols-rounded">edit</span>
```

```css
.material-symbols-rounded {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
  font-size: var(--size-md);
  color: var(--action-active);
  vertical-align: middle;
  user-select: none;
}
```

### Icon-name mapping cheat sheet (RDS → Material Symbols)

| RDS name | Material Symbols equivalent |
|---|---|
| `more vert` | `more_vert` |
| `more horiz` | `more_horiz` |
| `keyboard arrow - down/up/left/right` | `keyboard_arrow_down/up/left/right` |
| `actions menu` | `more_vert` |
| `Side Nav` | `menu` |
| `Acess Conversations` | `chat_bubble_outline` |
| `Manage agent` | `smart_toy` |
| `Workflow` | `account_tree` |
| `match rule` | `rule` |
| `merge` / `unmerge` | `merge` / `call_split` |
| `survivorship` | `verified` |
| `Velocity Pack: Healthcare` | `medical_services` |
| `application / dashboard` | `dashboard` |
| `application / data quality` | `verified_user` |
| `entity type / individual` | `person` |
| `entity type / organization` | `business` |
| `entity type / location` | `location_on` |

For **brand-specific Reltio icons** (entity types, velocity packs, agent icons) without a Material twin, fall back to closest Material match and add a comment in the code (`<!-- TODO: replace with Reltio's "agent_segmentation" SVG -->`) so designers know to swap.

### Icon container

Always pair an icon with the icon-container scale. An icon button is **icon (size-md) inside a container (size-xl, 40×40)** with hover state.

```css
.icon-btn {
  display: inline-flex; align-items: center; justify-content: center;
  width: var(--size-xl); height: var(--size-xl);
  border-radius: var(--radius-md);
  border: none; background: transparent; cursor: pointer;
  color: var(--action-active);
  transition: background 120ms ease;
}
.icon-btn:hover  { background: var(--action-hover-bg); }
.icon-btn:active { background: var(--action-selected-bg); }
.icon-btn:focus-visible { outline: none; box-shadow: var(--focus-ring); }
.icon-btn[aria-pressed="true"] { background: var(--action-selected-bg); }
.icon-btn:disabled { color: var(--text-disabled); cursor: not-allowed; }

/* size variants — change container size, NOT icon size */
.icon-btn--sm { width: var(--size-lg); height: var(--size-lg); }
.icon-btn--lg { width: var(--size-2xl); height: var(--size-2xl); }
```

---

## 11. Component Recipes

> All recipes assume the `:root` token block from §2 is loaded.

### 11.1 Button

```css
.btn {
  display: inline-flex; align-items: center; justify-content: center;
  gap: var(--space-4);
  height: var(--size-xl);
  padding: 0 var(--space-6);
  border-radius: var(--radius-md);
  font-family: var(--font-body);
  font-size: var(--fs-base);
  font-weight: var(--fw-medium);
  line-height: 1;
  border: 1px solid transparent;
  cursor: pointer;
  transition: background 120ms ease, border-color 120ms ease, color 120ms ease;
}
.btn:focus-visible { outline: none; box-shadow: var(--focus-ring); }
.btn:disabled { opacity: 0.5; cursor: not-allowed; }

/* Primary */
.btn--primary { background: var(--color-primary); color: var(--text-on-primary); }
.btn--primary:hover  { background: var(--color-primary-hover); }
.btn--primary:active { background: var(--color-primary-active); }

/* Secondary (outlined) */
.btn--secondary { background: transparent; color: var(--color-secondary); border-color: var(--border-default); }
.btn--secondary:hover  { background: var(--color-secondary-hover-bg); border-color: var(--color-secondary); }
.btn--secondary:active { background: var(--color-secondary-selected-bg); }

/* Tertiary (text) */
.btn--text { background: transparent; color: var(--color-primary); padding: 0 var(--space-4); }
.btn--text:hover { background: var(--action-hover-bg); }

/* Destructive */
.btn--danger { background: var(--status-error); color: #fff; }
.btn--danger:hover { background: #C72C2C; }

/* Sizes */
.btn--sm { height: var(--size-lg); padding: 0 var(--space-5); font-size: var(--fs-sm); }
.btn--lg { height: var(--size-2xl); padding: 0 var(--space-7); font-size: var(--fs-md); }

/* With icon */
.btn .material-symbols-rounded { font-size: 18px; }
```

```html
<button class="btn btn--primary"><span class="material-symbols-rounded">add</span>Create agent</button>
<button class="btn btn--secondary">Cancel</button>
<button class="btn btn--text">Learn more</button>
```

### 11.2 Input + Form Field

```css
.field { display: flex; flex-direction: column; gap: var(--space-2); }
.field__label { font-size: var(--fs-sm); font-weight: var(--fw-medium); color: var(--text-primary); }
.field__hint  { font-size: var(--fs-xs); color: var(--text-secondary); }
.field__error { font-size: var(--fs-xs); color: var(--status-error); }

.input {
  display: flex; align-items: center; gap: var(--space-4);
  height: var(--size-xl);
  padding: 0 var(--space-5);
  border: 1px solid var(--border-default);
  border-radius: var(--radius-md);
  background: var(--surface-1);
  color: var(--text-primary);
  font: var(--fw-regular) var(--fs-base)/1.5 var(--font-body);
  width: 100%;
  transition: border-color 120ms ease, box-shadow 120ms ease;
}
.input:hover { border-color: var(--border-strong); }
.input:focus-within, .input:focus { outline: none; border-color: var(--color-primary); box-shadow: 0 0 0 3px rgba(0, 0, 204, 0.15); }
.input[aria-invalid="true"] { border-color: var(--status-error); }
.input:disabled { background: var(--surface-3); color: var(--text-disabled); }
.input::placeholder { color: var(--text-secondary); }

/* Search variant — input wrapped to allow leading icon */
.input-group { position: relative; }
.input-group .material-symbols-rounded { position: absolute; left: var(--space-5); top: 50%; transform: translateY(-50%); color: var(--text-secondary); pointer-events: none; }
.input-group .input { padding-left: 40px; }
```

```html
<label class="field">
  <span class="field__label">Agent name</span>
  <input class="input" placeholder="e.g. Hierarchy Research Agent">
  <span class="field__hint">Visible in the marketplace.</span>
</label>

<div class="input-group">
  <span class="material-symbols-rounded">search</span>
  <input class="input" placeholder="Search agents, tools, runs…">
</div>
```

### 11.3 Card

```css
.card {
  background: var(--surface-1);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-lg);
  padding: var(--space-7);
  box-shadow: var(--shadow-1);
}
.card--interactive { transition: box-shadow 150ms ease, transform 150ms ease, border-color 150ms ease; cursor: pointer; }
.card--interactive:hover { box-shadow: var(--shadow-2); border-color: var(--border-default); }
.card__header { display: flex; align-items: flex-start; justify-content: space-between; gap: var(--space-6); margin-bottom: var(--space-5); }
.card__title { font: 600 var(--fs-md)/1.35 var(--font-title); color: var(--text-primary); }
.card__meta  { font-size: var(--fs-sm); color: var(--text-secondary); }
```

### 11.4 Top navigation bar

```html
<header class="topbar">
  <a class="topbar__brand" href="#">
    <svg width="24" height="24" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10" fill="#000066"/><circle cx="12" cy="12" r="4" fill="#0000CC"/></svg>
    <span>Reltio</span>
  </a>
  <nav class="topbar__nav">
    <a href="#" class="topbar__link is-active">Conversations</a>
    <a href="#" class="topbar__link">Marketplace</a>
    <a href="#" class="topbar__link">Builder</a>
    <a href="#" class="topbar__link">Admin</a>
  </nav>
  <div class="topbar__actions">
    <button class="icon-btn" aria-label="Search"><span class="material-symbols-rounded">search</span></button>
    <button class="icon-btn" aria-label="Notifications"><span class="material-symbols-rounded">notifications</span></button>
    <div class="avatar avatar--sm">VS</div>
  </div>
</header>
```

```css
.topbar {
  position: sticky; top: 0; z-index: 30;
  display: flex; align-items: center; gap: var(--space-7);
  height: var(--topbar-height);
  padding: 0 var(--space-7);
  background: var(--surface-1);
  border-bottom: 1px solid var(--border-subtle);
  backdrop-filter: saturate(140%) blur(8px);
}
.topbar__brand { display: inline-flex; align-items: center; gap: var(--space-4); font: 600 var(--fs-md)/1 var(--font-title); color: var(--text-primary); text-decoration: none; }
.topbar__nav   { display: flex; gap: var(--space-2); flex: 1; }
.topbar__link  { padding: 8px 12px; border-radius: var(--radius-md); font-size: var(--fs-base); color: var(--text-secondary); text-decoration: none; }
.topbar__link:hover { background: var(--action-hover-bg); color: var(--text-primary); }
.topbar__link.is-active { background: var(--action-selected-bg); color: var(--color-secondary); font-weight: var(--fw-medium); }
.topbar__actions { display: flex; align-items: center; gap: var(--space-4); }
```

### 11.5 Side navigation (collapsible)

```html
<aside class="sidenav">
  <button class="sidenav__item is-active"><span class="material-symbols-rounded">chat_bubble</span><span>Conversations</span></button>
  <button class="sidenav__item"><span class="material-symbols-rounded">smart_toy</span><span>Agents</span></button>
  <button class="sidenav__item"><span class="material-symbols-rounded">storefront</span><span>Marketplace</span></button>
  <button class="sidenav__item"><span class="material-symbols-rounded">account_tree</span><span>Builder</span></button>
  <div class="sidenav__divider"></div>
  <button class="sidenav__item"><span class="material-symbols-rounded">settings</span><span>Settings</span></button>
</aside>
```

```css
.sidenav { width: var(--sidenav-width); padding: var(--space-5); display: flex; flex-direction: column; gap: var(--space-1); border-right: 1px solid var(--border-subtle); background: var(--surface-1); }
.sidenav__item { display: flex; align-items: center; gap: var(--space-5); height: var(--size-xl); padding: 0 var(--space-5); border-radius: var(--radius-md); border: none; background: transparent; cursor: pointer; color: var(--text-secondary); font: var(--fw-medium) var(--fs-base)/1 var(--font-body); }
.sidenav__item:hover    { background: var(--action-hover-bg); color: var(--text-primary); }
.sidenav__item.is-active{ background: var(--action-selected-bg); color: var(--color-secondary); }
.sidenav__divider { height: 1px; background: var(--border-subtle); margin: var(--space-4) 0; }
```

### 11.6 Avatar

```css
.avatar { display: inline-flex; align-items: center; justify-content: center; border-radius: var(--radius-pill); background: var(--reltio-blue); color: #fff; font-weight: var(--fw-medium); }
.avatar--sm { width: var(--size-lg); height: var(--size-lg); font-size: var(--fs-xs); }
.avatar--md { width: var(--size-xl); height: var(--size-xl); font-size: var(--fs-base); }
.avatar--lg { width: var(--size-2xl); height: var(--size-2xl); font-size: var(--fs-md); }
```

### 11.7 Badge / Tag / Status chip

```css
.tag { display: inline-flex; align-items: center; gap: var(--space-2); padding: 2px var(--space-4); border-radius: var(--radius-pill); font: var(--fw-medium) var(--fs-xs)/1.4 var(--font-body); }
.tag--neutral { background: var(--surface-3); color: var(--text-primary); }
.tag--info    { background: var(--status-info-bg); color: var(--status-info); }
.tag--success { background: var(--status-success-bg); color: var(--status-success); }
.tag--warning { background: var(--status-warning-bg); color: var(--status-warning); }
.tag--error   { background: var(--status-error-bg); color: var(--status-error); }

/* Notification dot (top-right of icon) */
.dot { position: absolute; top: 4px; right: 4px; width: 6px; height: 6px; border-radius: var(--radius-pill); background: var(--status-error); box-shadow: 0 0 0 2px var(--surface-1); }
```

### 11.8 Modal / Drawer

```css
.scrim { position: fixed; inset: 0; background: rgba(0, 0, 51, 0.5); z-index: 50; }
.modal { position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); width: min(560px, 92vw); max-height: 86vh; overflow: auto; background: var(--surface-1); border-radius: var(--radius-lg); box-shadow: var(--shadow-overlay); padding: var(--space-7); z-index: 51; }
.modal__header { display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-6); }
.modal__title  { font: 600 var(--fs-xl)/1.3 var(--font-title); }
.modal__footer { display: flex; justify-content: flex-end; gap: var(--space-4); margin-top: var(--space-7); padding-top: var(--space-6); border-top: 1px solid var(--border-subtle); }

.drawer { position: fixed; top: 0; right: 0; bottom: 0; width: var(--rightpanel-width); background: var(--surface-1); border-left: 1px solid var(--border-subtle); box-shadow: var(--shadow-overlay); z-index: 51; padding: var(--space-7); overflow: auto; }
```

### 11.9 Chat (Agentflow Conversation UI)

```html
<div class="chat">
  <div class="chat__msg chat__msg--user">
    <div class="bubble bubble--user">Find duplicate organizations created in the last 7 days.</div>
  </div>
  <div class="chat__msg chat__msg--agent">
    <div class="avatar avatar--sm" style="background:#0000CC">AF</div>
    <div class="bubble bubble--agent">
      I found <strong>14 likely duplicates</strong> across 3 sources. Want me to open them in Match IQ?
      <div class="bubble__actions">
        <button class="btn btn--secondary btn--sm">Open in Match IQ</button>
        <button class="btn btn--text btn--sm">Show details</button>
      </div>
    </div>
  </div>
</div>

<div class="chat-dock">
  <div class="input-group">
    <input class="input" placeholder="Ask Agentflow…">
  </div>
  <button class="icon-btn" aria-label="Attach"><span class="material-symbols-rounded">attach_file</span></button>
  <button class="icon-btn" aria-label="Voice"><span class="material-symbols-rounded">mic</span></button>
  <button class="btn btn--primary"><span class="material-symbols-rounded">send</span></button>
</div>
```

```css
.chat { display: flex; flex-direction: column; gap: var(--space-7); padding: var(--space-7); max-width: 800px; margin: 0 auto; }
.chat__msg { display: flex; gap: var(--space-5); align-items: flex-start; }
.chat__msg--user { justify-content: flex-end; }
.bubble { padding: var(--space-5) var(--space-6); border-radius: var(--radius-lg); max-width: 76%; line-height: var(--lh-normal); }
.bubble--user  { background: var(--color-primary); color: #fff; border-bottom-right-radius: var(--radius-sm); }
.bubble--agent { background: var(--surface-2); color: var(--text-primary); border-bottom-left-radius: var(--radius-sm); }
.bubble__actions { display: flex; gap: var(--space-4); margin-top: var(--space-5); }
.chat-dock { position: sticky; bottom: 0; display: flex; gap: var(--space-4); padding: var(--space-5) var(--space-7); background: var(--surface-1); border-top: 1px solid var(--border-subtle); }
```

### 11.10 Tool-call card (Agentflow Tool call v2)

```html
<div class="tool-call">
  <div class="tool-call__head">
    <span class="material-symbols-rounded">build</span>
    <span class="tool-call__name">match_iq.search</span>
    <span class="tag tag--success">success</span>
    <span class="tool-call__time">1.2s</span>
    <button class="icon-btn icon-btn--sm" aria-label="Expand"><span class="material-symbols-rounded">keyboard_arrow_down</span></button>
  </div>
  <pre class="tool-call__body t-mono">{
  "entity_type": "Organization",
  "since": "P7D",
  "threshold": 0.85
}</pre>
</div>
```

```css
.tool-call { background: var(--surface-2); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); margin: var(--space-5) 0; }
.tool-call__head { display: flex; align-items: center; gap: var(--space-4); padding: var(--space-4) var(--space-5); }
.tool-call__name { font-family: 'JetBrains Mono', ui-monospace, monospace; font-size: var(--fs-sm); color: var(--text-primary); }
.tool-call__time { margin-left: auto; font-size: var(--fs-xs); color: var(--text-secondary); }
.tool-call__body { padding: var(--space-5); border-top: 1px dashed var(--border-subtle); margin: 0; font-size: var(--fs-sm); color: var(--text-primary); white-space: pre; overflow: auto; }
```

### 11.11 Table (data-dense)

```css
.table { width: 100%; border-collapse: collapse; font-size: var(--fs-sm); }
.table th, .table td { padding: var(--space-5) var(--space-6); text-align: left; border-bottom: 1px solid var(--border-subtle); }
.table thead th { background: var(--surface-2); font-weight: var(--fw-medium); color: var(--text-secondary); position: sticky; top: 0; }
.table tbody tr:hover { background: var(--action-hover-bg); }
.table tbody tr.is-selected { background: var(--action-selected-bg); }
```

### 11.12 Empty state

```html
<div class="empty">
  <span class="material-symbols-rounded empty__icon">inventory_2</span>
  <h3 class="t-h3">No agents yet</h3>
  <p class="t-body" style="color:var(--text-secondary)">Create your first agent or browse the marketplace.</p>
  <div style="display:flex;gap:var(--space-4);justify-content:center;margin-top:var(--space-6)">
    <button class="btn btn--primary">Create agent</button>
    <button class="btn btn--secondary">Browse marketplace</button>
  </div>
</div>
```

```css
.empty { text-align: center; padding: var(--space-10) var(--space-7); }
.empty__icon { font-size: 56px; color: var(--text-secondary); margin-bottom: var(--space-6); }
```

### 11.13 Skeleton loader

```css
.skeleton { background: linear-gradient(90deg, var(--surface-2) 0%, var(--surface-3) 50%, var(--surface-2) 100%); background-size: 200% 100%; animation: skel 1.4s ease-in-out infinite; border-radius: var(--radius-sm); }
@keyframes skel { 0% { background-position: 200% 0 } 100% { background-position: -200% 0 } }
```

---

## 12. Layout patterns — App shell

```html
<div class="app">
  <header class="topbar">…</header>
  <div class="app__body">
    <aside class="sidenav">…</aside>
    <main class="content">…</main>
    <aside class="rightpanel">…</aside>  <!-- optional -->
  </div>
</div>
```

```css
.app { min-height: 100vh; display: flex; flex-direction: column; }
.app__body { flex: 1; display: grid; grid-template-columns: var(--sidenav-width) 1fr auto; min-height: 0; }
.content { padding: var(--space-7) var(--space-8); overflow: auto; }
.rightpanel { width: var(--rightpanel-width); border-left: 1px solid var(--border-subtle); background: var(--surface-1); padding: var(--space-7); overflow: auto; }

@media (max-width: 1024px) {
  .app__body { grid-template-columns: var(--sidenav-collapsed) 1fr; }
  .rightpanel { display: none; }
}
```

---

## 13. Page anatomy by Agentflow product

These ten products all share the same app shell (top bar + side nav). The content region is what changes.

| Product | Figma | Content layout |
|---|---|---|
| **Conversation UI** | [link](https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=1076-112256) | Centered chat thread (max-width 800px) + sticky chat dock at bottom. No right panel. |
| **Tool call v2** | [link](https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=7627-104523) | Same as Conversation UI; tool-call cards rendered inline between user / agent bubbles. Expandable JSON body. |
| **Settings UX** | [link](https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=1076-117122) | Two-column inside the content area: 240px settings rail (categories) + form pane on the right. Each settings page is a vertically stacked set of cards or a single long form with section headings. |
| **Bring your own LLM** | [link](https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=4730-197152) | Stepper or single-form card with provider selector → credentials → model parameters. Uses primary-button pattern for "Test connection" and "Save". |
| **Long running task** | [link](https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=1076-117124) | Status banner at top of conversation; expandable progress card showing steps; resumable timeline with status chips (running, success, failed, skipped). |
| **Marketplace** | [link](https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=1076-135848) | Filter rail (left, 240px) + 3-up card grid (auto-fill `minmax(280px, 1fr)`). Each card uses `.card--interactive` with agent icon, name, vendor, tags, install button. |
| **Conversation Sharing** | [link](https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=4179-230549) | Modal launched from the conversation header. Includes link, permission select (Viewer/Editor), people picker, "Anyone with the link" toggle. |
| **Billing Dashboard** | [link](https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=4219-191034) | KPI tile row at top (4-up), usage chart (line/bar), invoice table below. Uses `.card` for each KPI. |
| **Builder** | [link](https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=5828-116636) | Full-bleed canvas (node graph) in the center, top toolbar (zoom, undo/redo, run), right-side properties panel (`.drawer` pattern, persistent). Use a CSS grid background for the canvas. |
| **Admin page** | [link](https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=7222-154988) | Tabs at top of content (Users, Roles, Audit, Settings) + filter row + data table below. Right-side drawer for row details. |

### Common content-region patterns

- **Page header:** `.t-h1` title + 1-line description in `--text-secondary` + right-aligned action buttons. Followed by a 24px gap before the first card/table.
- **Section divider:** 24px top padding, `.t-overline` label, content below. No horizontal rule unless really needed.
- **Filters:** sit in a horizontal row above tables/grids; use `.btn--secondary` for filter chips with a count badge inside.

---

## 14. Accessibility (WCAG 2.1 AA)

- **Contrast:** body text on `--surface-1` passes AAA (`#0E0E25` on white = 17:1). Secondary text passes AA. Don't put text smaller than 12px on any non-decorative surface.
- **Focus:** every interactive element must show `--focus-ring` on `:focus-visible`. Don't remove outlines without replacing them.
- **Touch targets:** desktop minimum 32×32; mobile minimum 44×44. Use `--size-xl` (40) as the comfortable default.
- **Keyboard nav:** modals trap focus; escape closes; first focus lands on the close button or first input. Side nav, tabs, and segmented controls support arrow-key navigation.
- **Motion:** respect `prefers-reduced-motion: reduce` — disable skeleton shimmer, slide-ins, and any decorative animation.
- **Forms:** every `.input` has a programmatic label (use `<label>` or `aria-label`). Errors use `aria-invalid="true"` + an `aria-describedby` pointing at `.field__error`.
- **Icons:** decorative icons get `aria-hidden="true"`; meaningful ones get `aria-label` on the parent button.

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
  .skeleton { animation: none; background: var(--surface-2); }
}
```

---

## 15. Microcopy / Voice

- **Sentence case** for buttons, menu items, and labels: "Create agent" not "Create Agent."
- **Verb-first** for primary actions: "Save changes," "Delete agent," "Run task."
- **Concise hints**: 1 short sentence, no period inside placeholders.
- **Error messages**: state what happened + what to do. "Couldn't reach the model. Check the API key and try again."
- **Empty states**: lead with the user value, not the empty fact. "Build your first agent" beats "No agents."
- **No emoji** in production microcopy.
- **No exclamation marks.**

---

## 16. Do / Don't

**Do**

- Use `data-theme="dark"` on `<html>` to switch themes; never hardcode colors per component.
- Anchor the wave background **bottom-right** at the page level.
- Use Material Symbols Rounded for icons; default size = `--size-md` (24).
- Keep cards on `--surface-1` with a 1px `--border-subtle` and `--shadow-1`.
- Use `--space-7` (24) as the default card padding and `--space-8` (32) between cards.
- Use Libre Franklin only for headings (h1–h4 + display).
- Show loading state via skeleton blocks, not a spinner overlay (unless full-page).
- Render numerical/tabular data in `font-variant-numeric: tabular-nums`.

**Don't**

- Don't introduce new colors. If you need a state color, pull from the status palette.
- Don't tile or recolor the wave SVG.
- Don't use Material Symbols Outlined or Sharp — Reltio uses **Rounded**.
- Don't use heavy box-shadows; surfaces stay flat.
- Don't mix typefaces beyond Libre Franklin + Roboto (and JetBrains Mono / a system mono for code).
- Don't put white text on `--reltio-blue` smaller than 14px (contrast becomes borderline). Use `--reltio-bright-blue` for primary actions; `--reltio-blue` is for branding only.
- Don't put primary CTAs in destructive contexts; use `.btn--danger`.
- Don't use ALL-CAPS except for `.t-overline`.
- Don't use placeholder text as a label.

---

## 17. Quick-start prototype skeleton

A drop-in HTML scaffold that already loads fonts, icons, tokens, theme toggle, wave, and an empty app shell. **Always start from this.**

```html
<!doctype html>
<html lang="en" data-theme="light">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Reltio — Prototype</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Libre+Franklin:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0">
<style>
  /* Paste the full :root + [data-theme="dark"] block from §2 here */

  *, *::before, *::after { box-sizing: border-box; }
  html, body { margin: 0; padding: 0; }
  body {
    font-family: var(--font-body);
    color: var(--text-primary);
    background: var(--bg-page);
    background-image: url('wave-light.svg');
    background-repeat: no-repeat;
    background-position: bottom right;
    background-size: 100% auto;
    background-attachment: fixed;
    min-height: 100vh;
    -webkit-font-smoothing: antialiased;
  }
  [data-theme="dark"] body { background-image: url('wave-dark.svg'); }

  /* Paste any component CSS you need from §11 here */
</style>
</head>
<body>
  <div class="app">
    <header class="topbar">
      <a class="topbar__brand" href="#"><svg width="24" height="24" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10" fill="#000066"/><circle cx="12" cy="12" r="4" fill="#0000CC"/></svg>Reltio</a>
      <nav class="topbar__nav"><a href="#" class="topbar__link is-active">Overview</a></nav>
      <div class="topbar__actions">
        <button class="icon-btn" id="theme-toggle" aria-label="Toggle theme"><span class="material-symbols-rounded">dark_mode</span></button>
      </div>
    </header>
    <div class="app__body">
      <aside class="sidenav"><!-- nav items --></aside>
      <main class="content">
        <!-- prototype content here -->
      </main>
    </div>
  </div>
<script>
  document.getElementById('theme-toggle').addEventListener('click', () => {
    const html = document.documentElement;
    html.dataset.theme = html.dataset.theme === 'dark' ? 'light' : 'dark';
  });
</script>
</body>
</html>
```

---

## 18. Reference URLs

### Design system (active source of truth)
- RDS 3.1 LTS — root: <https://www.figma.com/design/tu2YE7Y6bmgkmcdIqCJpLk/branch/ZWKDuZCQgNMyOl8afscgw0/Reltio-Design-System-3.1--LTS-?m=auto&node-id=18-231>
- Wave (light): <https://www.figma.com/design/tu2YE7Y6bmgkmcdIqCJpLk/Reltio-Design-System-3.1--LTS-?node-id=11224-3093>
- Wave (dark): <https://www.figma.com/design/tu2YE7Y6bmgkmcdIqCJpLk/Reltio-Design-System-3.1--LTS-?node-id=11224-3099>

### Agentflow products that consume RDS 3.1
1. Conversation UI — <https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=1076-112256>
2. Tool call v2 — <https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=7627-104523>
3. Settings UX — <https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=1076-117122>
4. Bring your own LLM — <https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=4730-197152>
5. Long running task — <https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=1076-117124>
6. Marketplace UX — <https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=1076-135848>
7. Conversation Sharing — <https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=4179-230549>
8. Billing Dashboard — <https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=4219-191034>
9. Builder — <https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=5828-116636>
10. Admin page — <https://www.figma.com/design/imWPymQc363zeQShLNzol9/Agentflow-GA?node-id=7222-154988>

---

## Appendix A — Token map (RDS Figma → CSS variable)

| Figma variable | CSS variable | Value (light) |
|---|---|---|
| `primary/Reltio Blue` | `--reltio-blue` | `#000066` |
| `primary/Midnight` | `--reltio-midnight` | `#000033` |
| `primary/main` | `--color-primary` | `#0000CC` |
| `secondary/main` | `--color-secondary` | `#000066` |
| `secondary/_states/hover` | `--color-secondary-hover-bg` | `#0000660A` |
| `secondary/_states/selected` | `--color-secondary-selected-bg` | `#00006614` |
| `action/active` | `--action-active` | `#000033CC` |
| `action/hover` | `--action-hover-bg` | `#0000330A` |
| `Fonts & Icons/Default` | `--text-primary` | `#0E0E25` |
| `text/secondary` | `--text-secondary` | `#00000099` |
| `text/disabled` | `--text-disabled` | `#00000080` |
| `Background/Surface 1` | `--surface-1` | `#FFFFFF` |
| `Background/Surface 3` | `--surface-3` | `#E3E3F2` |
| `Outline-Border/Surface Border 3` | `--border-default` | `#BABADE` |
| `error/default` | `--status-error` | `#E33` |
| `_font/family/title` | `--font-title` | `Libre Franklin` |
| `_font/family/body` | `--font-body` | `Roboto` |
| `_font/weight/Regular` | `--fw-regular` | `400` |
| `_font/weight/Medium` | `--fw-medium` | `500` |
| `_font/size/xs` | `--fs-xs` | `12` |
| `_font/size/2xl` | `--fs-3xl` | `32` |
| `space_padding/2` | `--space-1` | `2` |
| `space_padding/4` | `--space-2` | `4` |
| `space_padding/6` | `--space-3` | `6` |
| `space_padding/8` | `--space-4` | `8` |
| `space_padding/12` | `--space-5` | `12` |
| `numbers/max` (radius) | `--radius-pill` | `9999` |

> Tokens not present in Figma vars (e.g. `--fs-md`, `--fs-lg`, `--shadow-2`, dark-theme surfaces) are interpolated to fit the scale and brand. Confirm against Figma when working from a specific frame.

---

## Appendix B — Quick checklist before delivering a prototype

- [ ] Both fonts loaded (Libre Franklin + Roboto)
- [ ] Material Symbols Rounded loaded
- [ ] Full token block from §2 in `:root` and `[data-theme="dark"]`
- [ ] Wave background applied at `<body>` level, light + dark variants
- [ ] App shell uses topbar + sidenav layout (unless prototype is a single-page form/marketing surface)
- [ ] All buttons use a `.btn--*` variant — no ad-hoc styles
- [ ] All icons use Material Symbols Rounded inside `.icon-btn` or with explicit size
- [ ] Theme toggle works
- [ ] Focus states visible everywhere
- [ ] No invented colors, sizes, or fonts
- [ ] Sentence case microcopy, no emoji, no exclamation marks
