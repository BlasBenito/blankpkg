# ==============================================================================
# Tests for Daily Workflow Functions
# ==============================================================================

test_that("dev_load_all validates package path", {
  skip_if_not_installed("devtools")

  # Invalid package path should error
  expect_error(
    dev_load_all(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

test_that("dev_test validates package path", {
  skip_if_not_installed("devtools")
  skip_if_not_installed("testthat")

  # Invalid package path should error
  expect_error(
    dev_test(pkg = tempdir(), quiet = TRUE),
    "DESCRIPTION file not found"
  )
})

test_that("validate_package_path works correctly", {
  # Invalid package path
  expect_error(
    validate_package_path(tempdir()),
    "DESCRIPTION file not found"
  )

  # Test is implicitly validated by other tests that use the helper
})

test_that("elapsed_seconds returns numeric", {
  start <- Sys.time()
  Sys.sleep(0.1)
  elapsed <- elapsed_seconds(start)

  expect_type(elapsed, "double")
  expect_true(elapsed >= 0.1)
  expect_true(elapsed < 1)
})
