Exploratory Data Analysis Project - Assignment 2 
-------------------------------------------------

**NOTE: My work and answers to the questions are at the bottom of this document.**

**Assignment**

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999 - 2008. You may use any R package you want to support your analysis.

**Making and Submitting Plots**

For each plot you should

* Construct the plot and save it to a PNG file.
* Create a separate R code file (plot1.R, plot2.R, etc.) that constructs the corresponding plot, i.e. code in plot1.R constructs the plot1.png plot. Your code file should include code for reading the data so that the plot can be fully reproduced. You should also include the code that creates the PNG file. Only include the code for a single plot (i.e. plot1.R should only include code for producing plot1.png)
* Upload the PNG file on the Assignment submission page
* Copy and paste the R code from the corresponding R file into the text box at the appropriate point in the peer assessment.

In preparation we first ensure the data sets archive is downloaded and extracted.

1 - Set path (My path is E:/JHU/Course 4/Project")


```r
getwd()
```

```
## [1] "E:/JHU/Course 4/Project"
```

```r
setwd("E:/JHU/Course 4/Project")
```

My Path : "E:/JHU/Course 4/Project"

2 - Get the data - Download and unzip data


```
## Warning in download.file(fileUrl, destfile = "./data/NEI_data.zip"):
## InternetOpenUrl failed: 'The server name or address could not be resolved'
```

```
## Error in download.file(fileUrl, destfile = "./data/NEI_data.zip"): cannot open URL 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
```

```
## Warning in unzip("./data/NEI_data.zip", exdir = "./data"): error 1 in
## extracting from zip file
```

We now load the NEI and SCC data frames from the .rds files.


```r
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
```

Questions and Answer
--------------------

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

**QUESTION 1**

First we'll aggregate the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

Do some Sampling,


```r
NEI_sampling <- NEI[sample(nrow(NEI), size=2000, replace=F), ]
```

Aggregate


```r
Emissions <- aggregate(NEI[, 'Emissions'], by=list(NEI$year), FUN=sum)
Emissions$PM <- round(Emissions[,2]/1000,2)
```

Using the base plotting system, now we plot the total PM2.5 Emission from all sources,


```r
png(filename="./plot1.png")

barplot(Emissions$PM, names.arg=Emissions$Group.1, 
        main=expression('Total Emission of PM'[2.5]),
        xlab='Year', ylab=expression(paste('PM', ''[2.5], ' in Kilotons')))

dev.off()
```

```
## png 
##   2
```

**Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?**

**Answer:**
![Plot 1](https://github.com/chepakrul/ExploratoryDataAnalysis/blob/master/plot1.png "Plot 1")

Yes, as we can see from the plot, total emissions have decreased in the US from 1999 to 2008.


**QUESTION 2**

Do some Sampling

```r
NEI_sampling1 <- NEI[sample(nrow(NEI), size=5000, replace=F), ]
```

Then, subset data and append two years in one data frame

```r
MD <- subset(NEI, fips=='24510')
```

Now we use the base plotting system to make a plot of this data,


```r
png(filename="./plot2.png")

barplot(tapply(X=MD$Emissions, INDEX=MD$year, FUN=sum), 
        main='Total Emission in Baltimore City, MD', 
        xlab='Year', ylab=expression('PM'[2.5]))

dev.off()
```

```
## png 
##   2
```

**Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?**

**Answer:**
![Plot 2](https://github.com/chepakrul/ExploratoryDataAnalysis/blob/master/plot2.png "Plot 2")

Yes, Overall total emissions from PM2.5 have decreased in Baltimore City, Maryland from 1999 to 2008.


**QUESTION 3**

Using the ggplot2 plotting system,

Do some Sampling,

```r
NEI_sampling <- NEI[sample(nrow(NEI), size=5000, replace=F), ]
```

Subset NEI data by Baltimore's fip.

```r
baltimoreNEI <- NEI[NEI$fips=="24510",]
```

Aggregate using sum the Baltimore emissions data by year

```r
aggTotalsBaltimore <- aggregate(Emissions ~ year, baltimoreNEI,sum)
```

Generate the graph in the same directory as the source code

```r
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
```

```
## png 
##   2
```

**Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999 - 2008 for Baltimore City?**

**Answer:**
![Plot 3](https://github.com/chepakrul/ExploratoryDataAnalysis/blob/master/plot3.png "Plot 3")

The `non-road`, `nonpoint`, `on-road` source types have all seen decreased emissions overall from 1999-2008 in Baltimore City.

**Which have seen increases in emissions from 1999 - 2008?**

The `point` source saw a slight increase overall from 1999-2008. Also note that the `point` source saw a significant increase until 2005 at which point it decreases again by 2008 to just above the starting values. 

**QUESTION 4**

Load ggplot2 library

```r
require(ggplot2)
```

Coal combustion related sources

```r
SCC.coal = SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),]
```

Merge two data sets

```r
merge <- merge(x=NEI, y=SCC.coal, by='SCC')
merge.sum <- aggregate(merge[, 'Emissions'], by=list(merge$year), sum)
colnames(merge.sum) <- c('Year', 'Emissions')
```

Generate the graph in the same directory as the source code


```r
png(filename="./plot4.png",width=600,height=500,units="px")

ggplot(data=merge.sum, aes(x=Year, y=Emissions/1000)) + 
    geom_line(aes(group=1, col=Emissions)) + geom_point(aes(size=2, col=Emissions)) + 
    ggtitle(expression('Total Emissions of PM'[2.5])) + 
    ylab(expression(paste('PM', ''[2.5], ' in Kilotons'))) + 
    geom_text(aes(label=round(Emissions/1000,digits=2), size=2, hjust=1.5, vjust=1.5)) + 
    theme(legend.position='none') + scale_colour_gradient(low='black', high='red')

dev.off()
```

```
## png 
##   2
```


**Across the United States, how have emissions from coal combustion-related sources changed from 1999 - 2008?**

**Answer:**
![Plot 4](https://github.com/chepakrul/ExploratoryDataAnalysis/blob/master/plot4.png "Plot 4")

Emissions from coal combustion related sources have decreased from 600 kilotons to below 400 kilotons from 1999-2008.

Eg. Emissions from coal combustion related sources have decreased by about 1/3 from 1999-2008! 


**QUESTION 5**

Load ggplot2 library

```r
library(ggplot2)
```

Year

```r
NEI$year <- factor(NEI$year, levels=c('1999', '2002', '2005', '2008'))
```

subset Baltimore City, Maryland == fips

```r
MD.onroad <- subset(NEI, fips == 24510 & type == 'ON-ROAD')
```

Aggregate

```r
MD.df <- aggregate(MD.onroad[, 'Emissions'], by=list(MD.onroad$year), sum)
colnames(MD.df) <- c('year', 'Emissions')
```

Generate the graph in the same directory as the source code

```r
png("./plot5.png",width=600,height=500,units="px",bg="transparent")

ggplot(data=MD.df, aes(year,Emissions)) + geom_bar(aes(fill=year), stat="identity") + 
  guides(fill=F) + ggtitle('Total Emissions of Motor Vehicle Sources in Baltimore City, Maryland') + 
    ylab(expression('PM'[2.5])) + xlab('Year') + theme(legend.position='none') + 
    geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=2))

dev.off()
```

```
## png 
##   2
```

**How have emissions from motor vehicle sources changed from 1999 - 2008 in Baltimore City?**

**Answer:**
![Plot 5](https://github.com/chepakrul/ExploratoryDataAnalysis/blob/master/plot5.png "Plot 5")

Emissions from motor vehicle sources have dropped from 1999-2008 in Baltimore City!


**QUESTION 6**

 Load ggplot2 library

```r
library(ggplot2)
```
Year

```r
NEI$year <- factor(NEI$year, levels=c('1999', '2002', '2005', '2008'))
```

Subset Baltimore City, Maryland and Los Angeles County, California

```r
MD.onroad <- subset(NEI, fips == '24510' & type == 'ON-ROAD')
CA.onroad <- subset(NEI, fips == '06037' & type == 'ON-ROAD')
```

Aggregate

```r
MD.DF <- aggregate(MD.onroad[, 'Emissions'], by=list(MD.onroad$year), sum)
colnames(MD.DF) <- c('year', 'Emissions')
MD.DF$City <- paste(rep('MD', 4))

CA.DF <- aggregate(CA.onroad[, 'Emissions'], by=list(CA.onroad$year), sum)
colnames(CA.DF) <- c('year', 'Emissions')
CA.DF$City <- paste(rep('CA', 4))

DF <- as.data.frame(rbind(MD.DF, CA.DF))
```

Generate the graph in the same directory as the source code

```r
png("./plot6.png", width=600,height=500,units="px")

ggplot(data=DF, aes(x=year, y=Emissions)) + geom_bar(aes(fill=year), stat="identity") + guides(fill=F) + 
    ggtitle('Total Emissions of Motor Vehicle Sources\nLos Angeles County, California vs. Baltimore City, Maryland') + 
    ylab(expression('PM'[2.5])) + xlab('Year') + theme(legend.position='none') + facet_grid(. ~ City) + 
    geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=0))

dev.off()
```

```
## png 
##   2
```

**Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == 06037). Which city has seen greater changes over time in motor vehicle emissions?**

**Answer:**

![Plot 6](https://github.com/chepakrul/ExploratoryDataAnalysis/blob/master/plot6.png "Plot 6")


Los Angeles County has seen the greatest changes over time in motor vehicle emissions.

**Thanks for grading my Project Assignment**

Last updated 2016-09-17 18:36:14 using R version 3.3.0 (2016-05-03).Updated by: chepakrulazmi
