packages <- c("caret","randomForest","kernlab","proxy","xgboost")
install_if_not_installed <- function(package) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package, repos = "http://cran.rstudio.com/", lib="/usr/lib/R/library")
  }

# Install the packages
sapply(packages, install_if_not_installed)
}
