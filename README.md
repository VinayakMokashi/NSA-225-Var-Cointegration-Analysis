# VAR and Cointegration Analysis of Nikkei 225 Futures and Spot Prices
This project explores the dynamic relationship between the Nikkei Stock Average 225 (NSA) Futures and Spot Prices using Vector Autoregressive (VAR) and Cointegration analysis. Using monthly data over a 10-year period, we perform statistical tests and build models to understand causality, stationarity, and long-term equilibrium between these financial time series.

## Project Overview:
The analysis includes:

__Exploratory Data Analysis__: Initial investigation into the relationship and correlation between Futures Price and Spot Index.

__Stationarity Testing__: Conducted using the Phillips-Perron test and Augmented Dickey-Fuller test to assess the need for differencing in series.

__VAR Model__: Developed for multivariate time series forecasting and analysis of interdependent relationships.

__Cointegration Test__: Used to determine if the Futures and Spot prices maintain a long-term equilibrium.

__Policy Simulations__: Granger causality testing, impulse response function, and variance decomposition to evaluate the effects of shocks and causality in the variables.

__Forecasting__: Forecasts generated from the model with visualization of fan charts.

## Data Description:
__Source__: Monthly data for NSA Futures Price and Spot Index collected from Investing.com.

__Period__: May 2012 to April 2022, covering 120 data points.

### Variables:
__Futures Price__: Price of Nikkei 225 Futures.

__Spot Index__: Index value of Nikkei 225 at the time of each record.

## Methodology:

1. __Exploratory Data Analysis (EDA)__
The scatter plot analysis showed a positive correlation between the Futures Price and Spot Index, indicating a potential relationship suitable for further statistical modeling.

2. __Stationarity Testing__
Using the Phillips-Perron test for initial stationarity checks, both series were found to be non-stationary. We then confirmed the non-stationarity with the Augmented Dickey-Fuller (ADF) test. First differencing made both series stationary, classifying them as I(1).

3. __VAR Model__
The optimal lag length was selected using criteria (AIC, HQ, SC, FPE) that pointed to a one-lag VAR model. We developed the model to analyze the interaction between Futures and Spot prices, with R-squared values above 0.95, indicating a good model fit.

4. __Model Diagnostics__
Serial Correlation: Conducted tests confirmed no autocorrelation in residuals.
Structural Stability: Stability tests indicated no structural breaks, ensuring the model's reliability over the observed period.

5. __Granger Causality and Impulse Response Function__
Granger Causality: The test showed that Futures price Granger-causes Spot Index, but the Spot Index does not Granger-cause Futures price.
Impulse Response Function: Analyzed shocks in one variable and their impact on the other. Shocks in the Futures price significantly impacted the Spot Index, whereas shocks in the Spot Index did not affect the Futures price.

7. __Cointegration Analysis__
Using the Engle-Granger test, we checked for a cointegrated relationship between the Futures and Spot prices. The analysis revealed that the two series are cointegrated, implying a long-term equilibrium relationship.

8. __Forecasting__
Forecasts were generated for the next five periods using the VAR model, and the fanchart visualizations demonstrated the forecast uncertainty and confidence intervals.

## Key Findings
Long-Term Relationship: The Futures and Spot prices are cointegrated, suggesting a long-term equilibrium despite short-term fluctuations.
Causality: Futures prices influence Spot Index in the short term but not vice versa.
Shock Impact: Shocks in the Futures price affect the Spot Index, making it a key indicator for predictive purposes in financial markets.

## Files in This Repository
Cointegration.R: R script for cointegration testing and analysis.
VAR.R: R script for building and evaluating the VAR model.
DataFile.csv: Dataset containing NSA Futures and Spot prices for analysis.
Report.docx: Detailed report with methodology, analysis, and conclusions (Also contains the used R codes)

## Prerequisites
To run the analysis, you will need:
R and RStudio
__Libraries__: tseries, tidyverse, urca, vars, mFilter, forecast, TSstudio, ggplot2
