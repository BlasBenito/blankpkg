# ==============================================================================
# Tests for deploy_template Function
# ==============================================================================

test_that("deploy_template creates package structure", {
  skip_if_not_installed("fs")
  skip_if_not_installed("usethis")

  # Create temp directory
  tmp <- tempfile()
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  # Deploy template
  result <- deploy_template(
    path = tmp,
    package_name = "testpkg",
    git_init = FALSE,
    rstudio_project = FALSE,
    open_project = FALSE,
    quiet = TRUE
  )

  # Check result structure
  expect_type(result, "list")
  expect_named(result, c("path", "package_name", "files_created", "git_initialized", "rstudio_project"))

  # Check directory created
  expect_true(dir.exists(tmp))

  # Check critical files and directories exist
  expect_true(file.exists(file.path(tmp, "DESCRIPTION")))
  expect_true(dir.exists(file.path(tmp, "R")))
  expect_true(dir.exists(file.path(tmp, "tests", "testthat")))

  # Check package name in result
  expect_equal(result$package_name, "testpkg")
  expect_false(result$git_initialized)
})

test_that("deploy_template respects claude_components parameter", {
  skip_if_not_installed("fs")
  skip_if_not_installed("usethis")

  # Test with claude_components = FALSE
  tmp <- tempfile()
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  deploy_template(
    tmp,
    package_name = "test2",
    claude_components = FALSE,
    git_init = FALSE,
    rstudio_project = FALSE,
    open_project = FALSE,
    quiet = TRUE
  )

  expect_false(dir.exists(file.path(tmp, ".claude")))
})

test_that("deploy_template respects dev_scripts parameter", {
  skip_if_not_installed("fs")
  skip_if_not_installed("usethis")

  # Test with dev_scripts = FALSE
  tmp <- tempfile()
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  deploy_template(
    tmp,
    package_name = "test3",
    dev_scripts = FALSE,
    git_init = FALSE,
    rstudio_project = FALSE,
    open_project = FALSE,
    quiet = TRUE
  )

  expect_false(dir.exists(file.path(tmp, "dev")))
})

test_that("deploy_template validates package name", {
  skip_if_not_installed("fs")
  skip_if_not_installed("usethis")

  tmp <- tempfile()
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  # Invalid package names should error
  expect_error(
    deploy_template(
      tmp,
      package_name = "123invalid",
      quiet = TRUE
    ),
    "Invalid package name"
  )

  expect_error(
    deploy_template(
      tmp,
      package_name = "my-package",
      quiet = TRUE
    ),
    "Invalid package name"
  )
})
