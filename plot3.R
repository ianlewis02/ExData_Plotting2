##  Load the R libraries required for the function
	library(data.table)
	library(ggplot2)
	library(grid)
	library(httr)
	library(plyr)
	library(scales)

##  Set the working directory
	setwd("C:/Users/Ian/R/Rprogramming/assignment21/exdata-data-NEI_data")

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


	