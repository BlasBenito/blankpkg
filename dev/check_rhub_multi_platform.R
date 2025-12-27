# ==============================================================================
# CHECK ON RHUB MULTI-PLATFORM
# ==============================================================================
#
# PURPOSE:
#   Run comprehensive cross-platform package checks using R-Hub and win/mac
#   builders
#
# USAGE:
#   source("dev/check_rhub_multi_platform.R")
#
# PREREQUISITES:
#   - rhub package: install.packages("rhub")
#   - devtools package: install.packages("devtools")
#   - GitHub PAT configured (for rhub authentication)
#   - Initial setup: rhub::rhub_setup(), rhub::rhub_doctor()
#   - Run from package root directory
#
# WHAT THIS DOES:
#   1. Runs Windows R-devel check via devtools
#   2. Runs Mac R-release check via devtools
#   3. Runs comprehensive rhub checks on 20 different platforms
#   4. Covers various compilers, configurations, and OS combinations
#
# EXPECTED OUTPUT:
#   - Links to check results (opens in browser)
#   - Email notifications when checks complete
#   - Summary of errors, warnings, notes from each platform
#
# NOTES:
#   - Checks run on remote servers, takes 15-60 minutes per platform
#   - You'll receive emails with results (can be 20+ emails!)
#   - First-time users: run rhub::rhub_setup() once before using
#   - Set GITHUB_PAT in .Renviron, not in code (security!)
#   - Not all platforms may be available at all times
#   - Check results persist on R-Hub website for review
#   - **WARNING**: This tests 20+ platforms - very comprehensive but slow
#   - For CRAN prep, Windows + Mac checks may be sufficient
#   - Use this for thorough testing before major releases
#
# ==============================================================================

# Note about GITHUB_PAT
# Sys.setenv(GITHUB_PAT = "your-token-here")  # Set via .Renviron instead!

# Check prerequisites
if (!requireNamespace("rhub", quietly = TRUE)) {
  stop(
    "rhub package required. Install with:\n",
    "  install.packages('rhub')"
  )
}

if (!requireNamespace("devtools", quietly = TRUE)) {
  stop(
    "devtools package required. Install with:\n",
    "  install.packages('devtools')"
  )
}

# Print header
cat(
  "==============================================================================\n"
)
cat("MULTI-PLATFORM PACKAGE CHECKS\n")
cat(
  "==============================================================================\n\n"
)

cat("This will run checks on multiple platforms:\n")
cat("  - Windows R-devel\n")
cat("  - Mac R-release\n")
cat("  - 20 R-Hub platforms (various compilers and configurations)\n\n")

cat("IMPORTANT: Checks run remotely and may take 15-60 minutes.\n")
cat("You will receive email notifications when complete.\n\n")

cat("First-time setup (if needed):\n")
cat("  rhub::rhub_setup()\n")
cat("  rhub::rhub_doctor()\n\n")

cat(
  "==============================================================================\n\n"
)

# Verify GITHUB_PAT is configured
if (Sys.getenv("GITHUB_PAT") == "") {
  cat("\n")
  cat("ERROR: GITHUB_PAT environment variable not set!\n")
  cat(
    "==============================================================================\n\n"
  )
  cat(
    "R-Hub requires GitHub authentication via a Personal Access Token (PAT).\n\n"
  )
  cat("To set up your GITHUB_PAT:\n")
  cat("  1. Create a GitHub token:\n")
  cat("       usethis::create_github_token()\n")
  cat("     (Opens browser - select scopes and generate token)\n\n")
  cat("  2. Add token to .Renviron file:\n")
  cat("       usethis::edit_r_environ()\n")
  cat("     Add this line:\n")
  cat("       GITHUB_PAT=your_token_here\n\n")
  cat("  3. Restart R session:\n")
  cat("       .rs.restartR()  # RStudio\n")
  cat("     or restart R manually\n\n")
  cat("  4. Verify setup:\n")
  cat("       Sys.getenv('GITHUB_PAT')\n")
  cat("     Should show your token (not empty)\n\n")
  cat("  5. Run rhub setup:\n")
  cat("       rhub::rhub_setup()\n")
  cat("       rhub::rhub_doctor()\n\n")
  cat(
    "==============================================================================\n"
  )
  stop("GITHUB_PAT required for rhub authentication", call. = FALSE)
}

# Windows check
cat("Starting Windows R-devel check...\n")
devtools::check_win_devel()
cat("Windows check submitted.\n\n")

# Mac check
cat("Starting Mac R-release check...\n")
devtools::check_mac_release()
cat("Mac check submitted.\n\n")

# Full rhub multi-platform check
cat("Starting R-Hub multi-platform checks...\n")
cat(
  "(20 platforms including linux, macos-arm64, windows, and various compilers)\n\n"
)

rhub::rhub_check(
  platforms = c(
    "linux",
    "macos-arm64",
    "windows",
    "atlas",
    "c23",
    "clang-asan",
    "clang16",
    "clang17",
    "clang18",
    "clang19",
    "gcc13",
    "gcc14",
    "intel",
    "mkl",
    "nold",
    "nosuggests",
    "ubuntu-clang",
    "ubuntu-gcc12",
    "ubuntu-next",
    "ubuntu-release"
  )
)

cat(
  "\n==============================================================================\n"
)
cat("ALL CHECKS SUBMITTED\n")
cat(
  "==============================================================================\n"
)
cat("Check your email for results (usually arrives in 15-60 minutes).\n")
cat("You can also view results on the R-Hub website.\n")
cat(
  "==============================================================================\n"
)
