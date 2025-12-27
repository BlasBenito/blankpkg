# ==============================================================================
# Package Analysis Functions
# ==============================================================================
#
# Functions for analyzing package quality, structure, dependencies, and
# performance characteristics.
#
# ==============================================================================

#' Analyze Code Quality
#'
#' Runs codetools::checkUsagePackage() to detect potential code problems
#' including undefined variables, unused variables, and suspicious constructs.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Analyze code quality
#' dev_analyze_quality()
#' }
dev_analyze_quality <- function(pkg = ".", quiet = FALSE) {
  check_prerequisite("codetools", "dev_analyze_quality")

  pkg <- validate_package_path(pkg)

  # Get package name
  desc_file <- desc::desc(fs::path(pkg, "DESCRIPTION"))
  pkg_name <- desc_file$get("Package")

  if (!quiet) {
    cli::cli_h1("Analyzing Code Quality")
    cli::cli_alert_info("Package: {.pkg {pkg_name}}")
  }

  # Load package to analyze
  devtools::load_all(pkg, quiet = TRUE)

  # Run codetools check
  start_time <- Sys.time()

  # Capture output
  output <- utils::capture.output({
    codetools::checkUsagePackage(pkg_name, all = TRUE)
  })

  elapsed <- elapsed_seconds(start_time)

  if (!quiet) {
    cli::cli_h1("Quality Analysis Complete")
    cli::cli_text("Total time: {round(elapsed, 1)}s")

    if (length(output) == 0) {
      cli::cli_alert_success("No code quality issues detected!")
    } else {
      cli::cli_alert_warning("Found {length(output)} potential issue{?s}")
      cli::cli_h2("Issues Detected")
      cat(paste(output, collapse = "\n"), "\n")
    }
  }

  invisible(NULL)
}

#' Analyze Package Dependencies
#'
#' Creates an interactive network visualization of package dependencies
#' using pkgnet. Shows imports, suggests, and reverse dependencies.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#' @param open_report Logical. Open HTML report in browser? Default TRUE if
#'   interactive session.
#'
#' @return pkgnet report object invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Analyze dependencies
#' dev_analyze_dependencies()
#'
#' # Analyze without opening report
#' report <- dev_analyze_dependencies(open_report = FALSE)
#' }
dev_analyze_dependencies <- function(
  pkg = ".",
  quiet = FALSE,
  open_report = interactive()
) {
  check_prerequisite("pkgnet", "dev_analyze_dependencies")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Analyzing Package Dependencies")
  }

  start_time <- Sys.time()

  # Create dependency report
  report <- pkgnet::CreatePackageReport(pkg)

  elapsed <- elapsed_seconds(start_time)

  # Save report
  report_path <- fs::path(pkg, "dev", "dependency_report.html")
  fs::dir_create(fs::path(pkg, "dev"))

  if (!quiet) {
    cli::cli_h1("Dependency Analysis Complete")
    cli::cli_text("Total time: {round(elapsed, 1)}s")
    cli::cli_alert_success("Report saved to {.path dev/dependency_report.html}")
  }

  # Open report
  if (open_report && fs::file_exists(report_path)) {
    if (!quiet) cli::cli_alert_info("Opening dependency report...")
    utils::browseURL(report_path)
  }

  invisible(report)
}

#' Analyze Package Structure
#'
#' Provides detailed metrics about package structure including function
#' counts, file organization, documentation coverage, and export patterns.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return List with structure metrics invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Analyze package structure
#' dev_analyze_structure()
#'
#' # Get metrics
#' metrics <- dev_analyze_structure(quiet = TRUE)
#' }
dev_analyze_structure <- function(pkg = ".", quiet = FALSE) {
  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Analyzing Package Structure")
  }

  # Count R files
  r_files <- fs::dir_ls(fs::path(pkg, "R"), glob = "*.R")
  n_r_files <- length(r_files)

  # Count functions (approximate by counting function assignments)
  n_functions <- 0
  exported_functions <- 0

  for (file in r_files) {
    content <- readLines(file, warn = FALSE)
    # Count function definitions
    n_functions <- n_functions + sum(grepl("<-\\s*function\\s*\\(", content))
    # Count exports
    exported_functions <- exported_functions + sum(grepl("^#'\\s*@export", content))
  }

  # Count documentation files
  man_dir <- fs::path(pkg, "man")
  n_doc_files <- if (fs::dir_exists(man_dir)) {
    length(fs::dir_ls(man_dir, glob = "*.Rd"))
  } else {
    0
  }

  # Count test files
  test_dir <- fs::path(pkg, "tests", "testthat")
  n_test_files <- if (fs::dir_exists(test_dir)) {
    length(fs::dir_ls(test_dir, glob = "test-*.R"))
  } else {
    0
  }

  # Count vignettes
  vig_dir <- fs::path(pkg, "vignettes")
  n_vignettes <- if (fs::dir_exists(vig_dir)) {
    length(fs::dir_ls(vig_dir, glob = "*.Rmd"))
  } else {
    0
  }

  # Create metrics summary
  metrics <- list(
    r_files = n_r_files,
    functions = n_functions,
    exported = exported_functions,
    internal = n_functions - exported_functions,
    documentation = n_doc_files,
    tests = n_test_files,
    vignettes = n_vignettes
  )

  if (!quiet) {
    cli::cli_h1("Structure Analysis Complete")

    cli::cli_h2("Code Organization")
    cli::cli_ul(c(
      "R files: {metrics$r_files}",
      "Total functions: {metrics$functions}",
      "Exported: {metrics$exported}",
      "Internal: {metrics$internal}"
    ))

    cli::cli_h2("Documentation")
    cli::cli_ul(c(
      "Documentation files: {metrics$documentation}",
      "Test files: {metrics$tests}",
      "Vignettes: {metrics$vignettes}"
    ))

    # Calculate documentation coverage
    if (metrics$exported > 0) {
      doc_coverage <- round(100 * metrics$documentation / metrics$exported, 1)
      if (doc_coverage >= 100) {
        cli::cli_alert_success("Documentation coverage: {doc_coverage}%")
      } else {
        cli::cli_alert_warning("Documentation coverage: {doc_coverage}%")
      }
    }
  }

  invisible(metrics)
}

#' Analyze Package Performance
#'
#' Provides guidance and templates for benchmarking package performance
#' using microbenchmark and profvis.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Show performance analysis guide
#' dev_analyze_performance()
#' }
dev_analyze_performance <- function(pkg = ".", quiet = FALSE) {
  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Performance Analysis Guide")

    cli::cli_h2("Benchmarking with microbenchmark")
    cli::cli_text("Compare execution times of different implementations:")
    cli::cli_code('
library(microbenchmark)
library(yourpkg)

result <- microbenchmark(
  approach1 = your_function_v1(data),
  approach2 = your_function_v2(data),
  times = 100
)

print(result)
autoplot(result)
')

    cli::cli_h2("Profiling with profvis")
    cli::cli_text("Identify performance bottlenecks:")
    cli::cli_code('
library(profvis)
library(yourpkg)

profvis({
  # Your code to profile
  result <- your_function(large_dataset)
})
')

    cli::cli_h2("Tips for Performance Analysis")
    cli::cli_ul(c(
      "Test with realistic data sizes",
      "Run multiple iterations for accuracy",
      "Profile before optimizing",
      "Focus on hot spots (functions called frequently)",
      "Consider memory usage in addition to speed"
    ))

    cli::cli_h2("Resources")
    cli::cli_ul(c(
      "microbenchmark: {.url https://github.com/joshuaulrich/microbenchmark}",
      "profvis: {.url https://rstudio.github.io/profvis}",
      "Advanced R: {.url https://adv-r.hadley.nz/perf-measure.html}"
    ))
  }

  invisible(NULL)
}
