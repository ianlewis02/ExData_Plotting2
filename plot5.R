##  Load the R libraries required for the function
	library(data.table)
	library(ggplot2)
	library(grid)
	library(httr)
	library(plyr)
	library(scales)

##  Set the working directory
	setwd("C:/Users/Ian/R/Rprogramming/assignment21/exdata-data-NEI_data")

##  Assignment Question - Five
##  How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
	
	print('Question Five - Started')
	NEI <- readRDS("summarySCC_PM25.rds")
	print('Load of NEI data set completed')
	SCC <- readRDS("Source_Classification_Code.rds")
	print('Load of SCC data set completed')

###  Sort the NEI information by year, select the on-road information and aggregate
	
	NEI$year <- factor(NEI$year, levels = c('1999', '2002', '2005', '2008'))
	baltimore <- subset(NEI, fips == 24510 & type == 'ON-ROAD')
	baltimore_total <- aggregate(baltimore[, 'Emissions'], by = list(baltimore$year), sum)
	colnames(baltimore_total) <- c('year', 'Emissions')

### Generate the plot of how emissions from motor vehicle changed from 1999–2008 in Baltimore City
	png("plot5.png",width=640,height=480,units="px")
	ggplot5 <- ggplot(data = baltimore_total, aes(x = year, y = Emissions)) + geom_bar(aes(fill = year), stat = "identity") +
	guides(fill = F) + ggtitle("Total Emissions from On-Road Motor Vehicles in Baltimore, MD. (1999 to 2008)") + 
	ylab(expression('PM '[2.5]*' Emissions (Tons)')) + xlab('Year') + theme(legend.position = 'none') 
	print(ggplot5)
	dev.off()
	print('Question Five - Plot Complete')
