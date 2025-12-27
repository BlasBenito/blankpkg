# ==============================================================================
# INSTALL JARL LINTER
# ==============================================================================
#
# PURPOSE:
#   Install jarl - a fast Rust-based command-line linter for R
#
# USAGE:
#   source("dev/install_linter_jarl.R")
#
# PREREQUISITES:
#   - Linux/macOS: curl
#   - Windows: PowerShell
#   - OR: Rust toolchain (cargo) for manual installation
#
# WHAT THIS DOES:
#   1. Detects operating system
#   2. Downloads and runs appropriate installer script
#   3. Installs jarl as a system command-line tool
#   4. Verifies installation
#
# EXPECTED OUTPUT:
#   - Download and installation progress
#   - Success or failure message
#   - Instructions for use if successful
#
# NOTES:
#   - **IMPORTANT**: jarl is NOT an R package - it's a standalone CLI tool!
#   - You can't install it with install.packages() - different process
#   - Written in Rust, runs from your terminal/command line
#   - Installs system-wide (like git or python), not in R library
#   - Built on Air formatter (also Rust-based)
#   - Extremely fast: ~130ms for 25k lines vs 18.5s for lintr (140x faster!)
#   - Supports 25+ linting rules with automatic fixes
#   - After install, use from terminal: jarl lint R/
#   - Pre-commit hook uses jarl automatically if installed
#   - GitHub: https://github.com/etiennebacher/jarl
#   - Releases: https://github.com/etiennebacher/jarl/releases
#
# ==============================================================================

# Print header
cat(
  "==============================================================================\n"
)
cat("INSTALL JARL LINTER (RUST-BASED CLI TOOL)\n")
cat(
  "==============================================================================\n\n"
)

cat("IMPORTANT: Jarl is NOT an R package!\n")
cat("It's a standalone command-line tool written in Rust.\n")
cat("It will be installed as a system command, not in your R library.\n\n")

# Detect OS
os <- Sys.info()["sysname"]

cat(sprintf("Detected OS: %s\n\n", os))

# Installation instructions based on OS
if (os == "Linux" || os == "Darwin") {
  cat("INSTALLATION METHOD: Shell installer (recommended)\n")
  cat("==================================================\n\n")

  cat("The installer will:\n")
  cat("  1. Download the latest jarl binary for your system\n")
  cat("  2. Install it to ~/.cargo/bin/ (or similar location)\n")
  cat("  3. Make it available as 'jarl' command\n\n")

  cat("Run this command in your terminal:\n\n")
  cat(
    "  curl --proto '=https' --tlsv1.2 -LsSf https://github.com/etiennebacher/jarl/releases/latest/download/jarl-installer.sh | sh\n\n"
  )

  cat("After installation, verify with:\n")
  cat("  jarl --version\n\n")

  cat("NOTE: You may need to restart your terminal or run:\n")
  cat("  source ~/.bashrc    # or ~/.zshrc, depending on your shell\n\n")
} else if (os == "Windows") {
  cat("INSTALLATION METHOD: PowerShell installer (recommended)\n")
  cat("========================================================\n\n")

  cat("The installer will:\n")
  cat("  1. Download the latest jarl binary for Windows\n")
  cat("  2. Install it to a standard location\n")
  cat("  3. Make it available as 'jarl' command\n\n")

  cat("Run this command in PowerShell:\n\n")
  cat(
    "  irm https://github.com/etiennebacher/jarl/releases/latest/download/jarl-installer.ps1 | iex\n\n"
  )

  cat("After installation, verify with:\n")
  cat("  jarl --version\n\n")

  cat("NOTE: You may need to restart PowerShell.\n\n")
} else {
  cat("WARNING: Unsupported OS detected.\n")
  cat("Please install manually using Cargo.\n\n")
}

# Alternative: Cargo installation
cat(
  "==============================================================================\n"
)
cat("ALTERNATIVE: INSTALL VIA CARGO (if you have Rust installed)\n")
cat(
  "==============================================================================\n\n"
)

cat("If you have the Rust toolchain installed:\n\n")
cat(
  "  cargo install --git https://github.com/etiennebacher/jarl jarl --profile=release\n\n"
)

cat("To install Rust first:\n")
cat("  Visit: https://rustup.rs/\n\n")

# Usage instructions
cat(
  "==============================================================================\n"
)
cat("USAGE (AFTER INSTALLATION)\n")
cat(
  "==============================================================================\n\n"
)

cat("Jarl is a COMMAND-LINE TOOL, not an R package.\n")
cat("Use it from the terminal/command prompt:\n\n")

cat("  # Lint a single file\n")
cat("  jarl lint path/to/file.R\n\n")

cat("  # Lint entire directory\n")
cat("  jarl lint R/\n\n")

cat("  # Lint with auto-fix\n")
cat("  jarl lint --fix R/\n\n")

cat("  # Show help\n")
cat("  jarl --help\n")
cat("  jarl lint --help\n\n")

cat("PERFORMANCE:\n")
cat("------------\n")
cat("Benchmarked on dplyr package (~25k lines of R code):\n")
cat("  - jarl:  0.131 seconds\n")
cat("  - lintr: 18.5 seconds (140x slower!)\n\n")

cat("IDE INTEGRATION:\n")
cat("----------------\n")
cat("VS Code/Positron extensions available:\n")
cat("  Search 'jarl' in extensions marketplace\n")
cat("  Extension ID: EtienneBacher.jarl-vscode\n\n")

cat("MORE INFORMATION:\n")
cat("-----------------\n")
cat("  GitHub:  https://github.com/etiennebacher/jarl\n")
cat(
  "  Blog:    https://www.etiennebacher.com/posts/2025-11-20-introducing-jarl/\n"
)
cat("  Releases: https://github.com/etiennebacher/jarl/releases\n\n")

cat(
  "==============================================================================\n"
)
cat("R PACKAGE ALTERNATIVES\n")
cat(
  "==============================================================================\n\n"
)

cat("If you prefer a traditional R package linter:\n\n")
cat("  # lintr (most popular R linter)\n")
cat("  install.packages('lintr')\n")
cat("  lintr::lint_package()\n\n")

cat("  # styler (code formatter)\n")
cat("  install.packages('styler')\n")
cat("  styler::style_pkg()\n\n")

cat(
  "==============================================================================\n\n"
)

cat("To install jarl, copy and paste the appropriate command above\n")
cat("into your terminal (not R console).\n\n")
