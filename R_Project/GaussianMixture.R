# Plot our dataset.
plot(iris[, 1:4], col = iris$Species, pch = 18, main = "Fisher's Iris Dataset")
head(iris)

#load and prep data
gm <- read.csv("C:\\###Dace\\2021_2022\\###Master\\Data\\Final_data\\table2.csv")
plot(gm[, 5:9], col = gm$Code_area, pch = 18)

gm1 <- gm[, 5:9]
gm1 <- scale(gm1)

head(gm1)

require(mclust)

# Mclust comes with a method of hierarchical clustering. We'll
# initialize 3 different classes.
initialk <- mclust::hc(data = gm1, modelName = "EII")
initialk <- mclust::hclass(initialk, 3)

# First split by class and calculate column-means for each class.
mu <- split(gm1 [, 1:5], initialk)
mu <- t(sapply(mu, colMeans))

# Covariance Matrix for each initial class.
cov <- list(diag(4), diag(4), diag(4))

# Mixing Components
a <- runif(3)
a <- a/sum(a)