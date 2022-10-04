library(cluster)
library(ggplot2)
library(ggfortify)

autoplot(clara(df1[,1:5], 2))
autoplot(pam(df1[,1:5], 2), frame = TRUE, frame.type = 'norm')
autoplot(fanny(df1[,1:5], 2), frame = TRUE)

install.packages('dbscan')
install.packages('factoextra')

library("factoextra")

# NOT RUN {
set.seed(123)

# Data preparation
# +++++++++++++++
data("iris")
head(iris)
# Remove species column (5) and scale the data
iris.scaled <- scale(iris[, -5])

# K-means clustering
# +++++++++++++++++++++
km.res <- kmeans(iris.scaled, 3, nstart = 10)

# Visualize kmeans clustering
# use repel = TRUE to avoid overplotting
fviz_cluster(km.res, iris[, -5], ellipse.type = "norm")


# Change the color palette and theme
fviz_cluster(km.res, iris[, -5],
             palette = "Set2", ggtheme = theme_minimal())


# }
# NOT RUN {
# Show points only
fviz_cluster(km.res, iris[, -5], geom = "point")
# Show text only
fviz_cluster(km.res, iris[, -5], geom = "text")

# PAM clustering
# ++++++++++++++++++++
require(cluster)
pam.res <- pam(iris.scaled, 3)
# Visualize pam clustering
fviz_cluster(pam.res, geom = "point", ellipse.type = "norm")

# Hierarchical clustering
# ++++++++++++++++++++++++
# Use hcut() which compute hclust and cut the tree
hc.cut <- hcut(iris.scaled, k = 3, hc_method = "complete")
# Visualize dendrogram
fviz_dend(hc.cut, show_labels = FALSE, rect = TRUE)
# Visualize cluster
fviz_cluster(hc.cut, ellipse.type = "convex")

# }
# NOT RUN {


# }