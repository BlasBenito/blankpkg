# First-Time Setup Checklist for blankpkg Template Users

Welcome! You've forked the blankpkg template. This checklist will guide you through customizing it for your R package.

## Phase 1: Initial Setup (5-10 minutes)

### Step 1: Fork and Clone
- [ ] Fork this repository to your GitHub account
- [ ] Clone to your local machine: `git clone https://github.com/YOUR-USERNAME/YOUR-PACKAGE-NAME.git`
- [ ] Open the directory in RStudio or your preferred R IDE

### Step 2: Auto-Installation of Pre-Commit Hook
- [ ] Start an R session in the package directory
- [ ] The `.Rprofile` will automatically install the pre-commit hook
- [ ] You should see a message: "Pre-commit hook installed successfully"
- [ ] Verify hook exists: check `.git/hooks/pre-commit`

### Step 3: Install Development Dependencies
- [ ] Run `source("dev/install_dev_dependencies.R")`
- [ ] This installs all required development packages (devtools, roxygen2, testthat, etc.)
- [ ] May take 5-10 minutes on first run

---

## Phase 2: Core Customization (30-60 minutes)

### Step 4: Update Package Metadata (CRITICAL)
Edit `DESCRIPTION` file and replace ALL placeholder text:

- [ ] **Package:** Change `blankpkg` to your package name (lowercase, no spaces)
- [ ] **Title:** Replace "What the Package Does (One Line, Title Case)" with your actual title
- [ ] **Description:** Replace placeholder paragraph with what your package does
- [ ] **Authors@R:** Update `person("First", "Last", email = "first.last@example.com", ...)` with your info
- [ ] **Maintainer:** Ensure your email is correct (CRAN will contact you here)
- [ ] **URL:** Add your GitHub repo: `https://github.com/YOUR-USERNAME/YOUR-PACKAGE`
- [ ] **BugReports:** Add: `https://github.com/YOUR-USERNAME/YOUR-PACKAGE/issues`

### Step 5: Update License
- [ ] Open `LICENSE` file
- [ ] Replace `YEAR: 2025` with current year if different
- [ ] Replace `COPYRIGHT HOLDER: blankpkg authors` with your name or organization

### Step 6: Customize README
- [ ] Open `README.Rmd` (source file for README.md)
- [ ] **Delete the entire "TEMPLATE repository" explanation section** (lines 1-150+)
- [ ] Write your own package documentation:
  - [ ] Package name and badges
  - [ ] Installation instructions
  - [ ] Quick example usage
  - [ ] Main features
- [ ] **Update badge URLs:** Replace `username/blankpkg` in badges with `YOUR-USERNAME/YOUR-PACKAGE`
- [ ] Run `source("dev/build_readme.R")` to generate README.md from README.Rmd
- [ ] Verify README.md looks correct

---

## Phase 3: Replace Example Code (Variable Time)

### Step 7: Replace Example Functions
The template includes `lm_model()` as demonstration code:

- [ ] Review `R/lm_model.R` to understand the documentation and code structure
- [ ] **Delete** `R/lm_model.R` (or keep as reference and rename)
- [ ] Write your own functions in `R/` directory
- [ ] Follow the roxygen2 documentation pattern from the example:
  - `@title`, `@description`, `@param`, `@return`, `@examples`
  - **CRITICAL:** Add `@autoglobal` tag to EVERY function
- [ ] Run `source("dev/daily_document_and_check.R")` after adding functions

### Step 8: Replace Example Data (if applicable)
- [ ] If your package doesn't need example data, delete:
  - `data/dummy_df.rda`
  - `R/data.R`
- [ ] If you DO need data:
  - Use `dev/create_example_data.R` as template
  - Document data in `R/data.R` following the pattern
  - Save data objects with `usethis::use_data(your_data)`

### Step 9: Update Tests
- [ ] Review `tests/testthat/test-lm_model.R` to understand testing patterns
- [ ] **Delete** this file after reviewing
- [ ] Write tests for your own functions
- [ ] Use `dev/create_example_function.R` as template for test structure
- [ ] Run `source("dev/daily_test.R")` to verify tests pass

---

## Phase 4: Configuration & Polish (30-60 minutes)

### Step 10: GitHub Actions Workflows
- [ ] Update `.github/workflows/R-CMD-check.yaml`:
  - [ ] Workflow is already configured for multi-platform checks
  - [ ] Verify it runs on branches you want (main, master, development)
  - [ ] Adjust OS matrix (Ubuntu/macOS/Windows) if needed
  - [ ] Adjust R version matrix (release/oldrel-1/devel) if needed

### Step 11: Optional: pkgdown Website
If you want a package website:

- [ ] Edit `_pkgdown.yml`:
  - [ ] Set `url: https://YOUR-USERNAME.github.io/YOUR-PACKAGE/`
  - [ ] Customize navigation, theme, reference organization
  - [ ] Use `source("dev/pkgdown_customize_site.R")` for interactive guide
- [ ] Run `source("dev/pkgdown_build_site.R")` to build site locally
- [ ] Review `docs/index.html` in browser
- [ ] Configure GitHub Pages to deploy from `/docs` folder (repo Settings → Pages)

### Step 12: Optional: Vignettes & Articles
If you want long-form documentation:

**Template includes example article:**
- [ ] Review `vignettes/articles/article.Rmd` (example pkgdown article)
- [ ] **Delete or replace** example article with your own topic-specific documentation
- [ ] Articles in `vignettes/articles/` are web-only (pkgdown), not in package installation

**Add standard vignettes** (if needed):
- [ ] Create `vignettes/` directory (if adding vignettes, not just articles)
- [ ] Add vignette with `usethis::use_vignette("intro-to-yourpackage")`
- [ ] Write vignette content in R Markdown
- [ ] Run `source("dev/build_vignettes.R")` to build

**Difference:** Vignettes install with package; articles are pkgdown-only (tutorials, case studies)

### Step 13: Update NEWS.md
- [ ] Open `NEWS.md`
- [ ] Replace placeholder with your version history:
  ```
  # yourpackage (development version)

  ## New Features
  * Initial package release
  * Added function_name() to do X

  ## Bug Fixes
  * None yet
  ```

---

## Phase 5: Validation & Release (30 minutes)

### Step 14: Run Comprehensive Checks
Run these development scripts to ensure quality:

- [ ] `source("dev/check_local.R")` - **MUST PASS** with 0 errors, 0 warnings, 0 notes (or acceptable notes)
- [ ] `source("dev/test_spelling.R")` - Fix any spelling errors (add valid words to `inst/WORDLIST`)
- [ ] `source("dev/test_with_coverage.R")` - Review test coverage (aim for >70%)
- [ ] `source("dev/check_good_practice.R")` - Address recommendations

If any checks fail, fix issues and re-run.

### Step 15: Test Pre-Commit Hook
- [ ] Make a small change to any R file
- [ ] Run `git add .`
- [ ] Run `git commit -m "Test pre-commit hook"`
- [ ] Verify hook runs automatically (jarl lint, air format, document, check)
- [ ] Confirm commit succeeds if all checks pass

### Step 16: Push to GitHub
- [ ] Review all changes with `git status` and `git diff`
- [ ] Stage all files: `git add .`
- [ ] Commit: `git commit -m "Customize blankpkg template for my package"`
- [ ] Push to GitHub: `git push origin main` (or your default branch)

### Step 17: Verify GitHub Actions
- [ ] Go to GitHub repository → Actions tab
- [ ] Verify R-CMD-check workflow runs automatically
- [ ] Check that workflow passes on all platforms (may take 10-20 minutes)
- [ ] Verify badges in README update to "passing" status

---

## Phase 6: Optional - CRAN Release (Only if submitting to CRAN)

The template includes comprehensive CRAN release workflow scripts. **If you plan to submit to CRAN**, follow this sequence:

- [ ] Run `source("dev/release_01_prepare.R")` - Preparation checklist
- [ ] Run `source("dev/release_02_local_checks.R")` - Local validation
- [ ] Run `source("dev/release_03_remote_checks.R")` - Windows/macOS checks (results via email)
- [ ] Run `source("dev/release_04_submit_to_cran.R")` - Final submission

**If NOT submitting to CRAN:** You can ignore `cran-comments.md` and the `release_*` scripts.

---

## Quick Reference: Development Scripts

**Daily Workflow (Most Used):**
- `daily_load_all.R` - Load package for interactive development
- `daily_test.R` - Run all tests quickly (5-15 seconds)
- `daily_document_and_check.R` - **PRIMARY WORKFLOW** - Update docs + R CMD check (30-60 seconds)

**Quality Checks:**
- `check_local.R` - Full R CMD check (must pass before commits)
- `test_spelling.R` - Spell check documentation
- `test_with_coverage.R` - Test coverage report (HTML output)

**Building:**
- `build_readme.R` - Render README.Rmd → README.md
- `pkgdown_build_site.R` - Build package website

**See `dev/README.md` for complete documentation of all 30 scripts.**

---

## Troubleshooting

### Pre-commit hook not installing?
- Manually run: `source(".Rprofile")` in R session
- Check `.git/hooks/pre-commit` exists
- Verify you're in the package root directory

### R CMD check failing?
- Run `source("dev/check_local.R")` to see detailed error messages
- Common issues:
  - **Missing `@autoglobal` tags** → Add to all functions
  - **Undocumented functions** → Add roxygen2 comments
  - **Examples fail** → Test examples in `@examples` section
  - **Missing imports** → Add packages to DESCRIPTION Imports/Suggests

### GitHub Actions failing?
- Check Actions tab on GitHub for detailed logs
- Common issues:
  - **Badge URLs still point to `username/blankpkg`** → Update in README.Rmd
  - **Dependencies not listed in DESCRIPTION** → Add to Imports or Suggests
  - **Platform-specific issues** → Test locally on that platform or use rhub

### Tests failing after customization?
- Delete `tests/testthat/test-lm_model.R` (it tests the example function)
- Ensure your test files follow naming: `test-yourfunction.R`
- Run `source("dev/daily_test.R")` for quick feedback

---

## Getting Help

- **Template Documentation:** See main README.md (before you delete it!)
- **Development Scripts:** See `dev/README.md` (600+ line comprehensive guide)
- **Coding Standards:** See `CLAUDE.md` and `VOICE.md`
- **CRAN Submission:** Use `dev/CRAN_CHECKLIST.md`

**Claude Code Users:**
- Invoke `roxygen-doc-reviewer` agent after writing/modifying functions
- Invoke `cran-submission-expert` agent when preparing for CRAN

---

## Summary Checklist

Quick verification that you've completed key steps:

- [ ] DESCRIPTION fully customized (no placeholder text)
- [ ] LICENSE copyright holder updated
- [ ] README.Rmd rewritten for your package (template explanation deleted)
- [ ] README badge URLs point to YOUR repository
- [ ] Example code (lm_model.R, dummy_df) deleted or replaced
- [ ] Example article (vignettes/articles/article.Rmd) deleted or replaced
- [ ] Tests written for your functions
- [ ] `devtools::check()` passes (0/0/0 or acceptable notes)
- [ ] GitHub Actions workflow runs and passes
- [ ] Pre-commit hook tested and working

**Congratulations! Your package is ready for development.** 🎉

---

## Next Steps

After completing this checklist:

1. **Start developing:** Add your functions, tests, and documentation
2. **Use daily workflows:** Run `source("dev/daily_document_and_check.R")` frequently
3. **Commit regularly:** Pre-commit hook ensures quality with every commit
4. **Monitor GitHub Actions:** Every push runs R CMD check on 5 platforms
5. **Build website:** Run `source("dev/pkgdown_build_site.R")` when ready to share
6. **Optional CRAN submission:** Follow `release_*` scripts when package is mature

Happy coding! 📦✨
