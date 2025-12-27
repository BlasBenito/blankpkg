# ==============================================================================
# TEST WITH COVERAGE
# ==============================================================================
#
# PURPOSE:
#   Run tests and generate interactive code coverage report
#
# USAGE:
#   source("dev/test_with_coverage.R")
#
# PREREQUISITES:
#   - covr package: install.packages("covr")
#   - devtools package: install.packages("devtools")
#   - Tests configured in tests/testthat/
#   - Run from package root directory
#
# WHAT THIS DOES:
#   1. Runs all package tests
#   2. Calculates code coverage for each file
#   3. Generates interactive HTML coverage report
#   4. Opens report in web browser
#   5. Highlights untested code lines in red
#
# EXPECTED OUTPUT:
#   - Test execution output showing pass/fail
#   - Coverage percentage for each source file
#   - Overall package coverage percentage
#   - Interactive HTML report opens in browser
#
# NOTES:
#   - Combines testing and coverage analysis
#   - Interactive report shows line-by-line coverage
#   - Red highlighting shows uncovered code
#   - Green highlighting shows covered code
#   - Aim for > 80% coverage
#   - May take longer than regular test run
#
# ==============================================================================

# Check prerequisites
if (!requireNamespace("covr", quietly = TRUE)) {
  stop(
    "covr package required. Install with:\n",
    "  install.packages('covr')"
  )
}

# Print header
cat("==============================================================================\n")
cat("TEST WITH COVERAGE ANALYSIS\n")
cat("==============================================================================\n\n")

cat("Running tests and calculating coverage...\n")
cat("(This may take a moment as all tests are executed twice)\n\n")

start_time <- Sys.time()

# Calculate coverage
coverage <- covr::package_coverage()

# Show coverage summary
print(coverage)

# Calculate total coverage
total_coverage <- covr::percent_coverage(coverage)

cat("\n==============================================================================\n")
cat(sprintf("OVERALL COVERAGE: %.1f%%\n", total_coverage))
cat("==============================================================================\n")

# Generate interactive report
cat("\nGenerating interactive coverage report...\n")
covr::report(coverage)

total_time <- difftime(Sys.time(), start_time, units = "secs")

cat(sprintf("\nTotal time: %.1f seconds\n", total_time))
cat("\nInteractive coverage report should open in your browser.\n")
cat("Red lines indicate untested code.\n")
cat("==============================================================================\n")

# Return coverage invisibly
invisible(coverage)
