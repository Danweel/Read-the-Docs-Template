#!/usr/bin/env bash
#
# installdocs.sh — Read the Docs Template installer (docs-only edition)
#
# Copies essential docs infrastructure into an existing project.
# Designed for non-coders: employee handbooks, user guides, game design docs, etc.
#
# Usage:
#   ./installdocs.sh /path/to/target-project
#   ./installdocs.sh /path/to/target-project --full
#   ./installdocs.sh /path/to/target-project --dry-run
#   ./installdocs.sh /path/to/target-project --force

set -euo pipefail

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Parse Arguments ────────────────────────────────────────────────────────
TARGET=""
FULL=false
DRY_RUN=false
FORCE=false

for arg in "$@"; do
  case $arg in
    --full)    FULL=true ;;
    --dry-run) DRY_RUN=true ;;
    --force)   FORCE=true ;;
    *)         TARGET="$arg" ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  echo -e "${BOLD}Usage:${NC} ./installdocs.sh /path/to/target-project [options]"
  echo ""
  echo "Options:"
  echo "  --full      Include optional repo-level files (.github/, .gitignore, templates)"
  echo "  --dry-run   Show what would be copied without writing anything"
  echo "  --force     Overwrite existing files without prompting"
  echo ""
  echo "Example:"
  echo "  ./installdocs.sh ~/projects/EmployeeHandbook --full"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── Validate ────────────────────────────────────────────────────────────────
if [[ ! -d "$TARGET" ]]; then
  echo -e "${RED}Error: Target directory '$TARGET' does not exist.${NC}"
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"

if [[ "$TARGET" == "$SCRIPT_DIR" ]]; then
  echo -e "${RED}Error: Cannot install into the template directory itself.${NC}"
  echo -e "Please specify a different target project."
  exit 1
fi

# ─── Helper Functions ───────────────────────────────────────────────────────

copy_file() {
  local src="$1"
  local dest="$2"
  local rel="${src#$SCRIPT_DIR/}"

  if [[ -f "$dest" ]] && [[ "$FORCE" != true ]]; then
    echo -e "  ${YELLOW}⏭  Skip${NC}  $rel (already exists)"
    return 0
  fi

  if [[ "$DRY_RUN" == true ]]; then
    echo -e "  ${BLUE}📋 Would copy${NC}  $rel → ${dest#$TARGET/}"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo -e "  ${GREEN}✓ Copied${NC}  $rel → ${dest#$TARGET/}"
}

copy_dir() {
  local src="$1"
  local dest="$2"
  local rel="${src#$SCRIPT_DIR/}"

  if [[ -d "$dest" ]] && [[ "$FORCE" != true ]]; then
    echo -e "  ${YELLOW}⏭  Skip${NC}  $rel/ (already exists)"
    return 0
  fi

  if [[ "$DRY_RUN" == true ]]; then
    echo -e "  ${BLUE}📋 Would copy${NC}  $rel/ → ${dest#$TARGET/}/"
    return 0
  fi

  mkdir -p "$dest"
  cp -r "$src/"* "$dest/" 2>/dev/null || true
  cp -r "$src/".* "$dest/" 2>/dev/null || true
  echo -e "  ${GREEN}✓ Copied${NC}  $rel/ → ${dest#$TARGET/}/"
}

make_executable() {
  if [[ "$DRY_RUN" != true ]] && [[ -f "$1" ]]; then
    chmod +x "$1"
  fi
}

warn() {
  echo -e "  ${YELLOW}⚠ $1${NC}"
}

WARNINGS=""

# ─── Begin Install ───────────────────────────────────────────────────────────
if [[ "$DRY_RUN" == true ]]; then
  echo -e "${BOLD}DRY RUN — nothing will be written${NC}\n"
else
  echo -e "${BOLD}Installing docs infrastructure into:${NC} $TARGET\n"
fi

# ════════════════════════════════════════════════════════════════════════════
# ESSENTIAL FILES — always copied
# ════════════════════════════════════════════════════════════════════════════
echo -e "${BOLD}Essential docs infrastructure:${NC}"

# 1. docs/ directory (Sphinx source, conf.py, index.rst)
if [[ -d "$SCRIPT_DIR/docs" ]]; then
  copy_dir "$SCRIPT_DIR/docs" "$TARGET/docs"
else
  warn "docs/ directory not found in template — skipping"
fi

# 2. Read the Docs configuration
if [[ -f "$SCRIPT_DIR/.readthedocs.yaml" ]]; then
  copy_file "$SCRIPT_DIR/.readthedocs.yaml" "$TARGET/.readthedocs.yaml"
fi

# 3. Live preview script (shared across both templates now)
if [[ -f "$SCRIPT_DIR/live_preview.sh" ]]; then
  copy_file "$SCRIPT_DIR/live_preview.sh" "$TARGET/live_preview.sh"
  make_executable "$TARGET/live_preview.sh"
fi

# 4. Setup script (environment setup after install)
if [[ -f "$SCRIPT_DIR/setup.sh" ]]; then
  copy_file "$SCRIPT_DIR/setup.sh" "$TARGET/setup.sh"
  make_executable "$TARGET/setup.sh"
fi

# 5. Requirements file (simple pip install, no Poetry needed)
if [[ -f "$SCRIPT_DIR/requirements.txt" ]]; then
  copy_file "$SCRIPT_DIR/requirements.txt" "$TARGET/requirements.txt"
fi

# 6. Pyproject.toml as a reference (don't overwrite existing)
if [[ -f "$SCRIPT_DIR/pyproject.toml" ]]; then
  copy_file "$SCRIPT_DIR/pyproject.toml" "$TARGET/pyproject.docs.toml"
  WARNINGS+="• pyproject.docs.toml placed next to your existing pyproject.toml.\n  Merge the doc-related dependencies into yours, then delete pyproject.docs.toml.\n  If you don't have a pyproject.toml, rename pyproject.docs.toml to pyproject.toml.\n"
fi

# ════════════════════════════════════════════════════════════════════════════
# OPTIONAL FILES — only with --full
# ════════════════════════════════════════════════════════════════════════════
if [[ "$FULL" == true ]]; then
  echo ""
  echo -e "${BOLD}Optional repo-level files (--full):${NC}"

  # GitHub issue templates
  if [[ -d "$SCRIPT_DIR/.github" ]]; then
    copy_dir "$SCRIPT_DIR/.github" "$TARGET/.github"
  fi

  # Python .gitignore
  if [[ -f "$SCRIPT_DIR/.gitignore" ]]; then
    if [[ -f "$TARGET/.gitignore" ]] && [[ "$FORCE" != true ]]; then
      warn ".gitignore already exists — merge manually"
      WARNINGS+=".gitignore already exists in target. Compare and merge rules manually.\n"
    else
      copy_file "$SCRIPT_DIR/.gitignore" "$TARGET/.gitignore"
    fi
  fi

  # README template (never overwrite an existing README)
  if [[ -f "$SCRIPT_DIR/README_template.md" ]]; then
    if [[ -f "$TARGET/README.md" ]] && [[ "$FORCE" != true ]]; then
      warn "README.md already exists — copying as README_template.md"
      copy_file "$SCRIPT_DIR/README_template.md" "$TARGET/README_template.md"
    else
      copy_file "$SCRIPT_DIR/README_template.md" "$TARGET/README_template.md"
    fi
  fi

  # Contributing template
  if [[ -f "$SCRIPT_DIR/CONTRIBUTING_template.md" ]]; then
    if [[ -f "$TARGET/CONTRIBUTING.md" ]] && [[ "$FORCE" != true ]]; then
      warn "CONTRIBUTING.md already exists — skipping template version"
    else
      copy_file "$SCRIPT_DIR/CONTRIBUTING_template.md" "$TARGET/CONTRIBUTING_template.md"
    fi
  fi
fi

# ════════════════════════════════════════════════════════════════════════════
# POST-INSTALL WARNINGS
# ════════════════════════════════════════════════════════════════════════════
echo ""

if [[ -n "$WARNINGS" ]]; then
  echo -e "${BOLD}${YELLOW}⚠  Action Required:${NC}"
  echo -e "The following items need manual attention:\n"
  echo -e "$WARNINGS"
fi

# ════════════════════════════════════════════════════════════════════════════
# NEXT STEPS
# ════════════════════════════════════════════════════════════════════════════
if [[ "$DRY_RUN" != true ]]; then
  echo -e "${GREEN}✅ Install complete!${NC}\n"
  echo -e "${BOLD}Next steps:${NC}"
  echo ""
  echo -e "  ${BOLD}1.${NC} Set up your environment:"
  echo -e "     cd $TARGET && ./setup.sh"
  echo -e "     ${YELLOW}(installs dependencies, fills in placeholders)${NC}"
  echo ""
  echo -e "  ${BOLD}2.${NC} Merge doc dependencies (if you have an existing pyproject.toml):"
  echo -e "     Compare pyproject.docs.toml with your existing pyproject.toml"
  echo -e "     Copy over Sphinx, theme, and extension entries"
  echo -e "     Delete pyproject.docs.toml when done"
  echo ""
  echo -e "  ${BOLD}3.${NC} Build the docs locally:"
  echo -e "     cd $TARGET/docs && make html"
  echo -e "     ${YELLOW}(open docs/_build/html/index.html in your browser)${NC}"
  echo ""
  echo -e "  ${BOLD}4.${NC} (Optional) Live preview while writing:"
  echo -e "     cd $TARGET && ./live_preview.sh"
  echo ""
  echo -e "  ${BOLD}5.${NC} Connect to Read the Docs:"
  echo -e "     Go to https://readthedocs.org and import your GitHub repo"
  echo -e "     The .readthedocs.yaml file will configure the build automatically"
  echo ""
else
  echo -e "${BOLD}Dry run complete. No files were written.${NC}"
  echo -e "Run again without --dry-run to apply."
fi