# ==============================================================================
# BUILD VIGNETTES
# ==============================================================================
#
# PURPOSE:
#   Build all package vignettes
#
# USAGE:
#   source("dev/build_vignettes.R")
#
# PREREQUISITES:
#   - devtools package: install.packages("devtools")
#   - Run from package root directory
#   - vignettes/ directory with .Rmd files
#
# WHAT THIS DOES:
#   1. Checks for vignettes in vignettes/ directory
#   2. Builds all vignettes using devtools
#   3. Executes R code in vignette chunks
#   4. Generates HTML/PDF output
#   5. Installs vignettes with package
#
# EXPECTED OUTPUT:
#   - Built vignettes in inst/doc/
#   - HTML files for each vignette
#   - Build progress messages
#   - Success/failure notification
#
# NOTES:
#   - Vignettes provide long-form documentation
#   - Run after modifying vignette content
#   - Built vignettes included in package installation
#   - Users access via vignette() or browseVignettes()
#   - May take longer if vignettes have heavy computation
#   - Consider caching expensive computations
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
cat("BUILD VIGNETTES\n")
cat("==============================================================================\n\n")

# Check if vignettes exist
if (!dir.exists("vignettes") || length(list.files("vignettes", pattern = "\\.Rmd$")) == 0) {
  cat("No vignettes found in vignettes/ directory.\n\n")
  cat("This package has no vignettes to build.\n")
  cat("To create one:\n")
  cat("  usethis::use_vignette('vignette-name')\n")
  cat("==============================================================================\n")
  stop("No vignettes found", call. = FALSE)
}

vignette_files <- list.files("vignettes", pattern = "\\.Rmd$")
cat(sprintf("Found %d vignette(s) to build:\n", length(vignette_files)))
for (v in vignette_files) {
  cat(sprintf("  - %s\n", v))
}
cat("\n")

cat("Building vignettes...\n")
cat("(This may take a while if vignettes have expensive computations)\n")
cat("------------------------------------------------------------------------------\n\n")

start_time <- Sys.time()

# Build vignettes
devtools::build_vignettes()

build_time <- difftime(Sys.time(), start_time, units = "secs")

cat("\n==============================================================================\n")
cat("VIGNETTES BUILD COMPLETE\n")
cat("==============================================================================\n")
cat(sprintf("Build time: %.1f seconds\n\n", build_time))

cat("Built vignettes saved to: inst/doc/\n")
cat("\nTo view vignettes:\n")
cat("  browseVignettes('packagename')\n")
cat("==============================================================================\n")
