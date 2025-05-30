# Forecasting-Metro-Level-Hiring-Trends

## 🗽 Project Overview

This project focuses on modeling and forecasting hiring trends at the metro level in the U.S., particularly New York City, using **daily indexed job posting data** from Indeed. The goal is to identify patterns and forecast short-term employment demand using time series analysis techniques.

---

## 📊 Dataset Description

- **Source:** Indeed Job Postings Index  
- **Time Range:** Feb 1, 2020 – Feb 28, 2025 (Daily)  
- **Columns:**
  - `date`: Daily timestamp of job index
  - `metro`: Metropolitan Statistical Area (e.g., Abilene, TX)
  - `cbsa_code`: Core-Based Statistical Area code
  - `indeed_job_postings_index`: Indexed job postings (base 100 as of Feb 1, 2020)

---

## 🔍 Methodology

1. **Exploratory Analysis**
   - Observed a steep dip in 2020 due to COVID-19.
   - Rebound in 2021–2022, followed by a stable trend in 2023–2024.

2. **Stationarity Testing**
   - ADF Test: Initial series non-stationary (p = 0.955)
   - Differencing applied → p = 0.01 → Stationarity achieved

3. **Model Identification**
   - ACF and PACF analysis indicated ARIMA structure
   - Model candidates: ARIMA(1,1,1), ARIMA(0,1,1), ARIMA(2,1,1)

4. **Model Selection**
   - AIC & BIC used to compare models
   - ARIMA(2,1,1) selected (AIC = -1870.24, BIC = -1848.03)

5. **Residual Diagnostics**
   - Residuals are white-noise, uncorrelated, normally distributed
   - Validated via ACF plots, histograms, QQ plots, and Ljung-Box test

6. **Forecasting**
   - 40-day forecast produced
   - Confidence intervals: 80% (dark blue), 95% (light blue)

---

## ✅ Key Findings

- Sudden drop in job demand during pandemic followed by strong recovery
- Current trends show stable market demand in NYC metro area
- Short-term forecast suggests continued market stability

---

## 📁 Files

- `MA641_Final_Project_2.pdf`: Full project report with plots and interpretation
- `forecast_script.R`: R script used for analysis (if included)
- `metro_job_postings_us.csv`: Cleaned dataset (if included)

---

## 📚 References

- Custom dataset parsed from Indeed's metro-level hiring indices
