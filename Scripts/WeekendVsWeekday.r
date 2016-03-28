
weekdays1=c("Mon","Tue","Wed","Thr","Fri")
ND$wDay<-factor((weekdays(as.Date(ND$date),  abbreviate=TRUE) %in% weekdays1),
                  levels=c(FALSE,TRUE), labels=c('weekend','weekday'))

StepsByTimePeriod<-aggregate(ND$steps,by=list(ND$interval,ND$wDay),FUN=mean,na.rm=TRUE)
colnames(StepsByTimePeriod)<-c("interval","wDay","steps")

install.packages("lattice")
library("lattice")

xyplot(StepsByTimePeriod$steps~StepsByTimePeriod$interval| StepsByTimePeriod$wDay,
          type="l", layout = c(1, 2),xlab="interval",ylab="steps")