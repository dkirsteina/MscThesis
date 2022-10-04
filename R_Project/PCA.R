rm(list = ls(all = TRUE))
graphics.off()
shell("cls")


toInstall <- c("cluster", "fpc", "mclust")
install.packages(toInstall, dependencies=TRUE)
install_github("vqv/ggbiplot")
install.packages("factoextra")
install.packages("corrplot")            # Install & load corrplot package
install.packages("ggcorrplot")
library(factoextra)
library(devtools)
library(ggbiplot)
library("corrplot")
library(tidyverse)
library(ggplot2)
library(ggcorrplot)
ggcorrplot(r)

#1. Load data
mydata <- read.csv("C:\\###Dace\\2021_2022\\###Master\\Data\\Final_data\\table2.csv")
mydata1 <- data.frame(mydata[, c(5:10)])

#mydata1 <- scale(mydata1) # standardize variables


#2. Compute PCA
mydata.pca <- prcomp(mydata1, center = TRUE, scale. = TRUE)

print(mydata.pca)
summary(mydata.pca)

str(mydata.pca)


#3. Visualize eigenvalues (scree plot). Show the percentage of variances explained by each principal component.

eig.val <- get_eigenvalue(mydata.pca)
eig.val

fviz_eig(mydata.pca, addlabels = TRUE, ylim = c(0, 30))

var <- get_pca_var(mydata.pca)
var

#4. Coordinates for the variables
head(var$coord)
fviz_pca_var(mydata.pca, col.var = "red")


#5. Cos2: quality on the factor map
head(var$cos2)

#Color by cos2 values: quality on the factor map
fviz_pca_var(mydata.pca, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE # Avoid text overlapping
)

# Total cos2 of variables on Dim.1 and Dim.2
fviz_cos2(mydata.pca, choice = "var", axes = 1:2, fill = "deepskyblue4", color = "black") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=0))

# cos2 of variables on Dim.1
fviz_cos2(mydata.pca, choice="var", axes = 1,
          fill = "deepskyblue3", color = "black") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=0))

# cos2 of variables on Dim.1
fviz_cos2(mydata.pca, choice="var", axes = 2,
          fill = "deepskyblue3", color = "black") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=0))

corrplot(var$cos2, is.corr=FALSE, method="color", outline = TRUE, tl.col = "black", addCoef.col = 1)

#6. Contributions to the principal components
head(var$contrib)

# Most contributing variables for each dimension
corrplot(var$contrib, is.corr=FALSE, method="color", outline = TRUE, tl.col = "black", addCoef.col = 1) 

#Correlation matrix
M<-cor(mydata1)
corrplot(M, method="number")

ggcorrplot(M, 
           hc.order = TRUE, 
           type = "lower",
           colors = c("#061d9e", "white", "red"),
           lab = TRUE)

#Contributions of variables to PC1 and PC2

fviz_contrib(mydata.pca, choice = "var", axes = 1:2, fill = "deepskyblue4", color = "black") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=0))

# Contributions of variables on PC1

fviz_contrib(mydata.pca, choice = "var", axes = 1, fill = "deepskyblue3", color = "black") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=0))

# Contributions of variables to PC2
fviz_contrib(mydata.pca, choice = "var", axes = 2, fill = "deepskyblue3", color = "black") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=0))

# Graph of variables. Positive correlated variables point to the same side of the plot. Negative correlated variables point to opposite sides of the graph.

fviz_pca_var(mydata.pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)


