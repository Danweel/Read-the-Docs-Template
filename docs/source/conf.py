# Configuration file for the Sphinx documentation builder.
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

import pathlib
import sys
sys.path.insert(0, pathlib.Path(__file__).parents[2].resolve().as_posix())
# Legacy line from autodocing, leave this until further notice to prevent stops.
# ----------------------------------------------------------------------------


# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = '[PROJECT NAME]'
copyright = '20XX'
author = '[AUTHOR NAME]'
release = '0.0.1'
# While you are setting up and making changes (unreadable):
#release = '0.0.1'
# A readable version could start here:
#release = '0.1.0'
# ----------------------------------------------------------------------------


# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

# Mock imports for modules that don't exist:
autodoc_mock_imports = ['pymodulefordocs']
# ISSUE: The python script these docs are about isn't included, so this is to prevent a stopping error

templates_path = ['_templates']

exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

extensions = [
    'sphinx.ext.viewcode',         # Optional: Shows source code links if we ever host the .bpy
    'sphinx.ext.intersphinx',      # Allows sphinx to interact with other Read the Docs pages
    'sphinx.ext.todo',             # Allows for quick inline bugmaking on github
    'sphinxcontrib.mermaid',       # Required for Mermaid diagrams
    'notfound.extension',          # Required for custom 404 page for aesthetics
    'sphinx_copybutton',           # Copy button on code blocks (great for tutorials)
    'myst_parser'                  # Required for fullpage Markdown support in case contibutors are more comfortable writing .md files
]                                  # KNOWN ISSUE: myst_parser is in an odd format. This is normal but can throw warnings (that can be safely ignored)

# -- Optional Rendering Extensions (uncomment and add to [ ] above if needed) --
# 'sphinx_design',              # Cards, tabs, panels — great for organizing guides
#                                # Requires: pip install sphinx-design
#
# 'sphinxcontrib.bibtex',        # BibTeX bibliography support for academic citations
#                                # Requires: pip install sphinxcontrib-bibtex
#
# 'sphinx.ext.mathjax',          # Render LaTeX math ($...$) in HTML output
#                                # Built into Sphinx — no extra install needed
#                                # Enable 'dollarmath' in myst_enable_extensions too
#
# There are actually lots of extensions, once your build is working, you can add them here.
# Important: Make sure the same packages here are reflected in the /docs/source/pyproject.toml as well. You may have to look up the name format for both files.

# --------------------------------------------------------------------------


# -- Options for viewcode --------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/extensions/viewcode.html

viewcode_line_numbers = True

# --------------------------------------------------------------------------


# -- Options for intersphinx -----------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html#module-sphinx.ext.intersphinx

#intersphinx_mapping = {
#    'blender': ('https://docs.blender.org/api/current', None),  # you would set this to whatever you would want to incorporate
#     ... other mappings to any other documentation site that has a RTD page.
#}

# ---------------------------------------------------------------------------


# -- Options for todo extension ---------------------------------------------
# Turns todos on and off - you can type todo in caps in any file and create a github issue. Useful for editing.

todo_include_todos = True

# ---------------------------------------------------------------------------


# -- 404 Not Found customization --------------------------------------------
# https://sphinx-notfound-page.readthedocs.io/en/latest/

notfound_template = '404.html' # Optional: Explicitly set the 404 template if needed (usually automatic)

notfound_context = {
    'title': 'Page Not Found',
    'body': 'The page you are looking for does not exist.',
}
# Optional: add URLs that should always work
notfound_urls_prefix = '/en/latest/'  # For versioned docs

# ---------------------------------------------------------------------------


# -- 'Sphinx Contrib for Mermaid' Template ----------------------------------
# https://sphinxcontrib-mermaid-demo.readthedocs.io/en/latest/index.html
# Mermaid allows for text-based charts that are more versionable than images

mermaid_version = '11.13.0'  # Pinning Mermaid JS version to ensure build stability.
# Update this version only after testing with the new Mermaid release.

mermaid_init_js = "mermaid.initialize({startOnLoad:true});"
# mermaid_params = ['--theme', 'forest', '--width', '600', '--backgroundColor', 'transparent']

# --------------------------------------------------------------------------


# -- MyST Configuration ----------------------------------------------------
# https://myst-parser.readthedocs.io/en/latest/syntax/optional.html

myst_enable_extensions = [
    'colon_fence',      # Use ::: for directives
    'deflist',          # Definition lists
#   'dollarmath',       # LaTeX math syntax
    'html_admonition',  # HTML admonitions
    'linkify',          # Auto-link URLs
]

# Optional: Configure how MyST handles certain syntax
myst_heading_anchors = 4  # Add anchors to headings up to level 3

# --------------------------------------------------------------------------


# -- Options for HTML output ---------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'groundwork'

# html_static_path = ['build\html\source\_static']

html_theme_options = {
#    "light_css_variables": {
#        "color-brand-primary": "red",
#        "color-brand-content": "#CC3333",
#        "color-admonition-background": "orange",
#    },
}

# ---------------------------------------------------------------------------