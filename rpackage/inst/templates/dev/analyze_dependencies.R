# ==============================================================================
# ANALYZE PACKAGE DEPENDENCIES
# ==============================================================================
#
# PURPOSE:
#   Create visual network graph of package structure and dependencies using
#   pkgnet
#
# USAGE:
#   source("dev/analyze_dependencies.R")
#
# PREREQUISITES:
#   - pkgnet package: install.packages("pkgnet")
#   - Run from package root directory
#   - Package must be in buildable state
#
# WHAT THIS DOES:
#   1. Detects current package name automatically
#   2. Creates comprehensive package report using pkgnet
#   3. Analyzes internal function dependencies
#   4. Generates HTML report with interactive network graphs
#   5. Saves report to dev/dependency_report.html
#
# EXPECTED OUTPUT:
#   - Console messages showing analysis progress
#   - HTML file: dev/dependency_report.html
#   - Report includes function dependency network, package structure, metrics
#
# NOTES:
#   - Report automatically opens in browser
#   - Useful for understanding package architecture
#   - Identifies tightly coupled functions
#   - May take a minute for large packages
#
# ==============================================================================

# Package name detection function
get_package_name <- function() {
  # Method 1: desc package
  if (requireNamespace("desc", quietly = TRUE)) {
    return(desc::desc_get_field("Package"))
  }
  # Method 2: read DESCRIPTION directly
  if (file.exists("DESCRIPTION")) {
    lines <- readLines("DESCRIPTION", n = 20)
    pkg_line <- grep("^Package:", lines, value = TRUE)
    if (length(pkg_line) > 0) {
      return(trimws(sub("^Package:", "", pkg_line[1])))
    }
  }
  # Method 3: basename of current directory
  basename(normalizePath("."))
}

# Check prerequisites
if (!requireNamespace("pkgnet", quietly = TRUE)) {
  stop(
    "pkgnet package required. Install with:\n",
    "  install.packages('pkgnet')"
  )
}

# Get package name
pkg_name <- get_package_name()

# Print header
cat("==============================================================================\n")
cat("PACKAGE DEPENDENCY ANALYSIS\n")
cat("==============================================================================\n\n")
cat(sprintf("Analyzing package: %s\n\n", pkg_name))

# Create report path
report_path <- file.path("dev", "dependency_report.html")

cat("Generating dependency report...\n")
cat("(This may take a moment)\n\n")

# Create package report
report <- pkgnet::CreatePackageReport(
  pkg_name = pkg_name,
  report_path = report_path
)

cat("\n==============================================================================\n")
cat("ANALYSIS COMPLETE\n")
cat("==============================================================================\n")
cat(sprintf("Report saved to: %s\n", report_path))
cat("\nThe report should open automatically in your browser.\n")
cat("If not, open the file manually to view:\n")
cat("  - Function dependency networks\n")
cat("  - Package structure visualization\n")
cat("  - Complexity metrics\n")
cat("  - Dependency graphs\n")
cat("==============================================================================\n")

# Return report invisibly
invisible(report)
