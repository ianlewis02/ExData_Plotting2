##  Load the R libraries required for the function
	library(data.table)
	library(ggplot2)
	library(grid)
	library(httr)
	library(plyr)
	library(scales)

##  Set the working directory
	setwd("C:/Users/Ian/R/Rprogramming/assignment21/exdata-data-NEI_data")

##  Assignment Question - Two
##  Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?

	print('Question Two - Started')
	NEI <- readRDS("summarySCC_PM25.rds")
	print('Load of NEI data set completed')
	baltimore  <- subset(NEI, fips=='24510')

###  Generate the plot of the total emissions from PM2.5 in Baltimore 
	
	png(filename='plot2.png')
	barplot(tapply(X=baltimore$Emissions, INDEX=baltimore$year, FUN=sum), col="blue", 
      main=expression('Total Emissions of PM'[2.5]*' in Baltimore, MD. (1999 to 2008)'), 
      xlab='Year', ylab=expression('PM '[2.5]*' Emmisions (Tons)'))
	dev.off()

	print('Question Two - Plot Complete')

