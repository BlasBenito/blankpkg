# ==============================================================================
# Daily Development Workflow Functions
# ==============================================================================
#
# These are the most frequently used functions during R package development.
# They provide convenient wrappers around devtools functions with enhanced
# output formatting and timing information.
#
# ==============================================================================

#' Load All Package Functions
#'
#' Wrapper around devtools::load_all() for quick package loading during
#' development. Loads all functions, data, and compiled code from the package.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#' @param ... Additional arguments passed to devtools::load_all()
#'
#' @return Result from devtools::load_all() invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Load package in current directory
#' dev_load_all()
#'
#' # Load package in another directory
#' dev_load_all("path/to/package")
#'
#' # Quiet mode
#' dev_load_all(quiet = TRUE)
#' }
dev_load_all <- function(pkg = ".", quiet = FALSE, ...) {
  check_prerequisite("devtools", "dev_load_all")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Loading Package")
  }

  start_time <- Sys.time()
  result <- devtools::load_all(pkg, quiet = quiet, ...)
  elapsed <- elapsed_seconds(start_time)

  if (!quiet) {
    cli::cli_alert_success(
      "Package loaded in {.val {round(elapsed, 1)}} seconds"
    )
  }

  invisible(result)
}

#' Run Package Tests
#'
#' Wrapper around devtools::test() with timing and summary information.
#' Runs all tests in the tests/testthat directory.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#' @param reporter Test reporter to use. Default NULL (uses testthat default).
#' @param ... Additional arguments passed to devtools::test()
#'
#' @return Test results invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Run tests in current package
#' dev_test()
#'
#' # Run tests in another package
#' dev_test("path/to/package")
#'
#' # Use specific reporter
#' dev_test(reporter = "minimal")
#'
#' # Quiet mode
#' dev_test(quiet = TRUE)
#' }
dev_test <- function(pkg = ".", quiet = FALSE, reporter = NULL, ...) {
  check_prerequisite("devtools", "dev_test")
  check_prerequisite("testthat", "dev_test")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Running Tests")
  }

  start_time <- Sys.time()
  result <- devtools::test(pkg, reporter = reporter, ...)
  elapsed <- elapsed_seconds(start_time)

  if (!quiet) {
    cli::cli_alert_success(
      "Tests complete in {.val {round(elapsed, 1)}} seconds"
    )
  }

  invisible(result)
}

#' Document and Check Package
#'
#' Most common daily workflow: update documentation with roxygen2 and run
#' R CMD check. This is the go-to function before committing changes.
#'
#' Combines devtools::document() and devtools::check() with detailed timing
#' and results summary.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#' @param document Logical. Run devtools::document() first? Default TRUE.
#' @param ... Additional arguments passed to devtools::check()
#'
#' @return Check result invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Document and check current package
#' dev_document_and_check()
#'
#' # Check without documenting first
#' dev_document_and_check(document = FALSE)
#'
#' # Check another package
#' dev_document_and_check("path/to/package")
#'
#' # Quiet mode
#' result <- dev_document_and_check(quiet = TRUE)
#' }
dev_document_and_check <- function(
  pkg = ".",
  quiet = FALSE,
  document = TRUE,
  ...
) {
  check_prerequisite("devtools", "dev_document_and_check")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Document and Check")
  }

  start_time <- Sys.time()
  doc_elapsed <- NULL

  # Step 1: Document
  if (document) {
    if (!quiet) {
      cli::cli_h2("Step 1/2: Documenting")
    }
    doc_start <- Sys.time()
    devtools::document(pkg, quiet = quiet)
    doc_elapsed <- elapsed_seconds(doc_start)
    if (!quiet) {
      cli::cli_alert_success(
        "Documentation complete ({round(doc_elapsed, 1)}s)"
      )
    }
  }

  # Step 2: Check
  if (!quiet) {
    step_num <- if (document) "2/2" else "1/1"
    cli::cli_h2("Step {step_num}: Checking")
  }
  check_start <- Sys.time()
  result <- devtools::check(pkg, document = FALSE, quiet = quiet, ...)
  check_elapsed <- elapsed_seconds(check_start)

  # Summary
  if (!quiet) {
    total_elapsed <- elapsed_seconds(start_time)
    cli::cli_h1("Check Complete")
    if (document) {
      cli::cli_text("Documentation: {round(doc_elapsed, 1)}s")
    }
    cli::cli_text("Check: {round(check_elapsed, 1)}s")
    cli::cli_text("Total: {round(total_elapsed, 1)}s")
    cli::cli_h2("Results")
    print_check_summary(result)
  }

  invisible(result)
}
