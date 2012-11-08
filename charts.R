#nikeplus charts from Twitter data
library(Hmisc)

#plot distances for weekdays and weekends
png("distances.png",
    width     = 3.75,
    height    = 3.00,
    units     = "in",
    res       = 250,
    pointsize = 6)
weekends <- read.csv("weekends_hist.csv", header=1)
weekdays <- read.csv("weekdays_hist.csv", header=1)

plot(weekdays, type="l", xlab="distance", ylab="people", col="blue", lwd=.7)
lines(weekends, type="l", col="red", lwd=.7)
minor.tick(nx=10)
box()
title(main="Distribution of run lengths (km)", col.main="black")
legend(35, 10000, c("weekends","weekdays"), cex=0.8, 
   col=c("blue","red"), lty=1:1)

#plot speeds for 5k and 10k
png("speeds.png",
    width     = 3.75,
    height    = 3.00,
    units     = "in",
    res       = 250,
    pointsize = 6)
s1 <- read.csv("speeds_10k_hist.csv", header=1)
s2 <- read.csv("speeds_5k_hist.csv", header=1)

plot(s1, type="l", xlab="speed", ylab="runners", col="red", lwd=0.7)
lines(s2, type="l", col="blue", lwd=0.7)
minor.tick(nx=5)
box()
title(main="distribution of speeds (km/h)", col.main="black")
legend(17, 20000, c("10k","5k"), cex=0.8,
   col=c("blue","red"), lty=1:1)

#plot the difference in distance popularity between weekends and weekdays
png("distances_diff.png",
    width     = 3.75,
    height    = 3.00,
    units     = "in",
    res       = 250,
    pointsize = 6)
d <- read.csv("weekend_weekday_diff.csv", header=1)

plot(d, type="l", xlab="distance", ylab="people")
abline(h=0, lwd=0.3)
abline(v=10, lty="dotted", col="blue", lwd=0.5)
abline(v=16, lty="dotted", col="green", lwd=0.5)
abline(v=21, lty="dotted", col="red", lwd=0.5)
abline(v=42, lty="dotted", col="orange", lwd=0.5)
minor.tick(nx=10)
box()
title(main="Difference between weekends and weekdays", col.main="black")
