rm(list = ls(all = TRUE))
graphics.off()
shell("cls")

install.packages("ggridges")
install.packages("ggplot2")
install.packages("ggstatsplot")
install.packages("GMCM")
install.packages("moments")
library(moments)
library(ggridges)
library(ggplot2)
library(tidyr)
library(readr)
library(dplyr)
library(hrbrthemes)
library(viridis)
library(ggstatsplot)
library(GMCM)
library(sm)
library(httr)

#1. Load normalised data
mydata <- read.csv("C:\\###Dace\\2021_2022\\###Master\\Data\\Final_data\\table3.csv")
mydata1 <- data.frame(mydata[, c(5:10)])


#2. Load original data
orig_data <- read.csv("C:\\###Dace\\2021_2022\\###Master\\Data\\Final_data\\original_data.csv")
orig_data1 <- data.frame(orig_data[, c(2:7)])
summary(orig_data1)
log_data <- log(orig_data1)

df.long <- pivot_longer(mydata1, cols=1:6, names_to = "Variables", values_to = "Values")

#Vertical box plot by group + data points

ggplot(df.long,aes(x=Variables, y=Values, fill=Variables)) + theme_bw()+
  geom_boxplot() +
  geom_jitter(width=0.1, alpha=0.5, colour = 'darkgrey')+
  stat_summary(fun = mean, fun.min = min, fun.max = max, colour = "red")

#Basic Statistics

#Means
colMeans(mydata1)
#Variance
mydata1 %>% summarise_if(is.numeric, var)
#Standard Deviation
apply(mydata1,2,sd)
#Median
apply(mydata1,2,median)
#Skewness
skewness(mydata1)
#Kurtosis
kurtosis(mydata1)
#Summary
summary(mydata1)


ggplot(data = df.long) + 
  geom_bar(mapping = aes(x = Variables, y = Values))

# Kernel Density Plot
d <- density(mydata1$area) # returns the density data
plot(d) # plots the results


# With transparency (right)
ggplot(data=df.long, aes(x=Variables, group=Values, fill=Values)) +
  geom_density(adjust=1.5, alpha=.4) +
  theme_ipsum()

dens <- apply(mydata1, 2, density)
plot(NA, xlim=range(sapply(dens, "[", "x")), ylim=range(sapply(dens, "[", "y")))
mapply(lines, dens, col=1:length(dens))

legend("topright", legend=names(dens), fill=1:length(dens))

par(mfrow = c(3, 4))

ggplot(mydata1, aes(x=area)) + 
  geom_density(adjust=2) + 
  xlab("Variable") +
  ylab("Density")
ggplot(mydata1, aes(x=HD)) + 
  geom_density(adjust=2) + 
  xlab("Variable") +
  ylab("Density")

gg <- ggplot(data=df.long)
gg <- gg + geom_density(aes(x=Values, group=Variables, fill=Variables), adjust=2) 
gg <- gg + facet_grid(~Variables)
gg <- gg + theme_bw()
gg

###Original data

# Create the layout
#nf <- layout( matrix(c(1,2), ncol=1) )
nf <- layout( matrix(c(1,2), ncol=2) )

apply(orig_data1,2,sd)
# Area boxplot
hist(orig_data1$Area , breaks=100 , border=F , col="tomato1", xlab="Ha" , main="")
boxplot(orig_data1$Area,
        xlab = "Area",
        ylab = "Ha",
        col = "tomato1",
        vertical = TRUE
)

hist(log_data$Area , breaks=100 , border=F , 
      col="tomato1", xlab="log(Area)", xlim=c(-2, 8), main="")

# W boxplot
hist(orig_data1$W , breaks=100 , border=F , col="deepskyblue2", xlab="%" , main="")
boxplot(orig_data1$W,
        xlab = "W",
        ylab = "%",
        col = "deepskyblue2",
        vertical = TRUE
)    


hist(log_data$W , breaks=100 , border=F , 
     col="deepskyblue2", xlab="log(W)", xlim=c(-15, 5), main="")

#Structure boxplot
hist(orig_data1$S , breaks=100 , border=F , col="mediumorchid1", xlab="points/m2" , main="")
boxplot(orig_data1$S,
        xlab = "S",
        ylab = "points/m2",
        col = "mediumorchid1",
        vertical = TRUE
)

hist(log_data$S , breaks=100 , border=F , 
     col="mediumorchid1", xlab="log(S)", main="")

# HD boxplot
hist(orig_data1$HD , breaks=100 , border=F , col="green3", xlab="%" , main="")
boxplot(orig_data1$HD,
        xlab = "HD",
        ylab = "%",
        col = "green3",
        vertical = TRUE
)

# R boxplot
hist(orig_data1$R , breaks=100 , border=F , col="darkgrey", xlab="m/m2" , main="")
boxplot(orig_data1$R,
        xlab = "R",
        ylab = "m/m2",
        col = "darkgrey",
        vertical = TRUE
)


# VD boxplot
hist(orig_data1$VD , breaks=100 , border=F , col="forestgreen", xlab="points/m2" , main="")
boxplot(orig_data1$VD,
        xlab = "VD",
        ylab = "points/m2",
        col = "forestgreen",
        vertical = TRUE
)

     





