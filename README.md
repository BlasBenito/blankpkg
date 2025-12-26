
<!-- README.md is generated from README.Rmd. Please edit that file -->

# blankpkg: Complete R Package Template

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/username/blankpkg/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/username/blankpkg/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

> **⚠️ IMPORTANT: This is a TEMPLATE repository**
>
> This README.Rmd explains how the template works. When you use this for
> your own package, **replace this entire file** with documentation
> specific to your package. (Don’t just edit it—start fresh!)

## What is blankpkg?

`blankpkg` is a comprehensive R package template that gives you a
complete development infrastructure out of the box. No need to set up
the boring stuff—it’s all here:

- **28 development scripts** organized by workflow category
- **Automatic pre-commit hooks** for code quality
- **4-step CRAN release workflow**
- **pkgdown website configuration** with example article
- **Rcpp/C++ integration support**
- **Comprehensive testing and checking tools**
- **Example vignette/article** demonstrating documentation best
  practices

This template follows modern R package development best practices and
automates the tedious stuff so you can focus on writing code.

## Template Features

### 1. Development Scripts (28 total)

All scripts are in the `dev/` folder with prefix-based naming for easy
discovery:

**Setup & Installation (3 scripts)** - `setup_new_package.R` - Reference
for package creation - `setup_rcpp_infrastructure.R` - Add C++
functionality via Rcpp - `install_dev_dependencies.R` - Install all
development packages - `install_linter_jarl.R` - Install jarl linter
(Rust-based CLI tool)

**Daily Development (3 scripts)** - `daily_document_and_check.R` - Most
common workflow (document + check) - `daily_test.R` - Quick test
execution - `daily_load_all.R` - Interactive development

**Testing Suite (3 scripts)** - `test_run_all.R` - Full test suite -
`test_with_coverage.R` - Tests + coverage report - `test_spelling.R` -
Spell checking

**Checking Suite (4 scripts)** - `check_local.R` - Local R CMD check -
`check_win_devel.R` - Windows R-devel validation -
`check_mac_release.R` - Mac R-release validation -
`check_rhub_multi_platform.R` - 20+ platform checks -
`check_good_practice.R` - Package quality analysis

**Build Tools (3 scripts)** - `build_readme.R` - Render README.Rmd →
README.md - `build_vignettes.R` - Build all vignettes -
`pkgdown_build_site.R` - Build package website -
`pkgdown_customize_site.R` - Interactive pkgdown customization

**CRAN Release Workflow (4 scripts)** - `release_01_prepare.R` -
Version, NEWS.md, spell check - `release_02_local_checks.R` - Local
validation - `release_03_remote_checks.R` - Remote platform checks -
`release_04_submit_to_cran.R` - Final submission

**Analysis Tools (3 scripts)** - `analyze_code_coverage.R` - Test
coverage analysis - `analyze_dependencies.R` - Package dependency
mapping - `analyze_package_structure.R` - Function counts and metrics -
`analyze_performance.R` - Benchmarking and profiling -
`analyze_code_quality.R` - Code style and complexity

### 2. Pre-commit Hook System

The template includes an automatic pre-commit hook that runs before each
commit (so you don’t accidentally commit broken code):

1.  **jarl lint –fix** - Auto-fix linting issues (if installed)
2.  **air format** - Code formatting (if installed)
3.  **devtools::document()** - Update documentation (required)
4.  **devtools::check()** - CRAN-level checks (required)

The hook is automatically installed when you start R in the package
directory (via `.Rprofile`).

**Skip the hook for a single commit:**

``` bash
git commit --no-verify -m "your message"
```

### 3. Claude Code AI Agents

The template includes specialized Claude Code agents in the `.claude/`
folder:

- **roxygen-doc-reviewer** - Reviews roxygen2 documentation for
  completeness and accuracy
- **cran-submission-expert** - Assists with CRAN submission preparation
  and policy compliance

These agents integrate with Claude Code CLI to provide AI-assisted code
review and CRAN preparation. See `dev/README.md` for detailed usage
instructions.

### 4. Key Configuration Files

- `.Rprofile` - Auto-installs pre-commit hook, loads devtools
- `_pkgdown.yml` - Package website configuration (Bootstrap 5)
- `air.toml` - Air formatter configuration
- `dev/pre_commit_hook` - Git pre-commit hook script
- `dev/README.md` - Complete guide to all development scripts

### 4. All Scripts Use Automatic Package Detection

No hardcoded package names! Every script figures out your package name
automatically:

``` r
get_package_name <- function() {
  if (requireNamespace("desc", quietly = TRUE)) {
    return(desc::desc_get_field("Package"))
  }
  if (file.exists("DESCRIPTION")) {
    lines <- readLines("DESCRIPTION", n = 20)
    pkg_line <- grep("^Package:", lines, value = TRUE)
    if (length(pkg_line) > 0) {
      return(trimws(sub("^Package:", "", pkg_line[1])))
    }
  }
  basename(normalizePath("."))
}
```

## How to Use This Template

### Step 1: Create Your Package from This Template

On GitHub, click “Use this template” to create a new repository, or
clone this repository locally.

### Step 2: Customize Package Metadata

Edit `DESCRIPTION` file with your package details: - Package name -
Title and description - Author information - License - Dependencies

### Step 3: Replace This README

**⚠️ IMPORTANT:** Delete this README.Rmd and create your own. Start
fresh with: - Your package name and purpose - Installation
instructions - Usage examples - Function documentation - **Update badge
URLs:** Replace `username/blankpkg` in badges with your GitHub username
and repo name

After editing README.Rmd, generate README.md by running:

``` r
source("dev/build_readme.R")
```

### Step 4: Install Development Dependencies

``` r
source("dev/install_dev_dependencies.R")
```

Optionally install the jarl linter (recommended):

``` r
source("dev/install_linter_jarl.R")
```

### Step 5: Start Developing

Use the daily development scripts:

``` r
# Most common workflow
source("dev/daily_document_and_check.R")

# Quick testing
source("dev/daily_test.R")

# Interactive development
source("dev/daily_load_all.R")
```

### Step 6: Customize pkgdown Website (Optional)

If you want a package website:

``` r
source("dev/pkgdown_customize_site.R")
```

This interactive script helps you configure themes, navigation, and
function reference organization.

### Step 7: Add Rcpp Functionality (Optional)

Need to speed things up with C++?

``` r
source("dev/setup_rcpp_infrastructure.R")
```

This sets up the complete Rcpp infrastructure with example functions to
get you started.

## Quick Reference

### Most Common Workflows

**Daily development:**

``` r
source("dev/daily_document_and_check.R")
```

**Before committing:** The pre-commit hook runs automatically and
catches issues before they reach your repo: - Lints and formats your
code - Updates documentation - Runs R CMD check

**Optional: Preparing for CRAN Release**

*Note: CRAN submission is entirely optional. This template works
perfectly for GitHub-only packages. Only use these scripts if you plan
to submit to CRAN.*

``` r
# Step 1: Prepare
source("dev/release_01_prepare.R")

# Step 2: Local checks
source("dev/release_02_local_checks.R")

# Step 3: Remote checks
source("dev/release_03_remote_checks.R")

# Step 4: Submit
source("dev/release_04_submit_to_cran.R")
```

## Template Documentation

Complete documentation for all development scripts is in
`dev/README.md`:

``` r
file.edit("dev/README.md")
```

## Package Development Best Practices Included

This template follows modern R package development standards:

1.  **Code Style**: snake_case consistently, prefix-based function
    families
2.  **Testing**: testthat structure with coverage analysis
3.  **Documentation**: roxygen2 with comprehensive headers
4.  **Quality Control**: Pre-commit hooks with automated checks
5.  **CRAN Compliance**: Step-by-step release workflow
6.  **Website**: pkgdown with Bootstrap 5 and customization options
7.  **Performance**: Optional Rcpp integration for speed-critical code

## What to Keep vs. Replace

### Keep These (they work for any package):

- `dev/` folder and all scripts (they auto-detect your package name)
- `.claude/` folder (AI agents for documentation review and CRAN
  submission)
- `.Rprofile` (auto-installs pre-commit hook)
- `dev/pre_commit_hook` (git hook)
- `air.toml` (formatter config)
- `.Rbuildignore`, `NAMESPACE` (auto-managed)

### Replace These (make them yours):

- **README.Rmd** (THIS FILE—replace with your package documentation)
- **DESCRIPTION** (update with your package details)
- \*\*\_pkgdown.yml\*\* (customize for your package)
- `NEWS.md` (document your package changes)
- Everything in `R/`, `tests/`, `man/` (your code goes here)
- `vignettes/articles/article.Rmd` (example article—replace with your
  own documentation)

## After Customizing

Once you’ve customized the template for your package:

1.  Update README.Rmd with your package information
2.  Run `source("dev/build_readme.R")` to generate README.md
3.  Update DESCRIPTION with correct metadata
4.  Start writing your package functions in R/
5.  Add tests in tests/testthat/
6.  Use `source("dev/daily_document_and_check.R")` regularly

## License

MIT License - See LICENSE.md file for details.

## Questions or Issues?

See `dev/README.md` for comprehensive documentation on all development
scripts and workflows.

------------------------------------------------------------------------

**Remember:** This README explains the template. Replace it with
documentation specific to your package—don’t keep this file!
