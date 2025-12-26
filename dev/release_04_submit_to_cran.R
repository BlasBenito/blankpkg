# ==============================================================================
# RELEASE 04: SUBMIT TO CRAN
# ==============================================================================
#
# PURPOSE:
#   Fourth and final step in CRAN release workflow - submit package to CRAN
#
# USAGE:
#   source("dev/release_04_submit_to_cran.R")
#
# PREREQUISITES:
#   - devtools package installed
#   - All previous release steps (01-03) completed successfully
#   - Remote check results reviewed and passing
#   - Run from package root directory
#
# WHAT THIS DOES:
#   1. Displays final pre-submission checklist
#   2. Confirms you're ready to submit
#   3. Initiates CRAN submission via devtools::release()
#   4. Provides post-submission instructions
#
# EXPECTED OUTPUT:
#   - Pre-submission checklist
#   - Confirmation prompts
#   - Submission confirmation
#   - Post-submission instructions
#
# NOTES:
#   - **CRITICAL**: This is Step 4 of 4 (FINAL STEP) - Point of no return!
#   - PREREQUISITE: Must have passed ALL previous steps (01, 02, 03)
#   - PREREQUISITE: Remote checks (Windows & macOS) must have passed
#   - Read all prompts carefully before confirming - this submits to CRAN!
#   - devtools::release() is interactive - answer questions honestly
#   - You will receive email confirmation from CRAN
#   - First-time submissions may take longer for review (1-2 weeks)
#   - Updates usually processed within 1-3 days
#   - CRAN may request changes before acceptance - be responsive!
#   - Release workflow: 01_prepare → 02_local_checks → 03_remote_checks → **04_submit**
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
cat("SUBMIT TO CRAN (STEP 4/4 - FINAL)\n")
cat("==============================================================================\n\n")

cat("FINAL PRE-SUBMISSION CHECKLIST\n")
cat("==============================\n\n")

cat("Before submitting, confirm that:\n\n")

cat("  [ ] Local R CMD check passed (0 errors, 0 warnings, 0 notes)\n")
cat("  [ ] Windows R-devel check passed\n")
cat("  [ ] macOS R-release check passed\n")
cat("  [ ] Version number updated in DESCRIPTION\n")
cat("  [ ] NEWS.md updated with all changes\n")
cat("  [ ] All documentation is current\n")
cat("  [ ] All code committed to version control\n")
cat("  [ ] Good practice recommendations reviewed\n")
cat("  [ ] Spelling check passed\n")
cat("  [ ] Package website updated (if using pkgdown)\n\n")

cat("IMPORTANT REMINDERS\n")
cat("===================\n")
cat("  - First submissions may require manual CRAN review\n")
cat("  - CRAN may request changes before acceptance\n")
cat("  - Respond to CRAN emails promptly\n")
cat("  - Be polite and professional in all communications\n")
cat("  - Re-submission window is typically 2-4 weeks\n\n")

cat("==============================================================================\n\n")

if (interactive()) {
  cat("Are you ready to submit to CRAN?\n")
  cat("Type 'yes' to proceed, or anything else to cancel: ")
  response <- tolower(trimws(readline()))

  if (response != "yes") {
    cat("\nSubmission cancelled.\n")
    cat("Review checklist and rerun when ready.\n")
    cat("==============================================================================\n")
    stop("Submission cancelled by user", call. = FALSE)
  }
} else {
  cat("Running in non-interactive mode.\n")
  cat("IMPORTANT: Review the checklist above carefully before proceeding!\n")
  cat("Proceeding with CRAN submission...\n\n")
}

cat("\n==============================================================================\n")
cat("INITIATING CRAN SUBMISSION\n")
cat("==============================================================================\n\n")

cat("Launching devtools::release()...\n")
cat("Follow the interactive prompts carefully.\n\n")

# Run release
devtools::release()

cat("\n==============================================================================\n")
cat("POST-SUBMISSION STEPS\n")
cat("==============================================================================\n\n")

cat("WHAT TO DO NOW:\n")
cat("===============\n")
cat("1. Watch for confirmation email from CRAN\n")
cat("2. Respond to any CRAN requests promptly\n")
cat("3. Tag the release in version control:\n")
cat("     git tag -a vX.Y.Z -m 'Release X.Y.Z'\n")
cat("     git push --tags\n")
cat("4. Update package website if using pkgdown\n")
cat("5. Announce release (Twitter, blog, mailing list, etc.)\n")
cat("6. Start development version:\n")
cat("     - Increment version in DESCRIPTION (add .9000)\n")
cat("     - Add new section to NEWS.md\n\n")

cat("IF CRAN REQUESTS CHANGES:\n")
cat("=========================\n")
cat("1. Make requested changes\n")
cat("2. Restart release process from step 1\n")
cat("3. Re-submit within the allowed window (typically 2-4 weeks)\n\n")

cat("CONGRATULATIONS on submitting to CRAN!\n")
cat("==============================================================================\n")
