# ==============================================================================
# Package Checking Functions
# ==============================================================================
#
# Functions for running various types of package checks including local
# R CMD check, best practices analysis, and platform-specific remote checks.
#
# ==============================================================================

#' Run Local R CMD Check
#'
#' Wrapper around devtools::check() for local package validation.
#' This is similar to dev_document_and_check() but without the documentation
#' step, useful when you've already documented.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#' @param cran Logical. Use CRAN standards? Default TRUE.
#' @param ... Additional arguments passed to devtools::check()
#'
#' @return Check result invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Run R CMD check locally
#' dev_check_local()
#'
#' # Check with non-CRAN standards
#' dev_check_local(cran = FALSE)
#'
#' # Quiet mode
#' result <- dev_check_local(quiet = TRUE)
#' }
dev_check_local <- function(pkg = ".", quiet = FALSE, cran = TRUE, ...) {
  check_prerequisite("devtools", "dev_check_local")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Running R CMD Check")
  }

  start_time <- Sys.time()
  result <- devtools::check(pkg, cran = cran, quiet = quiet, ...)
  elapsed <- elapsed_seconds(start_time)

  if (!quiet) {
    cli::cli_h1("Check Complete")
    cli::cli_text("Total time: {round(elapsed, 1)}s")
    cli::cli_h2("Results")
    print_check_summary(result)
  }

  invisible(result)
}

#' Check Package Against Best Practices
#'
#' Runs goodpractice::gp() to analyze package for adherence to R best
#' practices. Provides recommendations for code quality, documentation,
#' and package structure.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return goodpractice result object invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Analyze package best practices
#' dev_check_good_practice()
#'
#' # Analyze another package
#' dev_check_good_practice("path/to/package")
#' }
dev_check_good_practice <- function(pkg = ".", quiet = FALSE) {
  check_prerequisite("goodpractice", "dev_check_good_practice")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Analyzing Best Practices")
    cli::cli_alert_info("This may take a few minutes...")
  }

  start_time <- Sys.time()
  result <- goodpractice::gp(pkg, quiet = quiet)
  elapsed <- elapsed_seconds(start_time)

  if (!quiet) {
    cli::cli_h1("Analysis Complete")
    cli::cli_text("Total time: {round(elapsed, 1)}s")
    cli::cli_h2("Results")
    print(result)
  }

  invisible(result)
}

#' Check on Windows Devel
#'
#' Submits package to win-builder for checking against R-devel on Windows.
#' Results are emailed to the package maintainer.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Submit to Windows builder
#' dev_check_windows()
#' }
dev_check_windows <- function(pkg = ".", quiet = FALSE) {
  check_prerequisite("devtools", "dev_check_windows")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Submitting to Windows Builder")
    cli::cli_alert_info("Results will be emailed to package maintainer")
  }

  devtools::check_win_devel(pkg = pkg)

  if (!quiet) {
    cli::cli_alert_success("Submission complete")
    cli::cli_text("Check your email in 15-60 minutes for results")
  }

  invisible(NULL)
}

#' Check on macOS Release
#'
#' Submits package to macOS builder for checking against R-release.
#' Results are emailed to the package maintainer.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Submit to macOS builder
#' dev_check_macos()
#' }
dev_check_macos <- function(pkg = ".", quiet = FALSE) {
  check_prerequisite("devtools", "dev_check_macos")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Submitting to macOS Builder")
    cli::cli_alert_info("Results will be emailed to package maintainer")
  }

  devtools::check_mac_release(pkg = pkg)

  if (!quiet) {
    cli::cli_alert_success("Submission complete")
    cli::cli_text("Check your email in 15-60 minutes for results")
  }

  invisible(NULL)
}

#' Check on Multiple Platforms via rhub
#'
#' Submits package to R-hub for checking on multiple platforms simultaneously.
#' Requires GITHUB_PAT to be set. Results accessible via rhub dashboard.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param platforms Character vector of platform names. If NULL, uses rhub
#'   recommended platforms. See rhub::platforms() for options.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return rhub check object invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Check on recommended platforms
#' dev_check_rhub()
#'
#' # Check on specific platforms
#' dev_check_rhub(
#'   platforms = c(
#'     "windows-x86_64-devel",
#'     "ubuntu-gcc-release",
#'     "macos-highsierra-release-cran"
#'   )
#' )
#' }
dev_check_rhub <- function(pkg = ".", platforms = NULL, quiet = FALSE) {
  check_prerequisite("rhub", "dev_check_rhub")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Submitting to R-Hub")
    if (is.null(platforms)) {
      cli::cli_alert_info("Using recommended platforms")
    } else {
      cli::cli_alert_info("Platforms: {paste(platforms, collapse = ', ')}")
    }
  }

  # Check for GITHUB_PAT
  if (Sys.getenv("GITHUB_PAT") == "") {
    cli::cli_abort(
      c(
        "GITHUB_PAT environment variable not set",
        "i" = "Set it with: {.code usethis::create_github_token()}",
        "i" = "Then: {.code gitcreds::gitcreds_set()}"
      )
    )
  }

  result <- if (is.null(platforms)) {
    rhub::check_for_cran(path = pkg)
  } else {
    rhub::check(path = pkg, platform = platforms)
  }

  if (!quiet) {
    cli::cli_alert_success("Submission complete")
    cli::cli_text("View results at: {.url https://builder.r-hub.io}")
    print(result)
  }

  invisible(result)
}
