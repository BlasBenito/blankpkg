# ==============================================================================
# RELEASE 02: LOCAL CHECKS
# ==============================================================================
#
# PURPOSE:
#   Second step in CRAN release workflow - run comprehensive local validation
#
# USAGE:
#   source("dev/release_02_local_checks.R")
#
# PREREQUISITES:
#   - devtools and goodpractice packages installed
#   - Release preparation (step 01) completed
#   - Run from package root directory
#
# WHAT THIS DOES:
#   1. Runs devtools::check() - comprehensive R CMD check
#   2. Runs goodpractice::gp() - best practices analysis
#   3. Validates that all checks pass
#   4. Reports any issues that must be fixed
#
# EXPECTED OUTPUT:
#   - Detailed R CMD check results
#   - Good practice recommendations
#   - Pass/fail summary
#   - List of issues to fix (if any)
#
# NOTES:
#   - **CRITICAL**: This is Step 2 of 4 - must follow exact sequence!
#   - PREREQUISITE: Must complete release_01_prepare.R first
#   - ALL checks must pass (0 errors, 0 warnings, 0 notes) before proceeding
#   - Fix all issues and rerun until checks pass
#   - May take 2-5 minutes to complete
#   - Do NOT skip to step 3 if checks fail - fix issues first!
#   - Release workflow: 01_prepare → **02_local_checks** → 03_remote_checks → 04_submit
#   - Next step: source("dev/release_03_remote_checks.R")
#
# ==============================================================================

# Check prerequisites
if (!requireNamespace("devtools", quietly = TRUE)) {
  stop(
    "devtools package required. Install with:\n",
    "  install.packages('devtools')"
  )
}

if (!requireNamespace("goodpractice", quietly = TRUE)) {
  stop(
    "goodpractice package required. Install with:\n",
    "  install.packages('goodpractice')"
  )
}

# Print header
cat("==============================================================================\n")
cat("LOCAL VALIDATION CHECKS (STEP 2/4)\n")
cat("==============================================================================\n\n")

cat("Running comprehensive local checks...\n")
cat("This may take 2-5 minutes.\n\n")

overall_start <- Sys.time()

# Check 1: R CMD check
cat("CHECK 1/2: R CMD CHECK\n")
cat("------------------------------------------------------------------------------\n")
check_start <- Sys.time()

check_result <- devtools::check()

check_time <- difftime(Sys.time(), check_start, units = "secs")

cat(sprintf("\nR CMD check completed in %.1f seconds\n", check_time))
cat(sprintf("  Errors:   %d %s\n",
            length(check_result$errors),
            ifelse(length(check_result$errors) == 0, "\u2714", "\u2716")))
cat(sprintf("  Warnings: %d %s\n",
            length(check_result$warnings),
            ifelse(length(check_result$warnings) == 0, "\u2714", "\u2716")))
cat(sprintf("  Notes:    %d %s\n",
            length(check_result$notes),
            ifelse(length(check_result$notes) == 0, "\u2714", "\u2716")))

check_passed <- (length(check_result$errors) == 0 &&
                 length(check_result$warnings) == 0 &&
                 length(check_result$notes) == 0)

# Check 2: Good practice
cat("\nCHECK 2/2: GOOD PRACTICE ANALYSIS\n")
cat("------------------------------------------------------------------------------\n")
gp_start <- Sys.time()

gp_result <- goodpractice::gp(quiet = TRUE)

gp_time <- difftime(Sys.time(), gp_start, units = "secs")

cat(sprintf("\nGood practice analysis completed in %.1f seconds\n", gp_time))
print(gp_result)

# Final summary
total_time <- difftime(Sys.time(), overall_start, units = "secs")

cat("\n==============================================================================\n")
cat("LOCAL CHECKS COMPLETE\n")
cat("==============================================================================\n")
cat(sprintf("Total time: %.1f seconds\n\n", total_time))

if (check_passed) {
  cat("\u2714 R CMD CHECK PASSED - Ready for remote checks\n\n")
  cat("NEXT STEPS:\n")
  cat("  Review good practice recommendations above\n")
  cat("  Address any critical issues\n")
  cat("  Then run: source('dev/release_03_remote_checks.R')\n")
} else {
  cat("\u2716 R CMD CHECK FAILED - Fix issues before proceeding\n\n")
  cat("DO NOT PROCEED TO REMOTE CHECKS\n")
  cat("  1. Fix all errors, warnings, and notes\n")
  cat("  2. Rerun this script\n")
  cat("  3. Ensure all checks pass\n")
}

cat("==============================================================================\n")

# Return results invisibly
invisible(list(check = check_result, gp = gp_result))
