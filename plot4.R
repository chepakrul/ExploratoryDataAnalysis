# Exploratory Data Analysis Project - Assignment 2 
# Question 4
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


# 3 - Loading provided datasets - loading from local machine

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# 4 - Load ggplot2 library

require(ggplot2)

# 5 - Coal combustion related sources

SCC.coal = SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),]

# 6 - Merge two data sets

merge <- merge(x=NEI, y=SCC.coal, by='SCC')
merge.sum <- aggregate(merge[, 'Emissions'], by=list(merge$year), sum)
colnames(merge.sum) <- c('Year', 'Emissions')

# Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999-2008?

# 7 - Generate the graph in the same directory as the source code

png(filename="./plot4.png",width=600,height=500,units="px")

ggplot(data=merge.sum, aes(x=Year, y=Emissions/1000)) + 
    geom_line(aes(group=1, col=Emissions)) + geom_point(aes(size=2, col=Emissions)) + 
    ggtitle(expression('Total Emissions of PM'[2.5])) + 
    ylab(expression(paste('PM', ''[2.5], ' in Kilotons'))) + 
    geom_text(aes(label=round(Emissions/1000,digits=2), size=2, hjust=1.5, vjust=1.5)) + 
    theme(legend.position='none') + scale_colour_gradient(low='black', high='red')

dev.off()
