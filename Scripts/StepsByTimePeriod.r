

StepsByTimePeriod<-aggregate(Xdata$steps, by=list(Xdata$interval), FUN=mean,na.rm=TRUE)
colnames(StepsByTimePeriod)<-c("interval","avgsteps")

plot(StepsByTimePeriod,type="n")
lines(StepsByTimePeriod)

#Most steps in time period 835
StepsByTimePeriod[which(StepsByTimePeriod$avgsteps==max(StepsByTimePeriod$avgsteps)),]

x<-merge(x=Xdata,y=StepsByTimePeriod,by.x="interval",by.y="interval")
Xdata$CleanSteps<-ifelse(is.na(x$steps),x$avgsteps,x$steps)