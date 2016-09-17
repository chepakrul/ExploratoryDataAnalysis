# Exploratory Data Analysis Project - Assignment 2 
# Question 1
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

# 4 - Sampling

NEI_sampling <- NEI[sample(nrow(NEI), size=2000, replace=F), ]

# 5 - Aggregate

Emissions <- aggregate(NEI[, 'Emissions'], by=list(NEI$year), FUN=sum)
Emissions$PM <- round(Emissions[,2]/1000,2)


# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources 
# for each of the years 1999, 2002, 2005, and 2008.

# 6 - Generate the graph in the same directory as the source code

png(filename="./plot1.png")

barplot(Emissions$PM, names.arg=Emissions$Group.1, 
        main=expression('Total Emission of PM'[2.5]),
        xlab='Year', ylab=expression(paste('PM', ''[2.5], ' in Kilotons')))

dev.off()
