##  Load the R libraries required for the function
	library(data.table)
	library(ggplot2)
	library(grid)
	library(httr)
	library(plyr)
	library(scales)

##  Set the working directory
	setwd("C:/Users/Ian/R/Rprogramming/assignment21/exdata-data-NEI_data")

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
