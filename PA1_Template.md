---
title: "StepAnalysis"
author: "Nathan Maichel"
date: "March 27, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_knit$set(root.dir = 'C:/Users/nmm79/OneDrive/Documents/Coursera/Data Science/Reproducible Research/Week 1/Data')

```


## Introduction
This document has the details for an analysis of steps per five minute interval over a two month time frame.

Data can be downloaded from <https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip>.

## Import Data

```{r Import Data}

Xdata<-read.csv('activity.csv')
```

## Steps per Day
We will look at a histogram of steps per day.  This data has some missing values, but we will leave those untouched for the present.  we will also look at the mean and the median of steps per day in the raw data set.

```{r Steps Per Day raw data}

StepsByDay<-aggregate(Xdata$steps, by=list(Xdata$date), FUN=sum)
colnames(StepsByDay)<-c("date","avgsteps")
hist(StepsByDay$avgsteps,breaks=10,xlab="Steps Per Day", main="Histogram of steps per day in raw data")

mean(StepsByDay$avgsteps,na.rm =TRUE)

median(StepsByDay$avgsteps,na.rm =TRUE)

```

## Average steps per time interval through the day
Next we will look at the average steps by five minute time interval throughout the day.  This is still using the raw data.  We will also find the five minute time interval in the day which on average has the most steps. 

```{r Steps per interval raw data}


StepsByTimePeriod<-aggregate(Xdata$steps, by=list(Xdata$interval), FUN=mean,na.rm=TRUE)
colnames(StepsByTimePeriod)<-c("interval","avgsteps")

plot(StepsByTimePeriod,type="n", main="Avg steps per 5 minute interval", ylab="steps")
lines(StepsByTimePeriod)

#Most steps in time period 835
StepsByTimePeriod[which(StepsByTimePeriod$avgsteps==max(StepsByTimePeriod$avgsteps)),]


```

The 5 minute interval from 8:35 AM to 8:40 AM has the most average steps. 


## Imputing MIssing Data
There a number of values missing in this data set.  Missing values can skew the analysis if are examining things like total steps in a day.  I will impute missing values with the average of that time frame over the test period.  First I will find the total number of missing values.

```{r Missing Values}

# Number of missing values 2304
dim(Xdata[which(is.na(Xdata$steps)),])[1]

#If data is missing for a period, substite the mean for the five minute period 
# over the time span.
ND<-merge(x=Xdata,y=StepsByTimePeriod,by.x="interval",by.y="interval")
ND$CleanSteps<-ifelse(is.na(ND$steps),ND$avgsteps,ND$steps)

ND<-ND[,c("CleanSteps","interval","date")]
colnames(ND)<-c("steps","interval","date")

StepsByDay<-aggregate(ND$steps, by=list(ND$date), FUN=sum)
colnames(StepsByDay)<-c("date","avgsteps")
hist(StepsByDay$avgsteps,breaks=10,xlab="Steps Per Day", main="Histogram of steps per day in after imputing values")

# Mean = 10766.19 steps
mean(StepsByDay$avgsteps,na.rm =TRUE)

# Mean = 10766.19 steps
median(StepsByDay$avgsteps,na.rm =TRUE)

```

## Weekdays vs Weekends
We will now examine the steps per time interval when comparing weekends vs weekdays.

```{r Weekends vs weekdays}
weekdays1=c("Mon","Tue","Wed","Thr","Fri")
ND$wDay<-factor((weekdays(as.Date(ND$date),  abbreviate=TRUE) %in% weekdays1),
                  levels=c(FALSE,TRUE), labels=c('weekend','weekday'))

StepsByTimePeriod<-aggregate(ND$steps,by=list(ND$interval,ND$wDay),FUN=mean,na.rm=TRUE)
colnames(StepsByTimePeriod)<-c("interval","wDay","steps")

#install.packages("lattice")
library("lattice")

xyplot(StepsByTimePeriod$steps~StepsByTimePeriod$interval| StepsByTimePeriod$wDay,
          type="l", layout = c(1, 2),xlab="interval",ylab="steps")
```

A significant difference between weekends and weekdays is the higher levels of steps on weekday in the early morning.


