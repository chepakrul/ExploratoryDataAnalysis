# Exploratory Data Analysis Project - Assignment 2 
# Question 6
# By Che pakrul Azmi 17-09-2016


# 1 - Set path (My path is E:/JHU/Course 4/Project")

getwd()
setwd("E:/JHU/Course 4/Project")

#"E:/JHU/Course 4/Project"

# 2 - Get the data

# download and unzip data
  
if(!file.exists('data')) dir.create('data')
fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileUrl, destfile = './data/NEI_data.zip')
unzip('./data/NEI_data.zip', exdir = './data')

# 3 -  Loading provided datasets - loading from local machine 
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# 4 - Load ggplot2 library
library(ggplot2)

# 5 - Year
NEI$year <- factor(NEI$year, levels=c('1999', '2002', '2005', '2008'))

# 6 - Subset
# Baltimore City, Maryland
# Los Angeles County, California
MD.onroad <- subset(NEI, fips == '24510' & type == 'ON-ROAD')
CA.onroad <- subset(NEI, fips == '06037' & type == 'ON-ROAD')

# 7 - Aggregate
MD.DF <- aggregate(MD.onroad[, 'Emissions'], by=list(MD.onroad$year), sum)
colnames(MD.DF) <- c('year', 'Emissions')
MD.DF$City <- paste(rep('MD', 4))

CA.DF <- aggregate(CA.onroad[, 'Emissions'], by=list(CA.onroad$year), sum)
colnames(CA.DF) <- c('year', 'Emissions')
CA.DF$City <- paste(rep('CA', 4))

DF <- as.data.frame(rbind(MD.DF, CA.DF))

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources 
# in Los Angeles County, California (fips == 06037). Which city has seen greater changes over time 
# in motor vehicle emissions?

# 8 - Generate the graph in the same directory as the source code
png("./plot6.png", width=600,height=500,units="px")

ggplot(data=DF, aes(x=year, y=Emissions)) + geom_bar(aes(fill=year), stat="identity") + guides(fill=F) + 
    ggtitle('Total Emissions of Motor Vehicle Sources\nLos Angeles County, California vs. Baltimore City, Maryland') + 
    ylab(expression('PM'[2.5])) + xlab('Year') + theme(legend.position='none') + facet_grid(. ~ City) + 
    geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=0))

dev.off()
