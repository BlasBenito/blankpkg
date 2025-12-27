# ==============================================================================
# Internal Helper Functions
# ==============================================================================
#
# These functions are used internally by rpkgdev and are not exported.
# They provide common functionality like path validation, timing, and
# formatted console output.
#
# ==============================================================================

#' Validate Package Path
#'
#' Checks if a given path is a valid R package directory by verifying
#' the existence of a DESCRIPTION file.
#'
#' @param pkg Path to package directory
#' @return Normalized absolute path to package
#' @keywords internal
#' @noRd
validate_package_path <- function(pkg) {
  pkg <- normalizePath(pkg, mustWork = FALSE)
  desc_path <- file.path(pkg, "DESCRIPTION")

  if (!file.exists(desc_path)) {
    cli::cli_abort(
      c(
        "Not a valid package directory: {.path {pkg}}",
        "x" = "DESCRIPTION file not found"
      )
    )
  }

  pkg
}

#' Calculate Elapsed Seconds
#'
#' Computes the number of seconds elapsed since a start time.
#'
#' @param start_time A POSIXct time object from Sys.time()
#' @return Numeric value representing elapsed seconds
#' @keywords internal
#' @noRd
elapsed_seconds <- function(start_time) {
  as.numeric(difftime(Sys.time(), start_time, units = "secs"))
}

#' Print Check Summary
#'
#' Displays a formatted summary of R CMD check results with colored indicators.
#'
#' @param result Check result object from devtools::check()
#' @keywords internal
#' @noRd
print_check_summary <- function(result) {
  cli::cli_ul()

  # Errors
  n_errors <- length(result$errors)
  if (n_errors == 0) {
    cli::cli_li("{cli::col_green('\u2714')} Errors: {.val 0}")
  } else {
    cli::cli_li("{cli::col_red('\u2716')} Errors: {.val {n_errors}}")
  }

  # Warnings
  n_warnings <- length(result$warnings)
  if (n_warnings == 0) {
    cli::cli_li("{cli::col_green('\u2714')} Warnings: {.val 0}")
  } else {
    cli::cli_li("{cli::col_red('\u2716')} Warnings: {.val {n_warnings}}")
  }

  # Notes
  n_notes <- length(result$notes)
  if (n_notes == 0) {
    cli::cli_li("{cli::col_green('\u2714')} Notes: {.val 0}")
  } else {
    cli::cli_li("{cli::col_yellow('\u2716')} Notes: {.val {n_notes}}")
  }

  cli::cli_end()
}

#' Check Package Prerequisite
#'
#' Verifies that a required package is installed, showing a helpful
#' error message if not.
#'
#' @param pkg Package name to check
#' @param func_name Function name requesting the package
#' @keywords internal
#' @noRd
check_prerequisite <- function(pkg, func_name) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cli::cli_abort(
      c(
        "{.fn {func_name}} requires {.pkg {pkg}}",
        "i" = "Install with: {.code install.packages('{pkg}')}"
      )
    )
  }
}
