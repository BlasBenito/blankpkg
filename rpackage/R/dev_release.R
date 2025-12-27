# ==============================================================================
# CRAN Release Workflow Functions
# ==============================================================================
#
# Four-step sequential workflow for CRAN package release. Must be run in order:
# 1. dev_release_prepare() - Prepare package metadata and documentation
# 2. dev_release_check_local() - Run local validation checks
# 3. dev_release_check_remote() - Submit to remote builders
# 4. dev_release_submit() - Final CRAN submission
#
# ==============================================================================

#' Step 1: Prepare for CRAN Release
#'
#' Prepares package for CRAN submission by displaying a checklist of tasks.
#' Updates version, NEWS.md, documentation, and runs spell check.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Start release process
#' dev_release_prepare()
#' }
dev_release_prepare <- function(pkg = ".", quiet = FALSE) {
  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("CRAN Release: Step 1 - Prepare")

    cli::cli_h2("Pre-Release Checklist")
    cli::cli_ol(c(
      "Update version in DESCRIPTION (use semantic versioning)",
      "Update NEWS.md with changes for this version",
      "Run {.code dev_spell_check()} and fix any issues",
      "Update README.Rmd if needed",
      "Review all documentation for accuracy",
      "Ensure examples run without errors"
    ))

    cli::cli_h2("Run Spell Check")
  }

  # Run spell check
  spell_result <- dev_spell_check(pkg = pkg, quiet = quiet)

  if (!quiet) {
    cli::cli_text("")
    cli::cli_h2("Next Steps")
    cli::cli_text("After completing the checklist:")
    cli::cli_ol(c(
      "Run {.code dev_release_check_local()} for local validation",
      "Fix any errors, warnings, or notes",
      "Proceed to remote checks"
    ))
  }

  invisible(NULL)
}

#' Step 2: Run Local CRAN Checks
#'
#' Runs comprehensive local checks including R CMD check with CRAN standards
#' and goodpractice analysis. Must pass before proceeding to remote checks.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#' @param run_good_practice Logical. Run goodpractice? Default TRUE.
#'
#' @return Check result invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Run local checks
#' dev_release_check_local()
#' }
dev_release_check_local <- function(
  pkg = ".",
  quiet = FALSE,
  run_good_practice = TRUE
) {
  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("CRAN Release: Step 2 - Local Checks")
  }

  # Run R CMD check
  check_result <- dev_check_local(pkg = pkg, cran = TRUE, quiet = quiet)

  # Check for errors/warnings
  has_errors <- length(check_result$errors) > 0
  has_warnings <- length(check_result$warnings) > 0

  if (has_errors || has_warnings) {
    cli::cli_abort(
      c(
        "R CMD check found errors or warnings",
        "x" = "Fix all issues before proceeding to remote checks"
      )
    )
  }

  # Run goodpractice
  if (run_good_practice) {
    if (!quiet) {
      cli::cli_text("")
      cli::cli_h2("Running Best Practices Analysis")
    }
    dev_check_good_practice(pkg = pkg, quiet = quiet)
  }

  if (!quiet) {
    cli::cli_text("")
    cli::cli_h2("Next Steps")
    if (has_errors || has_warnings) {
      cli::cli_alert_danger("Fix errors and warnings before continuing")
    } else {
      cli::cli_alert_success("Local checks passed!")
      cli::cli_text(
        "Run {.code dev_release_check_remote()} for platform checks"
      )
    }
  }

  invisible(check_result)
}

#' Step 3: Run Remote Platform Checks
#'
#' Submits package to Windows and macOS builders for platform-specific
#' validation. Results emailed to maintainer. Wait for results before
#' proceeding to CRAN submission.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#' @param check_windows Logical. Submit to Windows builder? Default TRUE.
#' @param check_macos Logical. Submit to macOS builder? Default TRUE.
#'
#' @return NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Submit to remote builders
#' dev_release_check_remote()
#' }
dev_release_check_remote <- function(
  pkg = ".",
  quiet = FALSE,
  check_windows = TRUE,
  check_macos = TRUE
) {
  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("CRAN Release: Step 3 - Remote Checks")
  }

  # Submit to Windows
  if (check_windows) {
    dev_check_windows(pkg = pkg, quiet = quiet)
  }

  # Submit to macOS
  if (check_macos) {
    if (!quiet && check_windows) {
      cli::cli_text("")
    }
    dev_check_macos(pkg = pkg, quiet = quiet)
  }

  if (!quiet) {
    cli::cli_text("")
    cli::cli_h2("Next Steps")
    cli::cli_ol(c(
      "Wait for email results (15-60 minutes)",
      "Review all platform check results",
      "Fix any platform-specific issues",
      "Run {.code dev_release_submit()} for final CRAN submission"
    ))
    cli::cli_alert_warning(
      "Do not proceed until all checks pass on all platforms"
    )
  }

  invisible(NULL)
}

#' Step 4: Submit to CRAN
#'
#' Final step: submits package to CRAN using devtools::release(). This is
#' the point of no return. Ensure all previous checks passed.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Final CRAN submission
#' dev_release_submit()
#' }
dev_release_submit <- function(pkg = ".", quiet = FALSE) {
  check_prerequisite("devtools", "dev_release_submit")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("CRAN Release: Step 4 - Submit to CRAN")

    cli::cli_h2("Pre-Submission Checklist")
    cli::cli_alert_warning("Ensure ALL of the following:")
    cli::cli_ul(c(
      "dev_release_check_local() passed with 0/0/0",
      "dev_release_check_remote() completed on Windows and macOS",
      "All remote checks passed",
      "cran-comments.md updated with check results",
      "You are ready to submit (this cannot be undone easily)"
    ))

    cli::cli_text("")
    response <- readline("Proceed with CRAN submission? (yes/no): ")

    if (tolower(response) != "yes") {
      cli::cli_alert_info("Submission cancelled")
      return(invisible(NULL))
    }
  }

  # Submit to CRAN
  devtools::release(pkg = pkg)

  if (!quiet) {
    cli::cli_text("")
    cli::cli_h2("Post-Submission")
    cli::cli_ol(c(
      "Check email for CRAN submission confirmation",
      "Wait for CRAN review (typically 1-7 days)",
      "Respond promptly to any CRAN feedback",
      "Monitor CRAN incoming: {.url https://cran.r-project.org/incoming/}"
    ))
  }

  invisible(NULL)
}
