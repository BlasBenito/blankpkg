# ==============================================================================
# DAILY DOCUMENT AND CHECK
# ==============================================================================
#
# PURPOSE:
#   Most common daily workflow: update documentation and run R CMD check
#
# USAGE:
#   source("dev/daily_document_and_check.R")
#
# PREREQUISITES:
#   - devtools package: install.packages("devtools")
#   - Run from package root directory
#   - Package must be in valid state
#
# WHAT THIS DOES:
#   1. Clears console for clean output
#   2. Runs devtools::document() to regenerate Rd files and NAMESPACE
#   3. Runs devtools::check() to validate package structure
#   4. Reports timing and results summary
#
# EXPECTED OUTPUT:
#   - Roxygen2 messages showing updated documentation files
#   - R CMD check output with errors, warnings, and notes
#   - Final summary with counts and timing information
#
# NOTES:
#   - Updates NAMESPACE file - commit changes if successful
#   - Fix all errors and warnings before committing code (no exceptions!)
#   - Check runs in temp directory, doesn't modify working directory
#   - Typical runtime: 30-60 seconds for small packages
#   - **MOST FREQUENTLY USED** development script - bookmark this!
#   - Run this multiple times per day during active development
#   - Good habit: run before every commit (catches issues early!)
#   - Think of this as your package health check
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
cat("==============================================================================\n")
cat("DAILY WORKFLOW: DOCUMENT AND CHECK\n")
cat("==============================================================================\n\n")

# Step 1: Document
cat("STEP 1/2: Documenting package...\n")
cat("------------------------------------------------------------------------------\n")
start_time <- Sys.time()

devtools::document()

doc_time <- difftime(Sys.time(), start_time, units = "secs")
cat(sprintf("\nDocumentation complete (%.1f seconds)\n\n", doc_time))

# Step 2: Check
cat("STEP 2/2: Running R CMD check...\n")
cat("------------------------------------------------------------------------------\n")
check_start <- Sys.time()

result <- devtools::check(
  document = FALSE,  # Already documented above
  quiet = FALSE
)

check_time <- difftime(Sys.time(), check_start, units = "secs")

# Print summary
cat("\n==============================================================================\n")
cat("CHECK COMPLETE\n")
cat("==============================================================================\n")
cat(sprintf("Documentation time: %.1f seconds\n", doc_time))
cat(sprintf("Check time:         %.1f seconds\n", check_time))
cat(sprintf("Total time:         %.1f seconds\n",
            difftime(Sys.time(), start_time, units = "secs")))
cat("\nResults:\n")
cat(sprintf("  Errors:   %d %s\n",
            length(result$errors),
            ifelse(length(result$errors) == 0, "\u2714", "\u2716")))
cat(sprintf("  Warnings: %d %s\n",
            length(result$warnings),
            ifelse(length(result$warnings) == 0, "\u2714", "\u2716")))
cat(sprintf("  Notes:    %d %s\n",
            length(result$notes),
            ifelse(length(result$notes) == 0, "\u2714", "\u2716")))
cat("==============================================================================\n")

# Return invisibly for programmatic use
invisible(result)
