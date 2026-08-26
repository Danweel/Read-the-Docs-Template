# What Happens: Script Reference

Detailed, step-by-step explanation of what each script does.
Read this when something unexpected happens during setup.

## `setup.sh`

The main setup script. Run it once after cloning the template
or after running `copy-to-project.sh` in your project.

### What it does (Docs-Only vers.):

1. **Checks prerequisites**
    - Python 3, Git, and either
   `requirements.txt` or `pyproject.toml` must exist.
2. **Checks for placeholders**
    - 'greps' (searches for) `conf.py` and `pyproject.toml` for `[PLACEHOLDER]` patterns.
    - Warns you and asks if you want to continue anyway.
3. **Sets up Git identity**
    - if `git config --global user.name` is empty, prompts you to enter a name and email.
    - Sets them globally.
4. **Installs dependencies**
    - auto-detects the best path:
        - If Poetry is installed AND `pyproject.toml` exists → `poetry install`
        - Otherwise → `pip install -r requirements.txt`
5. **Offers clean build**
    - **1**: delete old `docs/_build/`
    - **2**: keep it (default)
6. **Builds the docs**
    - runs `sphinx-build -b html docs/source docs/_build/html`
7. **Prints next steps**
    - tells you where to edit, how to rebuild, how to run live preview.

### What it does (Package vers.):

1. **Checks prerequisites**
    - Python 3, Git, Poetry.
2. **Installs Poetry**
    - If not found, downloads and runs the official installer. Adds `~/.local/bin` to PATH for the session.
3. **Checks `pyproject.toml`**
    - Must exist in the project root.
4. **Checks for placeholders**
    - `greps` (searches) `pyproject.toml` for patterns like `[PROJECTNAME]`, `[PACKAGENAME]`, `[DESCRIPTION]`, `[EMAIL]`.
5. **Checks `src/[PACKAGENAME]`**
    - which warns if the package directory still has the placeholder name.
6. **Sets up Git identity**
    - Same as Docs-Only.
7. **Creates Poetry venv**
    - using `poetry env use python3`.
8. **Generates lock file**
    - runs `poetry lock`.
9. **Asks which toolset**:
    - **1**: `docs` only → lighter, just Sphinx + theme
    - **2**: Full `dev` → adds `ruff`, `pytest`, `pytest-cov`
10. **Offers clean build**
11. **Installs dependencies**
    - runs `poetry install --extras <group>`
12. **Builds the docs**
    - runs `poetry run sphinx-build -b html ...`
13. **Prints next steps**
    - Includes `dev` commands if you chose option 2.

## `live_preview.sh`

Starts `sphinx-autobuild` which:
- Builds the docs to a temporary directory
- Opens `http://localhost:8000` in your default browser
- Watches all files in `docs/source/` for changes
- Rebuilds automatically when you save a file
- Shows build errors in the terminal in real time

Stop it with `Ctrl+C`. No cleanup needed — it writes to a temp folder.

**Package template:** runs inside the Poetry venv via
`poetry run sphinx-autobuild`.
**Docs-Only template:** runs with the system or venv Python.

---

## `copy-to-project.sh`

Copies the docs infrastructure from this template into an existing
project. Use this when you already have a project and want to add
documentation to it.

### What it does:

```bash
./copy-to-project.sh /path/to/target
./copy-to-project.sh /path/to/target --full
./copy-to-project.sh /path/to/target --dry-run
./copy-to-project.sh /path/to/target --force
```

### What it copies (essential, always):

| File | Target Location | Notes |
| --- | --- | --- |
| `docs/` (entire folder) | `target/docs/` | Includes `conf.py`, `index.rst`, `guide/`, `_static/` |
| `.readthedocs.yaml` | `target/.readthedocs.yaml` | RTD build config |
| `setup.sh` | `target/setup.sh` | Made executable |
| `live_preview.sh` | `target/live_preview.sh` | Made executable |

#### Docs-Only only:
| File | Target Location | Notes |
| --- | --- | --- |
|`requirements.txt` | `target/requirements.txt` | Auto-generated deps |
| `pyproject.toml` | `target/pyproject.docs.toml` | Reference only — rename to `pyproject.toml` if you want Poetry |

#### Package vers. only:
| File | Target Location | Notes |
| --- | --- | --- |
| `src/` (entire folder) | `target/src/` | Contains [PACKAGENAME] placeholder — rename after install | `pyproject.toml` | `target/pyproject.toml` | If one exists, copies as `pyproject.template.toml`, rename to `pyproject.toml` |

### What it copies (--full only):

| File | Target Location | Notes |
| --- | --- | --- |
| `.github/` | `target/.github/` | Pages workflow |
| `.gitignore` | `target/.gitignore` | Skips if one exists (warns you to merge) |
| `README_template.md` | `target/README_template.md` | Skips if `README.md` exists |
| `CONTRIBUTING_template.md` | `target/CONTRIBUTING_template.md` | Skips if `CONTRIBUTING.md` already exists |
| `CODE_OF_CONDUCT.md` (Package only) | `target/CODE_OF_CONDUCT.md` | Skips if `CONTRIBUTING.md` already exists

#### What none of the commands copy:

- `WHAT_HAPPENS.md` (this file)
- `TEMPLATE_COMPARISON.md`
- `TROUBLESHOOTING_SETUP.md`
- `CHANGELOG_template.md`
- `copy-to-project.sh` itself

These are template-repo reference files, you don't need them in your repo.

- `dry-run` shows exactly what would be copied without writing anything. Safe to run first:
```
--dry-run
```

- `force` overwrites existing files without asking. Use with caution.

```
--force
```
## How the Files Work Together
```
You clone the template (or, run copy-to-project.sh)
    │
    ▼
setup.sh
    ├── Checks Python, Git, Poetry
    ├── Finds and warns about [PLACEHOLDERS]
    ├── Installs dependencies
    └── Builds docs (first build)
    │
    ▼
You edit files in docs/source/
    │
    ▼
live_preview.sh
    ├── Watches docs/source/ for changes
    ├── Rebuilds on every save
    └── Shows errors in terminal
    │
    ▼
You're happy → push to GitHub
    │
    ├── 'Read the Docs' picks up the push → builds & hosts
    └── 'GitHub Actions' picks up the push → deploys to Pages
```
- `setup.sh` is one-time
- `live_preview.sh` is daily.

You run `setup.sh` once to get the environment working. After that, you just run `live_preview.sh` every time you want to write and preview.

#### To rebuild without the live server:
```
# Docs-Only:
python3 -m sphinx -b html docs/source docs/_build/html
```
```
# Package:
poetry run sphinx-build -b html docs/source docs/_build/html
```