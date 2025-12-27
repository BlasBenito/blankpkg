# ==============================================================================
# BUILD README
# ==============================================================================
#
# PURPOSE:
#   Render README.Rmd to README.md (if README.Rmd exists)
#
# USAGE:
#   source("dev/build_readme.R")
#
# PREREQUISITES:
#   - devtools package: install.packages("devtools")
#   - rmarkdown package: install.packages("rmarkdown")
#   - Run from package root directory
#   - README.Rmd file exists
#
# WHAT THIS DOES:
#   1. Checks if README.Rmd exists
#   2. Renders README.Rmd to README.md using devtools
#   3. Executes any R code chunks in README.Rmd
#   4. Updates README.md with current output
#   5. Validates the result
#
# EXPECTED OUTPUT:
#   - Updated README.md file
#   - Console output showing rendering progress
#   - Confirmation of successful build
#
# NOTES:
#   - Only runs if README.Rmd exists
#   - README.md is auto-generated, don't edit directly
#   - Rerun after changing README.Rmd
#   - Executes code chunks, ensure they're up-to-date
#   - Commit both .Rmd and .md files
#   - GitHub displays README.md on repository page
#
# ==============================================================================

# Check prerequisites
if (!requireNamespace("devtools", quietly = TRUE)) {
  stop(
    "devtools package required. Install with:\n",
    "  install.packages('devtools')"
  )
}

# Print header
cat("==============================================================================\n")
cat("BUILD README\n")
cat("==============================================================================\n\n")

# Check if README.Rmd exists
if (!file.exists("README.Rmd")) {
  cat("No README.Rmd found in package root.\n\n")
  cat("This package has no README.Rmd to build.\n")
  cat("To create one:\n")
  cat("  usethis::use_readme_rmd()\n")
  cat("==============================================================================\n")
  stop("README.Rmd not found", call. = FALSE)
}

cat("Rendering README.Rmd to README.md...\n")
cat("------------------------------------------------------------------------------\n\n")

start_time <- Sys.time()

# Build README
devtools::build_readme()

build_time <- difftime(Sys.time(), start_time, units = "secs")

cat("\n==============================================================================\n")
cat("README BUILD COMPLETE\n")
cat("==============================================================================\n")
cat(sprintf("Build time: %.1f seconds\n\n", build_time))

cat("README.md has been updated.\n")
cat("\nReminder:\n")
cat("  - Commit both README.Rmd and README.md\n")
cat("  - Don't edit README.md directly\n")
cat("  - Make changes in README.Rmd and rebuild\n")
cat("==============================================================================\n")
