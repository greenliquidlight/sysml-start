# Configuration file for the Sphinx documentation builder.
#
# For a full list of options see:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# ---------------------------------------------------------------------------
# Project information
# ---------------------------------------------------------------------------
project = 'sysml-start'
copyright = '2026, Amber Worth'
author = 'Amber Worth'
release = '0.1'

# ---------------------------------------------------------------------------
# Extensions
# ---------------------------------------------------------------------------
extensions = [
    'myst_parser',          # Markdown source files via MyST
]

# MyST: enable additional syntax used in .md files
myst_enable_extensions = [
    'colon_fence',          # :::{directive} shorthand
    'deflist',              # definition lists
]

# ---------------------------------------------------------------------------
# Source
# ---------------------------------------------------------------------------
source_suffix = {
    '.md': 'markdown',
    '.rst': 'restructuredtext',
}

exclude_patterns = [
    '_build',
    'Thumbs.db',
    '.DS_Store',
    'requirements.txt',
]

# ---------------------------------------------------------------------------
# HTML output
# ---------------------------------------------------------------------------
html_theme = 'sphinx_rtd_theme'

html_theme_options = {
    'navigation_depth': 3,
    'titles_only': False,
}

# Sphinx will copy files listed here into the output _static/ directory.
# Add any custom CSS or JS here if needed in future.
html_static_path = []
