#Non-Seasonal Dataset of Indeed Job Postings all over US.
#Forecasting the On-Time Performance for net 12 months
library(tidyverse)
library(lubridate)
library(ggplot2)
library(zoo)
library(urca)
library(tseries)
library(forecast)

setwd("C:/Users/akank/Downloads")
data <- read.csv("metro_job_postings_us.csv", stringsAsFactors = FALSE)

#Cleaning the data and converting the data type
names(data) <- toupper(trimws(names(data)))
data$DATE <- as.Date(data$DATE)
head(data, 10)
#List of unique column values
colnames(data)
unique(data$METRO)

# GG Plot only for job postings for New York
ggplot(data %>% filter(METRO == "New York-Newark-Jersey City, NY-NJ-PA"), aes(x = DATE, y = INDEED_JOB_POSTINGS_INDEX)) + geom_line(color = "darkblue") +
  labs(title = "Job Posting Index Over Time – NY Metro", x = "Date", y = "Job Posting Index") + theme_minimal()

# Further project is working only for New York metro
ny_data <- data %>% filter(METRO == "New York-Newark-Jersey City, NY-NJ-PA")
ny_data <- ny_data %>% arrange(DATE)

#Time series object for Job Postings in NY
ny_ts <- zoo(ny_data$INDEED_JOB_POSTINGS_INDEX, order.by = ny_data$DATE)
plot(ny_ts, main = "NY Metro Job Posting Index (Zoo Time Series)", ylab = "Index", xlab = "Date")

# Convert to numeric vector for tests
ny_vector <- as.numeric(ny_ts)
# Check Stationarity

#ADF Test (Augmented Dickey-Fuller)
#H0: Series is non-stationary.(If p-value<0.05 -> Reject H0)
adf.test(ny_vector)

# In ADF test our OTP Time series is non-stationary.
# First-order differencing
ny_diff1 <- diff(ny_ts)
plot(ny_diff1, main = "Differenced NY Metro Job Posting Index", ylab = "Differenced Index", xlab = "Date")

# Check stationarity tests 
#H0: Series is non-stationary.(If p-value<0.05 -> Reject H0)
adf.test(as.numeric(ny_diff1))

# In ADF test our data is now stationary after differencing.
# There are few spikes but not enough to invalidate modeling.

# ACF and PACF plots of differenced job posting series
# AR (p): At PACF – cut-off at lag p, gradual decay in ACF.
# MA (q): At ACF – cut-off at lag q, gradual decay in PACF.
acf(ny_diff1, main = "ACF of Differenced NY Job Index")
pacf(ny_diff1, main = "PACF of Differenced NY Job Index")

#MA(1) AND AR(2)
#ARIMA Models: ARIMA(0,1,1) , ARIMA(1,1,1), ARIMA(2,1,1)
model_011 <- Arima(ny_vector, order = c(0,1,1))
model_111 <- Arima(ny_vector, order = c(1,1,1))
model_211 <- Arima(ny_vector, order = c(2,1,1))

# Compare models using AIC and BIC
model_comparison <- data.frame(
  Model = c("ARIMA(0,1,1)", "ARIMA(1,1,1)", "ARIMA(2,1,1)"),
  AIC = c(AIC(model_011), AIC(model_111), AIC(model_211)),
  BIC = c(BIC(model_011), BIC(model_111), BIC(model_211))
)
print(model_comparison)

#Model ARIMA(2,1,1)

# Residual diagnostics
checkresiduals(model_211)
residuals_211 <- residuals(model_211)
ny_ts <- ts(ny_vector, start = c(2020, 1), frequency = 12)

# Histogram for Normality
hist(residuals_211, main = "Histogram of Residuals", xlab = "Residuals", col = "skyblue", breaks = 20)

# QQ plot for Normality
qqnorm(residuals_211)
qqline(residuals_211, col = "red")

# Ljung-Box Test for White noise
Box.test(residuals_211, lag = 20, type = "Ljung-Box")

# Forecast next 40 periods using ARIMA(2,1,1)
forecast_arima <- forecast::forecast(model_211, h = 40)

# Plot the forecast
autoplot(forecast_arima) +
  ggtitle("Forecast – NY Metro Job Posting Index (ARIMA 2,1,1)") +
  ylab("Job Posting Index") + xlab("Date") + theme_minimal()


