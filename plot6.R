##  Load the R libraries required for the function
	library(data.table)
	library(ggplot2)
	library(grid)
	library(httr)
	library(plyr)
	library(scales)

##  Set the working directory
	setwd("C:/Users/Ian/R/Rprogramming/assignment21/exdata-data-NEI_data")

##  Assignment Question - Six
##  Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources 
##  in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
	print('Question Six - Started')
	NEI <- readRDS("summarySCC_PM25.rds")
	print('Load of NEI data set completed')
	SCC <- readRDS("Source_Classification_Code.rds")
	print('Load of SCC data set completed')
	
###  Subset the Balitimore and Los Angeles data for Motor Vehicle data and create seperated dataset for plotting
	countyNEI <- NEI[(NEI$fips=="24510"|NEI$fips=="06037") & NEI$type=="ON-ROAD",  ]
	countytotals <- aggregate(Emissions ~ year + fips, countyNEI, sum)
	countytotals$fips[countytotals$fips=="24510"] <- "Baltimore, MD"
	countytotals$fips[countytotals$fips=="06037"] <- "Los Angeles, CA"

	png("plot6.png", width=640,height=480,units="px")
	ggplot6 <- ggplot(countytotals, aes(factor(year), Emissions)) + geom_bar(stat="identity") + facet_grid(. ~ fips) +
 	ylab(expression('PM '[2.5]*' Emissions (Tons)')) + xlab('Year') + theme(legend.position = 'none') + 
  	ggtitle('Total Emissions from On-Road Motor Vehicles in Baltimore, MD and Los Angeles, CA. (1999 to 2008)')
	print(ggplot6)
	dev.off()
	print('Question Six - Plot Complete')