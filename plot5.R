# Exploratory Data Analysis Project - Assignment 2 
# Question 5
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

# 4 -  Load ggplot2 library
library(ggplot2)

#Year

NEI$year <- factor(NEI$year, levels=c('1999', '2002', '2005', '2008'))

# Baltimore City, Maryland == fips

MD.onroad <- subset(NEI, fips == 24510 & type == 'ON-ROAD')

# 5 - Aggregate

MD.df <- aggregate(MD.onroad[, 'Emissions'], by=list(MD.onroad$year), sum)
colnames(MD.df) <- c('year', 'Emissions')

# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 

# 6 - Generate the graph in the same directory as the source code

png("./plot5.png",width=600,height=500,units="px",bg="transparent")

ggplot(data=MD.df, aes(year,Emissions)) + geom_bar(aes(fill=year), stat="identity") + 
  guides(fill=F) + ggtitle('Total Emissions of Motor Vehicle Sources in Baltimore City, Maryland') + 
    ylab(expression('PM'[2.5])) + xlab('Year') + theme(legend.position='none') + 
    geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=2))


dev.off()
