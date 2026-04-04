# SysML2 Workflow — Edit → Validate → Render → Build

This document describes the end-to-end workflow for authoring, validating, rendering, and publishing SysML2 model artifacts in this repository.

---

## Workflow Overview

```
 ┌──────────┐    ┌──────────────┐    ┌────────────────┐    ┌────────────┐
 │  Edit    │───►│  Validate    │───►│  Render        │───►│  Build     │
 │ .sysml   │    │  model files │    │  diagrams      │    │  docs      │
 └──────────┘    └──────────────┘    └────────────────┘    └────────────┘
     │                  │                    │                    │
  VS Code           scripts/            scripts/            scripts/
  or editor     validate-model      render-diagrams        build-docs
```

Each step is implemented as a standalone shell script in `scripts/` and as a VS Code task in `.vscode/tasks.json`. The same scripts are invoked by GitHub Actions on every push and pull request.

---

## Step 1: Edit

**Tool:** VS Code (recommended) or any text editor
**Files:** `model/*.sysml`, `model/views/*.sysml`

Model artifacts are plain-text SysML2 files. There is no GUI modeling tool required. Authors edit files directly and commit changes to a Git branch.

The recommended VS Code extensions (`.vscode/extensions.json`) provide:
- Syntax highlighting for `.sysml` files (when a SysML2 extension is available)
- Markdown preview for documentation files
- GitLens for change tracking

---

## Step 2: Validate

**Script:** `scripts/validate-model`
**VS Code Task:** Validate Model

The validate script checks that all expected model files are present and well-formed. Currently it performs a file-existence check and echoes what would be validated.

**TODO:** Replace the file-existence check with a real SysML2 validator invocation (e.g., the SysML2 Pilot Implementation CLI or another conformance checker).

A non-zero exit code from the validate script causes the GitHub Actions `validate.yml` workflow to fail, blocking the PR.

---

## Step 3: Render

**Script:** `scripts/render-diagrams`
**VS Code Task:** Render Diagrams
**Output:** `generated/diagrams/*.svg`

The render script reads the model and view definitions and generates SVG diagrams. Currently it generates placeholder SVGs with visible labels so that documentation renders immediately.

**TODO:** Replace placeholder SVG generation with calls to a real SysML2 rendering tool (e.g., the SysML2 Pilot Implementation CLI, PlantUML bridge, Graphviz, or a custom renderer).

Generated SVGs are committed to the repository in `generated/diagrams/` so that documentation is always renderable without running the script locally.

---

## Step 4: Build Docs

**Script:** `scripts/build-docs`
**VS Code Task:** Build Docs
**Output:** `generated/docs/index.html`

The build-docs script assembles Markdown documents and the generated SVG diagrams into a navigable HTML output. Currently it creates a simple HTML index page.

**TODO:** Integrate pandoc (or mkdocs, sphinx, or similar) to produce polished HTML, PDF, and/or docx output from the Markdown sources.

---

## How Model Files, Views, Diagrams, and Docs Relate

```
model/
  requirements.sysml  ─────────────────────────────────► (referenced in docs)
  context.sysml       ──► model/views/context-view.sysml
  workflow.sysml      ──► model/views/artifact-flow-view.sysml

model/views/
  context-view.sysml         ──► generated/diagrams/context.svg
  artifact-flow-view.sysml   ──► generated/diagrams/artifact-flow.svg

generated/diagrams/
  context.svg         ──► embedded in docs/overview.md
  artifact-flow.svg   ──► embedded in docs/overview.md

docs/
  overview.md         ──► rendered in GitHub / VS Code preview / HTML export
  workflow.md         ──► rendered in GitHub / VS Code preview / HTML export
```

---

## GitHub PR Review as V&V

The GitHub pull request process serves as the formal Verification & Validation gate:

1. **AI agent** (or any author) creates a feature branch and drafts model artifacts
2. **Author** opens a Pull Request targeting `main`
3. **GitHub Actions** automatically runs `validate-model`, `render-diagrams`, and `build-docs`
   - If any script fails (non-zero exit), the PR is blocked
4. **Human Reviewer (V&V role)** reviews:
   - The `.sysml` model diffs for correctness and completeness
   - The rendered SVG diagrams (visible in the PR diff and in `generated/diagrams/`)
   - The updated documentation in `docs/`
5. **Reviewer approves** the PR, triggering merge to `main`

This process ensures that no model change reaches `main` without human review of both the text artifact and the rendered output.

---

## Running the Full Pipeline

```bash
# From the repository root:
scripts/validate-model   # Step 2: Validate
scripts/render-diagrams  # Step 3: Render
scripts/build-docs       # Step 4: Build

# Or use the VS Code "Build All" task which runs them in sequence.
```
