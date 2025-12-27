# ==============================================================================
# ANALYZE CODE COVERAGE
# ==============================================================================
#
# PURPOSE:
#   Analyze test coverage for the package and optionally generate interactive
#   HTML report
#
# USAGE:
#   source("dev/analyze_code_coverage.R")
#
# PREREQUISITES:
#   - covr package: install.packages("covr")
#   - Package must have tests in tests/testthat/
#   - Run from package root directory
#
# WHAT THIS DOES:
#   1. Checks that covr package is installed
#   2. Calculates test coverage for all package code
#   3. Displays coverage summary in console
#   4. Optionally generates interactive HTML report in browser
#
# EXPECTED OUTPUT:
#   - Console output showing coverage percentage per file
#   - Overall package coverage percentage
#   - Optional: Interactive HTML report opens in browser
#
# NOTES:
#   - Coverage calculation runs all tests, may take time
#   - Look for files with < 80% coverage
#   - Interactive report shows line-by-line coverage
#   - Report highlights untested code in red
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
cat(
  "==============================================================================\n"
)
cat("CODE COVERAGE ANALYSIS\n")
cat(
  "==============================================================================\n\n"
)

# Calculate coverage
cat("Calculating test coverage...\n")
cat("(This may take a moment as all tests are executed)\n\n")

coverage <- covr::package_coverage()

# Print coverage summary
print(coverage)

# Calculate total coverage percentage
total_coverage <- covr::percent_coverage(coverage)

cat(
  "\n==============================================================================\n"
)
cat(sprintf("OVERALL COVERAGE: %.1f%%\n", total_coverage))
cat(
  "==============================================================================\n\n"
)

# Offer interactive report
cat("To view detailed interactive HTML report, run:\n")
cat("  covr::report(coverage)\n\n")

# Return coverage object invisibly
invisible(coverage)
