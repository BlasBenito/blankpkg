# ==============================================================================
# RELEASE 01: PREPARE
# ==============================================================================
#
# PURPOSE:
#   First step in CRAN release workflow - prepare package for submission
#
# USAGE:
#   source("dev/release_01_prepare.R")
#
# PREREQUISITES:
#   - devtools and usethis packages installed
#   - Run from package root directory
#   - All development work complete
#
# WHAT THIS DOES:
#   Provides a checklist for release preparation:
#   1. Version number update guidance
#   2. NEWS.md update reminder
#   3. DESCRIPTION file validation
#   4. Spell check execution
#   5. Final documentation review
#
# EXPECTED OUTPUT:
#   - Checklist displayed in console
#   - Spell check results
#   - Action items for manual completion
#
# NOTES:
#   - **CRITICAL**: This is Step 1 of 4 - must follow exact sequence!
#   - DO NOT skip steps or change order (each builds on the previous one!)
#   - Review checklist carefully and complete ALL tasks before proceeding
#   - Update version in DESCRIPTION manually (remove .9000 suffix if present)
#   - Update NEWS.md with changes since last release (be thorough!)
#   - Fix any spelling errors found
#   - Only proceed to step 2 after completing everything here (we mean it!)
#   - Release workflow: 01_prepare → 02_local_checks → 03_remote_checks → 04_submit
#   - Next step: source("dev/release_02_local_checks.R")
#
# ==============================================================================

# Print header
cat(
  "==============================================================================\n"
)
cat("RELEASE PREPARATION CHECKLIST (STEP 1/4)\n")
cat(
  "==============================================================================\n\n"
)

cat("RELEASE PREPARATION TASKS:\n")
cat("==========================\n\n")

# Task 1: Version number
cat("[1] UPDATE VERSION NUMBER\n")
cat("    - Open DESCRIPTION file\n")
cat("    - Update Version field following semantic versioning:\n")
cat("      * Major.Minor.Patch (e.g., 1.0.0, 1.1.0, 1.0.1)\n")
cat("      * Remove .9000 development suffix if present\n")
cat("    - Save DESCRIPTION file (don't forget this step!)\n\n")

# Task 2: NEWS.md
cat("[2] UPDATE NEWS.md\n")
cat("    - Document all changes since last release\n")
cat("    - Group changes by category:\n")
cat("      * New features\n")
cat("      * Bug fixes\n")
cat("      * Breaking changes\n")
cat("      * Deprecated features\n")
cat("    - Include issue/PR numbers if applicable\n\n")

# Task 3: Check DESCRIPTION
cat("[3] VALIDATE DESCRIPTION FILE\n")
cat("    Check that DESCRIPTION includes:\n")
cat("    - Accurate Title (title case, no period at the end)\n")
cat("    - Complete Description (what, why, how—be specific!)\n")
cat("    - All authors with proper roles (aut, cre, ctb, etc.)\n")
cat("    - Correct license\n")
cat("    - All imports and suggests listed (check your code!)\n")
cat("    - Valid URL and BugReports fields (if applicable)\n\n")

# Task 4: Spell check
cat("[4] SPELL CHECK\n")
cat("    Running spell check now...\n")
cat("    ----------------------------------------\n")

if (requireNamespace("spelling", quietly = TRUE)) {
  spelling_errors <- spelling::spell_check_package()
  if (nrow(spelling_errors) == 0) {
    cat("    \u2714 No spelling errors found\n")
  } else {
    cat(sprintf(
      "    \u2716 Found %d spelling error(s):\n",
      nrow(spelling_errors)
    ))
    print(spelling_errors)
    cat("\n    Fix errors and rerun this script\n")
  }
} else {
  cat("    \u26A0 spelling package not installed\n")
  cat("    Install with: install.packages('spelling')\n")
}

cat("\n")

# Task 5: Documentation
cat("[5] DOCUMENTATION REVIEW\n")
cat("    - Run devtools::document() to update documentation\n")
cat("    - Review all exported function documentation\n")
cat("    - Ensure examples run without errors\n")
cat("    - Update README.md if needed\n")
cat("    - Build vignettes if they exist\n\n")

cat(
  "==============================================================================\n"
)
cat("NEXT STEPS\n")
cat(
  "==============================================================================\n"
)
cat("After completing all tasks above:\n")
cat("  source('dev/release_02_local_checks.R')\n")
cat(
  "==============================================================================\n"
)
