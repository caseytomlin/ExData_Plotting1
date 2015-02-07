plot1 <- function() {
    # Loads the data from the zip file url and reproduces plot1.png
        
    # If the zip file is not in the present working directory, download it.
    # Then unzip (if necessary), and read the data into the dataframe data.
    filename <- "household_power_consumption.txt"
    zipname <- "exdata-data-household_power_consumption.zip"
    if(!file.exists(filename)) {
        if(!file.exists(zipname)) {
            download.file("https://d396qusza40orc.cloudfront.net
                          /exdata%2Fdata%2Fhousehold_power_consumption.zip",
                          destfile=zipname, method="curl")                        
        }
        unzip(zipname)
    }
    data <- read.table(filename, header=T, sep=";", stringsAsFactors=F)
    
    # convert Dates into date format, Times into time, subset to just the
    # 2 days we care about, merge Date and Time into a single DateTime column,
    # and force numeric values for the other measurements.
    library(lubridate)
    data$Date <- dmy(data$Date)
    data$Time <- hms(data$Time)
    data <- data[data$Date %in% c(dmy(01022007), dmy(02022007)), ]
    data <- cbind(data[,1] + data[,2], data[,3:9]) # now there is one less
    names(data)[1] <- "DateTime"                       # column.
    data[,2:8] <- apply(data[,2:8], 2, as.numeric)
        
    # construct plot1
    png(filename="plot1.png")
    hist(data$Global_active_power, col="red", main="Global Active Power",
         xlab="Global Active Power (kilowatts)")
    dev.off()
}