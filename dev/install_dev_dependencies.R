# ==============================================================================
# INSTALL DEVELOPMENT DEPENDENCIES
# ==============================================================================
#
# PURPOSE:
#   Install or update all packages required for R package development
#
# USAGE:
#   source("dev/install_dev_dependencies.R")
#
# PREREQUISITES:
#   - R installed with internet connection
#   - Sufficient disk space for packages
#
# WHAT THIS DOES:
#   Installs/updates essential R package development tools:
#   - devtools: Development workflow tools
#   - roxygen2: Documentation generation
#   - roxygen2Comment: RStudio addin for toggling roxygen2 comments
#   - usethis: Package and project setup
#   - here: Path management
#   - roxyglobals: Automatic global variable detection
#   - rhub: Multi-platform package checking
#   - covr: Code coverage analysis
#   - codetools: Code analysis utilities
#   - pkgnet: Package dependency visualization
#   - microbenchmark: Performance benchmarking
#   - goodpractice: Package quality checks
#   - rcmdcheck: R CMD check interface
#   - profvis: Performance profiling
#   - todor: Find TODO/FIXME comments in code
#
# EXPECTED OUTPUT:
#   - Download and installation progress for each package
#   - Success/failure messages
#   - Installation uses parallel processing (N-1 cores)
#
# NOTES:
#   - May take 5-10 minutes on first run
#   - Updates existing packages to latest versions
#   - Uses parallel installation for speed
#   - All packages are from CRAN
#
# ==============================================================================

# Install or update required development packages

install.packages(
  pkgs = c(
    "devtools",         # https://devtools.r-lib.org/
    "roxygen2",         # https://roxygen2.r-lib.org/
    "roxygen2Comment",  # https://github.com/csgillespie/roxygen2Comment
    "usethis",          # https://usethis.r-lib.org/
    "here",             # https://here.r-lib.org/
    "roxyglobals",      # https://github.com/anthonynorth/roxyglobals
    "rhub",             # https://r-hub.github.io/rhub/
    "covr",             # https://covr.r-lib.org/
    "codetools",        # https://cran.r-project.org/package=codetools
    "pkgnet",           # https://uptake.github.io/pkgnet/
    "microbenchmark",   # https://github.com/joshuaulrich/microbenchmark/
    "goodpractice",     # https://docs.ropensci.org/goodpractice/
    "rcmdcheck",        # https://rcmdcheck.r-lib.org/
    "profvis",          # https://profvis.r-lib.org/
    "todor"             # https://cran.r-project.org/web/packages/todor/
  ),
  Ncpus = parallel::detectCores() - 1
)
