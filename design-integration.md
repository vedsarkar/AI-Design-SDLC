# Design Integration

> **Status:** Draft
> **Owner:** TBD
> **Last updated:** 2026-04-28

---

## 1. Purpose

This document describes how design tooling (Figma, Pencil) integrates with the
Reltio AI SDLC pipeline and how designs flow into production code — and back.

---

## 2. Scope

| In scope | Out of scope |
|---|---|
| Figma → code (component implementation) | Native mobile / non-web surfaces |
| Code → Figma (push screens back to Figma) | Third-party design tools (Sketch, Adobe XD) |
| Design-system token mapping | Brand / marketing design |
| Code Connect template authoring | Design QA / user research process |

---

## 3. Component Map

| Component | Role | Entry point |
|---|---|---|
| **Figma MCP** (`plugin-figma-figma`) | Read designs, get screenshots, generate Code Connect, write screens back to Figma | `get_design_context`, `use_figma`, `generate_figma_design` |
| **Pencil MCP** (`user-highagency.pencildev-extension-pencil`) | Author and validate `.pen` design files | `batch_get`, `batch_design`, `get_screenshot` |
| **AI SDLC `skills/design/`** | PRD authoring, SDD authoring, architecture capture | Loaded by `pdlc init`; used during `/pdlc:story-design` |
| **Code Connect templates** (`.figma.ts` / `.figma.js`) | Map Figma components to codebase components so `get_design_context` returns real code | `figma-code-connect` skill |
| **Design-system rules** (`.cursor/rules/`) | Enforce token usage, component naming, layout conventions in generated code | `figma-create-design-system-rules` skill |
| **Reltio Open MCP Server** | Surfaces live Reltio data (entities, relations) that designs may need to reflect | `search_entities_tool`, `get_data_model_definition_tool` |

---

## 4. Integration Flows

### 4a. Figma → Code (implement a design)

```
Figma URL (figma.com/design/…)
  │
  ▼
get_design_context (fileKey + nodeId)
  │ returns: code snippet, screenshot, Code Connect hints, design tokens
  ▼
Adapt to project stack
  │ - Replace raw hex with design-system tokens
  │ - Swap generic HTML with project components
  │ - Follow AI SDLC language / testing skills
  ▼
PR via /pdlc:story-pr  →  CI gate via /pdlc:story-gate
```

### 4b. Code → Figma (sync a screen back)

```
Existing page / component in codebase
  │
  ├─ Run figma-generate-design (pixel-perfect screenshot capture)
  │
  └─ Run use_figma + search_design_system (build from design-system instances)
       │
       ▼
  Refine use_figma output to match pixel-perfect layout
  Delete generate_figma_design layer (reference only)
```

### 4c. Design-system setup (new project)

```
Scan codebase for tokens, components, themes
  │  (figma-generate-library skill)
  ▼
Create variables / color modes in Figma
  │  (use_figma + set_variables)
  ▼
Build component library with proper instances and variants
  │
  ▼
Author Code Connect templates (.figma.ts)
  │  so get_design_context returns real component props
  ▼
Generate design-system rules (.cursor/rules/)
  │  so AI follows token + naming conventions in all future code
```

### 4d. Design in the PDLC story lifecycle

```
/pdlc:story-design
  │
  ├─ Reads PRD / story requirements
  ├─ Generates OpenSpec design artifacts (SDD, data-flow, sequence)
  ├─ Optionally runs Figma MCP to capture or reference existing screens
  └─ Posts summaries as Jira comments  →  transitions Jira to "In Design"
```

---

## 5. Prerequisites

| Requirement | Where to configure |
|---|---|
| Figma MCP connected | Cursor Settings → MCP → `plugin-figma-figma` (access token) |
| Pencil MCP connected | Cursor Settings → MCP → `user-highagency.pencildev-extension-pencil` |
| `pdlc init` run in target repo | One-time per repo (installs design skills + slash commands) |
| Code Connect templates authored | Run `figma-code-connect` skill for existing component library |
| Design-system rules generated | Run `figma-create-design-system-rules` skill |
| Reltio Open MCP server running | `bash setup.sh` + `.env` configured (for data-model discovery) |

---

## 6. Source of Truth

| Artefact | Authoritative source | Sync direction |
|---|---|---|
| Design tokens (colors, spacing, type) | Figma variables | Figma → code via Code Connect / CSS variables |
| Component structure | Codebase | Code → Figma via `use_figma` + `figma-generate-design` |
| Data model (entity/relation schema) | Reltio tenant | Reltio MCP → both design and code |
| Story requirements | Jira + OpenSpec | Drives `/pdlc:story-design` |

---

## 7. Open Questions

- [ ] Which Figma file is the master design-system library for Reltio UI?
- [ ] Are design tokens currently exported as CSS variables or Tailwind config?
- [ ] Do Code Connect templates exist for any existing components?
- [ ] Who owns the Figma MCP access token and rotates it?
- [ ] Should `.pen` files be committed to the repo or kept external?

---

## 8. References

- [`reltio-ondemand-ai-sdlc-*/skills/design/`](reltio-ondemand-ai-sdlc-ca6aba6efbad/skills) — PRD, SDD, architecture capture skills
- [`reltio-ondemand-transparent-factory-*/pm/`](reltio-ondemand-transparent-factory-b1601e64ef9c/pm) — Definition of Done, documentation requirements
- [Figma MCP server instructions](https://cursor.directory/mcp/figma)
- [Pencil MCP server instructions](https://cursor.directory/mcp/pencil)
- [Code Connect docs](https://www.figma.com/developers/code-connect)
