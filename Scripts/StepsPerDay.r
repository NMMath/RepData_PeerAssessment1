
StepsByDay<-aggregate(Xdata$steps, by=list(Xdata$date), FUN=sum)
colnames(StepsByDay)<-c("date","avgsteps")
hist(StepsByDay$avgsteps,breaks=10,xlab="Steps Per Day", main="Histogram of steps per day in raw data")

# Mean = 10766.19 steps
mean(StepsByDay$avgsteps,na.rm =TRUE)

# Mean = 10765 steps
median(StepsByDay$avgsteps,na.rm =TRUE)