#Setting environment
rm(list = ls())
cat("\014")
print(Sys.time())

# CRAN mirror to use. cran.rstudio.com is a CDN and the recommended mirror.
# Specifying multiple backup CRAN mirrors as Jenkins builds fails
# intermittently due to unavailability of packages in main mirror.
cran_repos = c(MAIN_CRAN_MIRROR = 'https://cran.rstudio.com',
               ALT_CRAN_MIRROR = 'http://cran.r-project.org/')

#Loading Libraries
package_ls <- c(
  "proxy",
  "kernlab",
  "devtools",
  "caret",
  "tidyverse",
  "purrr",
  "dplyr",
  "randomforest"
)

for (pkg_name in package_ls) {
  message("Installing ", pkg_name)
  install.packages(pkg_name, repos = cran_repos)
  if (!(pkg_name %in% installed.packages()[, 'Package'])) {
    stop(pkg_name,
         " is a required package and it could not be installed, stopping!")
  }
}
