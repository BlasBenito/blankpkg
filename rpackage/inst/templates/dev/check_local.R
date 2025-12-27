# ==============================================================================
# CHECK LOCAL
# ==============================================================================
#
# PURPOSE:
#   Run R CMD check locally - standard package validation
#
# USAGE:
#   source("dev/check_local.R")
#
# PREREQUISITES:
#   - devtools package: install.packages("devtools")
#   - Run from package root directory
#   - Package should be in valid state
#
# WHAT THIS DOES:
#   1. Builds package tarball
#   2. Runs comprehensive R CMD check
#   3. Validates package structure, documentation, examples, tests
#   4. Reports errors, warnings, and notes
#   5. Checks CRAN compliance
#
# EXPECTED OUTPUT:
#   - Detailed check output showing each validation step
#   - Summary of errors, warnings, and notes
#   - List of specific issues if any found
#   - Final status (PASS or issues to fix)
#
# NOTES:
#   - Most important check before CRAN submission
#   - All checks should pass (0 errors, 0 warnings, 0 notes)
#   - Runs in temp directory, safe to run repeatedly
#   - Typical runtime: 30-90 seconds
#   - Fix all issues before committing
#   - Required check before any release
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
cat(
  "==============================================================================\n"
)
cat("LOCAL R CMD CHECK\n")
cat(
  "==============================================================================\n\n"
)

cat("Running comprehensive package check...\n")
cat(
  "(This validates package structure, documentation, examples, and tests)\n\n"
)

start_time <- Sys.time()

# Run check
result <- devtools::check()

# Calculate timing
check_time <- difftime(Sys.time(), start_time, units = "secs")

# Print summary
cat(
  "\n==============================================================================\n"
)
cat("CHECK COMPLETE\n")
cat(
  "==============================================================================\n"
)
cat(sprintf("Check time: %.1f seconds\n\n", check_time))

cat("Results:\n")
cat(sprintf(
  "  Errors:   %d %s\n",
  length(result$errors),
  ifelse(length(result$errors) == 0, "\u2714", "\u2716")
))
cat(sprintf(
  "  Warnings: %d %s\n",
  length(result$warnings),
  ifelse(length(result$warnings) == 0, "\u2714", "\u2716")
))
cat(sprintf(
  "  Notes:    %d %s\n",
  length(result$notes),
  ifelse(length(result$notes) == 0, "\u2714", "\u2716")
))

if (
  length(result$errors) == 0 &&
    length(result$warnings) == 0 &&
    length(result$notes) == 0
) {
  cat("\n\u2714 PACKAGE PASSED ALL CHECKS\n")
} else {
  cat("\n\u2716 FIX ISSUES ABOVE BEFORE PROCEEDING\n")
}

cat(
  "==============================================================================\n"
)

# Return result invisibly
invisible(result)
