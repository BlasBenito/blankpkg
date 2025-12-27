# ==============================================================================
# CHECK GOOD PRACTICE
# ==============================================================================
#
# PURPOSE:
#   Analyze package for adherence to R package best practices
#
# USAGE:
#   source("dev/check_good_practice.R")
#
# PREREQUISITES:
#   - goodpractice package: install.packages("goodpractice")
#   - Run from package root directory
#   - Package should be in buildable state
#
# WHAT THIS DOES:
#   1. Analyzes package structure and code quality
#   2. Checks coding style and conventions
#   3. Validates documentation completeness
#   4. Reviews function complexity
#   5. Checks for common anti-patterns
#   6. Provides actionable recommendations
#
# EXPECTED OUTPUT:
#   - List of recommendations categorized by type
#   - Code style issues
#   - Documentation gaps
#   - Complexity warnings
#   - Best practice violations
#   - Suggestions for improvement
#
# NOTES:
#   - More opinionated than R CMD check
#   - Recommendations may be subjective
#   - Not all suggestions are mandatory
#   - Useful for improving code quality
#   - May take 1-3 minutes to run
#   - Good to run before CRAN submission
#   - Can help catch issues before review
#
# ==============================================================================

# Check prerequisites
if (!requireNamespace("goodpractice", quietly = TRUE)) {
  stop(
    "goodpractice package required. Install with:\n",
    "  install.packages('goodpractice')"
  )
}

# Print header
cat("==============================================================================\n")
cat("GOOD PRACTICE ANALYSIS\n")
cat("==============================================================================\n\n")

cat("Analyzing package for best practices...\n")
cat("(This may take 1-3 minutes)\n\n")

start_time <- Sys.time()

# Run good practice check
gp_result <- goodpractice::gp()

# Print results
print(gp_result)

# Calculate timing
check_time <- difftime(Sys.time(), start_time, units = "secs")

cat("\n==============================================================================\n")
cat("ANALYSIS COMPLETE\n")
cat("==============================================================================\n")
cat(sprintf("Analysis time: %.1f seconds\n\n", check_time))

cat("Review recommendations above.\n")
cat("Not all suggestions are mandatory, but consider each one.\n")
cat("Address critical issues before CRAN submission.\n")
cat("==============================================================================\n")

# Return results invisibly
invisible(gp_result)
