library(sqldf)

# Read only the records needed for plotting, eliminating those with missing data
foo <- read.csv.sql("household_power_consumption.txt", header=TRUE, sep=";",
		sql = "select * 
			from file 
			where substr(date,5)||substr(date,3,1)||substr(date,1,1) 
      			between '200721' and '200722'
			and NOT( 	Global_active_power='?' OR
					Global_reactive_power ='?' OR
					Voltage = '?' OR
					Global_intensity = '?' OR
					Sub_metering_1 = '?' OR
					Sub_metering_2 = '?' OR
					Sub_metering_3 = '?')", eol = "\n")

# Convert the Date and Time column to a single column of type date 
foo <- fn$sqldf("select Date||' ' ||Time as dt, 
Sub_metering_1, Sub_metering_2, Sub_metering_3  from foo")

foo$dt <- as.POSIXct(foo$dt, format = "%d/%m/%Y %H:%M:%S") 

# Convert the data from wide to tall combining the Sub metering data into a 
# single column. Add an additional column to indicate the metering number
foo1 <- fn$sqldf("select dt, Sub_metering_1 as subm, 1 as mtype from foo")
foo2 <- fn$sqldf("select dt, Sub_metering_2 as subm, 2 as mtype from foo")
foo3 <- fn$sqldf("select dt, Sub_metering_3 as subm, 3 as mtype from foo")
fooN <- rbind(foo1, foo2, foo3)

# Plot to screen first and then copy to png file as per instructions
with(fooN, plot(dt, subm, type="n", xlab="", ylab="Energy sub metering"))
with(subset(fooN, mtype==1), lines(dt, subm, col="black"))
with(subset(fooN, mtype==2), lines(dt, subm, col="red"))
with(subset(fooN, mtype==3), lines(dt, subm, col="blue"))
legend("topright", pch="_", col=c("black","red","blue"), 
	legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.copy(png, file="./plot3.png", width=480, height=480)
dev.off()