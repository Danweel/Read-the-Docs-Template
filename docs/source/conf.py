# Configuration file for the Sphinx documentation builder.
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html


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

templates_path = ['_templates']

exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

extensions = [
    # Cross-referencing
    'sphinx.ext.intersphinx',      # Cross-reference other Sphinx docs
    'sphinx_hoverxref',            # Hover tooltips on cross-references
    # Content rendering
    'sphinx.ext.todo',             # Inline .. todo:: directives
    'sphinx.ext.mathjax',          # Render LaTeX math ($...$) in HTML output
    'myst_parser',                 # Markdown support
    'sphinx_design',               # Cards, tabs, panels, badges, grids
    'sphinxcontrib.mermaid',       # Text-based diagrams
    'sphinxcontrib.bibtex',        # BibTeX bibliography support
    'jupinx',                      # Jupyter notebook integration
    # Navigation & UX
    'notfound.extension',          # Custom 404 page (pip: sphinx-notfound-page)
    'sphinx_copybutton',           # Copy button on code blocks
    'sphinx_favicon',              # Custom favicon support
    'sphinx_navtree',              # Enhanced navigation tree
    'sphinx_tags',                 # Tag and filter pages
    # Metadata & versioning
    'sphinx_last_updated_by_git',  # Show last commit date per page
    'sphinxext.opengraph',         # Social media preview cards
    'sphinx_version_warning',      # Show banner if viewing an outdated version
    # Quality
    'sphinxcontrib.spelling',      # Spell-check during doc builds
]
# Note: myst_parser is the pip package name; the extension name is myst_parser.
# Ensure 'dollarmath' is enabled in myst_enable_extensions below for mathjax support.
# IMPORTANT: Make sure the same extensions here are reflected in pyproject.toml.
# Package names and extension names sometimes differ — check both.


# -- Options for spelling ---------------------------------------------------
# https://sphinxcontrib-spelling.readthedocs.io/
# Spell-checks documentation during build.
# Uses PyEnchant + a wordlist for domain-specific terms.

spelling_lang = 'en_US'
spelling_exclude_patterns = ['docs/_build/**', '.git/**', '**/tests/**', '*_lock']
spelling_ignore_pypi_package_names = True
spelling_ignore_wiki_words = True
spelling_show_all_misspelled = True
spelling_word_list_filename = ['spelling_wordlist.txt']


# -- Options for intersphinx -----------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html#module-sphinx.ext.intersphinx

intersphinx_mapping = {
    'python': ('https://docs.python.org/3', None),
    'Sphinx': ('https://www.sphinx-doc.org/en/master/', None),
    # ... other mappings
}


# -- Options for sphinx-hoverxref -------------------------------------------
# https://sphinx-hoverxref.readthedocs.io/
# Shows hover tooltips when hovering over cross-references.
# Requires intersphinx inventory to be configured for external tooltips.

hoverxref_auto_ref = True
hoverxref_intersphinx = ["python", "sphinx"]
hoverxref_domains = ["py"]
hoverxref_default_type = "tooltip"


# -- Options for todo extension ---------------------------------------------
# Turns todos on and off — type "todo" in CAPS in any file to create a bug reminder in git.

todo_include_todos = True


# -- 404 Not Found customization --------------------------------------------
# https://sphinx-notfound-page.readthedocs.io/en/latest/

notfound_template = '404.html'  # Optional: Explicitly set the 404 template if needed (usually automatic)
notfound_context = {
    'title': 'Page Not Found',
    'body': 'The page you are looking for does not exist.',
}
notfound_urls_prefix = '/en/latest/'  # For versioned docs


# -- Options for Mermaid ----------------------------------------------------
# https://sphinxcontrib-mermaid-demo.readthedocs.io/en/latest/index.html
# Mermaid allows text-based charts that are more versionable than images.

mermaid_version = '11.13.0'  # Pinning Mermaid JS version to ensure build stability.
# Update this version only after testing with the new Mermaid release.
mermaid_init_js = "mermaid.initialize({startOnLoad:true});"
# mermaid_params = ['--theme', 'forest', '--width', '600', '--backgroundColor', 'transparent']


# -- MyST Configuration ----------------------------------------------------
# https://myst-parser.readthedocs.io/en/latest/syntax/optional.html

myst_enable_extensions = [
    'colon_fence',      # Use ::: for directives
    'deflist',          # Definition lists
    'dollarmath',       # LaTeX math syntax ($...$ and $$...$$)
    'html_admonition',  # HTML admonitions
    'linkify',          # Auto-link URLs
]

myst_heading_anchors = 4  # Add anchors to headings up to level 4


# -- Options for MathJax ----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/extensions/math.html
# MathJax renders LaTeX math in HTML output. Built into Sphinx — no extra install.

mathjax_path = "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"


# -- Options for sphinx_design ----------------------------------------------
# https://sphinx-design.readthedocs.io/
# Provides cards, tabs, panels, badges, buttons, and grids.
# Usage in .rst: .. card:: Title  /  .. tab:: Label
# No additional configuration needed — just enable the extension.


# -- Options for sphinxcontrib-bibtex ---------------------------------------
# https://sphinxcontrib-bibtex.readthedocs.io/
# Provides BibTeX bibliography support for academic citations.
# Usage in .rst: .. footbibliography::  /  .. cite:: key2024
# Set the path to your .bib file (relative to docs/source/):

bibtex_bib_files = ['references.bib']


# -- Options for sphinx-favicon ----------------------------------------------
# https://sphinx-favicon.readthedocs.io/
# Custom favicons for the site.
# Place icon files in docs/source/_static/
# NOT in /images with the other image files.

favicons = [
    {"href": "favicon.ico"},                        # Classic .ico
    {"href": "favicon-32x32.png", "type": "image/png", "sizes": "32x32"},
    {"href": "favicon.png", "rel": "favicon"},
]


# -- Options for sphinx-tags ------------------------------------------------
# https://sphinx-tags.readthedocs.io/
# Tag pages and generate tag index pages.

tags_create_tags_page = True
tags_overview_title = "Tags"
tags_extension = ["rst", "md"]


# -- Options for sphinx-last-updated-by-git ----------------------------------
# https://sphinx-last-updated-by-git.readthedocs.io/
# Automatically inserts last git commit date at the bottom of each page.
# No configuration needed — works automatically from a git repository.


# -- Options for sphinxext-opengraph -----------------------------------------
# https://github.com/wpilibsuite/sphinxext-opengraph
# Generates social media preview cards when links are shared.
# IMPORTANT: Replace [USERNAME] and [REPO-NAME] with actual values!

ogp_site_url = "https://[USERNAME].github.io/[REPO-NAME]/"

ogp_site_url = "https://[USERNAME].github.io/[REPO-NAME]/"
ogp_image = "_static/og-image.png"
ogp_use_first_image = True
ogp_description_length = 200
ogp_type = "website"


# -- Options for sphinx-version-warning -------------------------------------
# https://sphinx-version-warning.readthedocs.io/
# Shows a banner if the reader is viewing an old version of the docs.
# Works with Read the Docs versioning.

versionwarning_messages = {
    'latest': 'You are viewing the development version. '
              '<a href="/[PROJECT-SLUG]/stable/">Switch to stable</a>.',
}
versionwarning_banner_title = "Notice"
versionwarning_body_selector = "div[itemprop='articleBody']"


# -- Options for sphinx-navtree ----------------------------------------------
# https://sphinx-navtree.readthedocs.io/
# Collapsible navigation tree with search.

navtree_include_root = False
navtree_max_depth = 3


# -- Options for Jupinx ------------------------------------------------------
# https://github.com/QuantEcon/jupinx
# Converts Jupyter notebooks into documentation pages.
# Place .ipynb files in docs/source/
# Usage in .rst: .. nbgallery::

jupinx_cache_path = "_build/jupyter_cache"


# -- Options for HTML output ------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'furo'
html_static_path = ['_static']

html_theme_options = {
    # "light_css_variables": {
    #     "color-brand-primary": "red",
    #     "color-brand-content": "#CC3333",
    #     "color-admonition-background": "orange",
    # },
}

# ----------------------------------------------------------------------------
# Note: This file contains build configuration only. Dependencies
# are specified in pyproject.toml (docs/source/pyproject.toml).
# Make sure any extension added here has the corresponding package
# in pyproject.toml, and vice versa.
# See the comment block at the bottom of pyproject.toml for a checklist.
# ----------------------------------------------------------------------------
