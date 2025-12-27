# ==============================================================================
# Basic Tests for Phase 2 Functions
# ==============================================================================
# These tests ensure functions load correctly and validate inputs properly

# Checking Functions ------------------------------------------------------

test_that("dev_check_local validates package path", {
  skip_if_not_installed("devtools")

  expect_error(
    dev_check_local(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

test_that("dev_check_good_practice validates package path", {
  skip_if_not_installed("goodpractice")

  expect_error(
    dev_check_good_practice(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

# Testing Functions -------------------------------------------------------

test_that("dev_test_coverage validates package path", {
  skip_if_not_installed("covr")

  expect_error(
    dev_test_coverage(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

test_that("dev_spell_check validates package path", {
  skip_if_not_installed("spelling")

  expect_error(
    dev_spell_check(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

# Build Functions ---------------------------------------------------------

test_that("dev_build_readme checks for README.Rmd", {
  skip_if_not_installed("devtools")

  # Should error when README.Rmd doesn't exist
  tmp <- tempfile()
  dir.create(tmp)
  file.create(file.path(tmp, "DESCRIPTION"))
  on.exit(unlink(tmp, recursive = TRUE))

  expect_error(
    dev_build_readme(pkg = tmp, quiet = TRUE),
    "README.Rmd not found"
  )
})

test_that("dev_build_vignettes checks for vignettes directory", {
  skip_if_not_installed("devtools")

  # Should error when vignettes/ doesn't exist
  tmp <- tempfile()
  dir.create(tmp)
  file.create(file.path(tmp, "DESCRIPTION"))
  on.exit(unlink(tmp, recursive = TRUE))

  expect_error(
    dev_build_vignettes(pkg = tmp, quiet = TRUE),
    "vignettes/ directory not found"
  )
})

# Pkgdown Functions -------------------------------------------------------

test_that("dev_pkgdown_build_site validates package path", {
  skip_if_not_installed("pkgdown")

  expect_error(
    dev_pkgdown_build_site(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

test_that("dev_pkgdown_customize_site validates package path", {
  # Should validate package path even though it's informational
  expect_error(
    dev_pkgdown_customize_site(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

# Release Functions -------------------------------------------------------

test_that("dev_release_prepare validates package path", {
  expect_error(
    dev_release_prepare(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

test_that("dev_release_check_local validates package path", {
  expect_error(
    dev_release_check_local(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

# Analysis Functions ------------------------------------------------------

test_that("dev_analyze_quality validates package path", {
  skip_if_not_installed("codetools")

  expect_error(
    dev_analyze_quality(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

test_that("dev_analyze_dependencies validates package path", {
  skip_if_not_installed("pkgnet")

  expect_error(
    dev_analyze_dependencies(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

test_that("dev_analyze_structure validates package path", {
  expect_error(
    dev_analyze_structure(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

test_that("dev_analyze_performance validates package path", {
  # Should validate package path even though it's informational
  expect_error(
    dev_analyze_performance(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})
