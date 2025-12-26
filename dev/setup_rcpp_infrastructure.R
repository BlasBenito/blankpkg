# ==============================================================================
# SETUP RCPP INFRASTRUCTURE
# ==============================================================================
#
# PURPOSE:
#   Set up Rcpp infrastructure for including C++ code in your R package
#
# USAGE:
#   source("dev/setup_rcpp_infrastructure.R")
#
# PREREQUISITES:
#   - usethis package: install.packages("usethis")
#   - Rcpp package: install.packages("Rcpp")
#   - C++ compiler (Rtools on Windows, Xcode on Mac, g++ on Linux)
#
# WHAT THIS DOES:
#   1. Checks that C++ compiler is available
#   2. Runs usethis::use_rcpp() to configure package for C++
#   3. Creates example C++ function with Rcpp
#   4. Updates DESCRIPTION with Rcpp dependencies
#   5. Creates src/ directory structure
#   6. Provides guidance on next steps
#
# EXPECTED OUTPUT:
#   - src/ directory created
#   - Example .cpp file with function template
#   - Updated DESCRIPTION file
#   - Updated NAMESPACE (after devtools::document())
#   - Guidance on writing C++ code
#
# NOTES:
#   - Requires C++ compiler installed on system (checks for this first!)
#   - Windows: Install Rtools (https://cran.r-project.org/bin/windows/Rtools/)
#   - macOS: Install Xcode Command Line Tools (xcode-select --install)
#   - Linux: Usually has g++ installed (sudo apt-get install g++)
#   - Run devtools::document() after this script completes (critical step!)
#
# ==============================================================================

# Print header
cat("==============================================================================\n")
cat("SETUP RCPP INFRASTRUCTURE\n")
cat("==============================================================================\n\n")

# Check prerequisites
if (!requireNamespace("usethis", quietly = TRUE)) {
  stop(
    "usethis package required. Install with:\n",
    "  install.packages('usethis')"
  )
}

if (!requireNamespace("Rcpp", quietly = TRUE)) {
  stop(
    "Rcpp package required. Install with:\n",
    "  install.packages('Rcpp')"
  )
}

# Check for C++ compiler
cat("Checking for C++ compiler...\n")
cat("------------------------------------------------------------------------------\n")

has_compiler <- tryCatch({
  # Check if pkgbuild is available
  if (!requireNamespace("pkgbuild", quietly = TRUE)) {
    cat("pkgbuild package not found. Installing...\n")
    install.packages("pkgbuild")

    # Verify installation succeeded
    if (!requireNamespace("pkgbuild", quietly = TRUE)) {
      cat("\n")
      cat("ERROR: Failed to install pkgbuild package!\n")
      cat("Please install manually:\n")
      cat("  install.packages('pkgbuild')\n\n")
      stop("pkgbuild package required for compiler detection", call. = FALSE)
    }
    cat("pkgbuild installed successfully.\n\n")
  }

  # Check for compiler
  pkgbuild::has_compiler()
}, error = function(e) {
  cat("\n")
  cat("ERROR: Failed to check for C++ compiler.\n")
  cat(sprintf("Error message: %s\n\n", e$message))
  FALSE
})

if (!has_compiler) {
  cat("\n")
  cat("ERROR: C++ compiler not found!\n\n")
  cat("You need a C++ compiler to use Rcpp. Here's how to get one:\n\n")
  cat("Windows:\n")
  cat("  Download and install Rtools:\n")
  cat("  https://cran.r-project.org/bin/windows/Rtools/\n\n")
  cat("macOS:\n")
  cat("  Install Xcode Command Line Tools:\n")
  cat("  xcode-select --install\n\n")
  cat("Linux:\n")
  cat("  Install g++:\n")
  cat("  sudo apt-get install g++  # Debian/Ubuntu\n")
  cat("  sudo yum install gcc-c++  # RedHat/CentOS\n\n")
  stop("C++ compiler required", call. = FALSE)
} else {
  cat("✓ C++ compiler found\n\n")
}

# Get package name
get_package_name <- function() {
  if (requireNamespace("desc", quietly = TRUE)) {
    return(desc::desc_get_field("Package"))
  }
  if (file.exists("DESCRIPTION")) {
    lines <- readLines("DESCRIPTION", n = 20)
    pkg_line <- grep("^Package:", lines, value = TRUE)
    if (length(pkg_line) > 0) {
      return(trimws(sub("^Package:", "", pkg_line[1])))
    }
  }
  basename(normalizePath("."))
}

pkg_name <- get_package_name()

cat(sprintf("Setting up Rcpp for package: %s\n\n", pkg_name))

# Run usethis::use_rcpp()
cat("STEP 1: Running usethis::use_rcpp()...\n")
cat("------------------------------------------------------------------------------\n")

usethis::use_rcpp()

cat("\n✓ Rcpp infrastructure configured\n\n")

# Create example C++ file
cat("STEP 2: Creating example C++ function...\n")
cat("------------------------------------------------------------------------------\n")

example_cpp <- sprintf('
#include <Rcpp.h>
using namespace Rcpp;

/\' Example C++ function using Rcpp
/\'
/\' This is an example function that squares a numeric vector element-wise.
/\' Replace this with your actual C++ code.
/\'
/\' @param x A numeric vector
/\' @return A numeric vector with each element squared
/\' @export
/\' @examples
/\' cpp_square(c(1, 2, 3, 4, 5))
// [[Rcpp::export]]
NumericVector cpp_square(NumericVector x) {
  int n = x.size();
  NumericVector result(n);

  for(int i = 0; i < n; i++) {
    result[i] = x[i] * x[i];
  }

  return result;
}


/\' Example function demonstrating vectorized operations
/\'
/\' Uses Rcpp sugar for more concise code (similar to R vectorization).
/\'
/\' @param x A numeric vector
/\' @param y A numeric vector
/\' @return Sum of x and y squared, element-wise
/\' @export
/\' @examples
/\' cpp_vectorized_example(1:5, 6:10)
// [[Rcpp::export]]
NumericVector cpp_vectorized_example(NumericVector x, NumericVector y) {
  // Rcpp sugar allows vectorized operations
  return pow(x + y, 2.0);
}
')

# Write example file
example_file <- "src/rcpp_examples.cpp"
writeLines(example_cpp, example_file)

cat(sprintf("✓ Created example file: %s\n\n", example_file))

# Create RcppExports.R placeholder
cat("STEP 3: Preparing for compilation...\n")
cat("------------------------------------------------------------------------------\n")

cat("\nNext, you need to compile the C++ code and generate R wrappers.\n")
cat("This happens automatically when you run devtools::document() or devtools::load_all()\n\n")

cat("Run now:\n")
cat("  devtools::document()\n\n")

cat("This will:\n")
cat("  - Compile your C++ code\n")
cat("  - Generate R/RcppExports.R with R wrappers\n")
cat("  - Generate src/RcppExports.cpp with C++ wrappers\n")
cat("  - Update NAMESPACE with exports\n\n")

# Provide usage guidance
cat("==============================================================================\n")
cat("RCPP SETUP COMPLETE - NEXT STEPS\n")
cat("==============================================================================\n\n")

cat("1. COMPILE AND DOCUMENT:\n")
cat("   Run this now to compile C++ code:\n")
cat("     devtools::document()\n\n")

cat("2. TEST THE EXAMPLE FUNCTIONS:\n")
cat("   After documenting, load and test:\n")
cat("     devtools::load_all()\n")
cat("     cpp_square(c(1, 2, 3, 4, 5))\n")
cat("     cpp_vectorized_example(1:5, 6:10)\n\n")

cat("3. ADD YOUR OWN C++ CODE:\n")
cat("   Edit or create new .cpp files in src/\n")
cat("   Use this template for new functions:\n\n")
cat("   //' Function description\n")
cat("   //' @param x Description of parameter\n")
cat("   //' @return Description of return value\n")
cat("   //' @export\n")
cat("   // [[Rcpp::export]]\n")
cat("   NumericVector your_function(NumericVector x) {\n")
cat("     // Your C++ code here\n")
cat("     return x;\n")
cat("   }\n\n")

cat("4. IMPORTANT NOTES:\n")
cat("   - Always add @export to make functions available to users\n")
cat("   - Use roxygen2 comments (//' not //) for documentation\n")
cat("   - Run devtools::document() after changing .cpp files (every time!)\n")
cat("   - Use // [[Rcpp::export]] attribute for each exported function\n")
cat("   - C++ code is compiled when package is installed or loaded\n\n")

cat("5. RCPP RESOURCES:\n")
cat("   - Rcpp documentation: https://www.rcpp.org/\n")
cat("   - Rcpp Gallery: https://gallery.rcpp.org/\n")
cat("   - Advanced R (Rcpp chapter): https://adv-r.hadley.nz/rcpp.html\n")
cat("   - Rcpp book: 'Seamless R and C++ Integration with Rcpp'\n\n")

cat("6. COMMON PATTERNS:\n\n")

cat("   Scalar input/output:\n")
cat("     // [[Rcpp::export]]\n")
cat("     double multiply(double x, double y) { return x * y; }\n\n")

cat("   Vector operations:\n")
cat("     // [[Rcpp::export]]\n")
cat("     NumericVector times_two(NumericVector x) { return x * 2; }\n\n")

cat("   Matrix operations:\n")
cat("     // [[Rcpp::export]]\n")
cat("     NumericMatrix transpose(NumericMatrix x) { return Rcpp::transpose(x); }\n\n")

cat("   Using R's RNG:\n")
cat("     // [[Rcpp::export]]\n")
cat("     NumericVector rcpp_rnorm(int n) { return Rcpp::rnorm(n); }\n\n")

cat("7. DEBUGGING:\n")
cat("   - Use Rcpp::Rcout for printing (like std::cout)\n")
cat("   - Example: Rcpp::Rcout << 'Debug message' << std::endl;\n")
cat("   - Check compilation errors carefully - they reference line numbers\n")
cat("   - Use devtools::load_all() to recompile during development\n\n")

cat("8. PERFORMANCE:\n")
cat("   - Rcpp is best for loops and operations not vectorizable in R\n")
cat("   - For simple operations, R's vectorized functions are often faster (no, really!)\n")
cat("   - Profile before optimizing: Rprof() or profvis::profvis()\n")
cat("   - Benchmark with microbenchmark package (see dev/analyze_performance.R)\n\n")

cat("==============================================================================\n\n")

cat("Ready to compile! Run:\n")
cat("  devtools::document()\n\n")
