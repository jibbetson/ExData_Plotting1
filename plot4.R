# Exploratory data analysis
# Week 1 assignment
# 
# Assumes copy of the data set household_power_consumption.txt 
# is already downloaded in the working directory
# setwd("~/R & Data Science Course/04_ExploratoryAnalysis")

# Read in all the data
# Initially I used read.table() with defaults and this read everything as a single row
# so i added the header and sep arguments
# also stringsAsFactors set to FALSE (otherwise dates and time strings are factors)
# also the instructions indicated missing values were "?"
# optional: set nrows=10 to quickly check what's happening
datafile <- "household_power_consumption.txt"
power <- read.table(datafile, header=TRUE, sep=";", na.strings ="?", stringsAsFactors = FALSE)
dim(power) 
# [1] 2075259       9
str(power)
# 'data.frame':    2075259 obs. of  9 variables:
# $ Date                 : chr  "16/12/2006" "16/12/2006" "16/12/2006" "16/12/2006" ...
# $ Time                 : chr  "17:24:00" "17:25:00" "17:26:00" "17:27:00" ...
# $ Global_active_power  : num  4.22 5.36 5.37 5.39 3.67 ...
# $ Global_reactive_power: num  0.418 0.436 0.498 0.502 0.528 0.522 0.52 0.52 0.51 0.51 ...
# $ Voltage              : num  235 234 233 234 236 ...
# $ Global_intensity     : num  18.4 23 23 23 15.8 15 15.8 15.8 15.8 15.8 ...
# $ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
# $ Sub_metering_2       : num  1 1 2 1 1 2 1 1 1 2 ...
# $ Sub_metering_3       : num  17 16 17 17 17 17 17 17 17 16 ...

# now format the Date column to a proper & consistent date format
# important: originally some dates were in dd/mm/yyyy format
# while some were in dd/m/yyyy format
power <- mutate(power, Date=as.Date(Date, "%d/%m/%Y"))
# filter to the dates of interest
power.f <- filter(power, Date=="2007-02-01" | Date=="2007-02-02" )

# now add a new column with a combined datetime parameter
power.f <- mutate(power.f, datetime=paste(Date, Time))
class(power.f$datetime) 
# [1] "character"
class(power.f$Date) 
# [1] "Date"

# now format datetime in POSIXct format suitable for plotting
power.f$datetime <- as.POSIXct(power.f$datetime)
class(power.f$datetime)
# [1] "POSIXct" "POSIXt" 

#plot 4
png(filename = "plot4.png")
# set up multiple plots
par(mfcol = c(2,2))
#1st one
with(power.f, plot(datetime, Global_active_power, type = "l" , xlab="", ylab="Global Active Power" ))
#2nd one (bottom left)
with(power.f, plot(datetime, Sub_metering_1, type = "n" , xlab="", ylab="Energy sub metering" ))
with(power.f, lines(datetime, Sub_metering_1, col="black"))
with(power.f, lines(datetime, Sub_metering_2, col="red"))
with(power.f, lines(datetime, Sub_metering_3, col="blue"))
legend("topright", bty="n", legend = names(power.f[7:9]), lty=c(1,1,1), col=c("black", "red", "blue"))
#3rd one (top right)
with(power.f, plot(datetime, Voltage, type="l", xlab="datetime", ylab="Voltage" ))
#4th one (bottom right)
with(power.f, plot(datetime, Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power" ))
dev.off()
# reset default to single plot
par(mfcol = c(1,1))







