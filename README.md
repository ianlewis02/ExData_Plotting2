# Exploratory Data Analysis - Assignment 2 #

# Instructions #
Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximately every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the EPA National Emissions Inventory web site.

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

# Data Source  #
The data for this assignment is a single zip file available from: [https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip "Click Here")

The zip file contains two files:

## PM2.5 Emissions Data (summarySCC_PM25.rds) ##
This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. 

- fips: A five-digit number (represented as a string) indicating the U.S. county
- SCC: The name of the source as indicated by a digit string (see source code classification table)
- Pollutant: A string indicating the pollutant
- Emissions: Amount of PM2.5 emitted, in tons
- type: The type of source (point, non-point, on-road, or non-road)
- year: The year of emissions recorded

## Source Classification Code Table (Source_Classification_Code.rds) ##
This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.

The following piece of code will load the libraries and data required for the plots (Note: the SCC data is not needed for every question!)
    
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

# Assignment  #
The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis. You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

## Question 1 ##

Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

### Code for Question 1 ###
    
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

### Plot for Question 1 ###
![](http://i.imgur.com/lXwS4lv.png)
### Answer to Question 1 ###

**The Total Emissions have declined in every year recorded in this dataset (1999, 2002, 2005 and 2008)**
 
## Question 2 ##
Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

### Code for Question 2 ###
    
    ##  Assignment Question - Two
    ##  Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
       	print('Question Two - Started')
    	NEI <- readRDS("summarySCC_PM25.rds")
    	print('Load of NEI data set completed')
    	baltimore  <- subset(NEI, fips=='24510')
    
    ###  Generate the plot of the total emissions from PM2.5 in Baltimore 
       	png(filename='plot2a.png')
		barplot(tapply(X=baltimore$Emissions, INDEX=baltimore$year, FUN=sum), col="blue", 
      	main=expression('Total Emissions of PM'[2.5]*' in Baltimore, MD. (1999 to 2008)'), 
      	xlab='Year', ylab=expression('PM '[2.5]*' Emmisions (Tons)'))
		dev.off()
		print('Question Two - Plot Complete')

### Plot for Question 2 ###
![](http://i.imgur.com/eL67MVf.png)
### Answer to Question 2 ###

**The Total Emissions in Baltimore have declined from 1999 to 2008, but not annually. In 2005 the emmissions were back upto the 1999 levels.**

## Question 3 ##
Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

### Code for Question 3 ###
    
    ##   Assignment Question - Three
    ##   Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources
    ##   have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008?
       	print('Question Three - Started')
    	NEI <- readRDS("summarySCC_PM25.rds")
    	print('Load of NEI data set completed')
    	baltimore  <- subset(NEI, fips=='24510')
    
    ###  Generate the plot with the four types of sources from 1999–2008 for Baltimore City
    	png(filename='plot3.png',width=640,height=480,units="px")
		ggplot3 <- ggplot(baltimore,aes(factor(year),Emissions,fill=type)) +
  		geom_bar(stat="identity") +
  		theme_bw() + guides(fill=FALSE)+
  		facet_grid(.~type,scales = "free",space="free") + 
  		labs(x="year", y=expression("PM"[2.5]*" Emissions (Tons)")) + 
  		labs(title=expression("Total Emmisions of PM"[2.5]*" per Type in Baltimore, MD (1999 to 2008)"))
		print(ggplot3)
		dev.off()
		print('Question Three - Plot Complete')

### Plot for Question 3 ###
![](http://i.imgur.com/g391wbg.png)
### Answer to Question 3 ###

**The sources which have seen decreases in emissions in Baltimore, MD. between 1999 and 2008 are Non-Road, Non-Point and On- Road. The source which increased emissions in Baltimore, MD. between 1999 and 2008 was Point, which increased in 2002 and 2005 and although in 2008 there was a decrease it was still greater than 1999.**

## Question 4 ##
Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

### Code for Question 4 ###

	##  Assignment Question - Four
	##  Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
		print('Question Four - Started')
		NEI <- readRDS("summarySCC_PM25.rds")
		print('Load of NEI data set completed')
		SCC <- readRDS("Source_Classification_Code.rds")
		print('Load of SCC data set completed')

	###  Merge the data by SCC, then identify the coal records
		merged_data <- merge(NEI, SCC, by="SCC")
		coal_data  <- grepl("coal", merged_data$Short.Name, ignore.case=TRUE)
		merged_coal <- merged_data[coal_data, ]
		annual_totals <- aggregate(Emissions ~ year, merged_coal, sum)

	### Generate the plot of how emissions sources from coal changed from 1999–2008
		png("plot4.png",width=640,height=480,units="px")
		ggplot4 <- ggplot(annual_totals, aes(factor(year), Emissions/1000))+
    	geom_line(aes(group=1, col=Emissions)) + geom_point(aes(size=2, col=Emissions)) + 
    	ggtitle(expression('Total Emissions of PM'[2.5]*' from Coal in the US (1999 to 2008)')) + 
    	ylab(expression(paste('PM '[2.5]*' Emmisions (Kilotons)'))) + 
    	geom_text(aes(label=round(Emissions/1000,digits=2), size=2, hjust=1.5, vjust=1.5)) + 
    	theme(legend.position='none') + scale_colour_gradient(low='black', high='red')
		print(ggplot4)
		dev.off()
		print('Question Four - Plot Complete')

### Plot for Question 4 ###
![](http://i.imgur.com/opOf9gH.png)
### Answer to Question 4 ###

**Emissions from coal combustion-related sources, reduced from 1999 to 2002, but had increased again by 1% in 2005. In 2008 the final figures show a significant drop in emissions (>30%), therefore the overall trend is downwards**
  
## Question 5 ##
How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

### Code for Question 5 ###
    
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

### Plot for Question 5 ###
![](http://i.imgur.com/dRRroxR.png)
### Answer to Question 5 ###
**Emissions from motor vehicle sources in Baltimore, MD. between 1999 and 2008 have seen a significant drop off. There were two big drops, the first between 1999 and 2002 and then again between 2005 and 2008. Emissions in 2008 are around 75% lower than the 1999 figures.**

## Question 6 ##
Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

### Code for Question 6 ###

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

### Plot for Question 6 ###
![](http://i.imgur.com/Z2u5Rpb.png)
### Answer to Question 6 ###
**Baltimore has seen a decline in emissions by 70% over the 9 years, whereas LA has seen growth in emissions until 2005, when levels reduced close to 1999 levels.**