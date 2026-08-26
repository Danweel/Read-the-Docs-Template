#!/usr/bin/env bash
# setup.sh — Set up local environment for plain documentation projects
#
# For docs-only projects: handbooks, guides, design docs.
# Uses pip (requirements.txt) as primary, Poetry as optional fallback.
# No Python package installation, no autodoc.
#
# Usage: cd /path/to/your-project && ./setup.sh

set -euo pipefail

# ---------- Colour Definitions ----------
if [[ -n "${NO_COLOR:-}" ]]; then
    RED='' GREEN='' YELLOW='' BLUE='' CYAN='' NC=''
else
    RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
    BLUE='\033[0;34m' CYAN='\033[0;36m' NC='\033[0m'
fi
BOLD='\033[1m'

# ---------- Formatting ----------
header() {
  echo -e "\n${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}${BOLD}  $1${NC}"
  echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}
success() { echo -e "${GREEN}✓${NC} $1"; }
error()   { echo -e "${RED}✗${NC} $1"; }
info()    { echo -e "${BOLD}${CYAN}ℹ${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# ---------- 1. Resolve script location ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ---------- 2. Verify prerequisites ----------
header "Checking prerequisites..."
echo "Required tools:"
echo -e "  ${BOLD}${CYAN}• Python 3${NC}"
echo -e "  ${BOLD}${CYAN}• Git${NC}"
echo -e "  ${BOLD}${CYAN}• pip (or Poetry, optional)${NC}"
echo ""

if ! command -v python3 >/dev/null 2>&1; then
    error "Python 3 not found"
    echo "Install from https://www.python.org/downloads/"
    exit 1
fi
success "Python 3 found ($(python3 --version))"

if ! command -v git >/dev/null 2>&1; then
    error "Git not found"
    echo "Install from your package manager or https://git-scm.com/"
    exit 1
fi
success "Git found"
echo ""

# ---------- 3. Verify project files ----------
if [ ! -f "$SCRIPT_DIR/requirements.txt" ] && [ ! -f "$SCRIPT_DIR/pyproject.toml" ]; then
    error "Neither requirements.txt nor pyproject.toml found"
    echo "Run copy-to-project.sh first to copy template files into your project."
    exit 1
fi

# ---------- 4. Check for placeholders ----------
PLACEHOLDER_FILES=()

if [[ -f "$SCRIPT_DIR/docs/source/conf.py" ]]; then
    if grep -qE '\[(PROJECT NAME|PROJECT-SLUG|USERNAME|YOUR NAME|LICENSE NAME)\]' "$SCRIPT_DIR/docs/source/conf.py"; then
        PLACEHOLDER_FILES+=("docs/source/conf.py")
    fi
fi

if [[ -f "$SCRIPT_DIR/pyproject.toml" ]]; then
    if grep -qE '\[(PROJECT NAME|PROJECT-SLUG|USERNAME|YOUR NAME)\]' "$SCRIPT_DIR/pyproject.toml"; then
        PLACEHOLDER_FILES+=("pyproject.toml")
    fi
fi

if [[ ${#PLACEHOLDER_FILES[@]} -gt 0 ]]; then
    warning "Some files still have placeholders:"
    for f in "${PLACEHOLDER_FILES[@]}"; do
        echo -e "    ${CYAN}$f${NC}"
    done
    echo ""
    echo "Replace these placeholders before publishing:"
    echo "  [PROJECT NAME]   → Your Project Display Name"
    echo "  [PROJECT-SLUG]   → your-project-slug"
    echo "  [USERNAME]       → your-github-username"
    echo "  [YOUR NAME]      → Your Actual Name"
    echo "  [LICENSE NAME]   → MIT, CC-BY-SA-4.0, etc."
    echo ""
    read -p "Continue with setup anyway? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting. Fill in placeholders first."
        exit 1
    fi
fi

# ---------- 5. Git identity ----------
if ! git config --global user.name >/dev/null 2>&1 || ! git config --global user.email >/dev/null 2>&1; then
    header "Setting up Git identity..."
    info "This tracks who contributed to the documentation."
    echo ""
    read -rp "$(echo -e ${CYAN}Name for commits:${NC} )" GIT_NAME
    read -rp "$(echo -e ${CYAN}Email for commits:${NC} )" GIT_EMAIL
    echo ""

    GIT_NAME="${GIT_NAME#"${GIT_NAME%%[![:space:]]*}"}"
    GIT_NAME="${GIT_NAME%"${GIT_NAME##*[![:space:]]}"}"
    GIT_EMAIL="${GIT_EMAIL#"${GIT_EMAIL%%[![:space:]]*}"}"
    GIT_EMAIL="${GIT_EMAIL%"${GIT_EMAIL##*[![:space:]]}"}"

    if [[ -n "$GIT_NAME" && -n "$GIT_EMAIL" ]]; then
        git config --global user.name "$GIT_NAME"
        git config --global user.email "$GIT_EMAIL"
        success "Git identity set: $GIT_NAME <$GIT_EMAIL>"
    else
        warning "Skipping Git config — empty name or email"
    fi
else
    success "Git identity configured: $(git config --global user.name) <$(git config --global user.email)>"
fi

# ---------- 6. Install dependencies ----------
# Detect: Poetry if available + pyproject.toml exists, otherwise pip
USE_POETRY=false

if command -v poetry >/dev/null 2>&1 && [[ -f "$SCRIPT_DIR/pyproject.toml" ]]; then
    USE_POETRY=true
fi

if [[ "$USE_POETRY" == true ]]; then
    header "Setting up Poetry environment..."
    poetry env use python3 >/dev/null 2>&1 || true
    poetry lock
    poetry install
    success "Dependencies installed via Poetry"
    BUILD_CMD="poetry run sphinx-build -b html docs/source docs/_build/html"
else
    header "Setting up pip environment..."
    python3 -m pip install --upgrade pip >/dev/null 2>&1 || true
    pip3 install -r "$SCRIPT_DIR/requirements.txt"
    success "Dependencies installed via pip"
    BUILD_CMD="python3 -m sphinx -b html docs/source docs/_build/html"
fi

# ---------- 7. Clean build (optional) ----------
header "Build options..."
echo -e "  ${CYAN}1.${NC} ${BOLD}Start fresh (remove old build)${NC}"
echo -e "  ${CYAN}2.${NC} ${BOLD}Keep existing (faster)${NC}"
echo ""
read -p "Choice [default: 2]: " clean_choice
clean_choice="${clean_choice:-2}"

if [[ "$clean_choice" == "1" ]] && [[ -d "$SCRIPT_DIR/docs/_build" ]]; then
    rm -rf "$SCRIPT_DIR/docs/_build"
    success "Old build removed"
fi

# ---------- 8. Build docs ----------
header "Building documentation..."
eval "$BUILD_CMD"
success "Build successful!"

# ---------- 9. Done ----------
echo ""
echo -e "${GREEN}${BOLD}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║          Setup Complete! You're ready to write!              ║${NC}"
echo -e "${GREEN}${BOLD}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}Next Steps:${NC}"
echo ""
echo -e "  ${CYAN}1.${NC} Edit files in ${BOLD}docs/source/${NC}"
echo -e "  ${CYAN}2.${NC} Rebuild: ${BOLD}$BUILD_CMD${NC}"
echo -e "  ${CYAN}3.${NC} Open ${BOLD}docs/_build/html/index.html${NC} in your browser"
echo -e "  ${CYAN}4.${NC} Live preview: ${BOLD}./live_preview.sh${NC}"
echo -e "  ${CYAN}5.${NC} Push to GitHub when ready"
echo ""