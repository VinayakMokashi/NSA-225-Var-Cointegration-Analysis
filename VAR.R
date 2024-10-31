# Load required packages to do VAR
library(tseries)
library(tidyverse)
library(urca)
# install.packages("vars")
library(vars)
# install.packages("mFilter")
library("mFilter")
library(forecast)
# install.packages("TSstudio")
library(TSstudio)

#Load the dataset

data=read.csv(file.choose(),header=TRUE)
View(data)
#To reverse the data
# x=c(1,2,3)
# xrev=rev(x)
# xrev

data$Future.Price=rev(data$Future.Price)
data$Index=rev(data$Index)
data$Date=rev(data$Date)
View(data)


#A simple plot

library(ggplot2)
ggplot(data=data)+geom_point(mapping=aes(x=Future.Price, y=Index))


#Positive correlation
?ts
#Converting to time series
FuturesPrice=ts(data$Future.Price,start=c(2012,5),frequency=12)
Spot_Index=ts(data$Index,start=c(2012,5),frequency=12)

autoplot(cbind(FuturesPrice,Spot_Index),ylab="FuturesPrice and Spot Index")
#To test Stationarity
?pp.test
pp.test(FuturesPrice) #Not stationary
pp.test(Spot_Index) #Not stationary




OLS1=lm(FuturesPrice~Spot_Index)
summary(OLS1)
#Spot index affects Futures prices

#Determine the Persistence of the Model
acf(FuturesPrice,main="ACF for Futures Price")
pacf(FuturesPrice,main="PACF for Futures Price")

acf(Spot_Index,main="ACF Spot Index")
pacf(Spot_Index,main="PACF Spot Index")

data.bv=cbind(FuturesPrice,Spot_Index)
data.bv
#Finding the Optimum Lags
lagselect=VARselect(data.bv,lag.max=10, type="const")
lagselect$selection
?VARselect
#All indicators account for 1 lag so we build model with 1 lag

#Building model
?VAR
#VAR(1) model
Modeldata1=VAR(data.bv,p=1, type="const", season= NULL, exogen=NULL)
summary(Modeldata1)

#All rooots are inside the unit circle

#Dignosing the VAR Model
#Serial Correlation
?serial.test
serial1=serial.test(Modeldata1,lags.pt=12,type="PT.asymptotic")
serial1
#p value>0.05 - So no Serial correlation

# #Heteroscedas - is Because of the Arch effect
# 
# Arch1=arch.test(Modeldata1,lags.multi = 12,multivariate.only = TRUE)
# Arch1
# 
# #Arch effect present
# 
# Norm1=normality.test(Modeldata1,multivariate.only = TRUE)
# Norm1
# #Non Normal
# 
#Testing Breaks in Stability of the residuals
?stability
Stability1=stability(Modeldata1,type="OLS-CUSUM")
plot(Stability1)
#There is stability since no curve goes above or below the red lines
# there seems to be no structural breaks evident


# Policy simulations

#VAR coefficients were not interpreted, we give preference to the 
#applications

#Granger causuality
#2 vars so two casualties will be seen
?causality
Granger_FuturesPrice=causality(Modeldata1, cause="FuturesPrice")
Granger_FuturesPrice$Granger
# FuturesPrice  Granger-cause Spot_Index
# Instantaneous causality between: FuturesPrice and Spot_Index

Granger_Spot_Index=causality(Modeldata1,cause="Spot_Index")
Granger_Spot_Index$Granger
# Spot_Index do not Granger-cause FuturesPrice
# Instantaneous causality between: Spot_Index and FuturesPrice

#Impulse Response Functions

#We see how a variable will behave n periods from now if I shock the other variables
#so we see how the stocks respond to stocks in itself and shocks in others
#Shock Spot Index and see Future Prices response and plot 20 periods ahead

Futures_irf=irf(Modeldata1,impulse="Spot_Index",response="FuturesPrice",n.ahead=20, boot=TRUE)
plot(Futures_irf,ylab="Futures Price", main="Shock from Spot Index")

#Spot_Index does not affect Future price, Future prices are affected by shocks in itself only

Index_irf=irf(Modeldata1,impulse="FuturesPrice",response="Spot_Index",n.ahead=20, boot=TRUE)
plot(Index_irf,ylab="Spot Index", main="Shock from FuturePrices")

#Future Prices positively affects Spot_Index  

#Variance Decomposition:
#TO see how much these variables are influenced by shocks
FEVD1=fevd(Modeldata1,n.ahead=10)
plot(FEVD1)

#For FuturesPrice, Futures price  affects itself if there is shock in it
#For Spot Index,shocks in Future price affects the Spot Index

#VAR Forecasting
?predict
forecast=predict(Modeldata1,n.ahead=5,ci=0.95)
#Fanchart forecast for Futures Price
fanchart(forecast, names="FuturesPrice")

#Fanchart forecast for Spot Index
fanchart(forecast, names="Spot_Index")





