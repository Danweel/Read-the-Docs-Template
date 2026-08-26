# Read the Docs Template — Docs-Only

A Sphinx documentation template for writers, illustrators, and researchers
who need professional docs without a Python package.

Hosted on [Read the Docs](https://readthedocs.org) with a GitHub Pages
fallback. Includes some reasonable defaults that you can change: Furo theme, Markdown support, diagrams, citations, spell-checking, and live preview.

---

## Quick Start
### Path A: Start a new project from this template

```bash
git clone https://github.com/Danweel/Read-the-Docs-Template.git my-project
cd my-project
./setup.sh
```

`setup.sh` walks you through filling in placeholders, installing dependencies, and building your first few docs. When it finishes, run:
`./live_preview.sh`

This opens a local preview at `http://localhost:8000` with auto-rebuild.

### Path B: Add docs to an existing project
- From a checkout of this template:
`./copy-to-project.sh /path/to/your-project`

- With all optional files (`.github/`, `.gitignore`, `templates`):
`./copy-to-project.sh /path/to/your-project --full`

Then cd into your project and run `./setup.sh` there.

## Which Template Do I Need?

| Your project... | Use |
| --- | --- |
| Has no Python code (handbook, guide, design doc) | This one (Docs-Only) |
| Has a Python package to document with autodoc	| [Package Template](https://github.com/Danweel/Read-the-Docs-Template-Package) |
| Has a CLI tool you want to auto-document | [Package Template](https://github.com/Danweel/Read-the-Docs-Template-Package) |

See `TEMPLATE_COMPARISON.md` for the full breakdown.

---

## What's Included

- Sphinx 8 with Furo theme (dark/light mode)
- Markdown + reST support via MyST parser
- Live preview with auto-rebuild (`./live_preview.sh`)
- Dual hosting: Read the Docs + GitHub Pages (workflow included)
- Mermaid diagrams, BibTeX citations, MathJax (LaTeX math)
- sphinx-design cards, tabs, and panels
- Spell-checking (sphinxcontrib-spelling + codespell)
- Open Graph cards, custom favicons, 404 page
- Hover cross-references, tag pages, last-updated timestamps

## File Guide

| File | What it does |
| --- | --- |
| `setup.sh` | Interactive setup: fills placeholders, installs deps, builds docs |
| `live_preview.sh` | Starts `sphinx-autobuild` — live reload while you write |
| `copy-to-docs.sh` | Copies docs infra into an existing project (`--full` for more) |
| `WHAT_HAPPENS.md` | Detailed step-by-step of what each script does |
| `TROUBLESHOOTING_SETUP.md` | Fixes for common setup and build errors |
| `TEMPLATE_COMPARISON.md` | Side-by-side comparison of Docs-Only vs Package |
| `requirements.txt` | Auto-generated from `pyproject.toml` — don't hand-edit |
| `pyproject.toml` | Dependency definitions (Poetry groups) |
| `docs/source/conf.py` | All Sphinx configuration (theme, extensions, options) |
| `.readthedocs.yaml`	| Read the Docs build configuration |
| `.github/workflows/` | GitHub Pages deployment automation |

## After Setup

Once `setup.sh` finishes and `live_preview.sh` is running, browse to the Guide section in your local docs for full customization instructions: changing themes, adding extensions, deploying, and more.

## License

https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

CC-BY-SA-4.0 — use it, modify it, share it. Just credit the source.