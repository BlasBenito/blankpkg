# ==============================================================================
# DAILY LOAD ALL
# ==============================================================================
#
# PURPOSE:
#   Load package code for interactive development and testing
#
# USAGE:
#   source("dev/daily_load_all.R")
#
# PREREQUISITES:
#   - devtools package: install.packages("devtools")
#   - Run from package root directory
#
# WHAT THIS DOES:
#   1. Clears console for clean workspace
#   2. Loads all package functions into current R session
#   3. Simulates package installation without actually installing
#   4. Makes all package functions available for interactive use
#
# EXPECTED OUTPUT:
#   - Loading messages from devtools
#   - Confirmation that package is loaded
#   - Package functions available in current session
#
# NOTES:
#   - Use this for interactive development
#   - Faster than install-and-load cycle
#   - Rerun after changing function code
#   - Functions available without library() call
#   - Source code changes require reload
#   - Very fast, typically < 1 second
#
# ==============================================================================

# Check prerequisites
if (!requireNamespace("devtools", quietly = TRUE)) {
  stop(
    "devtools package required. Install with:\n",
    "  install.packages('devtools')"
  )
}

# Clear console
cat("\014")

# Print header
cat("==============================================================================\n")
cat("DAILY WORKFLOW: LOAD PACKAGE\n")
cat("==============================================================================\n\n")

cat("Loading package into current R session...\n")
cat("------------------------------------------------------------------------------\n")
start_time <- Sys.time()

# Load package
devtools::load_all()

load_time <- difftime(Sys.time(), start_time, units = "secs")

cat("\n==============================================================================\n")
cat("PACKAGE LOADED\n")
cat("==============================================================================\n")
cat(sprintf("Load time: %.2f seconds\n", load_time))
cat("\nPackage functions are now available for interactive use.\n")
cat("Modify code and re-run this script to reload changes.\n")
cat("==============================================================================\n")
