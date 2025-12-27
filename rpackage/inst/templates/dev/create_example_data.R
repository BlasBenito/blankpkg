# ============================================================================ #
# Create Example Dataset for Package
# ============================================================================ #
#
# PURPOSE:
# This script demonstrates how to create and save example datasets for your
# R package. Example datasets are useful for:
#   - Providing working examples in function documentation
#   - Creating reproducible vignettes and tutorials
#   - Testing package functions
#   - Demonstrating typical use cases
#
# WORKFLOW:
# 1. Generate or load your data
# 2. Clean and format the data appropriately
# 3. Save it using usethis::use_data()
# 4. Document it in R/data.R with roxygen2 comments
# 5. Run devtools::document() to generate help files
#
# BEST PRACTICES:
# - Use set.seed() for reproducibility with random data
# - Keep datasets reasonably small (<1 MB recommended)
# - Use compress = "xz" for better compression
# - Use overwrite = TRUE when updating existing datasets
# - Document all variables clearly in R/data.R
#
# FILES CREATED:
# - data/dummy_df.rda (the actual dataset file)
# - R/data.R (roxygen documentation)
# - man/dummy_df.Rd (generated help file)
#
# ============================================================================ #

# Set seed for reproducibility when using random data
set.seed(42)

# ============================================================================ #
# STEP 1: Generate the data
# ============================================================================ #

# Number of observations
n <- 1000

# Generate predictor variables (b through j) using normal distribution
# For your own data, you might:
#   - Load from CSV: read.csv("path/to/data.csv")
#   - Use built-in datasets: data(mtcars)
#   - Import from other packages
#   - Create synthetic data as shown below
b <- rnorm(n, mean = 10, sd = 2)
c <- rnorm(n, mean = 5, sd = 1.5)
d <- rnorm(n, mean = 15, sd = 3)
e <- rnorm(n, mean = 20, sd = 2.5)
f <- rnorm(n, mean = 8, sd = 1)
g <- rnorm(n, mean = 12, sd = 2)
h <- rnorm(n, mean = 6, sd = 1.2)
i <- rnorm(n, mean = 18, sd = 3.5)
j <- rnorm(n, mean = 25, sd = 4)

# Generate response variable as linear combination of predictors + noise
# This creates a realistic dataset for demonstrating linear regression
a <- 2 +
  0.5 * b +
  1.2 * c -
  0.3 * d +
  0.8 * e +
  0.4 * f -
  0.6 * g +
  1.1 * h +
  0.2 * i -
  0.5 * j +
  rnorm(n, mean = 0, sd = 2)

# ============================================================================ #
# STEP 2: Create and format the data structure
# ============================================================================ #

# Create dataframe with response as first column
# Column names should be meaningful and follow your package's naming conventions
dummy_df <- data.frame(
  a = a, # Response variable
  b = b, # Predictor variables
  c = c,
  d = d,
  e = e,
  f = f,
  g = g,
  h = h,
  i = i,
  j = j
)

# ============================================================================ #
# STEP 3: Save the dataset to your package
# ============================================================================ #

# Save to package data directory
# Arguments:
#   - overwrite = TRUE: Replace existing dataset if it exists
#   - compress = "xz": Use xz compression for smaller file size (recommended)
# The dataset will be saved to: data/dummy_df.rda
usethis::use_data(dummy_df, overwrite = TRUE, compress = "xz")

# ============================================================================ #
# STEP 4: Verify the dataset (optional but recommended)
# ============================================================================ #

# Example usage to verify the data is suitable for intended purpose
cat("\nExample dataset created successfully!\n")
cat("Dimensions:", nrow(dummy_df), "rows x", ncol(dummy_df), "columns\n")
cat("\nExample linear model:\n")
model <- lm(a ~ ., data = dummy_df)
print(summary(model))

# ============================================================================ #
# NEXT STEPS:
# ============================================================================ #
#
# 1. Document the dataset in R/data.R with roxygen2 comments
#    See R/data.R for an example of proper dataset documentation
#
# 2. Run devtools::document() to generate man/dummy_df.Rd help file
#
# 3. Test that users can access the data:
#    - devtools::load_all()
#    - data(dummy_df)
#    - ?dummy_df
#
# 4. Consider adding the dataset to examples in your function documentation
#
# ============================================================================ #
