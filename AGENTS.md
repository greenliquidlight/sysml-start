# Agent Instructions — sysml-start

This repository uses a **text-first, docs-as-code** SysML2 modeling workflow in which AI agents
draft artifacts and humans approve them via GitHub pull requests. Read this file before making
any changes.

For project goals, stakeholder roles, and the rendering pipeline see
[docs/overview.md](docs/overview.md).
For the full edit → validate → render → build workflow see
[docs/workflow.md](docs/workflow.md).

---

## Your Role

You are the **AI Agent** stakeholder described in `docs/overview.md`. Your job is to draft model
artifacts, views, and documentation on a feature branch. A human V&V Reviewer approves changes
via GitHub PR before anything reaches `main`.

**Never push directly to `main`.** Always work on a `feature/<topic>` branch.

---

## Repository Layout

```
model/          ← SysML2 source files (edit these)
model/views/    ← view definitions (edit these)
docs/           ← Sphinx Markdown sources (edit these)
generated/      ← rendered output (SVGs + HTML); commit after rendering
scripts/        ← toolchain scripts (do not edit unless fixing the toolchain)
tools/          ← downloaded/compiled artifacts; mostly gitignored
.github/        ← CI workflows (do not edit unless fixing CI)
```

---

## Workflow

See [docs/workflow.md](docs/workflow.md) for the full description. In brief:

1. **Edit** — modify `.sysml` files in `model/` or `model/views/`
2. **Validate** — `scripts/validate-model` (must pass before opening a PR)
3. **Render** — `scripts/render-diagrams` (commit updated SVGs in `generated/diagrams/`)
4. **Build** — `scripts/build-docs` (commit updated HTML in `generated/docs/`)
5. **Open PR** — targeting `main`; CI re-runs steps 2–4 automatically

---

## Toolchain Rules

Always use the project scripts. Never invoke raw tools directly.

| Task | Command |
|------|---------|
| Install prerequisites | `scripts/setup-tools` |
| Validate model | `scripts/validate-model` |
| Render diagrams | `scripts/render-diagrams` |
| Build docs | `scripts/build-docs` |
| Local preview | `scripts/preview-docs` |

Do **not** run `pip install`, `sphinx-build`, `javac`, `dot`, etc. directly. Those are internal
to the scripts, which manage dependencies and error reporting.

---

## Before Every Commit

**Always run the full test pipeline and confirm all four exit 0 before staging a commit:**

```
scripts/validate-model
scripts/render-diagrams
SETUP_DOCS_DEPS=1 scripts/setup-tools
scripts/build-docs
```

---

## What a Valid PR Looks Like

- All `.sysml` files parse cleanly (`scripts/validate-model` exits 0)
- `generated/diagrams/` contains up-to-date SVGs matching the current model
- `generated/docs/` contains an up-to-date HTML build with no Sphinx warnings
- Commit messages are clear and describe *what changed and why*
- One logical change per PR; do not bundle unrelated edits

---

## Adding a New Diagram

1. Create `model/views/<name>-view.sysml`
2. Add a `%viz <Element>` command and output path to `scripts/render-diagrams`
3. Add a Markdown image reference in the appropriate `docs/*.md` file
4. Run `scripts/render-diagrams` and commit the new SVG
5. Run `scripts/build-docs` and commit the updated HTML

---

## Branch Conventions

| Branch | Purpose |
|--------|---------|
| `main` | Stable; GitHub Pages deploys on every push |
| `feature/<topic>` | Work branches; CI validates but does not deploy |

Rebase onto `main` before opening a PR; do not merge `main` into feature branches.
