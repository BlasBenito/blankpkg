# ==============================================================================
# .Rprofile - Project-level R configuration
# ==============================================================================
#
# This file runs automatically when R starts in this directory.
# It sets up the development environment for this R package.
#
# ==============================================================================

# Quiet startup
if (interactive()) {

  # --------------------------------------------------------------------------
  # Auto-install pre-commit hook
  # --------------------------------------------------------------------------

  # Check if this is a git repository
  if (dir.exists(".git")) {

    hook_source <- "dev/pre_commit_hook"
    hook_target <- ".git/hooks/pre-commit"

    # Check if pre-commit hook exists and is up-to-date
    if (file.exists(hook_source)) {

      install_hook <- FALSE

      if (!file.exists(hook_target)) {
        # Hook doesn't exist, install it
        install_hook <- TRUE
        reason <- "not installed"
      } else {
        # Check if hook is outdated (compare file sizes as simple check)
        source_info <- file.info(hook_source)
        target_info <- file.info(hook_target)

        if (source_info$size != target_info$size ||
            source_info$mtime > target_info$mtime) {
          install_hook <- TRUE
          reason <- "outdated"
        }
      }

      if (install_hook) {
        # Copy hook to .git/hooks/
        file.copy(hook_source, hook_target, overwrite = TRUE)

        # Make hook executable (Unix/Linux/Mac)
        if (.Platform$OS.type == "unix") {
          Sys.chmod(hook_target, mode = "0755")
        }

        # Inform user
        cat("\n")
        cat("================================================================================\n")
        cat("PRE-COMMIT HOOK INSTALLED\n")
        cat("================================================================================\n\n")

        cat(sprintf("Status: Hook was %s and has been updated.\n\n", reason))

        cat("The pre-commit hook will automatically run before each commit:\n")
        cat("  1. Jarl linter (auto-fix)\n")
        cat("  2. Air formatter\n")
        cat("  3. devtools::document()\n")
        cat("  4. devtools::check() (CRAN standards)\n\n")

        cat("USAGE:\n")
        cat("------\n")
        cat("Normal commit (hook runs automatically):\n")
        cat("  git commit -m 'your message'\n\n")

        cat("Skip hook for a single commit:\n")
        cat("  git commit --no-verify -m 'your message'\n\n")

        cat("Disable hook permanently:\n")
        cat("  rm .git/hooks/pre-commit\n\n")

        cat("NOTES:\n")
        cat("------\n")
        cat("- The hook ensures code quality before commits\n")
        cat("- R CMD check may take 30-90 seconds\n")
        cat("- Use --no-verify for quick commits (not recommended)\n")
        cat("- Hook auto-updates when dev/pre_commit_hook changes\n\n")

        cat("================================================================================\n\n")
      }
    }
  }

  # --------------------------------------------------------------------------
  # Package development helpers
  # --------------------------------------------------------------------------

  # Load devtools if available (for convenience)
  if (requireNamespace("devtools", quietly = TRUE)) {
    suppressMessages(library(devtools))
  }

  # Set options for package development
  options(
    # Use browser for help
    help_type = "html",

    # Warn on partial matches
    warnPartialMatchArgs = TRUE,
    warnPartialMatchAttr = TRUE,
    warnPartialMatchDollar = TRUE,

    # Show more in error traces
    error = rlang::entrace,

    # Timezone
    tz = "UTC"
  )

  # --------------------------------------------------------------------------
  # Startup message
  # --------------------------------------------------------------------------

  cat("\n")
  cat("R Package Development Environment Loaded\n")
  cat("=========================================\n")

  # Show package info if DESCRIPTION exists
  if (file.exists("DESCRIPTION")) {
    desc_lines <- readLines("DESCRIPTION", n = 10)
    pkg_line <- grep("^Package:", desc_lines, value = TRUE)
    ver_line <- grep("^Version:", desc_lines, value = TRUE)

    if (length(pkg_line) > 0) {
      pkg_name <- trimws(sub("^Package:", "", pkg_line))
      cat(sprintf("Package: %s\n", pkg_name))
    }
    if (length(ver_line) > 0) {
      version <- trimws(sub("^Version:", "", ver_line))
      cat(sprintf("Version: %s\n", version))
    }
  }

  cat("\n")
  cat("Quick commands:\n")
  cat("  devtools::load_all()  - Load package functions\n")
  cat("  devtools::test()      - Run tests\n")
  cat("  devtools::check()     - Run R CMD check\n")
  cat("  devtools::document()  - Update documentation\n")
  cat("\n")
  cat("Development scripts available in dev/ folder.\n")
  cat("See dev/README.md for complete guide.\n")
  cat("\n")
}
