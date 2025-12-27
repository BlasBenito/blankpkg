# ==============================================================================
# CHECK MAC RELEASE
# ==============================================================================
#
# PURPOSE:
#   Submit package for checking on macOS R-release (current stable version)
#
# USAGE:
#   source("dev/check_mac_release.R")
#
# PREREQUISITES:
#   - devtools package: install.packages("devtools")
#   - Run from package root directory
#   - Package must pass local checks first
#   - Internet connection required
#
# WHAT THIS DOES:
#   1. Builds package tarball
#   2. Submits to macOS builder service
#   3. Runs R CMD check on macOS R-release
#   4. Sends results via email
#
# EXPECTED OUTPUT:
#   - Submission confirmation message
#   - Email address where results will be sent
#   - Link to check results (if provided)
#
# NOTES:
#   - Check runs on remote macOS server
#   - Results arrive via email in 15-60 minutes
#   - Tests against current release version of R
#   - Important for CRAN submission
#   - May find macOS-specific issues
#   - Check your email spam folder if results don't arrive
#   - Useful for non-Mac developers
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
cat("MACOS R-RELEASE CHECK\n")
cat("==============================================================================\n\n")

cat("Submitting package to macOS builder for R-release check...\n")
cat("------------------------------------------------------------------------------\n\n")

cat("IMPORTANT:\n")
cat("  - Results will be emailed to the package maintainer\n")
cat("  - Check may take 15-60 minutes\n")
cat("  - Check your spam folder if results don't arrive\n")
cat("  - Tests against current release version of R on macOS\n\n")

# Submit to mac-builder
devtools::check_mac_release()

cat("\n==============================================================================\n")
cat("SUBMISSION COMPLETE\n")
cat("==============================================================================\n")
cat("Your package has been submitted to the macOS builder.\n")
cat("Results will be emailed when the check completes.\n")
cat("==============================================================================\n")
