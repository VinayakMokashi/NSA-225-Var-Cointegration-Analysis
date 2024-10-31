library(tseries)
library(forecast)
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
?as.Date
colnames(data)
summary(data)
str(data)
#Converting to time series:
data$Future.Price=ts(data$Future.Price,start=c(2012,5),frequency=12)
data$Index=ts(data$Index,start=c(2012,5),frequency=12)

plot(data$Future.Price,xlab="Dates",
     ylab="Futures Price & Index", type= "l",col="red",main="Cointegration")

lines(data$Index,col="blue")

legend("topleft",legend = c("Futures Price","Index"),
       cex=0.8,inset=0.02,fill=c("red","blue"))

#------Check Stationarity Using Augmented Dickey Fuller Test

# Ho:The data is not stationary
# H1:The data is stationary

#From the plot both the series appear to be non-Stationary

# Checking if Futures price is I(1) series.

# We check stationarity of first order differenced series
adf.test(data$Future.Price, alternative="stationary",k=0) # original series: Not Stationary
adf.test(diff(data$Future.Price), alternative="stationary",k=0) # differenced series : Stationary
#Becomes stationary after one differencing
#Hence Futures.Price is an I(1) series.

# Plotting original & differenced series of Futures.Price
plot(data$Future.Price,type="l",col="blue",lwd=2)
plot(diff(data$Future.Price),type="l",col="blue",lwd=2)


# We check stationarity of first order differenced series (Index)
adf.test(data$Index, alternative="stationary",k=0) # original series: Not stationary
adf.test(diff(data$Index), alternative="stationary",k=0) # differenced series: Stationary
# First order differenced series is Stationary, hence the series is I(1)

# Plotting original & differenced series of Spot_Index
plot(data$Index,type="l",col="blue",lwd=2)
plot(diff(data$Index),type="l",col="blue",lwd=2)

#----- Check correlation
# We check how these two series are related with correlation command
cor(data$Future.Price,data$Index)
library(ggplot2)
ggplot(data=data)+geom_point(mapping=aes(x=Future.Price, y=Index))


#strong positive relation between the series is seen


# Fitting simple linear regression model to find hedge ratio
model<-lm(data$Future.Price~data$Index)
summary(model)

#Save and Print Regression Coefficients
Regression_Coefficients<-model$coefficients
print(model$coefficients)

#Determine and Save Value of Beta (Hedge Ratio)
Hedge_Ratio<-Regression_Coefficients[2]
print(Hedge_Ratio)

# calculating Spread i.e. linear combination of the two series
spread<- data$Future.Price-(Hedge_Ratio*data$Index)
plot(spread,type="l",col="blue",lwd=2)
head(spread)
tail(spread)

# Checking if Spread is I(0) series
# We check stationarity of the series
adf.test(spread,k=0)
#The series is stationary
# The spread is I(0)

# Both Series are I(1) & their linear combination is I(0) series
# Therefore the given two series are co-integrated


