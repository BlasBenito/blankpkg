# ==============================================================================
# TEST SPELLING
# ==============================================================================
#
# PURPOSE:
#   Check package documentation for spelling errors
#
# USAGE:
#   source("dev/test_spelling.R")
#
# PREREQUISITES:
#   - spelling package: install.packages("spelling")
#   - Run from package root directory
#   - inst/WORDLIST file exists (created by usethis::use_spell_check())
#
# WHAT THIS DOES:
#   1. Scans all documentation files (Rd, vignettes, README)
#   2. Checks spelling against package dictionary
#   3. Reports potential spelling errors
#   4. Suggests words to add to WORDLIST
#
# EXPECTED OUTPUT:
#   - List of potential spelling errors found
#   - File and line number for each error
#   - Suggestion to add valid words to inst/WORDLIST
#   - Success message if no errors found
#
# NOTES:
#   - Add technical terms and package names to inst/WORDLIST
#   - One word per line in WORDLIST
#   - Package-specific jargon may be flagged
#   - Function names may need to be added
#   - Rerun after adding words to verify
#   - CRAN submission requires clean spell check
#
# ==============================================================================

# Check prerequisites
if (!requireNamespace("spelling", quietly = TRUE)) {
  stop(
    "spelling package required. Install with:\n",
    "  install.packages('spelling')"
  )
}

# Print header
cat(
  "==============================================================================\n"
)
cat("SPELL CHECK\n")
cat(
  "==============================================================================\n\n"
)

cat("Checking spelling in package documentation...\n")
cat(
  "------------------------------------------------------------------------------\n\n"
)

# Run spell check
spelling_errors <- spelling::spell_check_package()

# Print results
if (nrow(spelling_errors) == 0) {
  cat(
    "\n==============================================================================\n"
  )
  cat("NO SPELLING ERRORS FOUND\n")
  cat(
    "==============================================================================\n"
  )
  cat("All documentation passed spell check.\n")
} else {
  cat(
    "\n==============================================================================\n"
  )
  cat(sprintf("FOUND %d POTENTIAL SPELLING ERROR(S)\n", nrow(spelling_errors)))
  cat(
    "==============================================================================\n\n"
  )
  print(spelling_errors)
  cat(
    "\n------------------------------------------------------------------------------\n"
  )
  cat("To add valid words to the dictionary:\n")
  cat("  1. Open inst/WORDLIST\n")
  cat("  2. Add one word per line\n")
  cat("  3. Save and rerun this script\n")
  cat("\nTo update WORDLIST with suggested words:\n")
  cat("  spelling::update_wordlist()\n")
}

cat(
  "==============================================================================\n"
)

# Return errors invisibly
invisible(spelling_errors)
