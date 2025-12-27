# ==============================================================================
# CUSTOMIZE PKGDOWN SITE
# ==============================================================================
#
# PURPOSE:
#   Interactive guide to customize your pkgdown package website
#
# USAGE:
#   source("dev/pkgdown_customize_site.R")
#
# PREREQUISITES:
#   - pkgdown package: install.packages("pkgdown")
#   - _pkgdown.yml file exists in package root
#   - Run from package root directory
#
# WHAT THIS DOES:
#   1. Analyzes current _pkgdown.yml configuration
#   2. Provides templates for common customizations
#   3. Guides you through configuration options
#   4. Shows examples of advanced features
#   5. Offers to preview site locally
#
# EXPECTED OUTPUT:
#   - Guidance on customizing _pkgdown.yml
#   - Configuration templates and examples
#   - Optional preview of current site
#
# NOTES:
#   - Edit _pkgdown.yml manually to apply customizations
#   - Run pkgdown_build_site.R after making changes
#   - See pkgdown documentation: https://pkgdown.r-lib.org/
#   - Examples from popular packages shown
#
# ==============================================================================

# Check prerequisites
if (!requireNamespace("pkgdown", quietly = TRUE)) {
  stop(
    "pkgdown package required. Install with:\n",
    "  install.packages('pkgdown')"
  )
}

# Package name detection
get_package_name <- function() {
  if (requireNamespace("desc", quietly = TRUE)) {
    return(desc::desc_get_field("Package"))
  }
  if (file.exists("DESCRIPTION")) {
    lines <- readLines("DESCRIPTION", n = 20)
    pkg_line <- grep("^Package:", lines, value = TRUE)
    if (length(pkg_line) > 0) {
      return(trimws(sub("^Package:", "", pkg_line[1])))
    }
  }
  basename(normalizePath("."))
}

pkg_name <- get_package_name()

# Print header
cat(
  "==============================================================================\n"
)
cat("PKGDOWN SITE CUSTOMIZATION GUIDE\n")
cat(
  "==============================================================================\n\n"
)

cat(sprintf("Package: %s\n\n", pkg_name))

# Check current configuration
if (file.exists("_pkgdown.yml")) {
  cat("Current _pkgdown.yml configuration:\n")
  cat(
    "------------------------------------------------------------------------------\n"
  )
  current_config <- readLines("_pkgdown.yml")
  cat(paste(current_config, collapse = "\n"))
  cat("\n\n")
} else {
  cat("WARNING: _pkgdown.yml not found!\n")
  cat("Run: usethis::use_pkgdown()\n\n")
  stop("_pkgdown.yml required", call. = FALSE)
}

# ==============================================================================
# CUSTOMIZATION GUIDE
# ==============================================================================

cat(
  "==============================================================================\n"
)
cat("CUSTOMIZATION OPTIONS\n")
cat(
  "==============================================================================\n\n"
)

cat("Below are templates for common pkgdown customizations.\n")
cat("Copy the sections you want to _pkgdown.yml and modify as needed.\n\n")

# ----------------------------------------------------------------------------
# 1. BASIC CONFIGURATION
# ----------------------------------------------------------------------------

cat("1. BASIC CONFIGURATION\n")
cat("======================\n\n")

cat("Minimal but complete configuration:\n\n")
cat("```yaml\n")
cat("url: https://yourusername.github.io/", pkg_name, "/\n", sep = "")
cat("template:\n")
cat("  bootstrap: 5\n")
cat("  bootswatch: cosmo  # Theme: cosmo, flatly, cerulean, journal, etc.\n")
cat("\n")
cat("home:\n")
cat("  title: ", pkg_name, " • Your Package Title\n", sep = "")
cat("  description: A brief description of your package\n")
cat("```\n\n")

# ----------------------------------------------------------------------------
# 2. THEMES AND APPEARANCE
# ----------------------------------------------------------------------------

cat("2. THEMES AND APPEARANCE\n")
cat("========================\n\n")

cat("Popular Bootswatch themes (https://bootswatch.com/):\n\n")

cat("Modern & Clean:\n")
cat("  bootswatch: cosmo      # Clean, modern\n")
cat("  bootswatch: flatly     # Flat design\n")
cat("  bootswatch: lumen      # Light, spacious\n")
cat("  bootswatch: minty      # Fresh, green accents\n\n")

cat("Professional:\n")
cat("  bootswatch: cerulean   # Professional blue\n")
cat("  bootswatch: united     # Corporate\n")
cat("  bootswatch: yeti       # Clean professional\n\n")

cat("Dark Themes:\n")
cat("  bootswatch: darkly     # Dark theme\n")
cat("  bootswatch: cyborg     # Dark with blue accents\n")
cat("  bootswatch: slate      # Dark gray\n\n")

cat("Fun/Colorful:\n")
cat("  bootswatch: journal    # Newspaper style\n")
cat("  bootswatch: sketchy    # Hand-drawn look\n\n")

cat("Custom colors:\n\n")
cat("```yaml\n")
cat("template:\n")
cat("  bootstrap: 5\n")
cat("  bslib:\n")
cat("    primary: '#0051BA'        # Main color\n")
cat("    success: '#28A745'        # Success messages\n")
cat("    info: '#17A2B8'           # Info boxes\n")
cat("    warning: '#FFC107'        # Warnings\n")
cat("    danger: '#DC3545'         # Errors\n")
cat("    base_font: {google: 'Roboto'}\n")
cat("    heading_font: {google: 'Roboto Slab'}\n")
cat("    code_font: {google: 'JetBrains Mono'}\n")
cat("```\n\n")

# ----------------------------------------------------------------------------
# 3. NAVIGATION
# ----------------------------------------------------------------------------

cat("3. NAVIGATION BAR\n")
cat("=================\n\n")

cat("Customize navigation menu:\n\n")
cat("```yaml\n")
cat("navbar:\n")
cat("  structure:\n")
cat("    left:  [intro, reference, articles, tutorials, news]\n")
cat("    right: [search, github]\n")
cat("  components:\n")
cat("    home: ~  # Remove home icon\n")
cat("    articles:\n")
cat("      text: Articles\n")
cat("      menu:\n")
cat("        - text: Getting Started\n")
cat("          href: articles/getting-started.html\n")
cat("        - text: Advanced Usage\n")
cat("          href: articles/advanced.html\n")
cat("        - text: -------  # Separator\n")
cat("        - text: All Articles\n")
cat("          href: articles/index.html\n")
cat("    github:\n")
cat("      icon: fab fa-github fa-lg\n")
cat("      href: https://github.com/yourusername/", pkg_name, "\n", sep = "")
cat("      aria-label: GitHub\n")
cat("```\n\n")

# ----------------------------------------------------------------------------
# 4. FUNCTION REFERENCE
# ----------------------------------------------------------------------------

cat("4. FUNCTION REFERENCE ORGANIZATION\n")
cat("==================================\n\n")

cat("Organize functions into categories:\n\n")
cat("```yaml\n")
cat("reference:\n")
cat("  - title: Main Functions\n")
cat("    desc: Core functionality for end users\n")
cat("    contents:\n")
cat("      - has_concept('main')  # Functions with @concept main\n")
cat("      - starts_with('plot_') # All plot_* functions\n")
cat("  \n")
cat("  - title: Data Manipulation\n")
cat("    desc: Functions for data processing\n")
cat("    contents:\n")
cat("      - starts_with('data_')\n")
cat("  \n")
cat("  - title: Utilities\n")
cat("    desc: Helper and utility functions\n")
cat("    contents:\n")
cat("      - starts_with('utils_')\n")
cat("  \n")
cat("  - title: Internal Functions\n")
cat("    desc: Internal functions (not for end users)\n")
cat("    contents:\n")
cat("      - matches('_internal')\n")
cat("```\n\n")

cat("Function selectors available:\n")
cat("  - starts_with('prefix_')   # By prefix\n")
cat("  - ends_with('_suffix')     # By suffix\n")
cat("  - matches('pattern')       # Regex pattern\n")
cat("  - has_concept('concept')   # By @concept tag\n")
cat("  - has_keyword('keyword')   # By @keywords tag\n")
cat("  - lacks_concepts()         # No concepts\n\n")

# ----------------------------------------------------------------------------
# 5. HOME PAGE
# ----------------------------------------------------------------------------

cat("5. HOME PAGE CUSTOMIZATION\n")
cat("==========================\n\n")

cat("Customize home page sections:\n\n")
cat("```yaml\n")
cat("home:\n")
cat("  title: ", pkg_name, " • Fast Data Processing\n", sep = "")
cat("  description: |\n")
cat("    A comprehensive package for data processing with\n")
cat("    performance and ease of use in mind.\n")
cat("  \n")
cat("  links:\n")
cat("    - text: Browse source code\n")
cat("      href: https://github.com/yourusername/", pkg_name, "\n", sep = "")
cat("    - text: Report a bug\n")
cat(
  "      href: https://github.com/yourusername/",
  pkg_name,
  "/issues\n",
  sep = ""
)
cat("  \n")
cat("  sidebar:\n")
cat("    structure: [links, license, community, citation, authors, dev]\n")
cat("```\n\n")

cat("Add badges to README.md (automatically shown on home page):\n\n")
cat("```markdown\n")
cat("<!-- badges: start -->\n")
cat(
  "[![CRAN status](https://www.r-pkg.org/badges/version/",
  pkg_name,
  ")](https://CRAN.R-project.org/package=",
  pkg_name,
  ")\n",
  sep = ""
)
cat(
  "[![R-CMD-check](https://github.com/yourusername/",
  pkg_name,
  "/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yourusername/",
  pkg_name,
  "/actions/workflows/R-CMD-check.yaml)\n",
  sep = ""
)
cat(
  "[![Codecov](https://codecov.io/gh/yourusername/",
  pkg_name,
  "/branch/main/graph/badge.svg)](https://codecov.io/gh/yourusername/",
  pkg_name,
  ")\n",
  sep = ""
)
cat("<!-- badges: end -->\n")
cat("```\n\n")

# ----------------------------------------------------------------------------
# 6. ARTICLES/VIGNETTES
# ----------------------------------------------------------------------------

cat("6. ARTICLES ORGANIZATION\n")
cat("========================\n\n")

cat("Organize vignettes/articles:\n\n")
cat("```yaml\n")
cat("articles:\n")
cat("  - title: Getting Started\n")
cat("    navbar: Getting Started\n")
cat("    contents:\n")
cat("      - introduction\n")
cat("      - quick-start\n")
cat("  \n")
cat("  - title: Advanced Topics\n")
cat("    navbar: Advanced\n")
cat("    contents:\n")
cat("      - performance-tuning\n")
cat("      - parallel-processing\n")
cat("  \n")
cat("  - title: Case Studies\n")
cat("    contents:\n")
cat("      - case-study-1\n")
cat("      - case-study-2\n")
cat("```\n\n")

# ----------------------------------------------------------------------------
# 7. DEVELOPMENT MODE
# ----------------------------------------------------------------------------

cat("7. DEVELOPMENT MODE\n")
cat("===================\n\n")

cat("Show development version banner:\n\n")
cat("```yaml\n")
cat("development:\n")
cat("  mode: auto  # Shows dev banner if version has .9000\n")
cat("  # or\n")
cat("  # mode: release      # Never show dev mode\n")
cat("  # mode: devel        # Always show dev mode\n")
cat("  # mode: unreleased   # Show if not on CRAN\n")
cat("```\n\n")

# ----------------------------------------------------------------------------
# 8. SOCIAL MEDIA & SEO
# ----------------------------------------------------------------------------

cat("8. SOCIAL MEDIA & SEO\n")
cat("=====================\n\n")

cat("Optimize for social media sharing:\n\n")
cat("```yaml\n")
cat("template:\n")
cat("  opengraph:\n")
cat("    image:\n")
cat("      src: man/figures/logo.png\n")
cat("      alt: '", pkg_name, " package logo'\n", sep = "")
cat("    twitter:\n")
cat("      creator: '@yourusername'\n")
cat("      card: summary_large_image\n")
cat("```\n\n")

# ----------------------------------------------------------------------------
# 9. SEARCH & ANALYTICS
# ----------------------------------------------------------------------------

cat("9. SEARCH & ANALYTICS\n")
cat("=====================\n\n")

cat("Add Google Analytics:\n\n")
cat("```yaml\n")
cat("template:\n")
cat("  params:\n")
cat("    ganalytics: UA-XXXXXXX-X  # Google Analytics ID\n")
cat("```\n\n")

# ----------------------------------------------------------------------------
# 10. CUSTOM CSS/JS
# ----------------------------------------------------------------------------

cat("10. CUSTOM CSS/JS\n")
cat("=================\n\n")

cat("Add custom styling:\n\n")
cat("1. Create pkgdown/extra.css:\n\n")
cat("```css\n")
cat("/* Custom styles */\n")
cat(".navbar {\n")
cat("  background-color: #0051BA !important;\n")
cat("}\n")
cat("\n")
cat("code {\n")
cat("  background-color: #f5f5f5;\n")
cat("  padding: 2px 4px;\n")
cat("  border-radius: 3px;\n")
cat("}\n")
cat("```\n\n")

cat("2. Reference in _pkgdown.yml:\n\n")
cat("```yaml\n")
cat("template:\n")
cat("  includes:\n")
cat("    in_header: |\n")
cat("      <link rel='stylesheet' href='extra.css'>\n")
cat("  assets: pkgdown\n")
cat("```\n\n")

# ----------------------------------------------------------------------------
# 11. DEPLOYMENT
# ----------------------------------------------------------------------------

cat("11. GITHUB PAGES DEPLOYMENT\n")
cat("===========================\n\n")

cat("Option 1: Manual deployment (from docs/):\n")
cat("1. Build site: source('dev/pkgdown_build_site.R')\n")
cat("2. Commit docs/ directory\n")
cat("3. Push to GitHub\n")
cat("4. Settings → Pages → Source: main branch /docs folder\n\n")

cat("Option 2: GitHub Actions (automatic):\n")
cat("Run: usethis::use_pkgdown_github_pages()\n")
cat("This sets up automatic deployment on push\n\n")

# ==============================================================================
# COMPLETE EXAMPLE CONFIGURATION
# ==============================================================================

cat(
  "\n==============================================================================\n"
)
cat("COMPLETE EXAMPLE CONFIGURATION\n")
cat(
  "==============================================================================\n\n"
)

cat("Copy this entire template to _pkgdown.yml and customize:\n\n")
cat("```yaml\n")
cat("# Package website URL\n")
cat("url: https://yourusername.github.io/", pkg_name, "/\n\n", sep = "")
cat("# Template configuration\n")
cat("template:\n")
cat("  bootstrap: 5\n")
cat("  bootswatch: cosmo\n")
cat("  bslib:\n")
cat("    primary: '#0051BA'\n")
cat("    base_font: {google: 'Roboto'}\n")
cat("    code_font: {google: 'Fira Code'}\n")
cat("  \n")
cat("  opengraph:\n")
cat("    image:\n")
cat("      src: man/figures/logo.png\n")
cat("    twitter:\n")
cat("      creator: '@yourusername'\n")
cat("      card: summary\n\n")
cat("# Home page\n")
cat("home:\n")
cat("  title: ", pkg_name, " • Your Package Subtitle\n", sep = "")
cat("  description: |\n")
cat("    A comprehensive description of what your package does.\n")
cat("    Use multiple lines for better readability.\n\n")
cat("# Navigation\n")
cat("navbar:\n")
cat("  structure:\n")
cat("    left:  [intro, reference, articles, news]\n")
cat("    right: [search, github]\n")
cat("  components:\n")
cat("    github:\n")
cat("      icon: fab fa-github fa-lg\n")
cat("      href: https://github.com/yourusername/", pkg_name, "\n\n", sep = "")
cat("# Function reference\n")
cat("reference:\n")
cat("  - title: Main Functions\n")
cat("    desc: Core package functionality\n")
cat("    contents:\n")
cat("      - starts_with('main_')\n")
cat("  \n")
cat("  - title: Utilities\n")
cat("    desc: Helper functions\n")
cat("    contents:\n")
cat("      - starts_with('utils_')\n\n")
cat("# Development mode\n")
cat("development:\n")
cat("  mode: auto\n")
cat("```\n\n")

# ==============================================================================
# PREVIEW OPTION
# ==============================================================================

cat(
  "==============================================================================\n"
)
cat("NEXT STEPS\n")
cat(
  "==============================================================================\n\n"
)

cat("1. Edit _pkgdown.yml with your chosen customizations\n\n")

cat("2. Build the site:\n")
cat("   source('dev/pkgdown_build_site.R')\n\n")

cat("3. Preview locally:\n")
cat("   Open: docs/index.html in your browser\n\n")

cat("4. Deploy to GitHub Pages:\n")
cat("   - Option A: Push docs/ folder (manual)\n")
cat("   - Option B: usethis::use_pkgdown_github_pages() (automatic)\n\n")

cat("RESOURCES:\n")
cat("----------\n")
cat("- pkgdown documentation: https://pkgdown.r-lib.org/\n")
cat(
  "- Customization guide: https://pkgdown.r-lib.org/articles/customise.html\n"
)
cat("- Examples from packages:\n")
cat("  * dplyr: https://dplyr.tidyverse.org/\n")
cat("  * ggplot2: https://ggplot2.tidyverse.org/\n")
cat("  * testthat: https://testthat.r-lib.org/\n\n")

cat(
  "==============================================================================\n"
)

# Offer to preview current site
if (interactive()) {
  cat("\nWould you like to preview the current site? (y/n): ")
  response <- tolower(trimws(readline()))

  if (response == "y" || response == "yes") {
    cat("\nBuilding preview...\n\n")
    pkgdown::build_site()
    cat("\nSite built! Opening docs/index.html...\n")
    cat("(If it doesn't open automatically, navigate to docs/index.html)\n\n")
  }
} else {
  cat("\nSkipping preview (non-interactive mode).\n")
  cat("To preview: pkgdown::build_site() then open docs/index.html\n\n")
}

cat("Customization guide complete!\n")
