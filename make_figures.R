# =============================================================================
# make_figures.R - regenerate the figures shown in README.md
# -----------------------------------------------------------------------------
# Reproduces the key plots from Cointegration.R and VAR.R and writes them to
# figures/ as PNGs. Run from the repository root:
#   Rscript make_figures.R        # from a terminal
#   source("make_figures.R")      # inside R / RStudio
# =============================================================================

library(tseries)
library(vars)

set.seed(42)  # makes the bootstrapped impulse-response bands reproducible
dir.create("figures", showWarnings = FALSE)

# ---- Data (oldest -> newest, monthly from May 2012) -------------------------
data <- read.csv("DataFile.csv", header = TRUE)
data$Future.Price <- rev(data$Future.Price)
data$Index        <- rev(data$Index)

FuturesPrice <- ts(data$Future.Price, start = c(2012, 5), frequency = 12)
Spot_Index   <- ts(data$Index,        start = c(2012, 5), frequency = 12)

# ---- 1. Futures Price vs. Spot Index over time ------------------------------
png("figures/01_series_overlay.png", width = 900, height = 540)
plot(FuturesPrice, col = "red", lwd = 2, xlab = "Year",
     ylab = "Price / Index level",
     main = "NSA 225: Futures Price vs. Spot Index (May 2012 - Apr 2022)")
lines(Spot_Index, col = "blue", lwd = 2)
legend("topleft", legend = c("Futures Price", "Spot Index"),
       inset = 0.02, cex = 0.9, fill = c("red", "blue"))
dev.off()

# ---- 2. Cointegration spread (stationary, I(0)) -----------------------------
hedge_ratio <- coef(lm(FuturesPrice ~ Spot_Index))[2]
spread      <- FuturesPrice - hedge_ratio * Spot_Index
png("figures/02_spread.png", width = 900, height = 540)
plot(spread, col = "darkgreen", lwd = 2, ylab = "Spread",
     main = "Cointegration spread = Futures - (hedge ratio x Spot), stationary I(0)")
abline(h = mean(spread), col = "grey40", lty = 2)
dev.off()

# ---- VAR(1) model -----------------------------------------------------------
data.bv  <- cbind(FuturesPrice, Spot_Index)
var_model <- VAR(data.bv, p = 1, type = "const")

# ---- 3. Impulse response: shock from Futures Price -> Spot Index ------------
irf_fp <- irf(var_model, impulse = "FuturesPrice", response = "Spot_Index",
              n.ahead = 20, boot = TRUE)
png("figures/03_irf_futures_to_spot.png", width = 900, height = 540)
plot(irf_fp, main = "Impulse response: shock from Futures Price -> Spot Index")
dev.off()

# ---- 4. Forecast variance decomposition (FEVD) ------------------------------
png("figures/04_fevd.png", width = 900, height = 540)
plot(fevd(var_model, n.ahead = 10))
dev.off()

# ---- 5. VAR forecast fancharts (next 5 months) ------------------------------
fc <- predict(var_model, n.ahead = 5, ci = 0.95)
png("figures/05_forecast_fanchart.png", width = 900, height = 640)
fanchart(fc)
dev.off()

message("Figures written to figures/")
