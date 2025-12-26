# ==============================================================================
# CHECK WINDOWS DEVEL
# ==============================================================================
#
# PURPOSE:
#   Submit package for checking on Windows R-devel (development version)
#
# USAGE:
#   source("dev/check_win_devel.R")
#
# PREREQUISITES:
#   - devtools package: install.packages("devtools")
#   - Run from package root directory
#   - Package must pass local checks first
#   - Internet connection required
#
# WHAT THIS DOES:
#   1. Builds package tarball
#   2. Submits to win-builder service
#   3. Runs R CMD check on Windows R-devel
#   4. Sends results via email
#
# EXPECTED OUTPUT:
#   - Submission confirmation message
#   - Email address where results will be sent
#   - Link to check results (if provided)
#
# NOTES:
#   - Check runs on remote Windows server
#   - Results arrive via email in 15-60 minutes
#   - Tests against development version of R
#   - Important for CRAN submission
#   - May find Windows-specific issues
#   - Check your email spam folder if results don't arrive
#   - Free service provided by Uwe Ligges
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
cat("WINDOWS R-DEVEL CHECK\n")
cat("==============================================================================\n\n")

cat("Submitting package to win-builder for Windows R-devel check...\n")
cat("------------------------------------------------------------------------------\n\n")

cat("IMPORTANT:\n")
cat("  - Results will be emailed to the package maintainer\n")
cat("  - Check may take 15-60 minutes\n")
cat("  - Check your spam folder if results don't arrive\n")
cat("  - Tests against development version of R on Windows\n\n")

# Submit to win-builder
devtools::check_win_devel()

cat("\n==============================================================================\n")
cat("SUBMISSION COMPLETE\n")
cat("==============================================================================\n")
cat("Your package has been submitted to win-builder.\n")
cat("Results will be emailed when the check completes.\n")
cat("==============================================================================\n")
