# CLAUDE.md - rpkgdev Package

This file provides guidance to Claude Code when working with the rpkgdev package.

## Package Summary

**rpkgdev** (R Package Development Tools) is an R package that provides a comprehensive suite of development workflow functions for R package development.

**Version:** 0.1.0 (Complete and production-ready)

**Status:** Prototype within blankpkg repository at `/rpackage/`. Will be extracted to separate repository when mature.

## Package Objectives

### Primary Goal
Transform blankpkg's script-based development workflow (30 `dev/*.R` scripts) into a clean, function-based API.

**Before (script-based):**
```r
source("dev/daily_test.R")
source("dev/daily_document_and_check.R")
source("dev/check_local.R")
```

**After (function-based):**
```r
library(rpkgdev)
dev_test()
dev_document_and_check()
dev_check_local()
```

### Secondary Goal
Provide programmatic template deployment from R instead of requiring GitHub fork.

**Template deployment:**
```r
deploy_template(
  path = "~/projects/mynewpkg",
  package_name = "mynewpkg",
  claude_components = TRUE,
  dev_scripts = TRUE
)
```

## Relationship with blankpkg Template

### Two Complementary Approaches

**blankpkg** (parent directory) and **rpkgdev** (this directory) serve different but complementary purposes:

| Aspect | blankpkg | rpkgdev |
|--------|----------|---------|
| Type | Template repository | R package |
| Usage | Fork from GitHub | Install and call functions |
| Deployment | Manual (fork + customize) | Programmatic (`deploy_template()`) |
| Updates | Git-based | Package updates |
| Workflow | 30 dev/ scripts via `source()` | 23 `dev_*()` functions |
| Best for | Want to customize template first | Quick package creation from R |

### How They Work Together

1. **Template Embedding:** rpkgdev embeds blankpkg template files in `inst/templates/`
   - Copied from parent directory during development
   - Deployed to new packages via `deploy_template()`

2. **Script → Function Mapping:** Each `dev/*.R` script has an equivalent `dev_*()` function
   - Example: `dev/daily_test.R` → `dev_test()`
   - Functions provide same functionality with enhanced API

3. **Two Ways to Get blankpkg Infrastructure:**
   - **Fork blankpkg** directly from GitHub (traditional)
   - **Use rpkgdev** `deploy_template()` (programmatic)
   - Both result in identical package structure

### Development Workflow Choice

**Users can choose their preferred workflow:**

```r
# Option 1: Use blankpkg scripts (traditional)
source("dev/daily_test.R")
source("dev/daily_document_and_check.R")

# Option 2: Use rpkgdev functions (modern)
library(rpkgdev)
dev_test()
dev_document_and_check()

# Option 3: Mix both (during migration)
library(rpkgdev)
dev_test()                              # Function
source("dev/setup_rcpp_infrastructure.R")  # Script (specialized)
```

## Package Architecture

### Function Organization

23 exported functions organized into 7 families:

1. **Daily Development (3):** dev_load_all, dev_test, dev_document_and_check
2. **Checking (5):** dev_check_local, dev_check_good_practice, dev_check_windows, dev_check_macos, dev_check_rhub
3. **Testing (2):** dev_test_coverage, dev_spell_check
4. **Building (2):** dev_build_readme, dev_build_vignettes
5. **Pkgdown (2):** dev_pkgdown_build_site, dev_pkgdown_customize_site
6. **Release (4):** dev_release_prepare, dev_release_check_local, dev_release_check_remote, dev_release_submit
7. **Analysis (4):** dev_analyze_quality, dev_analyze_dependencies, dev_analyze_structure, dev_analyze_performance

Plus: **deploy_template()** for creating new packages

### Consistent API Design

All functions follow the same pattern:
- `pkg = "."` - Work on current directory by default
- `quiet = FALSE` - Rich console output by default
- Return invisibly for programmatic use

Example:
```r
dev_test()                    # Default: current directory, verbose
dev_test(pkg = "../other")    # Different package
dev_test(quiet = TRUE)        # Suppress output
```

### Template Deployment Options

`deploy_template()` offers customization:
- `claude_components = TRUE/FALSE` - Include Claude AI agents?
- `dev_scripts = TRUE/FALSE` - Include dev/ scripts?
- `git_init = TRUE/FALSE` - Initialize git repo?
- `rstudio_project = TRUE/FALSE` - Create .Rproj file?
- `open_project = TRUE/FALSE` - Open in RStudio?

## Key Files and Structure

```
rpackage/
├── R/
│   ├── dev_daily.R          # 3 most-used functions
│   ├── dev_check.R          # 5 checking functions
│   ├── dev_test.R           # 2 testing functions
│   ├── dev_build.R          # 2 build functions
│   ├── dev_pkgdown.R        # 2 pkgdown functions
│   ├── dev_release.R        # 4 release functions (sequential)
│   ├── dev_analyze.R        # 4 analysis functions
│   ├── deploy_template.R    # Template deployment
│   ├── utils_internal.R     # Internal helpers (not exported)
│   └── zzz.R                # Package startup message
├── inst/templates/          # Embedded template files
│   ├── core/                # Config files (.Rbuildignore, etc.)
│   ├── claude/              # AI agents
│   ├── dev/                 # 30 development scripts
│   ├── github/              # CI/CD
│   └── tests/               # Test infrastructure
├── vignettes/
│   ├── rpkgdev.Rmd          # Main vignette (comprehensive)
│   └── articles/
│       ├── quick-start.Rmd        # 5-minute guide
│       └── migration-guide.Rmd    # Script → function mapping
├── _pkgdown.yml             # Website config (8 reference sections)
└── docs/                    # Pkgdown website (built)
```

## Development Status

**All 3 phases complete:**

- ✅ **Phase 1 (MVP):** Core functions + deploy_template
- ✅ **Phase 2 (Complete Suite):** All 23 functions
- ✅ **Phase 3 (Documentation):** Vignettes, website, polish

**Quality Metrics:**
- R CMD check: 0 errors / 0 warnings / 0 notes ✓
- Tests: 31 passing ✓
- Documentation: 23 .Rd files + 3 vignettes ✓
- Website: Built and ready ✓

**Result:** Production-ready prototype

## Common Tasks

### When Modifying Functions

1. Edit function in `R/dev_*.R`
2. Update roxygen documentation
3. Run `devtools::document()` to regenerate .Rd files
4. Run `devtools::test()` to verify tests pass
5. Run `devtools::check()` before committing (must pass 0/0/0)

### When Adding New Functions

1. Add to appropriate `R/dev_*.R` file (or create new)
2. Write roxygen documentation with examples
3. Export with `@export` tag
4. Add tests to `tests/testthat/test-*.R`
5. Update `_pkgdown.yml` reference section
6. Document in README and vignettes
7. Run `devtools::check()`

### When Updating Template Files

Template files in `inst/templates/` are copied from parent blankpkg directory:

1. Make changes in parent `/dev/`, `/.claude/`, etc.
2. Copy updated files to `rpackage/inst/templates/`
3. Maintain directory structure (core/, claude/, dev/, github/, tests/)
4. Update `deploy_template()` if new files added
5. Test deployment with `deploy_template()`

### Before Finalizing Changes

```r
# 1. Document
devtools::document()

# 2. Test
devtools::test()

# 3. Check (must be 0/0/0)
devtools::check()

# 4. Rebuild website
pkgdown::build_site()

# 5. Commit
```

## Important Notes

### Coding Style

Follow the parent CLAUDE.md coding style:
- Use snake_case consistently
- Organize functions by prefix-based families
- Maintain consistent parameter names (pkg, quiet)
- Use standard R data structures (data frames, lists, vectors)
- Lead with code, follow with brief explanations

### Dependencies

- **Imports (required):** cli, desc, devtools, fs, usethis
- **Suggests (optional):** 17 packages for specialized functionality
- Functions check prerequisites and provide installation instructions

### Testing Philosophy

- Test all functions for basic operation
- Test error conditions (invalid paths, missing dependencies)
- Test deploy_template() with different configurations
- Keep tests fast (use temp directories, quiet = TRUE)

### Documentation Standards

- All functions must have complete roxygen documentation
- Include @param for all parameters
- Include @return describing return value
- Include @examples with working code
- Include @export for exported functions
- Write clear, concise descriptions

## Future Development

### Before Extracting to Separate Repo

- Update DESCRIPTION URL when repo created
- Set up GitHub Actions CI/CD
- Create release workflow
- Consider CRAN submission

### Potential Enhancements

- Interactive RStudio addins for common workflows
- GitHub integration functions (PRs, issues)
- Extended deploy_template() templates
- Performance benchmarking helpers
- Code complexity metrics

## Quick Reference

### Most Common Functions (The Big Three)

```r
dev_load_all()           # Load package for interactive testing
dev_test()               # Run all tests
dev_document_and_check() # Update docs + R CMD check (before commit)
```

### CRAN Release Workflow (Sequential)

```r
dev_release_prepare()       # Step 1: Checklist
dev_release_check_local()   # Step 2: Local checks
dev_release_check_remote()  # Step 3: Remote checks
dev_release_submit()        # Step 4: Submit
```

### Create New Package

```r
deploy_template(
  path = "~/projects/mynewpkg",
  package_name = "mynewpkg"
)
```

## Resources

- **Development Notes:** See DEVELOPMENT-NOTES.md for detailed session history
- **Main Vignette:** `vignettes/rpkgdev.Rmd` for complete function reference
- **Quick Start:** `vignettes/articles/quick-start.Rmd` for 5-minute guide
- **Migration Guide:** `vignettes/articles/migration-guide.Rmd` for script → function mapping
- **Parent Template:** https://github.com/blasbenito/blankpkg

---

**Remember:** This package transforms blankpkg's script-based workflow into clean, function-based API while maintaining the ability to deploy complete package infrastructure programmatically.
