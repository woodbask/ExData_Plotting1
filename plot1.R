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



# Plot to screen first and then copy to png file as per instructions
with(foo, hist(Global_active_power, 
xlab="Global Active Power (kilowatts)", col="red", main="Global Active Power" ))

dev.copy(png, file="./plot1.png", width=480, height=480)
dev.off()
