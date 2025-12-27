# ==============================================================================
# Template Deployment Function
# ==============================================================================
#
# Deploys the complete blankpkg template to a new package directory with
# all development infrastructure included.
#
# ==============================================================================

#' Deploy blankpkg Template to New Package
#'
#' Creates a new R package directory with complete development infrastructure
#' from the embedded blankpkg template. Includes development scripts, Claude
#' AI agents, GitHub workflows, and comprehensive configuration.
#'
#' @param path Character. Path where the new package directory will be created.
#' @param package_name Character. Name for the new package. If NULL, extracted
#'   from the basename of path.
#' @param claude_components Logical. Deploy .claude/ agents directory?
#'   Default TRUE.
#' @param dev_scripts Logical. Deploy dev/ workflow scripts directory?
#'   Default TRUE.
#' @param overwrite Logical. Overwrite existing files? Default FALSE.
#' @param git_init Logical. Initialize git repository? Default TRUE.
#' @param rstudio_project Logical. Create .Rproj file? Default TRUE.
#' @param open_project Logical. Open project in RStudio? Default interactive().
#' @param quiet Logical. Suppress console messages? Default FALSE.
#'
#' @return Invisibly returns a list with deployment details:
#'   \item{path}{Absolute path to created package}
#'   \item{package_name}{Name of the package}
#'   \item{files_created}{Character vector of created files}
#'   \item{git_initialized}{Logical, whether git was initialized}
#'   \item{rstudio_project}{Path to .Rproj file if created}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Deploy with defaults to a new directory
#' deploy_template("../mynewpackage")
#'
#' # Customize deployment
#' deploy_template(
#'   path = "../mynewpackage",
#'   package_name = "mynewpackage",
#'   claude_components = TRUE,
#'   dev_scripts = TRUE,
#'   git_init = TRUE
#' )
#'
#' # Deploy without Claude components or git
#' deploy_template(
#'   path = "../testpkg",
#'   claude_components = FALSE,
#'   git_init = FALSE
#' )
#' }
deploy_template <- function(
  path,
  package_name = NULL,
  claude_components = TRUE,
  dev_scripts = TRUE,
  overwrite = FALSE,
  git_init = TRUE,
  rstudio_project = TRUE,
  open_project = interactive(),
  quiet = FALSE
) {

  # Check prerequisites
  check_prerequisite("fs", "deploy_template")
  check_prerequisite("usethis", "deploy_template")

  # Step 1: Validate and normalize path
  if (!quiet) cli::cli_h1("Deploying blankpkg Template")

  path <- fs::path_expand(path)
  path <- fs::path_abs(path)

  # Step 2: Determine package name
  if (is.null(package_name)) {
    package_name <- fs::path_file(path)
  }

  # Validate package name
  if (!grepl("^[a-zA-Z][a-zA-Z0-9.]*$", package_name)) {
    cli::cli_abort(
      c(
        "Invalid package name: {.val {package_name}}",
        "i" = "Package names must start with a letter and contain only letters, numbers, and dots"
      )
    )
  }

  if (!quiet) {
    cli::cli_alert_info("Package name: {.pkg {package_name}}")
    cli::cli_alert_info("Target path: {.path {path}}")
  }

  # Step 3: Check if directory exists
  if (fs::dir_exists(path) && !overwrite) {
    cli::cli_abort(
      c(
        "Directory already exists: {.path {path}}",
        "i" = "Use {.code overwrite = TRUE} to overwrite existing files"
      )
    )
  }

  # Step 4: Create directory structure
  if (!quiet) cli::cli_h2("Creating Directory Structure")

  fs::dir_create(path, recurse = TRUE)
  fs::dir_create(fs::path(path, "R"))
  fs::dir_create(fs::path(path, "man"))
  fs::dir_create(fs::path(path, "tests", "testthat"))
  fs::dir_create(fs::path(path, "vignettes", "articles"))
  fs::dir_create(fs::path(path, "data"))
  fs::dir_create(fs::path(path, "inst"))

  files_created <- character()

  # Step 5: Copy core template files
  if (!quiet) cli::cli_h2("Copying Template Files")

  template_dir <- system.file("templates", package = "rpkgdev")
  if (template_dir == "") {
    cli::cli_abort("Template files not found. Package may not be installed correctly.")
  }

  # Copy core files
  core_dir <- fs::path(template_dir, "core")
  if (fs::dir_exists(core_dir)) {
    core_files <- fs::dir_ls(core_dir, all = TRUE, recurse = FALSE)
    for (file in core_files) {
      dest <- fs::path(path, fs::path_file(file))
      fs::file_copy(file, dest, overwrite = overwrite)
      files_created <- c(files_created, fs::path_rel(dest, path))
      if (!quiet) cli::cli_alert_success("Copied {.file {fs::path_file(file)}}")
    }
  }

  # Copy Claude components (optional)
  if (claude_components) {
    claude_dir <- fs::path(template_dir, "claude")
    if (fs::dir_exists(claude_dir)) {
      dest_claude <- fs::path(path, ".claude")
      fs::dir_create(dest_claude)
      fs::dir_create(fs::path(dest_claude, "agents"))

      # Copy settings
      settings_file <- fs::path(claude_dir, "settings.local.json")
      if (fs::file_exists(settings_file)) {
        fs::file_copy(
          settings_file,
          fs::path(dest_claude, "settings.local.json"),
          overwrite = overwrite
        )
      }

      # Copy agents
      agent_files <- fs::dir_ls(claude_dir, glob = "*.md")
      for (file in agent_files) {
        fs::file_copy(
          file,
          fs::path(dest_claude, "agents", fs::path_file(file)),
          overwrite = overwrite
        )
      }

      files_created <- c(files_created, ".claude/")
      if (!quiet) cli::cli_alert_success("Copied Claude AI agents")
    }
  }

  # Copy dev scripts (optional)
  if (dev_scripts) {
    dev_dir <- fs::path(template_dir, "dev")
    if (fs::dir_exists(dev_dir)) {
      dest_dev <- fs::path(path, "dev")
      fs::dir_copy(dev_dir, dest_dev, overwrite = overwrite)
      files_created <- c(files_created, "dev/")
      if (!quiet) cli::cli_alert_success("Copied development scripts")
    }
  }

  # Copy GitHub workflows
  github_dir <- fs::path(template_dir, "github", "workflows")
  if (fs::dir_exists(github_dir)) {
    dest_gh <- fs::path(path, ".github", "workflows")
    fs::dir_create(fs::path(path, ".github"))
    fs::dir_copy(github_dir, dest_gh, overwrite = overwrite)
    files_created <- c(files_created, ".github/workflows/")
    if (!quiet) cli::cli_alert_success("Copied GitHub workflows")
  }

  # Copy test infrastructure
  tests_dir <- fs::path(template_dir, "tests")
  if (fs::dir_exists(tests_dir)) {
    test_files <- fs::dir_ls(tests_dir)
    for (file in test_files) {
      dest <- fs::path(path, "tests", fs::path_file(file))
      fs::file_copy(file, dest, overwrite = overwrite)
    }
    files_created <- c(files_created, "tests/")
    if (!quiet) cli::cli_alert_success("Copied test infrastructure")
  }

  # Step 6: Create DESCRIPTION file
  if (!quiet) cli::cli_h2("Creating Package Metadata")

  desc_path <- fs::path(path, "DESCRIPTION")
  usethis::create_package(
    path = path,
    fields = list(
      Package = package_name,
      Version = "0.0.0.9000",
      Title = "What the Package Does (One Line, Title Case)",
      Description = "What the package does (one paragraph).",
      `Authors@R` = 'person("First", "Last", email = "first.last@example.com", role = c("aut", "cre"))',
      License = "MIT + file LICENSE"
    ),
    rstudio = FALSE,
    open = FALSE
  )

  if (!quiet) cli::cli_alert_success("Created DESCRIPTION")

  # Step 7: Create .Rproj file (optional)
  rproj_path <- NULL
  if (rstudio_project) {
    rproj_path <- fs::path(path, paste0(package_name, ".Rproj"))
    rproj_content <- "Version: 1.0

RestoreWorkspace: No
SaveWorkspace: No
AlwaysSaveHistory: Default

EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8

RnwWeave: knitr
LaTeX: pdfLaTeX

AutoAppendNewline: Yes
StripTrailingWhitespace: Yes
LineEndingConversion: Posix

BuildType: Package
PackageUseDevtools: Yes
PackageInstallArgs: --no-multiarch --with-keep.source
PackageRoxygenize: rd,collate,namespace
"
    writeLines(rproj_content, rproj_path)
    files_created <- c(files_created, fs::path_file(rproj_path))
    if (!quiet) cli::cli_alert_success("Created RStudio project file")
  }

  # Step 8: Initialize git (optional)
  git_initialized <- FALSE
  if (git_init) {
    old_wd <- getwd()
    on.exit(setwd(old_wd), add = TRUE)
    setwd(path)

    if (Sys.which("git") != "") {
      system("git init", intern = TRUE, ignore.stdout = quiet)
      git_initialized <- TRUE
      if (!quiet) cli::cli_alert_success("Initialized git repository")
    } else {
      if (!quiet) cli::cli_alert_warning("git not found, skipping initialization")
    }
  }

  # Step 9: Final summary
  if (!quiet) {
    cli::cli_h1("Deployment Complete")
    cli::cli_alert_success("Package {.pkg {package_name}} created at {.path {path}}")
    cli::cli_text("")
    cli::cli_text("Next steps:")
    cli::cli_ol(c(
      "Edit {.file DESCRIPTION} with your package details",
      "Read {.file FIRST-TIME-CHECKLIST.md} for customization guide",
      "Start developing in {.file R/}",
      "Run {.code devtools::load_all()} to load your package"
    ))
  }

  # Step 10: Open project (optional)
  if (open_project && !is.null(rproj_path) && rstudioapi::isAvailable()) {
    rstudioapi::openProject(rproj_path, newSession = TRUE)
  }

  # Return deployment info
  invisible(list(
    path = path,
    package_name = package_name,
    files_created = files_created,
    git_initialized = git_initialized,
    rstudio_project = rproj_path
  ))
}
