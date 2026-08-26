# Which Template Do I Need?

Two templates, one goal: professional documentation on Read the Docs
with a GitHub Pages fallback. The difference is whether you have
Python code to document.



## Quick Decision

| Question | Docs-Only | Package |
|----------|:---------:|:-------:|
| Do you have a Python package to document? | No | Yes |
| Do you need `autodoc` (docstring → docs)? | No | Yes |
| Do you have a CLI tool with argparse? | No | Yes |
| Is your project purely content (prose, images, guides)? | Yes | No |
| Does `pip install .` need to work for your users? | No | Yes |

**If you answered "Yes" to any of the right column** → Package template.

**If you answered "Yes" to any of the left column** → Docs-Only template.

**If you're not sure** → start with Docs-Only.

It's a bit of a pain, but you CAN always add autodoc-type functionality later. For small projects, it's probably not a good idea anyway unless you're practicing.



## Side-by-Side

| Feature | Docs-Only | Package |
|---------|-----------|---------|
| Python package required | No | **Yes** (`src/[package]/`) |
| Install method | `pip` or Poetry | Poetry only |
| `autodoc` / `napoleon` / `viewcode` | Not included | **Included** |
| `sphinxcontrib-autoprogram` (CLI docs) | Not included | **Included** |
| `sphinx-issues` (GitHub issue links) | Not included | **Included** |
| `sphinx-json-schema` | Not included | **Included** |
| `sphinx-version-warning` | **Included** | Not included |
| `sphinx-navtree` | **Included** | Not included |
| `jupinx` (Jupyter notebooks) | **Included** | Not included |
| `src/` directory | No | **Yes** |
| `setup.sh` behavior | Auto-detects Poetry vs pip | Auto-installs Poetry |
| `copy-to-project.sh --full` extra files | README, CONTRIBUTING | README, CONTRIBUTING, CODE_OF_CONDUCT |
| Complexity | Lower | A Little Higher |



## When to Migrate

**Docs-Only → Package:** You wrote your docs, then built a Python
package and want autodoc. Copy your `docs/source/` into the Package
template, add the `src/` structure, update `conf.py` to add the
`sys.path` line and autodoc extensions, and add your package deps. You
can try to use these docs (note the Package vers. details)
to add what's needed, or read Sphinx documentation, which is detailed.

**Package → Docs-Only:** You removed the Python package and just have
docs to manage. Copy `docs/source/` into the Docs-Only template, remove the
`sys.path` line from `conf.py`, remove autodoc extensions, and you're done.

Both migrations are fairly straightforward because the `docs/source/` structure and many tools are identical between templates.



## Shared Infrastructure

#### Both templates share:
- `setup.sh` (interactive setup)
- `live_preview.sh` (sphinx-autobuild)
- `copy-to-project.sh` (install into existing project)
- `.readthedocs.yaml` (RTD config)
- `.github/workflows/pages-deploy.yml` (GitHub Pages)
- Furo + Groundwork themes (both installed, choose one, or use the examples to add diffrent one)
- MyST parser, Mermaid, MathJax, `sphinx-design`, BibTeX, Open Graph, favicons, `hoverxref`, tags, spell-check
- `WHAT_HAPPENS.md` + `TROUBLESHOOTING_SETUP.md`