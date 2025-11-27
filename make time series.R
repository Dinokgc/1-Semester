########## time series ############

#General
ts(data, start = c(year, period), frequency = n)
##########

# 1. Yearly Data — frequency = 1
gdp <- c(2.1, 2.4, 1.9, 2.3, 3.0)

gdp_ts <- ts(gdp, start = 2015, frequency = 1)

# What to adapt
# change gdp to your data 
# Only the year changes — period is always 1
################################################################################

# 2. Quarterly Data — frequency = 4
revenue <- c(10,12,15,13, 11,14,17,16)

rev_ts <- ts(revenue, start = c(2020, 1), frequency = 4)

# What to adapt
# change revenue to your data 
# If your first observation is Q3 2018 → use start = c(2018, 3)
# Set frequency = 4

################################################################################
# 3. Monthly Data — frequency = 12
sales <- c(100,110,120,...)

sales_ts <- ts(sales,
               start = c(2022, 5),   # May = 5
               frequency = 12)
# What to adapt
# change sales to your data 
# change start_date
# Replace 5 with the actual start month
# Replace 2022 with your year

################################################################################
# 4. Weekly Data → frequency = 52
demand <- rnorm(52)

demand_ts <- ts(demand,
                start = c(2022, 3),   # starts week 3
                frequency = 52)
# What to adapt
# change demand to your data
# Choose correct week number

################################################################################
#5. Daily Data with Weekly Seasonality — frequency = 7
start_date <- as.Date("2023-01-25")
start_year <- as.numeric(format(start_date, "%Y"))
start_dow <- as.numeric(format(start_date, "%u"))  # 1=Mon, 7=Sun

ts_daily_week <- ts(data,
                    start = c(start_year, start_dow),
                    frequency = 7)
# What to adapt
# change data to your data 
#just start_date 

################################################################################
#6. Daily Data with Yearly Seasonality — frequency = 365
start_date <- as.Date("2020-02-27")
start_year <- as.numeric(format(start_date, "%Y"))
start_doy  <- as.numeric(format(start_date, "%j"))  # Day of year 1–365

ts_daily_annual <- ts(data,
                      start = c(start_year, start_doy),
                      frequency = 365)

# What to adapt
# change data to your data 
# change start_date

################################################################################
#7. Business-Day Daily Data — frequency = 5
start_date <- as.Date("2023-03-02")
start_year <- as.numeric(format(start_date, "%Y"))

# Business day index (Mon=1 … Fri=5)
start_bday <- as.numeric(format(start_date, "%u"))
start_bday[start_bday > 5] <- 1  # Map weekend to Monday if needed

ts_business <- ts(data,
                  start = c(start_year, start_bday),
                  frequency = 5)
# What to adapt
# change data to your data 
# change start_date

