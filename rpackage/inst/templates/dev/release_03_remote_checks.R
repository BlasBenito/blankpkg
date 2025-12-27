# ==============================================================================
# RELEASE 03: REMOTE CHECKS
# ==============================================================================
#
# PURPOSE:
#   Third step in CRAN release workflow - submit to remote checking services
#
# USAGE:
#   source("dev/release_03_remote_checks.R")
#
# PREREQUISITES:
#   - devtools package installed
#   - Local checks (step 02) passed successfully
#   - Run from package root directory
#   - Internet connection required
#
# WHAT THIS DOES:
#   1. Submits package to Windows R-devel builder
#   2. Submits package to macOS R-release builder
#   3. Provides instructions for reviewing results
#
# EXPECTED OUTPUT:
#   - Submission confirmations
#   - Email addresses where results will be sent
#   - Estimated wait time
#   - Instructions for next steps
#
# NOTES:
#   - **CRITICAL**: This is Step 3 of 4 - must follow exact sequence!
#   - PREREQUISITE: Must have passed release_02_local_checks.R
#   - Results arrive via email in 15-60 minutes
#   - Check results carefully before final submission
#   - Both checks (Windows & macOS) should pass with 0 errors/warnings
#   - Check spam folder if results don't arrive
#   - If remote checks fail, go back to step 2, fix issues, repeat
#   - Release workflow: 01_prepare → 02_local_checks → **03_remote_checks** → 04_submit
#   - Next step: source("dev/release_04_submit_to_cran.R")
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
cat("REMOTE VALIDATION CHECKS (STEP 3/4)\n")
cat(
  "==============================================================================\n\n"
)

cat("IMPORTANT INFORMATION:\n")
cat("======================\n")
cat("This script will submit your package to remote checking services.\n")
cat("Results will be emailed to the package maintainer.\n")
cat("Typical wait time: 15-60 minutes\n")
cat("Check your spam folder if results don't arrive.\n\n")

if (interactive()) {
  cat(
    "Press ENTER to submit package for remote checks, or Ctrl+C to cancel...\n"
  )
  readline()
} else {
  cat("Running in non-interactive mode - proceeding with submission...\n")
}

cat(
  "\n==============================================================================\n\n"
)

# Submit to Windows builder
cat("SUBMITTING TO WINDOWS R-DEVEL BUILDER\n")
cat("--------------------------------------\n")
devtools::check_win_devel()
cat("\n\u2714 Submitted to Windows builder\n\n")

# Submit to Mac builder
cat("SUBMITTING TO MACOS R-RELEASE BUILDER\n")
cat("--------------------------------------\n")
devtools::check_mac_release()
cat("\n\u2714 Submitted to macOS builder\n\n")

cat(
  "==============================================================================\n"
)
cat("REMOTE CHECKS SUBMITTED\n")
cat(
  "==============================================================================\n\n"
)

cat("WHAT HAPPENS NEXT:\n")
cat("==================\n")
cat("1. You will receive 2 emails with check results (15-60 minutes)\n")
cat("2. Review both sets of results carefully\n")
cat("3. Both checks should show:\n")
cat("   - 0 errors\n")
cat("   - 0 warnings\n")
cat("   - 0 notes (or only acceptable notes)\n\n")

cat("IF CHECKS PASS:\n")
cat("  Proceed to final submission:\n")
cat("  source('dev/release_04_submit_to_cran.R')\n\n")

cat("IF CHECKS FAIL:\n")
cat("  1. Fix the reported issues\n")
cat("  2. Return to step 2: source('dev/release_02_local_checks.R')\n")
cat("  3. Rerun all checks\n")

cat(
  "==============================================================================\n"
)
