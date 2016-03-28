
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
hist(StepsByDay$avgsteps,breaks=10)

# Mean = 10766.19 steps
mean(StepsByDay$avgsteps,na.rm =TRUE)

# Mean = 10766.19 steps
median(StepsByDay$avgsteps,na.rm =TRUE)