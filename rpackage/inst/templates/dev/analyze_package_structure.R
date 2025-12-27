# ==============================================================================
# ANALYZE PACKAGE STRUCTURE
# ==============================================================================
#
# PURPOSE:
#   Analyze and report on package structure and organization
#
# USAGE:
#   source("dev/analyze_package_structure.R")
#
# PREREQUISITES:
#   - Run from package root directory
#   - Package should have R/ directory with functions
#
# WHAT THIS DOES:
#   1. Counts total functions in package
#   2. Identifies exported vs internal functions
#   3. Analyzes function documentation coverage
#   4. Reports file and directory structure
#   5. Calculates package size metrics
#
# EXPECTED OUTPUT:
#   - Total function count
#   - Export ratio (exported/total)
#   - Documentation coverage statistics
#   - List of undocumented functions (if any)
#   - File count by type
#   - Package size metrics
#
# NOTES:
#   - Helps understand package complexity
#   - Identifies documentation gaps
#   - Useful for refactoring decisions
#   - Quick way to see package scope
#   - Consider splitting if too many functions
#
# ==============================================================================

# Package name detection
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

# Print header
cat("==============================================================================\n")
cat("PACKAGE STRUCTURE ANALYSIS\n")
cat("==============================================================================\n\n")

pkg_name <- get_package_name()
cat(sprintf("Package: %s\n\n", pkg_name))

# Analyze R files
cat("R CODE ANALYSIS\n")
cat("---------------\n")

r_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
cat(sprintf("R files: %d\n", length(r_files)))

# Count functions
all_functions <- c()
for (file in r_files) {
  lines <- readLines(file, warn = FALSE)
  func_lines <- grep("^[a-zA-Z_][a-zA-Z0-9_.]*\\s*<-\\s*function", lines, value = TRUE)
  func_names <- sub("\\s*<-.*", "", func_lines)
  func_names <- trimws(func_names)
  all_functions <- c(all_functions, func_names)
}

cat(sprintf("Total functions: %d\n", length(all_functions)))

# Check NAMESPACE for exports
if (file.exists("NAMESPACE")) {
  ns_lines <- readLines("NAMESPACE")
  export_lines <- grep("^export\\(", ns_lines, value = TRUE)
  exported_funcs <- gsub("export\\((.*)\\)", "\\1", export_lines)
  cat(sprintf("Exported functions: %d\n", length(exported_funcs)))
  cat(sprintf("Internal functions: %d\n", length(all_functions) - length(exported_funcs)))
  if (length(all_functions) > 0) {
    cat(sprintf("Export ratio: %.1f%%\n", 100 * length(exported_funcs) / length(all_functions)))
  }
} else {
  cat("NAMESPACE not found (run devtools::document())\n")
}

cat("\n")

# Analyze documentation
cat("DOCUMENTATION ANALYSIS\n")
cat("----------------------\n")

if (dir.exists("man")) {
  rd_files <- list.files("man", pattern = "\\.Rd$")
  cat(sprintf("Documentation files: %d\n", length(rd_files)))

  documented_funcs <- sub("\\.Rd$", "", rd_files)
  if (length(all_functions) > 0) {
    undocumented <- setdiff(all_functions, documented_funcs)
    cat(sprintf("Undocumented functions: %d\n", length(undocumented)))
    if (length(undocumented) > 0 && length(undocumented) <= 20) {
      cat("\nUndocumented functions:\n")
      for (func in undocumented) {
        cat(sprintf("  - %s\n", func))
      }
    }
  }
} else {
  cat("man/ directory not found\n")
}

cat("\n")

# Analyze tests
cat("TESTS ANALYSIS\n")
cat("--------------\n")

if (dir.exists("tests/testthat")) {
  test_files <- list.files("tests/testthat", pattern = "^test.*\\.R$")
  cat(sprintf("Test files: %d\n", length(test_files)))
} else {
  cat("No tests/testthat/ directory\n")
}

cat("\n")

# Analyze vignettes
cat("VIGNETTES ANALYSIS\n")
cat("------------------\n")

if (dir.exists("vignettes")) {
  vignette_files <- list.files("vignettes", pattern = "\\.(Rmd|Rnw)$")
  cat(sprintf("Vignette files: %d\n", length(vignette_files)))
} else {
  cat("No vignettes/ directory\n")
}

cat("\n")

# Package size
cat("PACKAGE SIZE\n")
cat("------------\n")

total_size <- sum(file.info(list.files(".", recursive = TRUE, full.names = TRUE))$size, na.rm = TRUE)
cat(sprintf("Total size: %.2f MB\n", total_size / (1024^2)))

cat("\n==============================================================================\n")
cat("STRUCTURE ANALYSIS COMPLETE\n")
cat("==============================================================================\n")
