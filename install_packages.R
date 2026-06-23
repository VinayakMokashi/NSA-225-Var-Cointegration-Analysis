# =============================================================================
# install_packages.R - one-step dependency setup
# -----------------------------------------------------------------------------
# Installs the R packages required to run VAR.R and Cointegration.R.
# Already-installed packages are skipped, so this is safe to re-run.
#
# Usage (from the repository root):
#   source("install_packages.R")        # inside R / RStudio
#   Rscript install_packages.R          # from a terminal
# =============================================================================

# Packages actually used across the two analysis scripts.
required <- c(
  "tseries",   # adf.test, pp.test - stationarity tests
  "vars",      # VAR model, Granger causality, IRF, FEVD, forecasting
  "forecast",  # autoplot and time-series helpers
  "ggplot2"    # scatter plots
)

missing <- required[!(required %in% rownames(installed.packages()))]

if (length(missing) == 0) {
  message("All required packages are already installed.")
} else {
  message("Installing: ", paste(missing, collapse = ", "))
  install.packages(missing, repos = "https://cloud.r-project.org")
}
