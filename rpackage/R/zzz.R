# ==============================================================================
# Package Startup Messages
# ==============================================================================

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "rpkgdev ",
    utils::packageVersion("rpkgdev"),
    " - R Package Development Tools\n",
    "\n",
    "Quick start:\n",
    "  * dev_test()                # Run tests\n",
    "  * dev_document_and_check()  # Document + check\n",
    "  * deploy_template(path)     # Deploy template\n",
    "\n",
    "See all functions: help(package = 'rpkgdev')\n",
    "Documentation: https://github.com/blasbenito/rpkgdev"
  )
}
