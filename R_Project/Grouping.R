rm(list = ls(all = TRUE))
graphics.off()
shell("cls")

library(factoextra)
library(cluster)
library(dbscan)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(corrplot)
library(readr)
library(data.table)
library(psycho)
library(gridExtra)
library(cowplot)
library(ggpubr)
library(ggsci)


#1. LOAD DATA (Variables are MIN-MAX normalized )

#Load and prepare data (Density (Distribution)/Scale/Standardize)

gr0 <- read.csv("C:\\###Dace\\2021_2022\\###Master\\Data\\Final_data\\burough.csv")
# df1 <- data.frame(df0[, c(5:10)])

burough <- gr0 %>% group_by(Burough_na)
burough

bb <- burough %>% summarise(
  S = mean(S),
  W = mean(W),
  R = mean(R),
  HD= mean(HD),
  VD = mean(VD),
  Ar_log = mean(Ar_log))
 
# bb <- format(round(bb[, c(2:7)], 2), nsmall = 2)

#1. Stacked Barchart

#bb2 <- bb %>% 
#gather(Legend, Value, -c(Burough_na))

bb2$Legend <- factor(bb2$Legend,levels = c("S", "W", "R", "HD", "VD", "Ar_log"))

bb %>% 
  gather(Legend, Value, -c(Burough_na)) %>% 
  mutate(Legend=fct_reorder(Legend, Value)) %>% 
  ggplot(aes(Burough_na, Value, label = Value)) +
  geom_col(aes(fill = Legend, color = "")) +
  labs(x = "Mean Values per Buroughs") +
  scale_fill_manual(values = c("#E7B800", "#4E84C4", "#999999", 
                               "#D16103", "#C3D7A4", "#52854C")) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 


##geom_text(size = 5, position = position_stack(vjust = 0.5))

#2. Barplots per Variable

#par(mfrow = c(2, 3))

#Area Logaritmic
Area_boxplot <- gr0 %>%
  mutate(class = fct_reorder(Burough_na, Ar_log, .fun='length' )) %>%
  ggplot( aes(x=Burough_na, y=Ar_log)) + 
  geom_boxplot(colour = "black", fill = "#D16103") +
  theme(legend.position="none") +
  xlab("") +
  xlab("") +
  ylab("") +
  ylab("") +
  labs(x = "Area") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 

# Roads
R_boxplot <- gr0 %>%
  mutate(class = fct_reorder(Burough_na, R, .fun='length' )) %>%
  ggplot( aes(x=Burough_na, y=R,)) + 
  geom_boxplot(colour = "black", fill = "grey") +
  theme(legend.position="none") +
  xlab("") +
  xlab("") +
  ylab("") +
  ylab("") +
  labs(x = "Trails") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 

# Water
W_boxplot <- gr0 %>%
  mutate(class = fct_reorder(Burough_na, W, .fun='length' )) %>%
  ggplot( aes(x=Burough_na, y=W,)) + 
  geom_boxplot(colour = "black", fill = "#4E84C4") +
  theme(legend.position="none") +
  xlab("") +
  xlab("") +
  ylab("") +
  ylab("") +
  labs(x = "Water Objects") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 

# Structures
S_boxplot <- gr0 %>%
  mutate(class = fct_reorder(Burough_na, S, .fun='length' )) %>%
  ggplot( aes(x=Burough_na, y=S,)) + 
  geom_boxplot(colour = "black", fill = "#E7B800") +
  theme(legend.position="none") +
  xlab("") +
  xlab("") +
  ylab("") +
  ylab("") +
  labs(x = "Structures") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 

# Horizontal Density
HD_boxplot <- gr0 %>%
  mutate(class = fct_reorder(Burough_na, HD, .fun='length' )) %>%
  ggplot( aes(x=Burough_na, y=HD,)) + 
  geom_boxplot(colour = "black", fill = "#C3D7A4") +
  theme(legend.position="none") +
  xlab("") +
  xlab("") +
  ylab("") +
  ylab("") +
  labs(x = "Horizontal Density") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 

# Vertical Density
VD_boxplot <- gr0 %>%
  mutate(class = fct_reorder(Burough_na, VD, .fun='length' )) %>%
  ggplot( aes(x=Burough_na, y=VD,)) + 
  geom_boxplot(colour = "black", fill = "#52854C") +
  theme(legend.position="none") +
  xlab("") +
  xlab("") +
  ylab("") +
  ylab("") +
  labs(x = "Vertical Density") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 


plot_grid(Area_boxplot, R_boxplot, S_boxplot, W_boxplot, HD_boxplot, VD_boxplot)

## Amount of parks per burough
ggplot(data = gr0) + 
  geom_bar(mapping = aes(x = Burough_na, fill = Cluster1_4), colour = "black", fill = "orange") +
  labs(x = "Amount of Parks per Burough") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 

## Buroughs by clusters

c0 <- gr0 %>% group_by(Burough_na, Cluster1_4)


f1 <- filter(c0, Cluster1_4 == 1)
f2 <- filter(c0, Cluster1_4 == 2)
f3 <- filter(c0, Cluster1_4 == 3)
f4 <- filter(c0, Cluster1_4 == 4)

c1 <- f1 %>% 
  summarise((n = n()))
c2 <- f2 %>% 
  summarise((n = n()))
c3 <- f3 %>% 
  summarise((n = n()))
c4 <- f4 %>% 
  summarise((n = n()))

merge1 <- merge(x=c1,y=c2, by="Burough_na", all=TRUE)
merge2 <- merge(x=c3,y=c4, by="Burough_na", all=TRUE)
merge <- merge(x=merge1,y=merge2, by="Burough_na", all=TRUE)

names(merge)[3] <- "c1"
names(merge)[5] <- "c2"
names(merge)[7] <- "c3"
names(merge)[9] <- "c4"

merge <- merge[ -c(2,4,6,8) ]

merge[is.na(merge)] <- 0



merge %>% 
  gather(Legend, Value, -c(Burough_na)) %>% 
  ggplot(aes(Burough_na, Value, label = Value)) +
  geom_col(aes(fill = Legend, color = "")) +
  labs(x = "Clusters Values per Buroughs") +
  scale_fill_manual(values = c("dark red", "blue", "orange", 
                               "dark green")) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 
