rm(list = ls(all = TRUE))
graphics.off()
shell("cls")

install.packages("ape")
install.packages("NbClust")
library(ape)
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
library(NbClust)


#1. LOAD DATA (Variables are MIN-MAX normalized )

#Load and prepare data (Density (Distribution)/Scale/Standardize)

df0 <- read.csv("C:\\###Dace\\2021_2022\\###Master\\Data\\Final_data\\table2.csv")
df1 <- data.frame(df0[, c(5:10)])

#Scale Variables
df2 <- scale(df1)
summary(df2)

#2. Evaluate the Correlation between Variables

#Correlation Matrix 1
round(cor(df2),
      digits = 2 # rounded to 2 decimals
)

#Correlation Matrix 2 (plot)
corrplot(cor(df2),
         method="color", 
         outline = TRUE, 
         tl.col = "black", 
         addCoef.col = 1,
         type = "upper" # show only upper side
)

#3. K-MEAN CLUSTER ANALYSIS

#DETERMINE HOW MANY CLUSTERS IS OPTIMAL

# Elbow method
fviz_nbclust(df2, kmeans, method = "wss", linecolor = "blue") +
  geom_vline(xintercept = 4, linetype = 2)+
  labs(subtitle = "Elbow method")

# Silhouette method
fviz_nbclust(df2, kmeans, method = "silhouette", linecolor = "blue")+
  labs(subtitle = "Silhouette method")


#PERFORM K-MEANS CLUSTERING WITH OPTIMAL K

#perform k-means clustering with k = 5 clusters
km <- kmeans(df2, centers = 4, nstart = 50)

#view results
km

#plot results of final k-means model
fviz_cluster(km, data = df2, geom = "point", ellipse.type = "convex")
fviz_cluster(km, data = df2, geom = "point", ellipse.type = "norm")

#find mean of each cluster
aggregate(df2, by=list(cluster=km$cluster), mean)

#add cluster assigment to original data
final_data <- cbind(df2, cluster = km$cluster)

#view final data
head(final_data)


#Copy cluster column to original data

df0$cluster4 <- final_data[, c(7)]
orig_data$cluster4 <- final_data[, c(7)]
###Plot Clusters

par(mfrow = c(2, 2))

#Cluster1
cluster1 <- filter(df0, df0$cluster4 == 1 )
dim(cluster1)
c1_boxplot <- boxplot(cluster1[, c(5:10)] ,xlab="Variables",ylab="Value (0-1)",
        main="Cluster 1", col=c("grey","deepskyblue2", "mediumorchid1", "green3","forestgreen", "tomato1"))
#Boxplot Statistics
#boxplot(cluster1 [, c(5:10)], plot=FALSE)
#Correlation Matrix
#c1_matrix <- corrplot(cor(cluster1[, c(5:10)]),
#method = "number",
#type = "upper" # show only upper side
#)

#Cluster2
cluster2 <- filter(df0, df0$cluster4 == 2 )
dim(cluster2)
c2_boxplot <- boxplot(cluster2 [, c(5:10)],xlab="Variables",ylab="Value (0-1)",
        main="Cluster 2", col=c("grey","deepskyblue2", "mediumorchid1", "green3","forestgreen", "tomato1"))
#Boxplot Statistics
#boxplot(cluster2 [, c(5:10)], plot=FALSE)
#Correlation Matrix
#c2_matrix <- corrplot(cor(cluster2[, c(5:10)]),
#method = "number",
#type = "upper" # show only upper side
#)

#Cluster3
cluster3 <- filter(df0, df0$cluster4 == 3 )
dim(cluster3)
c3_boxplot <- boxplot(cluster3 [, c(5:10)],xlab="Variables",ylab="Value (0-1)",
        main="Cluster 3", col=c("grey","deepskyblue2", "mediumorchid1", "green3","forestgreen", "tomato1"))
#Boxplot Statistics
#boxplot(cluster3 [, c(5:10)], plot=FALSE)
#Correlation Matrix
#c3_matrix <- corrplot(cor(cluster3[, c(5:10)]),
#method = "number",
#type = "upper" # show only upper side
#)

#Cluster4
cluster4 <- filter(df0, df0$cluster4 == 4 )
dim(cluster4)
c4_boxplot <- boxplot(cluster4 [, c(5:10)],xlab="Variables",ylab="Value (0-1)",
                      main="Cluster 4", col=c("grey","deepskyblue2", "mediumorchid1", "green3","forestgreen", "tomato1"))
#Boxplot Statistics
#boxplot(cluster4 [, c(5:10)], plot=FALSE)
#Correlation Matrix
#c4_matrix <- corrplot(cor(cluster4[, c(5:10)]),
#method = "number",
#type = "upper" # show only upper side
#)

#Cluster5
cluster5 <- filter(df0, df0$cluster5 == 5 )
dim(cluster5)
c5_boxplot <- boxplot(cluster5 [, c(5:10)],xlab="Variables",ylab="Value (0-1)",
                      main="Cluster 5", col=c("grey","blue", "magenta", "yellowgreen","forestgreen", "orange"))
#Boxplot Statistics
boxplot(cluster5 [, c(5:10)], plot=FALSE)
#Correlation Matrix
c5_matrix <- corrplot(cor(cluster5[, c(5:10)]),
                      method = "number",
                      type = "upper" # show only upper side
)


#4. Compute hierarchical clustering
res.hc <- df2 %>%
  # Scale the data
  dist(method = "euclidean") %>% # Compute dissimilarity matrix
  hclust(method = "ward.D2")     # Compute hierachical clustering

head(res.hc)
# Cut tree into 5 groups
sub_grp <- cutree(res.hc, k = 5)
 
# Number of members in each cluster
table(sub_grp)
grp_list <- as.list(sub_grp)
grp_list <- as.data.frame(sub_grp)

#add hierarchical cluster assigment to original data
final_data_hier <- cbind(df2, cluster = grp_list$sub_grp)

#Copy cluster column to original data

df0$cluster_h_5 <- final_data_hier[, c(7)]


# Visualize using factoextra
# Cut in 5 groups and color by groups
fviz_dend(res.hc, k = 5, # Cut in four groups
          cex = 0.5, # label size
          k_colors = c("royalblue3", "tomato1", "forestgreen", "yellow2", "purple"),
          color_labels_by_k = TRUE, # color labels by groups
          rect = TRUE # Add rectangle around groups
)

###Plot Hierarchial Clusters

par(mfrow = c(3, 4))

#Cluster1
cluster1 <- filter(df0, df0$cluster_h_5 == 1 )
dim(cluster1)
c1_boxplot <- boxplot(cluster1[, c(5:10)] ,xlab="Variables",ylab="Value (0-1)",
                      main="Cluster 1", col=c("grey","blue", "magenta", "yellowgreen","forestgreen", "orange"))
#Boxplot Statistics
boxplot(cluster1 [, c(5:10)], plot=FALSE)
#Correlation Matrix
c1_matrix <- corrplot(cor(cluster1[, c(5:10)]),
                      method = "number",
                      type = "upper" # show only upper side
)

#Cluster2
cluster2 <- filter(df0, df0$cluster_h_5 == 2 )
dim(cluster2)
c2_boxplot <- boxplot(cluster2 [, c(5:10)],xlab="Variables",ylab="Value (0-1)",
                      main="Cluster 2", col=c("grey","blue", "magenta", "yellowgreen","forestgreen", "orange"))
#Boxplot Statistics
boxplot(cluster2 [, c(5:10)], plot=FALSE)
#Correlation Matrix
c2_matrix <- corrplot(cor(cluster2[, c(5:10)]),
                      method = "number",
                      type = "upper" # show only upper side
)

#Cluster3
cluster3 <- filter(df0, df0$cluster_h_5 == 3 )
dim(cluster3)
c3_boxplot <- boxplot(cluster3 [, c(5:10)],xlab="Variables",ylab="Value (0-1)",
                      main="Cluster 3", col=c("grey","blue", "magenta", "yellowgreen","forestgreen", "orange"))
#Boxplot Statistics
boxplot(cluster3 [, c(5:10)], plot=FALSE)
#Correlation Matrix
c3_matrix <- corrplot(cor(cluster3[, c(5:10)]),
                      method = "number",
                      type = "upper" # show only upper side
)

#Cluster4
cluster4 <- filter(df0, df0$cluster_h_5 == 4 )
dim(cluster3)
c4_boxplot <- boxplot(cluster4 [, c(5:10)],xlab="Variables",ylab="Value (0-1)",
                      main="Cluster 4", col=c("grey","blue", "magenta", "yellowgreen","forestgreen", "orange"))
#Boxplot Statistics
boxplot(cluster4 [, c(5:10)], plot=FALSE)
#Correlation Matrix
c4_matrix <- corrplot(cor(cluster4[, c(5:10)]),
                      method = "number",
                      type = "upper" # show only upper side
)

#Cluster5
cluster5 <- filter(df0, df0$cluster_h_5 == 5 )
dim(cluster3)
c5_boxplot <- boxplot(cluster5 [, c(5:10)],xlab="Variables",ylab="Value (0-1)",
                      main="Cluster 5", col=c("grey","blue", "magenta", "yellowgreen","forestgreen", "orange"))
#Boxplot Statistics
boxplot(cluster5 [, c(5:10)], plot=FALSE)
#Correlation Matrix
c5_matrix <- corrplot(cor(cluster5[, c(5:10)]),
                      method = "number",
                      type = "upper" # show only upper side
)

write.csv(df0,"C:\\###Dace\\2021_2022\\###Master\\Data\\Final_data\\export1.csv", row.names = FALSE)
write.csv(orig_data,"C:\\###Dace\\2021_2022\\###Master\\Data\\Final_data\\export_orig_fin.csv", row.names = FALSE)

