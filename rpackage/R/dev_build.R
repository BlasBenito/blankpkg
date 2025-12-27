# ==============================================================================
# Build Functions
# ==============================================================================
#
# Functions for building package documentation including README and vignettes.
#
# ==============================================================================

#' Build README from README.Rmd
#'
#' Renders README.Rmd to README.md by executing all R code chunks and
#' updating output. Useful for keeping examples and badges up-to-date.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return Path to README.md invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Build README
#' dev_build_readme()
#' }
dev_build_readme <- function(pkg = ".", quiet = FALSE) {
  check_prerequisite("devtools", "dev_build_readme")

  pkg <- validate_package_path(pkg)

  readme_rmd <- fs::path(pkg, "README.Rmd")
  if (!fs::file_exists(readme_rmd)) {
    cli::cli_abort(
      c(
        "README.Rmd not found",
        "i" = "Create one with: {.code usethis::use_readme_rmd()}"
      )
    )
  }

  if (!quiet) {
    cli::cli_h1("Building README")
  }

  start_time <- Sys.time()
  devtools::build_readme(pkg = pkg, quiet = quiet)
  elapsed <- elapsed_seconds(start_time)

  readme_md <- fs::path(pkg, "README.md")

  if (!quiet) {
    cli::cli_h1("README Build Complete")
    cli::cli_text("Total time: {round(elapsed, 1)}s")
    cli::cli_alert_success("Generated {.file README.md}")

    # Show file size
    if (fs::file_exists(readme_md)) {
      size <- fs::file_info(readme_md)$size
      cli::cli_text("File size: {prettyunits::pretty_bytes(size)}")
    }
  }

  invisible(readme_md)
}

#' Build Package Vignettes
#'
#' Builds all vignettes in vignettes/ directory by running R code and
#' generating output documents. Useful for ensuring vignettes are up-to-date.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#' @param clean Logical. Clean temporary files after building? Default TRUE.
#' @param ... Additional arguments passed to devtools::build_vignettes()
#'
#' @return NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Build all vignettes
#' dev_build_vignettes()
#'
#' # Build without cleaning
#' dev_build_vignettes(clean = FALSE)
#' }
dev_build_vignettes <- function(
  pkg = ".",
  quiet = FALSE,
  clean = TRUE,
  ...
) {
  check_prerequisite("devtools", "dev_build_vignettes")

  pkg <- validate_package_path(pkg)

  vignettes_dir <- fs::path(pkg, "vignettes")
  if (!fs::dir_exists(vignettes_dir)) {
    cli::cli_abort(
      c(
        "vignettes/ directory not found",
        "i" = "Create vignettes with: {.code usethis::use_vignette()}"
      )
    )
  }

  if (!quiet) {
    cli::cli_h1("Building Vignettes")
    n_vignettes <- length(fs::dir_ls(vignettes_dir, glob = "*.Rmd"))
    cli::cli_alert_info("Found {n_vignettes} vignette{?s}")
  }

  start_time <- Sys.time()
  devtools::build_vignettes(pkg = pkg, quiet = quiet, clean = clean, ...)
  elapsed <- elapsed_seconds(start_time)

  if (!quiet) {
    cli::cli_h1("Vignette Build Complete")
    cli::cli_text("Total time: {round(elapsed, 1)}s")
    cli::cli_alert_success("Vignettes built to {.path inst/doc/}")
  }

  invisible(NULL)
}
