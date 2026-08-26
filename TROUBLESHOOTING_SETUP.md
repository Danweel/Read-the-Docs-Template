# Troubleshooting: Setup & Initial Build

If you're stuck here, your docs probably aren't building yet.
Work through these in order.

---

## "`Permission denied`" When Running Scripts

Scripts need the `execute bit` set. From the project root, open a terminal and paste:

```bash
chmod +x setup.sh copy-to-project.sh live_preview.sh
```

If you cloned from GitHub this shouldn't be an issue, but it can happen after copying files manually or on some filesystems.

## Python Not Found
Open a terminal and type:
```
python3 --version
```

Must be **3.11 or higher**. If not installed or too old copy and paste into the terminal:

- Linux (**Debian/Ubuntu**): `sudo apt install python3 python3-venv python3-pip`
- **macOS**: `brew install python`
- **Windows**: Download from python.org (check "`Add to PATH`" during install)

However, the `.sh` files should help you install this correctly - if the installer didn't do this for you, please open an issue letting me know. However, you can continue to troubleshoot to start your docs even without the install scripts.

## Git Not Found

- **Linux**: `sudo apt install git`
- **macOS**: `brew install git`
- **Windows**: `Download from git-scm.com`

However, the `.sh` files should help you install this correctly - if the installer failed for you, please open an issue letting me know. However, you can continue to troubleshoot to start your docs even without the install scripts.

## Poetry Not Found (Package Template Only)

The Package template's `setup.sh` will auto-install Poetry if it's missing. If it fails, paste this into the terminal:
```
# Manual install
curl -sSL https://install.python-poetry.org | python3 -

# Add to PATH (if not already there)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Docs-Only template**: Poetry is optional. The script (should) fall back to `pip` if Poetry isn't available.

Open an issue if this isn't the case to let me know this part broke.

## "`Neither requirements.txt nor pyproject.toml found`" (Docs-Only)

You're running `setup.sh` in the wrong directory. Make sure you're in the project root — the same directory that contains `docs/`.

- Open a terminal and paste:

```
ls
# The terminal should return: `docs/  requirements.txt  pyproject.toml  setup.sh`
```

If you used `copy-to-project.sh` to install into an existing project, `cd` into that project first.

## Placeholders Still Present

`setup.sh` checks for [PLACEHOLDER] patterns before proceeding. Common placeholders to find and replace:

| File | Placeholder | Replace With |
| --- | --- | --- |
| `docs/source/conf.py`	| `[PROJECT NAME]` | Your project's display name |
| `docs/source/conf.py`	| `[AUTHOR NAME]` | Your name |
| `docs/source/conf.py`	| `[USERNAME]` | Your GitHub username |
| `docs/source/conf.py`	| `[REPO-NAME]` | Your repo name (lowercase) |
| `pyproject.toml` | `[PROJECT-SLUG]` | `your-project-slug` |
| `pyproject.toml` | `[DESCRIPTION]` | One-line description |
| `pyproject.toml` | `[YOUR NAME]` | Your name |
| `pyproject.toml` | `[EMAIL]` | Your email |
| `pyproject.toml` | `[LICENSE]` | MIT, CC-BY-SA-4.0, etc. |
| `pyproject.toml` (Package vers.) | `[PACKAGENAME]` | `your_package_name` |

Search for all of them via:
```
grep -r "\[" --include="*.py" --include="*.toml" --include="*.yaml" .
```

## "`Key ... already exists`" (Poetry)

Your `pyproject.toml` has a duplicate dependency entry. Open the file and look for the package name listed twice. Remove one.

```
# Find duplicates:
grep -i "sphinx" pyproject.toml | sort | uniq -d
```
## "`Invalid TOML file`"

Syntax error in `pyproject.toml`. Common causes:

- Missing comma between list items
- Mixed quote styles (backticks instead of ")
- Unclosed brackets `[` or `{`
- A section header like `[tool.poetry]` with a leading space

Run poetry check to get the exact line number.


## "`ModuleNotFoundError: No module named 'XXX'`"

A dependency isn't installed. Re-run either:

```
# Docs-Only (pip path):
pip3 install -r requirements.txt
```
or

```
# Docs-Only (Poetry path) or Package vers.:
poetry install
```

If `poetry install` succeeds but you **still** get the error, you might be running Python outside the virtual environment (happens to me all the time):

```
# Check which Python you're using:
which python3

# The response should point to the venv, not /usr/bin/python3
```
Activate the `venv`:
```
# Docs-Only (pip):
source .venv/bin/activate
# Package (Poetry):
poetry shell
```

## "`extension not found`" Error

The extension is in `conf.py` but the package isn't installed. Check:

- `docs/source/conf.py` → `extensions =` [...] lists the extension
- `pyproject.toml` → the corresponding package is in the dependencies

The names often differ, for example:

| Extension in `conf.py` | Package in `pyproject.toml` |
| --- | --- |
| `sphinx_copybutton` | `sphinx-copybutton` |
| `myst_parser` | `myst-parser` |
| `notfound.extension` | `sphinx-notfound-page` |
| `sphinx_favicon` | `sphinx-favicon` |

Full checklist is at the bottom of `pyproject.toml`.

## Build Fails on Read the Docs

Check your `.readthedocs.yaml` in the repo root - it should say this:

```
version: "2"

build:
  os: ubuntu-22.04
  tools:
    python: "3.12"        # Must match requires-python in pyproject.toml

sphinx:
  configuration: docs/source/conf.py

python:
  install:
    - requirements: requirements.txt   # Docs-Only
    # - method: pip
    #   path: .                        # Package (installs your package)
    #   extra_requirements:
    #     - docs
```

Common RTD issues:

- Python version mismatch → update `tools.python`
- Missing `requirements.txt` → regenerate with `poetry export`
- `docs/` in wrong location → check `sphinx.configuration` path

## GitHub Pages Deployment Fails

Check `.github/workflows/pages-deploy.yml`:

- Workflow has triggered (check the Actions tab)
- Repo Settings → Pages → Source is "GitHub Actions"
- The workflow deploys to the `gh-pages` branch
- The build step uses the correct `sphinx-build` command

If the workflow never runs, check:

- The branch in the workflow's on.push.branches matches your default
- The workflow file is in .github/workflows/ (not .github/Workflows/)


## When All Else Fails, Reset:
```
# Nuke everything and start clean:
rm -rf docs/_build/
rm -rf .venv/
rm -rf __pycache__/
rm -rf src/__pycache__/          # Package template only
rm poetry.lock                    # Package template only

# Re-run setup from scratch:
./setup.sh
```

## Still Stuck?

Open an issue on the template's repo with:

- Your OS and Python version
- Which template ("Docs-Only" or "Package", though try to use the right repo)
- The exact error message (copy>paste, not paraphrased)
- Which step failed for you (`setup.sh`, `live_preview.sh`, Read-the-Docs build, 'Github Pages' deploy)
