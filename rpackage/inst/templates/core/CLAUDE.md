# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

This is a **complete R package template** (`blankpkg`) with comprehensive development infrastructure:
- `roxyglobals` for automatic global variable detection
- `air` formatter for code styling (Rust-based)
- `testthat` (edition 3) for testing
- `pkgdown` for documentation website
- `rhub` for cross-platform CRAN checks
- Pre-commit hooks for automated quality checks
- 30 development scripts organized by workflow

## Available Claude Code Agents

This package includes specialized agents in `.claude/` folder. **Use these agents proactively** when appropriate:

### roxygen-doc-reviewer
**When to invoke:** After writing or modifying function documentation, BEFORE running `devtools::document()`

**Purpose:** Reviews roxygen2 documentation for:
- Grammatical correctness and clarity
- Accuracy of descriptions relative to actual code
- Completeness of `@param`, `@return`, `@examples` tags
- Proper use of `@autoglobal` tag (required for all functions)
- Consistency between documentation and implementation

**Proactive triggers:**
- User has just written a new function with roxygen comments
- User modified function parameters or behavior
- Before running `devtools::document()` or `devtools::check()`
- When documentation-related CHECK warnings/notes appear

**How to use:**
```bash
# Invoke via Task tool with subagent_type
Task(subagent_type="roxygen-doc-reviewer",
     prompt="Review roxygen documentation in R/my_function.R for accuracy and completeness")
```

### cran-submission-expert
**When to invoke:** During CRAN preparation or after receiving CRAN feedback

**Purpose:** Assists with:
- CRAN policy compliance verification
- R CMD check results interpretation
- Common CRAN rejection issues
- DESCRIPTION file requirements
- Documentation standards for CRAN

**Proactive triggers:**
- User mentions "CRAN submission" or "submit to CRAN"
- User is running `release_*` scripts
- User receives CRAN reviewer feedback
- R CMD check produces CRAN-specific warnings/notes
- User asks about package release readiness

**How to use:**
```bash
# Invoke via Task tool with subagent_type
Task(subagent_type="cran-submission-expert",
     prompt="Review package for CRAN compliance before running release_01_prepare.R")
```

**Remember:** These agents complement but don't replace development scripts. Use them for guidance, then execute appropriate `dev/*.R` scripts.

## Essential Development Commands

### Quick Reference (Most Common)
```r
# Daily workflow (use these frequently)
source("dev/daily_document_and_check.R")  # Update docs + R CMD check
source("dev/daily_test.R")                # Run tests quickly
source("dev/daily_load_all.R")            # Load package for interactive use

# Before committing
source("dev/check_local.R")               # Full R CMD check
source("dev/test_spelling.R")             # Check spelling

# Direct devtools commands
devtools::document()        # Generate documentation from roxygen2
devtools::load_all()        # Load package for interactive testing
devtools::test()            # Run all tests
devtools::check()           # R CMD check (required before completion)
```

## Development Scripts Architecture

**30 scripts in `dev/` organized by prefix-based naming for autocomplete discovery:**

- `setup_*` - Initial package setup, Rcpp infrastructure configuration
- `install_*` - Installation of dependencies, dev tools, linters (jarl)
- `daily_*` - Common daily development workflows (most used)
- `test_*` - Testing workflows with coverage and spelling
- `check_*` - Package checking and validation (local, remote, multi-platform)
- `build_*` - Building documentation (README, vignettes)
- `pkgdown_*` - Package website building and customization
- `release_*` - 4-step CRAN release workflow (must follow order 01→02→03→04)
- `analyze_*` - Code analysis, coverage, dependencies, performance, quality

**See `dev/README.md` for complete guide** (600+ lines with detailed usage instructions for all scripts)

**Key Pattern:** Type prefix (e.g., `daily_`) + TAB to discover all related scripts

**Special Scripts:**
- `setup_rcpp_infrastructure.R` - Configure package for C++ code with Rcpp (checks compiler, creates examples)
- `install_linter_jarl.R` - Install jarl CLI linter (Rust-based, 140x faster than lintr)
- `pkgdown_customize_site.R` - Interactive guide with templates for website customization

## Complete Scripts Reference

### Setup & Installation (4 scripts)
- `setup_new_package.R` - Reference documentation of package creation steps (DO NOT RUN - historical reference only)
- `setup_rcpp_infrastructure.R` - Configure package for C++ code with Rcpp; checks compiler, creates src/ directory with example functions
- `install_dev_dependencies.R` - Install all development packages (devtools, roxygen2, usethis, etc.) with parallel installation
- `install_linter_jarl.R` - Display installation instructions for jarl CLI linter (Rust-based, 140x faster than lintr)

### Daily Development (3 scripts - MOST USED)
- `daily_document_and_check.R` - **Most common workflow:** Update documentation with roxygen2 + run R CMD check (30-60 sec)
- `daily_test.R` - Quick test execution: loads package + runs all tests (5-15 sec)
- `daily_load_all.R` - Load package functions into current R session for interactive development (<1 sec)

### Testing Suite (3 scripts)
- `test_run_all.R` - Run complete test suite with detailed output; similar to daily_test.R but preserves console history
- `test_with_coverage.R` - Run tests + generate interactive HTML coverage report; highlights untested code in red
- `test_spelling.R` - Check all documentation for spelling errors; add valid words to inst/WORDLIST

### Checking Suite (5 scripts)
- `check_local.R` - Full R CMD check locally; must pass 0/0/0 before committing or releasing (30-90 sec)
- `check_good_practice.R` - Analyze package for R best practices using goodpractice; recommendations are suggestions not requirements
- `check_win_devel.R` - Submit to Windows R-devel builder; results emailed in 15-60 min
- `check_mac_release.R` - Submit to macOS R-release builder; results emailed in 15-60 min
- `check_rhub_multi_platform.R` - Comprehensive multi-platform checks on 20+ platforms via R-Hub (requires GITHUB_PAT)

### Build Tools (2 scripts)
- `build_readme.R` - Render README.Rmd to README.md; executes code chunks and updates output
- `build_vignettes.R` - Build all vignettes to inst/doc/; runs R code in vignettes

### Pkgdown Website (2 scripts)
- `pkgdown_build_site.R` - Build complete package website to docs/ directory (10-30 sec)
- `pkgdown_customize_site.R` - Interactive guide with templates for customizing _pkgdown.yml; 20+ themes, navigation, reference organization

### Release Workflow (4 scripts - MUST RUN IN ORDER)
- `release_01_prepare.R` - **Step 1/4:** Checklist for version update, NEWS.md, spell check, documentation review
- `release_02_local_checks.R` - **Step 2/4:** Run R CMD check + goodpractice locally; must pass before proceeding
- `release_03_remote_checks.R` - **Step 3/4:** Submit to Windows + macOS builders; wait for email results
- `release_04_submit_to_cran.R` - **Step 4/4:** Final CRAN submission via devtools::release(); includes post-submission checklist

### Analysis Tools (5 scripts)
- `analyze_code_coverage.R` - Calculate test coverage; displays percentage per file with optional HTML report
- `analyze_code_quality.R` - Static code analysis with codetools; identifies global variables, undefined vars, suspicious constructs
- `analyze_dependencies.R` - Create interactive dependency network graph with pkgnet; saves to dev/dependency_report.html
- `analyze_package_structure.R` - Count functions, files, documentation coverage; identifies undocumented functions
- `analyze_performance.R` - **TEMPLATE SCRIPT:** Provides templates for microbenchmark and profvis; customize before use

### Development Helpers (2 scripts)
- `create_example_data.R` - Template for creating example datasets; uses usethis::use_data() and shows documentation pattern
- `create_example_function.R` - Template for creating well-documented functions; includes complete roxygen2 example with validation

## Package Configuration

### roxyglobals Setup
- **Critical:** Add `@autoglobal` tag to EVERY function
- Globals detected automatically and written to `R/globals.R`
- Config in DESCRIPTION:
  - `Config/roxyglobals/filename: globals.R`
  - `Config/roxyglobals/unique: TRUE`

### Roxygen Configuration
Uses markdown format with custom roclets:
```
Roxygen: list(markdown = TRUE, roclets = c("collate", "namespace", "rd", "roxyglobals::global_roclet"))
```

### Code Formatting
- Uses `air` formatter (Rust-based, configured in `air.toml`)
- Run via: `air format .` or let pre-commit hook handle it
- Pre-commit hook auto-formats before commits

## Pre-Commit Hook System

**Automatically installed via `.Rprofile` when R starts**

The pre-commit hook (`dev/pre_commit_hook`) runs before each commit:
1. `jarl lint --fix R/` - Fast Rust-based linting with auto-fix (if installed)
2. `air format .` - Format all R files (if installed)
3. `devtools::document()` - Update documentation (required)
4. `devtools::check(cran = TRUE)` - R CMD check with CRAN standards (required)

**Usage:**
```bash
git commit -m "message"              # Hook runs automatically
git commit --no-verify -m "message"  # Skip hook for quick commits
rm .git/hooks/pre-commit             # Disable hook permanently
```

**Auto-updates:** Hook reinstalls when `dev/pre_commit_hook` changes

## CRAN Release Workflow

**MUST follow 4-step sequence in order:**
1. `source("dev/release_01_prepare.R")` - Update version, NEWS.md, spell check
2. `source("dev/release_02_local_checks.R")` - R CMD check + goodpractice
3. `source("dev/release_03_remote_checks.R")` - Submit to win-builder + macOS builder
4. `source("dev/release_04_submit_to_cran.R")` - Final submission

Each step validates prerequisites before allowing progression to next step.

## Coding Style (from CLAUDE.md user instructions)

1. **Use snake_case consistently** — All functions, arguments, internal variables
2. **Organize functions into prefix-based families** — Group related functions under common prefixes (`data_*`, `plot_*`, `utils_*`)
3. **Provide main entry point with accessible internals** — One primary function for typical workflow; individual steps exported for advanced users
4. **Maintain consistent parameter names** — Identical argument names across related functions
5. **Delegate parallelization to `future`** and progress to `progressr` — Let users configure externally
6. **Use standard R data structures** — Accept/return data frames, lists, vectors; avoid custom S4/R6 unless necessary

## Communication Style

7. **Lead with code, follow with explanation** — Show code first, keep explanations brief
8. **Match technical level** — Skip basic explanations; assume familiarity with R package development

## Writing Style (for comments, documentation, READMEs)

**Tone and Voice:**
- Conversational yet technically rigorous — like a knowledgeable colleague explaining over coffee
- Direct and personal: address reader as "you", use "we" for shared experience, "I" when sharing opinions
- Admit uncertainty openly; not afraid to be opinionated when appropriate
- Use **bold** for key concepts, *italics* for emphasis, strikethrough for humor: "~~junk~~ code"

**Language Patterns:**
- Start sentences with conjunctions deliberately: "But...", "So...", "And...", "Now..."
- Use conversational fragments when natural: "Great!", "So now we have..."
- Ask rhetorical questions: "But what the heck is...?"
- Include parenthetical asides for clarifications or side comments
- Mix formal and informal vocabulary: "ameliorate" alongside "pitiful", "cumbersome", "buzz kill"
- Common phrases: "Let me go ahead and...", "At this point...", "That said...", "Keep in mind...", "Here's the thing..."

**Technical Communication:**
- Break down complex terms by etymology when helpful (e.g., "multicollinearity from Latin roots")
- Provide multiple explanation levels: conceptual first (what/why), then technical (how it works), then practical (how to implement)
- Acknowledge complexity honestly: "This is a deep rabbit hole", "well beyond the scope"
- Comment code generously with `#`
- Use clear, descriptive variable names
- Show wrong approaches before correct ones when instructive

**Structure:**
- Keep paragraphs short (3-5 sentences typically)
- Break complex topics with numbered or bulleted lists
- Use transitions: "Now that we have...", "Let's see...", "Here goes..."
- Credit others generously: reference papers, link to sources, acknowledge contributors

**Avoid:**
- Corporate jargon or buzzwords (unless used ironically)
- Passive voice unnecessarily
- Excessive formality in tone
- Over-explaining basic concepts to stated audience
- Emoji (except rare, strategic cases)
- Walls of text without breaks

## Workflow Rules

9. **Preserve existing architecture** — Follow established patterns; don't refactor unrelated code
10. **Run `devtools::check()` and `testthat` before completion** — Verify R CMD check passes with 0/0/0 and existing tests pass

## Critical Workflow Requirements

1. **Always run `devtools::check()`** before considering any task complete (must pass with 0 errors, 0 warnings, 0 notes)
2. **Run tests with `devtools::test()`** to verify no regressions
3. **Add `@autoglobal` to new functions** for automatic global variable detection
4. **Use roxygen2 markdown format** for all documentation
5. **Check spelling** with `spelling::spell_check_package()` (custom words go in `inst/WORDLIST`)
6. **Use development scripts** — Don't run raw commands; use appropriate `dev/*.R` scripts for workflows
7. **Use roxygen-doc-reviewer agent** — After writing/modifying functions, proactively invoke the agent to review documentation quality before running `devtools::document()`
