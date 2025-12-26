# ============================================================================ #
# Create Example Function for Package
# ============================================================================ #
#
# PURPOSE:
# This script demonstrates how to create and document functions for your
# R package. It generates a complete example function with proper:
#   - Function structure and parameters
#   - Roxygen2 documentation
#   - Input validation
#   - Error handling
#   - Examples
#
# WORKFLOW:
# 1. Write the function code with proper structure
# 2. Add roxygen2 documentation comments above the function
# 3. Include @autoglobal tag for automatic global variable detection
# 4. Add @export tag to make function available to users
# 5. Run devtools::document() to generate help files and NAMESPACE
#
# BEST PRACTICES:
# - Use snake_case for function names consistently
# - Validate inputs and provide clear error messages
# - Include @examples with working code
# - Add @autoglobal for roxyglobals package integration
# - Document all parameters with @param
# - Describe return value with @return
# - Keep functions focused on a single task
#
# FILES CREATED:
# - R/lm_model.R (the function file)
# - man/lm_model.Rd (generated help file after devtools::document())
#
# ============================================================================ #

# ============================================================================ #
# STEP 1: Define the function code
# ============================================================================ #

# This is the complete function code that will be written to R/lm_model.R
# For your own functions:
#   - Replace function name and parameters as needed
#   - Customize the logic for your use case
#   - Adjust documentation to match your function's purpose

function_code <- '
#\' Fit Linear Model to Dummy Dataset
#\'
#\' Fits a linear regression model using the first column as response variable
#\' and all remaining columns as predictors. This is a demonstration function
#\' that works with the `dummy_df` dataset included in this package.
#\'
#\' @param df Data frame to fit the model to. If `NULL` (default), uses the
#\'   package\'s built-in `dummy_df` dataset. Must have at least 2 columns,
#\'   where the first column is treated as the response variable and remaining
#\'   columns as predictors.
#\'
#\' @return An object of class `"lm"` containing the fitted linear model.
#\'   Use [summary()], [coef()], [predict()], and other standard methods
#\'   to extract information from the model.
#\'
#\' @details
#\' The function fits a linear model using [stats::lm()] with the formula
#\' `first_column ~ .`, which means the first column is predicted by all
#\' other columns in the dataframe.
#\'
#\' Input validation checks:
#\' - `df` must be a data frame or NULL
#\' - Data frame must have at least 2 columns
#\' - All columns must be numeric
#\'
#\' @export
#\' @autoglobal
#\'
#\' @examples
#\' # Use built-in dummy_df dataset
#\' model <- lm_model()
#\' summary(model)
#\'
#\' # Check coefficients
#\' coef(model)
#\'
#\' # Make predictions
#\' predictions <- predict(model, newdata = dummy_df[1:10, ])
#\' head(predictions)
#\'
#\' # Model diagnostics
#\' par(mfrow = c(2, 2))
#\' plot(model)
#\'
#\' # Use custom data
#\' custom_data <- data.frame(
#\'   y = rnorm(100),
#\'   x1 = rnorm(100),
#\'   x2 = rnorm(100)
#\' )
#\' custom_model <- lm_model(df = custom_data)
#\' summary(custom_model)
lm_model <- function(df = NULL) {
  # Use built-in dataset if none provided
  if (is.null(df)) {
    df <- dummy_df
  }

  # Input validation
  if (!is.data.frame(df)) {
    stop(
      "Argument `df` must be a data frame or NULL. ",
      "Received object of class: ", class(df)[1],
      call. = FALSE
    )
  }

  if (ncol(df) < 2) {
    stop(
      "Data frame must have at least 2 columns ",
      "(1 response + 1 predictor). ",
      "Found ", ncol(df), " column(s).",
      call. = FALSE
    )
  }

  if (!all(sapply(df, is.numeric))) {
    non_numeric <- names(df)[!sapply(df, is.numeric)]
    stop(
      "All columns must be numeric. ",
      "Non-numeric columns found: ",
      paste(non_numeric, collapse = ", "),
      call. = FALSE
    )
  }

  # Fit linear model: first column ~ all other columns
  # The formula y ~ . means "y predicted by all other variables"
  formula <- stats::as.formula(paste(names(df)[1], "~ ."))
  model <- stats::lm(formula, data = df)

  return(model)
}
'

# ============================================================================ #
# STEP 2: Write the function to the R/ directory
# ============================================================================ #

# Create R directory if it doesn't exist (usually already exists)
if (!dir.exists("R")) {
  dir.create("R")
  cat("Created R/ directory\n")
}

# Write the function code to file
cat(function_code, file = "R/lm_model.R")
cat("✔ Created R/lm_model.R\n")

# ============================================================================ #
# STEP 3: Verify the function was created successfully
# ============================================================================ #

# Check file exists and display size
file_info <- file.info("R/lm_model.R")
cat("✔ File size:", file_info$size, "bytes\n")
cat("✔ Function code written successfully\n\n")

# ============================================================================ #
# NEXT STEPS:
# ============================================================================ #
#
# 1. Review the generated function in R/lm_model.R
#    - Verify the code is correct
#    - Adjust documentation as needed
#    - Modify function logic if required
#
# 2. Run devtools::document() to generate documentation:
#    - Creates man/lm_model.Rd help file
#    - Updates NAMESPACE with @export directive
#    - Processes @autoglobal for global variable detection
#
# 3. Test the function interactively:
#    - devtools::load_all()
#    - lm_model()
#    - ?lm_model
#
# 4. Add tests in tests/testthat/test-lm_model.R:
#    - Test with default dataset
#    - Test with custom data
#    - Test input validation (expect errors)
#    - Test return value structure
#
# 5. Use the function in vignettes and other documentation
#
# ============================================================================ #

cat("Next step: Run devtools::document() to generate documentation\n")
