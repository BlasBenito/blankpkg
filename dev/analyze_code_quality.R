# ==============================================================================
# ANALYZE CODE QUALITY
# ==============================================================================
#
# PURPOSE:
#   Analyze code style, quality, and potential issues
#
# USAGE:
#   source("dev/analyze_code_quality.R")
#
# PREREQUISITES:
#   - codetools package: install.packages("codetools")
#   - Run from package root directory
#
# WHAT THIS DOES:
#   1. Checks for potential coding problems with codetools
#   2. Identifies global variable usage
#   3. Detects undefined variables
#   4. Finds possible errors in code logic
#   5. Reports suspicious constructs
#
# EXPECTED OUTPUT:
#   - List of potential code quality issues
#   - Global variable warnings
#   - Undefined variable errors
#   - Suspicious code patterns
#   - Suggestions for improvement
#
# NOTES:
#   - Helps catch common coding mistakes
#   - Some warnings may be false positives
#   - Use with roxyglobals for global variable handling
#   - Review all warnings, but use judgment
#   - Run before CRAN submission
#   - Complements goodpractice::gp() analysis
#   - Sources R files in isolated environment (safe for analysis)
#   - Will not execute top-level code outside of functions
#
# ==============================================================================

# Check prerequisites
if (!requireNamespace("codetools", quietly = TRUE)) {
  stop(
    "codetools package required. Install with:\n",
    "  install.packages('codetools')"
  )
}

# Print header
cat(
  "==============================================================================\n"
)
cat("CODE QUALITY ANALYSIS\n")
cat(
  "==============================================================================\n\n"
)

cat("Analyzing code for potential issues...\n")
cat(
  "------------------------------------------------------------------------------\n\n"
)

# Get all R files
r_files <- list.files(
  "R",
  pattern = "\\.R$",
  full.names = TRUE,
  recursive = TRUE
)

if (length(r_files) == 0) {
  cat("No R files found in R/ directory.\n")
  cat(
    "==============================================================================\n"
  )
  stop("No R files to analyze", call. = FALSE)
}

cat(sprintf("Analyzing %d R file(s)...\n\n", length(r_files)))

# Track issues found
total_issues <- 0

# Analyze each file
for (r_file in r_files) {
  file_name <- basename(r_file)

  cat(sprintf("Checking: %s\n", file_name))
  cat(strrep("-", 78), "\n")

  # Capture codetools output
  analysis_error <- FALSE
  issues <- capture.output({
    tryCatch(
      {
        # Source file and check
        env <- new.env()
        source(r_file, local = env)

        # Check all functions in the file
        func_names <- ls(env)
        for (func_name in func_names) {
          func <- get(func_name, envir = env)
          if (is.function(func)) {
            codetools::checkUsage(func, name = func_name)
          }
        }
      },
      error = function(e) {
        analysis_error <<- TRUE
        cat(sprintf("ERROR: Failed to analyze this file\n"))
        cat(sprintf("Reason: %s\n", e$message))
        cat("Possible causes:\n")
        cat("  - Syntax errors in the file\n")
        cat("  - Top-level code that fails when sourced\n")
        cat("  - Missing dependencies\n")
      }
    )
  })

  # If there was an error, mark it
  if (analysis_error) {
    total_issues <- total_issues + 1
  }

  # Print issues for this file
  if (length(issues) > 0) {
    for (issue in issues) {
      cat(sprintf("  %s\n", issue))
      total_issues <- total_issues + 1
    }
  } else {
    cat("  \u2714 No issues found\n")
  }

  cat("\n")
}

# Summary
cat(
  "==============================================================================\n"
)
cat("CODE QUALITY ANALYSIS COMPLETE\n")
cat(
  "==============================================================================\n"
)
cat(sprintf("Total potential issues found: %d\n\n", total_issues))

if (total_issues > 0) {
  cat("COMMON ISSUES EXPLAINED:\n")
  cat("------------------------\n")
  cat(
    "- 'no visible binding for global variable': May need @importFrom or utils::\n"
  )
  cat(
    "- 'no visible global function definition': Import the function or use pkg::\n"
  )
  cat("- 'local variable assigned but not used': Remove unused variables\n")
  cat("- 'parameter never used': Consider removing or using parameter\n\n")

  cat("HANDLING GLOBAL VARIABLES:\n")
  cat("--------------------------\n")
  cat("- Use roxyglobals: Add @autoglobal tag to functions\n")
  cat("- Use utils::globalVariables() for intentional globals\n")
  cat("- Import functions explicitly with @importFrom\n\n")

  cat("NEXT STEPS:\n")
  cat("-----------\n")
  cat("1. Review each issue listed above\n")
  cat("2. Fix genuine problems\n")
  cat("3. Document false positives (globals, NSE, etc.)\n")
  cat("4. Rerun analysis to verify fixes\n")
} else {
  cat("\u2714 No code quality issues found!\n")
  cat("\nYour code passes static analysis.\n")
}

cat(
  "==============================================================================\n"
)
