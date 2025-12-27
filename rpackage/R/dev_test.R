# ==============================================================================
# Testing Functions
# ==============================================================================
#
# Extended testing functions for code coverage analysis and spell checking.
# Basic testing is provided by dev_test() in dev_daily.R
#
# ==============================================================================

#' Run Tests with Coverage Analysis
#'
#' Runs tests and generates a coverage report showing which lines of code
#' are tested. Optionally opens an interactive HTML report.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#' @param show_report Logical. Open interactive HTML report? Default TRUE if
#'   interactive session.
#' @param ... Additional arguments passed to covr::package_coverage()
#'
#' @return Coverage object invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Run tests with coverage
#' dev_test_coverage()
#'
#' # Run without opening report
#' cov <- dev_test_coverage(show_report = FALSE)
#'
#' # View coverage percentage
#' covr::percent_coverage(cov)
#' }
dev_test_coverage <- function(
  pkg = ".",
  quiet = FALSE,
  show_report = interactive(),
  ...
) {
  check_prerequisite("covr", "dev_test_coverage")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Running Tests with Coverage")
  }

  start_time <- Sys.time()
  coverage <- covr::package_coverage(path = pkg, quiet = quiet, ...)
  elapsed <- elapsed_seconds(start_time)

  if (!quiet) {
    cli::cli_h1("Coverage Analysis Complete")
    cli::cli_text("Total time: {round(elapsed, 1)}s")
    cli::cli_h2("Coverage Summary")

    pct <- covr::percent_coverage(coverage)
    if (pct >= 80) {
      cli::cli_alert_success("Coverage: {round(pct, 1)}%")
    } else if (pct >= 60) {
      cli::cli_alert_warning("Coverage: {round(pct, 1)}%")
    } else {
      cli::cli_alert_danger("Coverage: {round(pct, 1)}%")
    }

    print(coverage)
  }

  if (show_report) {
    if (!quiet) {
      cli::cli_alert_info("Opening interactive coverage report...")
    }
    covr::report(coverage)
  }

  invisible(coverage)
}

#' Check Package Spelling
#'
#' Checks all documentation (Rd files, DESCRIPTION, vignettes) for spelling
#' errors. Add valid words to inst/WORDLIST to suppress false positives.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return Spell check results invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Check spelling
#' dev_spell_check()
#'
#' # Add words to dictionary
#' # Edit inst/WORDLIST and add one word per line
#' }
dev_spell_check <- function(pkg = ".", quiet = FALSE) {
  check_prerequisite("spelling", "dev_spell_check")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Checking Spelling")
  }

  result <- spelling::spell_check_package(pkg = pkg)

  if (!quiet) {
    cli::cli_h1("Spell Check Complete")

    n_errors <- nrow(result)
    if (n_errors == 0) {
      cli::cli_alert_success("No spelling errors found!")
    } else {
      cli::cli_alert_warning("Found {n_errors} potential spelling error{?s}")
      cli::cli_h2("Misspelled Words")
      print(result)
      cli::cli_text("")
      cli::cli_text("To add valid words to dictionary:")
      cli::cli_ol(c(
        "Edit {.file inst/WORDLIST}",
        "Add one word per line",
        "Re-run spell check"
      ))
    }
  }

  invisible(result)
}
