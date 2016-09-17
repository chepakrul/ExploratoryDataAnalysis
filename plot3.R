# Exploratory Data Analysis Project - Assignment 2 
# Question 3
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


# 3 - Load ggplot2 library

require(ggplot2)

# 4 - Loading provided datasets - loading from local machine

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# 5 - Sampling

NEI_sampling <- NEI[sample(nrow(NEI), size=5000, replace=F), ]


# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999 - 2008 for Baltimore City? 
# Which have seen increases in emissions from 1999 - 2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

# 6 - Generate the graph in the same directory as the source code

# Subset NEI data by Baltimore's fip.

baltimoreNEI <- NEI[NEI$fips=="24510",]

# 8 - Aggregate using sum the Baltimore emissions data by year

aggTotalsBaltimore <- aggregate(Emissions ~ year, baltimoreNEI,sum)

# 9 - Generate the graph in the same directory as the source code
library(ggplot2)

png("./plot3.png",width=600,height=500,units="px",bg="transparent")

ggp <- ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="Year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

print(ggp)

dev.off()
