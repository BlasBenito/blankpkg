# ==============================================================================
# BUILD PACKAGE SITE
# ==============================================================================
#
# PURPOSE:
#   Build pkgdown website for package documentation
#
# USAGE:
#   source("dev/pkgdown_build_site.R")
#
# PREREQUISITES:
#   - pkgdown package: install.packages("pkgdown")
#   - Run from package root directory
#   - _pkgdown.yml configuration file exists
#   - Package documentation should be up-to-date
#
# WHAT THIS DOES:
#   1. Checks that pkgdown is configured
#   2. Builds complete package website
#   3. Generates HTML documentation from Rd files
#   4. Creates function reference pages
#   5. Renders vignettes and articles
#   6. Builds search index
#   7. Saves website to docs/ directory
#
# EXPECTED OUTPUT:
#   - docs/ directory with complete website
#   - index.html (homepage)
#   - reference/ (function documentation)
#   - articles/ (vignettes)
#   - Website preview opens in browser
#
# NOTES:
#   - Run after updating documentation
#   - Website saved to docs/ directory
#   - Configure appearance in _pkgdown.yml
#   - Can deploy to GitHub Pages from docs/
#   - Typical runtime: 10-30 seconds
#   - Rebuilds entire site each time
#
# ==============================================================================

# Check prerequisites
if (!requireNamespace("pkgdown", quietly = TRUE)) {
  stop(
    "pkgdown package required. Install with:\n",
    "  install.packages('pkgdown')"
  )
}

# Print header
cat("==============================================================================\n")
cat("BUILD PACKAGE WEBSITE\n")
cat("==============================================================================\n\n")

cat("Building pkgdown site...\n")
cat("(This may take 10-30 seconds)\n\n")

start_time <- Sys.time()

# Build site
pkgdown::build_site()

build_time <- difftime(Sys.time(), start_time, units = "secs")

cat("\n==============================================================================\n")
cat("SITE BUILD COMPLETE\n")
cat("==============================================================================\n")
cat(sprintf("Build time: %.1f seconds\n\n", build_time))

cat("Website saved to: docs/\n")
cat("Main page: docs/index.html\n\n")

cat("To preview locally, open docs/index.html in your browser.\n")
cat("To deploy to GitHub Pages:\n")
cat("  1. Push docs/ directory to GitHub\n")
cat("  2. Enable GitHub Pages in repository settings\n")
cat("  3. Set source to 'main branch /docs folder'\n")
cat("==============================================================================\n")
