# GitHub Copilot Instructions — sysml-start

See [AGENTS.md](../../AGENTS.md) for the full agent instructions that apply to this repository.

Key points:
- Work on `feature/<topic>` branches only; never commit directly to `main`
- Test using project scripts (`scripts/validate-model`, `scripts/render-diagrams`, `scripts/build-docs`); do not invoke raw tools directly
- Commit updated `generated/` output (SVGs + HTML) alongside model changes
- All PRs must pass `scripts/validate-model` with exit code 0
