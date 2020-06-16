library(tidyverse)
library(TTR)
library(quantmod)
library(RColorBrewer)
library(PerformanceAnalytics)
library(tseries)
library(lubridate)
library(Quandl)
Quandl.api_key("") # Get a free Quandl api key from https://docs.quandl.com/docs#section-authentication


# pull the stock data from yahoo finance
options(scipen = 9999)  # turn on scientific notation
tsla <- getSymbols("TSLA",auto.assign = F)  # do not store the variable in a global environment
print(plot(dailyReturn(tsla$TSLA.Adjusted), type = "l", main = "Daily Return" ))


# pull the stock data and get adjusted daily closes and daily return
msft <- getSymbols("MSFT",auto.assign = F)
msft_ad <- Ad(msft)
msft_daily <- dailyReturn(msft_ad)

fb <- getSymbols("FB",auto.assign = F)
fb_ad <- Ad(fb)
fb_daily <- dailyReturn(fb_ad)

# merge the data
comb <- merge(msft,fb)
comb_traded <- merge(msft_daily,fb_daily, all = F)  # get only data when both companies were trading

# print a performance chart to compare Fb and MSFT
chart <- charts.PerformanceSummary(comb_traded, main = "FB vs MSFT",ylim = c(-2,5))
print(chart)

# compare sharp ratios
annualizedReturn <- table.AnnualizedReturns(comb_traded,scale=252,Rf = 0.004/252)
print(annualizedReturn)

# based on risk profile and return Microsoft is better as risk adjusted reward benefits Microsoft
