##  Load the R libraries required for the function
	library(data.table)
	library(ggplot2)
	library(grid)
	library(httr)
	library(plyr)
	library(scales)

##  Set the working directory
	setwd("C:/Users/Ian/R/Rprogramming/assignment21/exdata-data-NEI_data")

##  Read PM2.5 Emissions Data (summarySCC_PM25.rds)
##  This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. 
##  For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year 

	NEI <- readRDS("summarySCC_PM25.rds")
	print('Load of NEI data set completed')

##  Read Source Classification Code Table (Source_Classification_Code.rds): 
##  This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source
##  The sources are categorized in a few different ways from more general to more specific

	SCC <- readRDS("Source_Classification_Code.rds")
	print('Load of SCC data set completed')

##  Assignment Question - One
##  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 

	print('Question One - Started')
	NEI_aggregate <- aggregate(NEI[, 'Emissions'], by=list(NEI$year), FUN=sum)
	NEI_aggregate$PM <- round(NEI_aggregate[,2]/1000,2)

###  Generate the plot of the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008
	
	png(filename='plot1.png')
	barplot(NEI_aggregate$PM, names.arg=NEI_aggregate$Group.1, col="blue",
      main=expression('Total Emissions of PM'[2.5]*' in the US (1999 to 2008)'),

      xlab='Year', ylab=expression('PM '[2.5]*' Emmisons (Kilotons)'))
	dev.off()
	print('Question One - Plot Complete')
	dev.off()