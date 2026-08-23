#!/bin/bash
# setup.sh - Install prerequisites and dependencies for the Read-the-Docs-Template

set -e

echo "🔍 Checking prerequisites..."

# 1. Check for Python 3.11+
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed."
    echo ""
    echo "Install Python 3.11+ from:"
    echo "  Linux: sudo apt install python3.11"
    echo "  macOS: brew install python@3.12"
    echo "  Windows: https://www.python.org/downloads/"
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
echo "✅ Python $PYTHON_VERSION found"

# 2. Check for Git
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed."
    echo ""
    echo "Install Git from:"
    echo "  https://git-scm.com/download/"
    exit 1
fi
echo "✅ Git found"

# 3. Check for Poetry
if ! command -v poetry &> /dev/null; then
    echo "⚠️ Poetry is not installed. Installing now..."
    
    if command -v curl &> /dev/null; then
        curl -sSL https://install.python-poetry.org | python3 -
        echo ""
        echo "✅ Poetry installed"
        echo "💡 To activate, add to your shell config (if needed):"
        echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo "   source ~/.bashrc  # or ~/.zshrc"
    else
        echo "❌ curl is not available. Install Poetry manually:"
        echo "   https://python-poetry.org/docs/#installation"
        exit 1
    fi
else
    POETRY_VERSION=$(poetry --version | awk '{print $2}')
    echo "✅ Poetry $POETRY_VERSION found"
fi

# 4. Check for pyproject.toml validity
if [ ! -f "pyproject.toml" ]; then
    echo "❌ pyproject.toml not found. Run this script from the project root."
    exit 1
fi

# Check if placeholders are still present
if grep -q "\[PROJECTNAME\]" pyproject.toml; then
    echo "⚠️ Warning: pyproject.toml still has placeholders."
    echo ""
    echo "Before running 'poetry lock', edit pyproject.toml and replace:"
    echo "  [PROJECTNAME] → your-project-name"
    echo "  [DESCRIPTION] → your description"
    echo "  [NAME]        → your name"
    echo "  [EMAIL]       → your email"
    echo ""
    read -p "Continue anyway? (poetry lock will fail with these placeholders) [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting. Update pyproject.toml first."
        exit 1
    fi
fi

# 5. Generate lock file
echo ""
echo "📦 Generating poetry.lock..."
poetry lock

# 6. Install dependencies
echo ""
echo "📚 Installing documentation dependencies..."
poetry install --with docs

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  cd docs"
echo "  poetry run make html"
echo "  open build/html/index.html  # or open in your browser"