# ==============================================================================
# Pkgdown Website Functions
# ==============================================================================
#
# Functions for building and customizing package documentation websites
# using pkgdown.
#
# ==============================================================================

#' Build Package Website with pkgdown
#'
#' Builds a complete documentation website for the package using pkgdown.
#' Generates HTML pages for function reference, README, vignettes, and news.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#' @param preview Logical. Open website in browser after building? Default
#'   TRUE if interactive session.
#' @param ... Additional arguments passed to pkgdown::build_site()
#'
#' @return NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Build package website
#' dev_pkgdown_build_site()
#'
#' # Build without preview
#' dev_pkgdown_build_site(preview = FALSE)
#' }
dev_pkgdown_build_site <- function(
  pkg = ".",
  quiet = FALSE,
  preview = interactive(),
  ...
) {
  check_prerequisite("pkgdown", "dev_pkgdown_build_site")

  pkg <- validate_package_path(pkg)

  if (!quiet) {
    cli::cli_h1("Building pkgdown Website")
  }

  start_time <- Sys.time()
  pkgdown::build_site(pkg = pkg, preview = preview, ...)
  elapsed <- elapsed_seconds(start_time)

  docs_dir <- fs::path(pkg, "docs")

  if (!quiet) {
    cli::cli_h1("Website Build Complete")
    cli::cli_text("Total time: {round(elapsed, 1)}s")
    cli::cli_alert_success("Website built to {.path docs/}")

    if (fs::dir_exists(docs_dir)) {
      # Count generated files
      html_files <- length(fs::dir_ls(docs_dir, recurse = TRUE, glob = "*.html"))
      cli::cli_text("Generated {html_files} HTML page{?s}")
    }
  }

  invisible(NULL)
}

#' Customize pkgdown Website
#'
#' Displays helpful information and templates for customizing the package
#' website via _pkgdown.yml configuration file.
#'
#' @param pkg Path to package directory. Default is current directory.
#' @param quiet Logical. If TRUE, suppress console output. Default FALSE.
#'
#' @return NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Show customization guide
#' dev_pkgdown_customize_site()
#' }
dev_pkgdown_customize_site <- function(pkg = ".", quiet = FALSE) {
  pkg <- validate_package_path(pkg)

  pkgdown_yml <- fs::path(pkg, "_pkgdown.yml")

  if (!quiet) {
    cli::cli_h1("pkgdown Website Customization Guide")

    if (!fs::file_exists(pkgdown_yml)) {
      cli::cli_alert_warning("_pkgdown.yml not found")
      cli::cli_text("Create one with: {.code usethis::use_pkgdown()}")
      cli::cli_text("")
    }

    cli::cli_h2("Common Customizations")

    cli::cli_text("Edit {.file _pkgdown.yml} to customize your website:")
    cli::cli_ul(c(
      "Theme: Choose from 25+ Bootstrap themes",
      "Navigation: Organize reference pages",
      "Home page: Customize landing page",
      "Articles: Add tutorials and guides",
      "News: Display changelog"
    ))

    cli::cli_h2("Example Configuration")
    cli::cli_text("")
    cli::cli_code("
template:
  bootstrap: 5
  bootswatch: cosmo

navbar:
  structure:
    left:  [intro, reference, articles, news]
    right: [search, github]

reference:
  - title: Daily Workflow
    desc: Most commonly used functions
    contents:
    - starts_with('dev_')
")

    cli::cli_h2("Resources")
    cli::cli_ul(c(
      "Documentation: {.url https://pkgdown.r-lib.org}",
      "Themes: {.url https://bootswatch.com}",
      "Examples: {.url https://github.com/r-lib/pkgdown/tree/main/inst/examples}"
    ))
  }

  invisible(NULL)
}
