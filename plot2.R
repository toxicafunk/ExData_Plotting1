library(data.table)
library(lubridate)

###  include code for reading the data so that the plot can be fully reproduced

# Download and unzip the file if it doesn't exist
if (!file.exists("household_power_consumption.txt")) { 
  if (!file.exists("exdata_data_household_power_consumption.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "exdata_data_household_power_consumption.zip", method = "curl")
  }
  unzip("exdata_data_household_power_consumption.zip")
}

### Use fread from data.table to extract only the subset we need without loading the whole file into memory
### "skip" looks for the first row with the specified text and we set "nrows" to read the rows equivalent to 2 days.
## We can verify this with head(dat) and tail(dat) if desired
dat <- fread("household_power_consumption.txt", sep=";", header = FALSE, skip = "1/2/2007", nrows = 60*24*2)

### setnames does not copy the whole table and is faster. See help('setnames').
setnames(dat, names(dat), names(fread("household_power_consumption.txt", sep=";", header = TRUE, nrows = 0)))

### Nothing beats lubridate for working with dates in R, we paste Date and Time and parse them with lubridate
dat$Datetime <- dmy_hms(paste(dat$Date, dat$Time))

### Plot using type "l" for "lines"
with(dat, plot(Datetime, Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = ""))

### Copy to a PNG file and close the device
### I set the width and height even though 480 seems to be the default value.
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()
