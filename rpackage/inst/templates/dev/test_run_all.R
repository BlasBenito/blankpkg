# ==============================================================================
# TEST RUN ALL
# ==============================================================================
#
# PURPOSE:
#   Run complete test suite with detailed output
#
# USAGE:
#   source("dev/test_run_all.R")
#
# PREREQUISITES:
#   - devtools package: install.packages("devtools")
#   - testthat configured (tests/testthat/ directory exists)
#   - Run from package root directory
#
# WHAT THIS DOES:
#   1. Loads package with devtools::load_all()
#   2. Runs all tests in tests/testthat/ directory
#   3. Reports detailed results for each test file
#   4. Highlights failures and provides summary statistics
#
# EXPECTED OUTPUT:
#   - Individual test results (pass/fail) for each test
#   - Summary showing total passed, failed, skipped, warnings
#   - Detailed failure messages if any tests fail
#   - Execution timing
#
# NOTES:
#   - Nearly identical to daily_test.R (differs only in console clearing)
#   - daily_test.R clears console first for cleaner output
#   - This script preserves previous console output
#   - Use whichever fits your workflow preference
#   - All tests should pass before committing/pushing
#   - Failed tests show full error details
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
cat("RUN ALL TESTS\n")
cat("==============================================================================\n\n")

cat("Loading package and running full test suite...\n")
cat("------------------------------------------------------------------------------\n\n")

start_time <- Sys.time()

# Run tests
result <- devtools::test()

# Print summary
total_time <- difftime(Sys.time(), start_time, units = "secs")

cat("\n==============================================================================\n")
cat("ALL TESTS COMPLETE\n")
cat("==============================================================================\n")
cat(sprintf("Total time: %.1f seconds\n", total_time))
cat("\nReview any failures above and fix before committing.\n")
cat("==============================================================================\n")

# Return results invisibly
invisible(result)
