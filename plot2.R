# Exploratory Data Analysis Project - Assignment 2 
# Question 2
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

NEI_sampling <- NEI[sample(nrow(NEI), size=5000, replace=F), ]

# 5 - Subset data and append two years in one data frame

MD <- subset(NEI, fips=='24510')

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# 6 - Generate the graph in the same directory as the source code

png(filename="./plot2.png")

barplot(tapply(X=MD$Emissions, INDEX=MD$year, FUN=sum), 
        main='Total Emission in Baltimore City, MD', 
        xlab='Year', ylab=expression('PM'[2.5]))

dev.off()
