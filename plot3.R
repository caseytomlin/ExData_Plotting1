plot3 <- function() {
    # Loads the data from the zip file url and reproduces plot3.png
        
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
        
    # construct plot3
    png(filename="plot3.png")
    plot(data$DateTime, data$Sub_metering_1, type="l",
         ylab="Energy sub metering", xlab="")
    lines(data$DateTime, data$Sub_metering_2, col="red")
    lines(data$DateTime, data$Sub_metering_3, col="blue")
    legend("topright", lty=1, col=c("black", "red", "blue"), 
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    dev.off()
}