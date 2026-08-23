#!/usr/bin/env bash
# setup.sh — Install prerequisites and dependencies
#
# Checks for Python, Git, and Poetry, sets up a virtual environment,
# and installs the right dependencies based on your contribution type.
#
# NOTE: We use SINGLE $ for variables (e.g., $GROUP).
#       Do NOT use $$ (that expands to the Process ID in Bash!).

set -euo pipefail

# ---------- Colour Definitions ----------
if [[ -n "${NO_COLOR:-}" ]]; then
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    NC=''
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    NC='\033[0m'
fi

BOLD='\033[1m'

# ---------- Formatting Functions ----------
header() {
  echo -e "\n${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}${BOLD}  $1${NC}"
  echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

success() {
  echo -e "${GREEN}✓${NC} $1"
}

error() {
  echo -e "${RED}✗${NC} $1"
}

info() {
  echo -e "${BOLD}${CYAN}ℹ${NC} $1"
}

warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

# SCRIPT START

# ---------- 1. Verify prerequisites ----------
header "Checking you have everything needed..."
echo "We need to make sure you have the right tools installed:"
echo -e "  ${BOLD}${CYAN}• Python 3${NC}"
echo -e "  ${BOLD}${CYAN}• Poetry${NC}"
echo -e "  ${BOLD}${CYAN}• Git${NC}"
echo ""

echo "Checking prerequisites..."
echo ""

# Check for Python
command -v python3 >/dev/null || { echo -e "${RED}✗ Python 3 not found.${NC}"; exit 1; }
success "Python 3 found"

# Check for and install Poetry
if ! command -v poetry >/dev/null 2>&1; then
    warning "Poetry not found. Installing now..."

    if curl -sSL https://install.python-poetry.org | python3 -; then
        success "Poetry installed successfully!"

        POETRY_BIN="$HOME/.local/bin"
        if [[ ":$PATH:" != *":$POETRY_BIN:"* ]]; then
            echo ""
            info "Adding Poetry to PATH for this session..."
            export PATH="$POETRY_BIN:$PATH"

            echo ""
            info "To make this permanent, add this to your ~/.bashrc or ~/.zshrc:"
            echo "   export PATH=\"$POETRY_BIN:\$PATH\""
        fi
    else
        error "Failed to install Poetry. Please install it manually from https://python-poetry.org/docs/"
        exit 1
    fi
else
    success "Poetry is already installed."
    poetry --version
fi

# Check Git
echo ""
command -v git >/dev/null || { echo -e "${RED}✗ Git not found.${NC}"; exit 1; }
success "Git found"

echo ""
success "All required tools are installed!"
echo ""

# ---------- 2. Check for placeholders ----------
if [ ! -f "pyproject.toml" ]; then
    echo "❌ pyproject.toml not found. Run this script from the project root."
    exit 1
fi

if grep -q "\[PROJECTNAME\]" pyproject.toml; then
    warning "pyproject.toml still has placeholders."
    echo ""
    echo "Before continuing, edit pyproject.toml and replace:"
    echo "  [PROJECTNAME]   → your-project-name"
    echo "  [DESCRIPTION]   → your description"
    echo "  [NAME]          → your name"
    echo "  [EMAIL]         → your email"
    echo ""
    read -p "Continue anyway? (poetry lock will fail with these placeholders) [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting. Update pyproject.toml first."
        exit 1
    fi
fi

# ---------- 3. Git identity verification ----------
if ! git config --global user.name >/dev/null || ! git config --global user.email >/dev/null; then
  header "Setting up your Git identity..."
  info "This helps track who made changes to the documentation and provides attribution."
  echo ""
  read -rp "$(echo -e ${CYAN}Enter the name you want listed on your commits on GitHub:${NC} )" GIT_NAME
  read -rp "$(echo -e ${CYAN}Enter your email address you want associated with commits:${NC} )" GIT_EMAIL
  echo ""

  # Trim whitespace
  GIT_NAME="${GIT_NAME#"${GIT_NAME%%[![:space:]]*}"}"
  GIT_NAME="${GIT_NAME%"${GIT_NAME##*[![:space:]]}"}"
  GIT_EMAIL="${GIT_EMAIL#"${GIT_EMAIL%%[![:space:]]*}"}"
  GIT_EMAIL="${GIT_EMAIL%"${GIT_EMAIL##*[![:space:]]}"}"

  if [[ -n "$GIT_NAME" && -n "$GIT_EMAIL" ]]; then
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    success "Git identity set to \"$GIT_NAME <$GIT_EMAIL>\""
  else
    warning "Skipping Git configuration – name or email was empty!"
    echo ""
    info "To set up your credentials later, open a terminal and type the following:"
    echo -e "    ${CYAN}git config --global user.name \"Your Name\"${NC}"
    echo -e "    ${CYAN}git config --global user.email \"your@email.com\"${NC}"
  fi
else
  success "Git identity already configured:"
  echo -e "    ${CYAN}$(git config --global user.name)${NC} <$(git config --global user.email)>"
fi

# ---------- 4. Create Poetry venv ----------
header "Setting up your local workspace..."
echo "Creating a private space for the project's tools for you..."
info "This won't affect other programs on your computer, nor your local Python installations."
poetry env use python3 >/dev/null 2>&1 || true

# ---------- 5. Generate lock file ----------
header "Generating lock file..."
poetry lock
success "Lock file generated!"

# ---------- 6. Choose dependency group ----------
header "Choosing your tools:"
echo -e "  ${YELLOW}What do you want to do?${NC}"
echo ""
echo -e "  ${CYAN}1.${NC} ${BOLD}Write documentation only (lightweight)${NC}"
echo -e "  ${CYAN}2.${NC} ${BOLD}Write + test + lint (full development tools)${NC}"
echo ""
echo -e "${YELLOW}Enter ${CYAN}1 ${YELLOW}for light or ${CYAN}2 ${YELLOW}for development [default: 1]: ${NC}"
read group_choice
group_choice="${group_choice// /}"
group_choice=${group_choice:-1}
case "$group_choice" in
  1) GROUP="docs" ;;
  2) GROUP="dev" ;;
  *) echo "Invalid choice – Please rerun this script."; exit 1 ;;
esac

# ---------- 7. Optionally delete old build files ----------
header "Choosing build options:"
echo -e "  ${YELLOW}Would you like to start fresh or update existing documentation?${NC}"
echo ""
echo -e "  ${CYAN}1.${NC} ${BOLD}Start fresh (recommended for first-time setup or troubleshooting)${NC}"
echo -e "  ${CYAN}2.${NC} ${BOLD}Update existing (faster for regular edits)${NC}"
echo ""
echo -e "${YELLOW}Enter ${CYAN}1 ${YELLOW}to start fresh or ${CYAN}2 ${YELLOW}to update [default: 2]: ${NC}"
read clean_choice
clean_choice="${clean_choice// /}"
clean_choice=${clean_choice:-2}
case "$clean_choice" in
  1) CLEAN_BUILD=true ;;
  2) CLEAN_BUILD=false ;;
  *) echo "Invalid choice – Please rerun this script."; exit 1 ;;
esac

# ---------- 8. Install chosen dependencies ----------
header "Installing tools..."

poetry install --with "$GROUP"
success "Tools installed!"

# ---------- 9. Clean previous build (if selected) ----------
if [[ "$CLEAN_BUILD" == "true" ]]; then
  header "Cleaning previous build..."
  rm -rf docs/_build/
  success "Old build files removed successfully!"
fi

# ---------- 10. Sanity check build ----------
header "Building documentation..."
poetry run sphinx-build -b html docs/source docs/_build/html
success "Build successful!"

# ---------- 11. Finished ----------
echo ""
echo -e "${GREEN}${BOLD}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║                                                            ║${NC}"
echo -e "${GREEN}${BOLD}║          Setup Complete! You're ready to write!            ║${NC}"
echo -e "${GREEN}${BOLD}║                                                            ║${NC}"
echo -e "${GREEN}${BOLD}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo ""
echo -e "${BOLD}Next Steps:${NC}"
echo ""
echo -e "  ${CYAN}1.${NC} Open the ${BOLD}docs/source/${NC} folder in your text editor"
echo -e "  ${CYAN}2.${NC} Edit ${YELLOW}.rst${NC} or ${YELLOW}.md${NC} files to add your content"
echo -e "  ${CYAN}3.${NC} Build your docs: ${BOLD}poetry run sphinx-build -b html docs/source docs/_build/html${NC}"
echo -e "  ${CYAN}4.${NC} Open ${BOLD}docs/_build/html/index.html${NC} in your browser"
echo -e "  ${CYAN}5.${NC} Push your changes to GitHub the usual way"
echo ""
if [[ "$GROUP" == "dev" ]]; then
  echo -e "  ${BOLD}${CYAN}Dev commands:${NC}"
  echo -e "    Build docs:  poetry run sphinx-build -b html docs/source docs/_build/html"
  echo -e "    Run tests:   poetry run pytest"
  echo -e "    Lint code:   poetry run ruff check ."
else
  echo -e "  ${BOLD}${CYAN}Doc commands:${NC}"
  echo -e "    Build docs:  poetry run sphinx-build -b html docs/source docs/_build/html"
fi
echo ""
echo -e "  ${BOLD}${CYAN}•${NC} Live preview:  ./live_preview.sh"
echo -e "  ${BOLD}${CYAN}•${NC} Check out the README.md for full documentation"
echo ""
