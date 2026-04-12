# sysml-start

> **Bootstrap SysML2 Modeling Workflow — Proof of Concept**

A text-first, docs-as-code SysML2 modeling workflow optimized for VS Code and easy onboarding of
systems engineers. Model artifacts live in Git as plain text. Rendered diagrams and a navigable
HTML documentation site are a day-1 capability.

📖 **[Full documentation](https://greenliquidlight.github.io/sysml-start/)** — goals, stakeholders, rendering pipeline, and workflow details.

---

## Quick Start

### 1. Open in VS Code

```bash
git clone https://github.com/greenliquidlight/sysml-start.git
cd sysml-start
code .
```

When VS Code opens you will be prompted to install the **recommended extensions** (defined in `.vscode/extensions.json`). Accept the prompt.

### 2. Install Prerequisites

Requires Java 21+, GraphViz, and the OMG SysML v2 Pilot JAR. Run once:

```bash
scripts/setup-tools
```

This installs GraphViz via Homebrew, downloads the OMG kernel ZIP (~85 MB) to `tools/`, and compiles `tools/SysMLRender.java` against the bundled JAR.

### 3. Run Tasks

Open the Command Palette (`Ctrl+Shift+P`) and choose **Tasks: Run Task**, then select:

| Task | What it does |
|------|--------------|
| **Validate Model** | Loads all `.sysml` files into the OMG SysML v2 Pilot REPL and reports any errors |
| **Render Diagrams** | Generates SVG diagrams via `%viz` + PlantUML into `generated/diagrams/` |
| **Build Docs** | Builds a navigable HTML site via Sphinx + MyST into `generated/docs/` |
| **Build All** | Runs Validate → Render → Build in sequence |

Or run the scripts directly:

```bash
scripts/validate-model
scripts/render-diagrams
scripts/build-docs
```

---

## Repository Structure

```
.
├── docs/           ← Sphinx source (overview, workflow, conf.py)
├── model/template/ ← Replaceable SysML2 project model payload
├── model/views/    ← SysML2 view definitions
├── generated/      ← rendered SVGs and built HTML docs (committed)
├── tools/          ← SysMLRender.java + downloaded OMG kernel (gitignored)
├── scripts/        ← validate-model, render-diagrams, build-docs, setup-tools
└── .github/        ← CI workflows (validate, docs + GitHub Pages deploy)
```

---

## License

Apache 2.0 — see [LICENSE](LICENSE) for details.
