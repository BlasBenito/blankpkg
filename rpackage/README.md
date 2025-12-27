# rpkgdev: R Package Development Workflow Tools

<!-- badges: start -->
[![R-CMD-check](https://github.com/blasbenito/rpkgdev/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/blasbenito/rpkgdev/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

> **Prototype Status**: This package is currently under development as a prototype within the blankpkg repository at `/rpackage/`. It will eventually be extracted to a separate repository.

Comprehensive suite of development workflow functions for R package development. Provides 23 `dev_*()` functions for common tasks like testing, checking, building documentation, and CRAN release preparation. Includes `deploy_template()` to scaffold new packages with complete development infrastructure.

## Why rpkgdev?

**Transform this:**
```r
source("dev/daily_test.R")
source("dev/daily_document_and_check.R")
source("dev/check_local.R")
source("dev/test_spelling.R")
```

**Into this:**
```r
library(rpkgdev)
dev_test()
dev_document_and_check()
dev_check_local()
dev_spell_check()
```

**Benefits:**
- Clean function calls instead of script sourcing
- Rich console output with timing and progress
- Work on any package with `pkg` parameter
- Programmatic access with return values
- Tab completion for function discovery
- Consistent API across all functions

## Installation

```r
# Install from local prototype (development)
devtools::install("path/to/blankpkg/rpackage")

# Future: Install from GitHub (when extracted)
# remotes::install_github("blasbenito/rpkgdev")
```

## Quick Start

The three essential functions for daily development:

```r
library(rpkgdev)

# 1. Load package for interactive testing
dev_load_all()

# 2. Run tests
dev_test()

# 3. Update docs and run R CMD check (before every commit)
dev_document_and_check()
```

That's 80% of your daily workflow. See [Quick Start Guide](vignettes/articles/quick-start.html) for more.

## Function Families

All 23 functions organized by prefix for autocomplete discovery:

### Daily Development (3 functions)
- `dev_load_all()` - Load package functions for interactive testing
- `dev_test()` - Run all tests with detailed output
- `dev_document_and_check()` - Update documentation + R CMD check

**Use these every day.** Type `dev_` + TAB to discover.

### Checking (5 functions)
- `dev_check_local()` - R CMD check locally (must pass 0/0/0)
- `dev_check_good_practice()` - Analyze code for R best practices
- `dev_check_windows()` - Submit to Windows R-devel builder
- `dev_check_macos()` - Submit to macOS R-release builder
- `dev_check_rhub()` - Multi-platform checks via R-Hub

**Use before commits and releases.** Type `dev_check_` + TAB.

### Testing (2 functions)
- `dev_test_coverage()` - Calculate test coverage with optional HTML report
- `dev_spell_check()` - Check documentation spelling

**Use to improve quality.** Type `dev_test_` + TAB.

### Building (2 functions)
- `dev_build_readme()` - Render README.Rmd to README.md
- `dev_build_vignettes()` - Build all vignettes

**Use after documentation changes.** Type `dev_build_` + TAB.

### Pkgdown (2 functions)
- `dev_pkgdown_build_site()` - Build package website
- `dev_pkgdown_customize_site()` - Interactive customization guide

**Use for website creation.** Type `dev_pkgdown_` + TAB.

### Release (4 functions - sequential workflow)
- `dev_release_prepare()` - **Step 1/4:** Preparation checklist
- `dev_release_check_local()` - **Step 2/4:** Local checks
- `dev_release_check_remote()` - **Step 3/4:** Remote checks
- `dev_release_submit()` - **Step 4/4:** CRAN submission

**Use in order for CRAN releases.** Type `dev_release_` + TAB.

### Analysis (4 functions)
- `dev_analyze_quality()` - Static code analysis with codetools
- `dev_analyze_dependencies()` - Interactive dependency network
- `dev_analyze_structure()` - Package structure metrics
- `dev_analyze_performance()` - Performance benchmarking guide

**Use to understand your package.** Type `dev_analyze_` + TAB.

### Template (1 function)
- `deploy_template()` - Create new package with full infrastructure

**Use to start new packages.**

## Common Workflows

### Daily Development

```r
library(rpkgdev)

# Load and test
dev_load_all()
dev_test()

# Before committing
dev_document_and_check()
```

### Pre-Commit Checklist

```r
library(rpkgdev)

# Essential checks
dev_document_and_check()
dev_test()
dev_spell_check()

# Optional but recommended
dev_check_local()
dev_test_coverage()
```

### CRAN Release

Four-step sequential workflow:

```r
library(rpkgdev)

# Step 1: Prepare (update version, NEWS.md, spell check)
dev_release_prepare()

# Step 2: Local checks (must pass 0/0/0)
dev_release_check_local()

# Step 3: Remote checks (wait for email results)
dev_release_check_remote()

# Step 4: Submit to CRAN
dev_release_submit()
```

Wait for clean results from Step 3 before running Step 4.

### Documentation Updates

```r
library(rpkgdev)

# Update all documentation
dev_build_readme()
dev_build_vignettes()
dev_pkgdown_build_site(preview = TRUE)

# Check and commit
dev_document_and_check()
```

## Deploy New Package

Create new package with complete infrastructure:

```r
library(rpkgdev)

deploy_template(
  path = "~/projects/mynewpkg",
  package_name = "mynewpkg"
)
```

**What you get:**
- Complete R package structure
- 30 development scripts in `dev/`
- Pre-commit hooks for quality checks
- pkgdown website configuration
- Test infrastructure (testthat)
- Claude Code agents for AI assistance
- GitHub Actions CI/CD
- Code formatting (air) and linting (jarl) setup

The package opens automatically in RStudio, ready to use.

### Customization Options

```r
# Skip Claude components
deploy_template(
  path = "~/projects/mynewpkg",
  package_name = "mynewpkg",
  claude_components = FALSE
)

# Skip dev scripts
deploy_template(
  path = "~/projects/mynewpkg",
  package_name = "mynewpkg",
  dev_scripts = FALSE
)

# Skip git initialization
deploy_template(
  path = "~/projects/mynewpkg",
  package_name = "mynewpkg",
  git_init = FALSE
)
```

## Key Features

### Consistent API

All functions share common parameters:

```r
# Default: work on current directory
dev_test()

# Work on different package
dev_test(pkg = "../otherpackage")

# Suppress output
dev_test(quiet = TRUE)
```

### Enhanced Feedback

Rich console output using cli package:

```
✔ Loading rpkgdev
══ Testing rpkgdev ═════════════════════════════════════════════════════════
✔ |  OK F W S | Context
✔ | 10      | dev_daily [0.5s]
✔ | 12      | deploy_template [1.2s]

══ Results ═════════════════════════════════════════════════════════════════
Duration: 1.7 seconds

OK: 22
Failed: 0
Warnings: 0
Skipped: 0

✔ All tests passed!
Total time: 2.1s
```

### Programmatic Access

All functions return invisibly for use in scripts:

```r
# Get results
metrics <- dev_analyze_structure(quiet = TRUE)
coverage <- dev_test_coverage(quiet = TRUE)

# Check conditions
if (metrics$exported > 10) {
  message("Large package!")
}
```

### Function Discovery

Type prefix + TAB for autocomplete:

- `dev_` + TAB → All 23 functions
- `dev_check_` + TAB → All checking functions
- `dev_release_` + TAB → Release workflow (4 steps)

## Documentation

- **[Main Vignette](vignettes/rpkgdev.html)** - Complete function reference with examples
- **[Quick Start Guide](vignettes/articles/quick-start.html)** - Get productive in 5 minutes
- **[Migration Guide](vignettes/articles/migration-guide.html)** - Migrate from dev/ scripts to functions
- **Function Help** - `?dev_test`, `?deploy_template`, etc.
- **Package Help** - `help(package = "rpkgdev")`

## Relationship with blankpkg Template

rpkgdev and [blankpkg](https://github.com/blasbenito/blankpkg) work together:

- **blankpkg** is the forkable template repository
- **rpkgdev** programmatically deploys the blankpkg template

**Two ways to use blankpkg:**
1. Fork blankpkg repository directly (traditional approach)
2. Use `deploy_template()` from rpkgdev (programmatic approach)

Both result in identical infrastructure. Choose your preferred workflow.

## Development Status

**Phases:**
- ✅ **Phase 1 (MVP):** Core functions + template deployment
- ✅ **Phase 2 (Complete Suite):** All 23 functions across 7 families
- 🔄 **Phase 3 (Documentation):** Vignettes, README, website (current)

**Package is functional and ready for testing.** Documentation is being finalized.

## Requirements

**Required packages (Imports):**
- cli, desc, devtools, fs, usethis

**Optional packages (Suggests):**
- codetools, covr, goodpractice, knitr, microbenchmark
- pkgdown, pkgnet, profvis, rcmdcheck, rhub
- rmarkdown, roxygen2, roxyglobals, rstudioapi
- spelling, testthat

Functions check for prerequisites and provide installation instructions when needed.

## Contributing

This is a prototype under active development. Feedback welcome!

1. Try the functions on your packages
2. Report issues or suggestions
3. Test `deploy_template()` with new packages
4. Review documentation for clarity

## License

MIT License - see LICENSE file for details.

## Acknowledgments

Built on the shoulders of:
- devtools and usethis (Hadley Wickham & RStudio team)
- cli (Gábor Csárdi)
- testthat, roxygen2, pkgdown (RStudio/Posit)
- All the amazing R package development tools ecosystem
