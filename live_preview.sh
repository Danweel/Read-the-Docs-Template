#!/bin/bash
# live_preview.sh - Start Sphinx autobuild with live reload
# Usage: ./live_preview.sh
#
# Requires sphinx-autobuild. To install it:
#   poetry add sphinx-autobuild --group dev
# (or install globally: pip install sphinx-autobuild)

# Use the current directory (script should be run from project root)
cd "$(dirname "$0")" || { echo "❌ Could not find project directory"; exit 1; }

# Check if pyproject.toml exists
if [ ! -f "pyproject.toml" ]; then
    echo "❌ pyproject.toml not found. Run this from the project root."
    exit 1
fi

# Let Poetry resolve the venv automatically
echo "🔍 Locating Poetry environment..."
VENV_PATH=$(poetry env info --path 2>/dev/null)

if [ -z "$VENV_PATH" ]; then
    echo "❌ No Poetry environment found. Run './setup.sh' first."
    exit 1
fi

# Activate the venv so sphinx-autobuild is found if installed
source "$VENV_PATH/bin/activate"
echo "✅ Activated: $(basename "$VENV_PATH")"

# Check if sphinx-autobuild is installed
if ! command -v sphinx-autobuild &> /dev/null; then
    echo "❌ sphinx-autobuild is not installed."
    echo ""
    echo "To install it, run:"
    echo "  poetry add sphinx-autobuild --group dev"
    echo ""
    echo "Then run this script again."
    exit 1
fi

echo ""
echo "📚 Starting Sphinx autobuild..."
echo "   Open your browser to: http://127.0.0.1:8001"
echo "   Press Ctrl+C to stop."
echo ""

sphinx-autobuild docs/source docs/_build/html --host 127.0.0.1