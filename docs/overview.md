# sysml-start — Project Overview

A text-first, docs-as-code SysML2 modeling workflow optimized for VS Code and easy onboarding of
systems engineers. Model artifacts live in Git as plain text. Rendered diagrams and a navigable
HTML documentation site are a day-1 capability.

---

## Goals

- Store all model artifacts as plain text files in Git
- Enable editing in VS Code (or any text editor) without a GUI modeling tool
- Render diagrams as SVG on day 1, embedded directly in Markdown documentation
- Support command-line validate / render / build operations
- Enable automated CI validation and doc generation via GitHub Actions
- Structure the repository so an AI agent can draft artifacts and a human can review/approve via pull requests

---

## Stakeholders

| Stakeholder | Role |
|-------------|------|
| Systems Engineer | Authors and reviews model artifacts |
| AI Agent | Drafts model artifacts, views, and documentation |
| V&V Reviewer (Human) | Reviews AI-drafted content via GitHub PR; approves or requests changes |
| Documentation Consumer | Reads rendered HTML docs with embedded diagrams |
| CI System | Automatically validates and builds on every push and pull request |

---

## Artifact Flow

```
Model Files (.sysml)
       │
       ▼
 validate-model script
       │
       ▼
 render-diagrams script ──► generated/diagrams/*.svg
                                       │
                                       ▼
                             build-docs script ──► generated/docs/index.html
                                                   docs/*.md (with embedded SVG links)
```

Model files in `model/` are the source of truth. Views in `model/views/` define which diagram
perspectives are rendered. The `scripts/render-diagrams` script reads the model and view
definitions and produces SVG files. The `scripts/build-docs` script assembles those SVGs and the
Markdown documents into a navigable HTML output.

---

## Rendering Pipeline

```
model/*.sysml + model/views/*.sysml
         │
         │  SysMLInteractive REPL (OMG SysML v2 Pilot JAR)
         │  %viz <element>  →  @startuml...@enduml (PlantUML + sysmlbw skin)
         ▼
  tools/SysMLRender.java  (PlantUML Java API — skin resolved from JAR classpath)
         │
         ▼
generated/diagrams/context.svg
generated/diagrams/artifact-flow.svg
generated/diagrams/requirements.svg
         │
         │  (embedded in docs/workflow.md via Markdown image links)
         ▼
Rendered in VS Code Markdown Preview / GitHub / HTML export
```

The same pipeline applies to each diagram target configured in `scripts/render-diagrams`.
Adding a new rendered diagram requires:

1. Choosing a model element to visualize
2. Adding a `%viz <element>` line and output filename in `scripts/render-diagrams`
3. Embedding the resulting SVG in the appropriate Markdown document

---

## Next Steps

- [ ] Add more model views (e.g., internal block, sequence, state machine)

---

## Acknowledgements

- **[OMG SysML v2 Pilot Implementation](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation)** — the open-source reference implementation of the SysML v2 standard. This project uses the Pilot JAR for model validation and diagram rendering via the `SysMLInteractive` REPL and `%viz` commands.
- **[PlantUML](https://plantuml.com/)** — diagram rendering engine bundled within the Pilot JAR.
- **[GraphViz](https://graphviz.org/)** — graph layout engine used by PlantUML for SVG output.
- **[Sphinx](https://www.sphinx-doc.org/)** with **[MyST Parser](https://myst-parser.readthedocs.io/)** — documentation toolchain used by `scripts/build-docs`.
- **[sphinx-rtd-theme](https://sphinx-rtd-theme.readthedocs.io/)** — Read the Docs theme for Sphinx HTML output.
