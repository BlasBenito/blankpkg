# ==============================================================================
# DAILY TEST
# ==============================================================================
#
# PURPOSE:
#   Quick test run for rapid development iteration
#
# USAGE:
#   source("dev/daily_test.R")
#
# PREREQUISITES:
#   - devtools package: install.packages("devtools")
#   - testthat configured (tests/testthat/ directory exists)
#   - Run from package root directory
#
# WHAT THIS DOES:
#   1. Clears console for clean output
#   2. Loads package code with devtools::load_all()
#   3. Runs all tests with devtools::test()
#   4. Reports test results and timing
#
# EXPECTED OUTPUT:
#   - Loading messages showing package loaded
#   - Test execution with pass/fail indicators
#   - Summary of test results (passed, failed, skipped, warnings)
#   - Total execution time
#
# NOTES:
#   - Faster than full check, use for quick iteration
#   - Load_all() simulates package installation
#   - Tests run in current R session
#   - Typical runtime: 5-15 seconds
#   - Fix failing tests before committing
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
cat(
  "==============================================================================\n"
)
cat("DAILY WORKFLOW: RUN TESTS\n")
cat(
  "==============================================================================\n\n"
)

cat("Loading package...\n")
cat(
  "------------------------------------------------------------------------------\n"
)
start_time <- Sys.time()

# Load package
devtools::load_all(quiet = TRUE)

cat("Package loaded.\n\n")

# Run tests
cat("Running tests...\n")
cat(
  "------------------------------------------------------------------------------\n"
)

result <- devtools::test()

# Print summary
total_time <- difftime(Sys.time(), start_time, units = "secs")

cat(
  "\n==============================================================================\n"
)
cat("TEST COMPLETE\n")
cat(
  "==============================================================================\n"
)
cat(sprintf("Total time: %.1f seconds\n", total_time))
cat(
  "==============================================================================\n"
)

# Return results invisibly
invisible(result)
