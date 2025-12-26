# Development Scripts Guide

This folder contains development and release scripts for R package maintenance. All scripts are designed to be run from the **package root directory** using `source("dev/script_name.R")`. (Don't run them from within the `dev/` folder—they won't work!)

## Table of Contents

- [Quick Start](#quick-start)
- [Script Organization](#script-organization)
- [Daily Development Workflow](#daily-development-workflow)
- [Testing Workflow](#testing-workflow)
- [Pre-Release Checklist](#pre-release-checklist)
- [CRAN Release Workflow](#cran-release-workflow)
- [All Scripts Reference](#all-scripts-reference)
  - [Setup & Installation](#setup--installation)
  - [Daily Development](#daily-development)
  - [Testing Suite](#testing-suite)
  - [Checking Suite](#checking-suite)
  - [Build Tools](#build-tools)
  - [Pkgdown Website](#pkgdown-website)
  - [Release Workflow](#release-workflow)
  - [Analysis Tools](#analysis-tools)
  - [Linting Tools](#linting-tools)
  - [Code Organization Tools](#code-organization-tools)
- [Claude Code AI Agents](#claude-code-ai-agents)
- [Prerequisites](#prerequisites)
- [Tips & Best Practices](#tips--best-practices)

## Quick Start

### First Time Setup

1. **Install development dependencies:**
   ```r
   source("dev/install_dev_dependencies.R")
   ```

2. **Configure your environment:**
   - Run `rhub::rhub_setup()` for R-Hub checks (one-time setup)
   - Set GitHub PAT in `.Renviron` for rhub authentication

### Most Common Scripts

```r
# Daily development (most used)
source("dev/daily_document_and_check.R")  # Update docs + check package
source("dev/daily_test.R")                # Run tests quickly
source("dev/daily_load_all.R")            # Load package for interactive use

# Before committing
source("dev/check_local.R")               # Full R CMD check
source("dev/test_spelling.R")             # Check spelling
```

## Script Organization

Scripts are organized with **prefix-based naming** for easy discovery via autocomplete:

- `setup_*` - Initial package setup and configuration
- `install_*` - Installation of dependencies
- `daily_*` - Common daily development workflows
- `test_*` - Testing workflows
- `check_*` - Package checking and validation
- `build_*` - Building documentation (README, vignettes)
- `pkgdown_*` - Package website with pkgdown
- `release_*` - CRAN release preparation (4-step process)
- `analyze_*` - Code analysis and reporting

**Tip:** Type the prefix (e.g., `daily_`) and hit tab to discover all scripts in that category. It's like autocomplete for your workflow!

## Daily Development Workflow

### Typical Day

1. **Start development session:**
   ```r
   source("dev/daily_load_all.R")
   ```
   - Loads package functions into current R session
   - Use for interactive testing and development
   - Rerun after making code changes

2. **After making changes:**
   ```r
   source("dev/daily_document_and_check.R")
   ```
   - Updates documentation (roxygen2)
   - Runs R CMD check
   - **Most frequently used script** (bookmark this one!)
   - Takes 30-60 seconds

3. **Quick test run:**
   ```r
   source("dev/daily_test.R")
   ```
   - Runs test suite quickly
   - Faster than full check
   - Use for rapid iteration

### Before Committing

Run these before committing code:

```r
source("dev/check_local.R")      # Full validation
source("dev/test_spelling.R")    # Check spelling
```

All checks should pass (0 errors, 0 warnings, 0 notes) before committing. No exceptions!

## Testing Workflow

### Run All Tests

```r
source("dev/test_run_all.R")
```
- Comprehensive test execution
- Detailed output for each test
- Use before committing

### Test with Coverage

```r
source("dev/test_with_coverage.R")
```
- Runs tests + generates coverage report
- Opens interactive HTML report in browser
- Highlights untested code in red
- Aim for >80% coverage

### Spell Check

```r
source("dev/test_spelling.R")
```
- Checks all documentation for spelling errors
- Add valid words to `inst/WORDLIST` (package names, technical terms, etc.)
- Required to pass before CRAN submission

## Pre-Release Checklist

Before starting the release process, ensure:

### Code Quality Checks

```r
source("dev/check_local.R")           # Must pass with 0/0/0
source("dev/check_good_practice.R")   # Review recommendations
source("dev/test_spelling.R")         # Fix all errors
source("dev/test_with_coverage.R")    # Check coverage >80%
```

### Documentation

```r
source("dev/build_readme.R")          # If README.Rmd exists
source("dev/build_vignettes.R")       # If vignettes exist
source("dev/pkgdown_build_site.R")    # Build pkgdown site
```

### Analysis (Optional)

```r
source("dev/analyze_package_structure.R")  # Review package metrics
source("dev/analyze_code_quality.R")       # Static analysis
source("dev/analyze_dependencies.R")       # Dependency visualization
```

## CRAN Release Workflow

**Important:** Follow these steps **in order**. Do not skip steps. (Yes, we mean it—each step validates the previous one!)

### Step 1: Prepare

```r
source("dev/release_01_prepare.R")
```

**What it does:**
- Displays preparation checklist
- Runs spell check
- Reminds you to update version and NEWS.md

**Manual tasks:**
- Update `DESCRIPTION` version number (remove `.9000` suffix if present)
- Update `NEWS.md` with all changes since last release
- Review `DESCRIPTION` for completeness (don't forget URLs and author roles!)
- Run `devtools::document()`

**Next:** Proceed to Step 2 when all tasks complete. (Not before!)

---

### Step 2: Local Checks

```r
source("dev/release_02_local_checks.R")
```

**What it does:**
- Runs full R CMD check
- Runs good practice analysis
- Reports pass/fail status

**Requirements:**
- **Must pass:** 0 errors, 0 warnings, 0 notes
- Fix all issues before proceeding

**Time:** 2-5 minutes

**Next:** Only proceed to Step 3 if all checks pass.

---

### Step 3: Remote Checks

```r
source("dev/release_03_remote_checks.R")
```

**What it does:**
- Submits to Windows R-devel builder
- Submits to macOS R-release builder

**Requirements:**
- Interactive confirmation required
- Results emailed in 15-60 minutes (check your spam folder!)

**Wait for emails, then:**
- Review both check results carefully
- Both must pass (0 errors, 0 warnings)
- If checks fail, fix the issues and return to Step 2 (don't skip ahead!)

**Next:** Only proceed to Step 4 when remote checks pass.

---

### Step 4: Submit to CRAN

```r
source("dev/release_04_submit_to_cran.R")
```

**What it does:**
- Displays final checklist
- Confirms you're ready
- Runs `devtools::release()` (interactive)

**Requirements:**
- All previous steps complete and passing
- Version and NEWS.md updated
- All code committed to git

**After submission:**
- Tag release in git: `git tag -a vX.Y.Z -m "Release X.Y.Z"`
- Wait for CRAN confirmation email
- Respond to any CRAN requests promptly

---

## All Scripts Reference

### Setup & Installation

#### `setup_new_package.R`
**When to use:** Never (reference only)
**What it does:** Documents the initial package setup process
**Notes:** **DON'T RUN THIS!** It's a reference script showing how the package template was created, not meant to be executed.

#### `setup_rcpp_infrastructure.R`
**When to use:** Adding C++ code to your package via Rcpp
**What it does:** Configures package for Rcpp, creates example C++ functions
**Time:** 1-2 minutes
**Prerequisites:** C++ compiler (Rtools on Windows, Xcode on Mac, g++ on Linux)
**What it creates:**
- `src/` directory with example .cpp file
- Updates DESCRIPTION with Rcpp dependencies
- Provides comprehensive guidance on writing C++ code
**Notes:**
- Checks for C++ compiler before setup (saves you from cryptic errors later)
- Creates two example functions: `cpp_square()` and `cpp_vectorized_example()`
- Must run `devtools::document()` after setup to compile
- Includes debugging tips, performance notes, and common patterns
- Links to Rcpp resources and documentation

#### `install_dev_dependencies.R`
**When to use:** First time setup, or to update dev packages
**What it does:** Installs all required development packages
**Time:** 5-10 minutes first run
**Packages installed:** devtools, roxygen2, roxygen2Comment, usethis, here, roxyglobals, rhub, covr, codetools, pkgnet, microbenchmark, goodpractice, rcmdcheck, profvis, todor

---

### Daily Development

#### `daily_document_and_check.R`
**When to use:** After making code changes (most common workflow)
**What it does:** Updates documentation + runs R CMD check
**Time:** 30-60 seconds
**Notes:** Run this frequently during development—like, multiple times a day!

#### `daily_test.R`
**When to use:** Quick test execution during development
**What it does:** Loads package and runs all tests
**Time:** 5-15 seconds
**Notes:** Faster than full check

#### `daily_load_all.R`
**When to use:** Interactive development and testing
**What it does:** Loads package functions into current R session
**Time:** <1 second
**Notes:** Rerun after changing function code

---

### Testing Suite

#### `test_run_all.R`
**When to use:** Before committing code
**What it does:** Runs complete test suite with detailed output
**Time:** Varies by test complexity
**Notes:** More detailed than `daily_test.R`

#### `test_with_coverage.R`
**When to use:** Checking test coverage
**What it does:** Runs tests + generates interactive coverage report
**Time:** 2x test execution time
**Notes:** Opens HTML report in browser; aim for >80% coverage (but use your judgment)

#### `test_spelling.R`
**When to use:** Before committing, before release
**What it does:** Spell checks all documentation
**Time:** Few seconds
**Notes:** Add valid words to `inst/WORDLIST`

---

### Checking Suite

#### `check_local.R`
**When to use:** Before committing, before release
**What it does:** Full R CMD check locally
**Time:** 30-90 seconds
**Notes:** Must pass with 0/0/0 before release (no shortcuts here!)

#### `check_win_devel.R`
**When to use:** Before CRAN submission (or use release workflow)
**What it does:** Submits to Windows R-devel builder
**Time:** 15-60 minutes (remote)
**Notes:** Results emailed to maintainer

#### `check_mac_release.R`
**When to use:** Before CRAN submission (or use release workflow)
**What it does:** Submits to macOS R-release builder
**Time:** 15-60 minutes (remote)
**Notes:** Results emailed to maintainer

#### `check_rhub_multi_platform.R`
**When to use:** Comprehensive cross-platform testing
**What it does:** Checks on 20+ platforms via R-Hub
**Time:** 15-60 minutes (remote)
**Notes:** First-time users run `rhub::rhub_setup()` first

#### `check_good_practice.R`
**When to use:** Before release, periodic quality checks
**What it does:** Analyzes package for best practices
**Time:** 1-3 minutes
**Notes:** Recommendations are suggestions, not all mandatory (but worth considering!)

---

### Build Tools

#### `build_readme.R`
**When to use:** After editing README.Rmd
**What it does:** Renders README.Rmd to README.md
**Time:** Few seconds
**Notes:** Only runs if README.Rmd exists

#### `build_vignettes.R`
**When to use:** After editing vignettes
**What it does:** Builds all vignettes
**Time:** Varies by vignette complexity
**Output:** `inst/doc/` directory
**Notes:**
- Only runs if vignettes exist in `vignettes/` directory
- Files in `vignettes/articles/` are pkgdown articles (web-only, see `pkgdown_build_site.R`)
- Template includes example article: `vignettes/articles/article.Rmd`

---

### Pkgdown Website

#### `pkgdown_build_site.R`
**When to use:** After documentation updates
**What it does:** Builds pkgdown website
**Time:** 10-30 seconds
**Output:** `docs/` directory with HTML site
**Notes:**
- Configure appearance in `_pkgdown.yml`
- Template includes example article in `vignettes/articles/article.Rmd`
- Articles are web-only documentation (not included in package installation)
- Replace example article with your own topic-specific documentation

#### `pkgdown_customize_site.R`
**When to use:** Setting up or customizing package website
**What it does:** Interactive guide to pkgdown customization
**Time:** Educational/reference (doesn't modify files)
**Provides:**
- Templates for common configurations
- Theme options (20+ Bootswatch themes)
- Navigation customization
- Function reference organization
- Social media & SEO setup
- Custom CSS/JS guidance
- GitHub Pages deployment options
- Complete example configuration
**Notes:**
- Shows current `_pkgdown.yml` configuration
- Provides copy-paste templates
- Includes examples from popular packages
- Optional preview of current site
- Must edit `_pkgdown.yml` manually to apply changes

---

### Release Workflow

See [CRAN Release Workflow](#cran-release-workflow) section above for detailed step-by-step instructions.

#### `release_01_prepare.R` - Step 1 of 4
#### `release_02_local_checks.R` - Step 2 of 4
#### `release_03_remote_checks.R` - Step 3 of 4
#### `release_04_submit_to_cran.R` - Step 4 of 4

---

### Analysis Tools

#### `analyze_code_coverage.R`
**When to use:** Detailed coverage analysis
**What it does:** Calculates test coverage, optional HTML report
**Time:** Varies by test complexity
**Notes:** Similar to `test_with_coverage.R` but standalone

#### `analyze_dependencies.R`
**When to use:** Understanding package architecture
**What it does:** Creates visual dependency network with pkgnet
**Time:** 1-2 minutes
**Output:** `dev/dependency_report.html`
**Notes:** Useful for identifying tightly coupled functions

#### `analyze_package_structure.R`
**When to use:** Reviewing package metrics
**What it does:** Counts functions, files, documentation coverage
**Time:** Few seconds
**Notes:** Helps identify documentation gaps

#### `analyze_performance.R`
**When to use:** Benchmarking and profiling
**What it does:** Provides templates for microbenchmark and profvis
**Time:** Depends on benchmarks
**Notes:** **TEMPLATE SCRIPT**—won't do anything until you customize it for your functions!

#### `analyze_code_quality.R`
**When to use:** Static code analysis
**What it does:** Checks for coding issues with codetools
**Time:** Few seconds
**Notes:** May report false positives for globals and NSE (use `@autoglobal` to fix these)

---

### Linting Tools

#### `install_linter_jarl.R`
**When to use:** Setting up fast Rust-based linting
**What it does:** Provides instructions to install jarl command-line linter
**Time:** Few seconds (displays instructions only)
**Notes:**
- **IMPORTANT:** Jarl is NOT an R package—it's a standalone CLI tool
- Installation requires running commands in terminal/PowerShell (not R console!)
- 140x faster than lintr (~0.13s vs 18.5s on 25k lines)—yes, really!
- Supports 25+ linting rules with automatic fixes
- IDE extensions available for VS Code/Positron

**Installation commands (copy to terminal):**

Linux/macOS:
```bash
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/etiennebacher/jarl/releases/latest/download/jarl-installer.sh | sh
```

Windows (PowerShell):
```powershell
irm https://github.com/etiennebacher/jarl/releases/latest/download/jarl-installer.ps1 | iex
```

**Usage (in terminal, not R console):**
```bash
jarl lint R/              # Lint directory
jarl lint --fix R/        # Lint with auto-fix
jarl lint path/to/file.R  # Lint single file
```

**R Package Alternatives:**
- `lintr` - Traditional R linter: `install.packages("lintr")`
- `styler` - Code formatter: `install.packages("styler")`

---

### Code Organization Tools

#### `roxygen2Comment` - Toggle Roxygen2 Comments

**When to use:** Writing or editing roxygen2 documentation, especially for code examples
**What it does:** RStudio addin that toggles roxygen2 comment markers (`#'`) on/off
**Time:** Instant
**How to use:**
- **RStudio Addin:** Select code lines → Addins menu → "Roxygen2 Comment"
- **Toggle behavior:**
  - Standard code → Adds `#'` prefix (converts to roxygen2 comment)
  - Roxygen2 comments → Removes `#'` prefix (converts back to code)
- **Typical workflow:** Write example code normally, then toggle to roxygen2 format for `@examples`
**Notes:**
- Especially useful for documenting code examples in function documentation
- Works like RStudio's native comment shortcut but for roxygen2 format
- Can assign custom keyboard shortcut in RStudio: Tools → Modify Keyboard Shortcuts
- Install: Already included in `dev/install_dev_dependencies.R`

---

#### `todor` - Find TODO Comments

**When to use:** During code review, before releases, or when cleaning up technical debt
**What it does:** Scans R project for TODO, FIXME, CHANGED, and other marker comments
**Time:** Few seconds
**How to use:**
- RStudio: Addins menu → "Find TODO comments"
- Programmatically: `todor::todor_package()` in R console
- Results appear in RStudio's Markers pane for easy navigation
**Notes:**
- Searches all .R files in package directory
- Common markers: TODO, FIXME, CHANGED, IDEA, HACK, NOTE, REVIEW
- Helps track incomplete implementations and known issues
- Install: Already included in `dev/install_dev_dependencies.R`

---

#### `create_example_data.R`

**When to use:** Creating example datasets for package documentation, vignettes, or testing
**What it does:** Template script for generating and documenting example datasets
**Time:** Few seconds (plus time to create your data)
**How to use:**
1. Run: `source("dev/create_example_data.R")`
2. Modify the data generation code to create your actual dataset
3. Document the dataset in `R/data.R` with roxygen2 comments
4. Run `devtools::document()` to generate help file

**What it creates:**
- `data/dummy_df.rda` - The dataset file (compressed with xz)
- Requires documentation in `R/data.R` with proper roxygen2 format

**Notes:**
- Template creates a 1000-row dataframe with 10 variables for demonstration
- Uses `set.seed(42)` for reproducibility
- Saves with `usethis::use_data(overwrite = TRUE, compress = "xz")`
- Keep datasets small (< 1 MB recommended)
- Document all variables clearly in `R/data.R`
- Run `devtools::document()` after creating data documentation
- Includes example showing how to verify data with `lm()` model

**Example workflow:**
```r
# 1. Run script to create example data
source("dev/create_example_data.R")

# 2. Edit R/data.R to document the dataset
# (See the file for roxygen2 documentation template)

# 3. Generate documentation
devtools::document()

# 4. Test that data is accessible
devtools::load_all()
data(dummy_df)
?dummy_df
```

---

#### `create_example_function.R`

**When to use:** Creating new functions with proper roxygen2 documentation structure
**What it does:** Template script for generating well-documented functions following package conventions
**Time:** Few seconds
**How to use:**
1. Run: `source("dev/create_example_function.R")`
2. Review the generated function in `R/lm_model.R`
3. Modify function code and documentation for your needs
4. Run `devtools::document()` to generate help files

**What it creates:**
- `R/lm_model.R` - Example function with complete roxygen2 documentation
- After `devtools::document()`: `man/lm_model.Rd` help file

**Notes:**
- Creates example `lm_model()` function that works with `dummy_df` dataset
- Includes complete roxygen2 documentation with all standard tags:
  - `@param` with detailed parameter descriptions
  - `@return` explaining return value structure
  - `@details` with implementation notes
  - `@export` to make function available to users
  - `@autoglobal` for automatic global variable detection
  - `@examples` with working code examples
- Demonstrates input validation and error handling
- Shows how to use `stats::` namespace prefix
- Example function fits linear models using formula `first_column ~ .`
- Includes 4 usage examples in documentation

**Example workflow:**
```r
# 1. Create example function
source("dev/create_example_function.R")

# 2. Review and customize R/lm_model.R

# 3. Generate documentation
devtools::document()

# 4. Test the function
devtools::load_all()
lm_model()
?lm_model
```

---

## Prerequisites

### Required Packages

Most scripts check for required packages and provide installation instructions if missing.

**Core development tools** (installed by `install_dev_dependencies.R`):
- devtools
- roxygen2
- usethis
- testthat (configured via `usethis::use_testthat()`)

**Additional tools** (used by specific scripts):
- covr (coverage analysis)
- pkgnet (dependency visualization)
- goodpractice (quality checks)
- spelling (spell checking)
- microbenchmark (benchmarking)
- profvis (profiling)
- rhub (multi-platform checks)
- pkgdown (website building)

### First-Time Setup

1. **Install dependencies:**
   ```r
   source("dev/install_dev_dependencies.R")
   ```

2. **Configure R-Hub (for rhub checks):**
   ```r
   rhub::rhub_setup()
   rhub::rhub_doctor()
   ```

3. **Set GitHub PAT in `.Renviron`:**
   ```
   GITHUB_PAT=your_token_here
   ```

### Working Directory

**All scripts must be run from the package root directory** (one level up from `dev/`):

```r
# Good - from package root
source("dev/daily_test.R")

# Bad - from dev/ directory
source("daily_test.R")  # Will fail with cryptic errors!
```

---

## Claude Code AI Agents

The `.claude/` folder contains specialized AI agents for use with Claude Code CLI. These agents provide intelligent assistance at critical stages of package development.

### Available Agents

#### roxygen-doc-reviewer

**Purpose:** Reviews roxygen2 documentation for completeness, accuracy, and clarity.

**When to use:**
- After writing new functions with roxygen documentation
- After modifying existing function documentation
- Before running `devtools::document()`
- During code review to catch documentation issues early

**What it checks:**
- Grammatical correctness and clarity of English
- Accuracy of parameter descriptions relative to function code
- Completeness of `@param`, `@return`, `@examples` tags
- Consistency between documentation and implementation
- Appropriate use of roxygen tags (`@export`, `@autoglobal`, etc.)

**Usage with Claude Code CLI:**
```bash
# Review specific function documentation
claude code "Review the roxygen documentation in R/my_function.R"

# Review all documentation before documenting
claude code "Review all roxygen documentation in R/ folder"
```

**Development stages:**
- **Active development:** Use after writing/modifying functions
- **Before commits:** Verify documentation quality
- **Pre-release:** Ensure all documentation is publication-ready

#### cran-submission-expert

**Purpose:** Assists with CRAN submission preparation and policy compliance verification.

**When to use:**
- When preparing for initial CRAN submission
- Before running the `release_*` workflow scripts
- After receiving CRAN review feedback
- When updating package for resubmission

**What it checks:**
- CRAN policy compliance (file structure, licensing, examples)
- R CMD check results interpretation
- DESCRIPTION file requirements
- Documentation standards (help files, vignettes)
- Code quality issues that affect CRAN acceptance
- Common CRAN rejection reasons

**Usage with Claude Code CLI:**
```bash
# Full CRAN compliance check
claude code "Check if this package is ready for CRAN submission"

# Address specific CRAN feedback
claude code "CRAN reviewer said 'Examples with CPU time > 5 sec'. Help me fix this."

# Pre-submission verification
claude code "Review CRAN requirements before I run release_04_submit_to_cran.R"
```

**Development stages:**
- **Pre-release:** Before starting `release_01_prepare.R`
- **After remote checks:** Interpret rhub/win-builder results
- **Post-rejection:** Address CRAN maintainer feedback
- **Resubmission:** Verify all issues resolved

### Integration with Development Workflow

The agents complement but do not replace the development scripts:

```r
# 1. Write/modify function
# 2. Ask roxygen-doc-reviewer to check documentation
# 3. Run documentation
source("dev/daily_document_and_check.R")

# ... later, preparing for CRAN ...

# 1. Ask cran-submission-expert for pre-check
# 2. Run release workflow
source("dev/release_01_prepare.R")
source("dev/release_02_local_checks.R")
# 3. Ask cran-submission-expert to interpret results
source("dev/release_03_remote_checks.R")
# 4. Ask cran-submission-expert for final verification
source("dev/release_04_submit_to_cran.R")
```

### Best Practices

1. **Use roxygen-doc-reviewer proactively** - Catch issues before `devtools::check()` fails
2. **Use cran-submission-expert early** - Don't wait until submission to check compliance
3. **Provide context** - Tell the agent what stage of development you're at
4. **Iterate** - Use agent feedback to improve, then ask for re-review
5. **Combine with scripts** - Agents provide guidance, scripts do the work

---

## Tips & Best Practices

### Autocomplete Discovery

Type the prefix and use tab completion to see all related scripts:
- `daily_` + TAB → see all daily workflow scripts
- `test_` + TAB → see all testing scripts
- `check_` + TAB → see all checking scripts
- etc.

### Common Workflows

**Before committing code:**
```r
source("dev/daily_document_and_check.R")
source("dev/test_spelling.R")
```

**Before pushing to remote:**
```r
source("dev/check_local.R")
source("dev/test_run_all.R")
```

**After documentation changes:**
```r
source("dev/pkgdown_build_site.R")
source("dev/build_readme.R")  # if README.Rmd exists
```

**Periodic quality checks:**
```r
source("dev/check_good_practice.R")
source("dev/analyze_code_quality.R")
source("dev/test_with_coverage.R")
```

### Script Execution Order

**No strict order required** for most scripts - they're standalone.

**Exception: CRAN release workflow MUST follow order:**
1. `release_01_prepare.R`
2. `release_02_local_checks.R`
3. `release_03_remote_checks.R`
4. `release_04_submit_to_cran.R`

### Customization

**Template scripts** (customize for your package):
- `analyze_performance.R` - Add your benchmarks
- `setup_new_package.R` - Reference only, adapt for new packages

**Configuration files** (customize as needed):
- `_pkgdown.yml` - Website appearance
- `inst/WORDLIST` - Valid spelling exceptions
- `air.toml` - Code formatting (if using air)

### Common Issues

**Script fails with "package not found":**
- Install required package: `install.packages("packagename")`
- Or run: `source("dev/install_dev_dependencies.R")` to install everything at once

**Remote checks don't arrive:**
- Check spam folder (seriously, check it!)
- Verify email in DESCRIPTION is correct
- Wait up to 60 minutes (grab a coffee)

**Check has notes about global variables:**
- Add `@autoglobal` tag to functions (roxyglobals handles this automatically)
- Or use `utils::globalVariables()` for intentional globals

**Performance scripts have errors:**
- `analyze_performance.R` is a template—it won't work until you customize it!
- Uncomment and modify the templates for your actual functions

---

## Getting Help

1. **Read script headers:** Each script has detailed documentation in comments
2. **Check prerequisites:** Scripts list required packages in headers
3. **Review error messages:** Scripts provide clear installation instructions
4. **Consult package documentation:**
   - devtools: https://devtools.r-lib.org/
   - usethis: https://usethis.r-lib.org/
   - pkgdown: https://pkgdown.r-lib.org/

---

## Script Maintenance

All scripts use **automatic package name detection**—no hardcoded values. They work with any package name without modification.

**Package detection method:**
1. Uses `desc::desc_get_field("Package")` if available
2. Falls back to parsing DESCRIPTION file directly
3. Falls back to current directory name

This ensures scripts work correctly when:
- Renaming the package
- Copying to a new package
- Using as a template

So go ahead and rename your package, fork the template, whatever rocks your boat!

---

**Happy developing!** These scripts are here to make R package development efficient and (dare we say it) enjoyable.
