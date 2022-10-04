# ---------------------------------------
# Visualize PCA (Biplot) using base functions
# ---------------------------------------
# clear data and values in golbal environment and close windows or plots
# shell("cls") = Clear console

rm(list = ls(all = TRUE))
graphics.off()
shell("cls")

#------
# Importing data
#------

mydata <- read.csv("C:\\###Dace\\2021_2022\\###Master\\Data\\Final_data\\table2.csv")
mydata1 <- data.frame(mydata[, c(5:10)])


head(mydata1)

#------
# Principal component analysis
#------

require(stats)

pc <- prcomp(x = mydata1,       # Give response variable range
             scale = TRUE, center = TRUE)
print(pc)
summary(pc)

#------
# Visualizing biplot using base functions
#------
# Package required for base graphics system

require(graphics)

# Create a new plot frame

par()

par(pty = "s",
    cex.main = 1.2,
    cex.lab = 1,
    font.main = 2,
    font.lab = 2,
    family = "sans",
    col.main = "gray10",
    col.lab = "gray10",
    fg = "gray10",            # color for axis and boxes around the plot
    las = 1)

plot.new()

range(pc$rotation[,1])
range(pc$rotation[,2])

plot.window(xlim = c(-1, 1), 
            ylim = c(-1, 1), 
            asp = 1)


#------
# Add X and Y axis to the plot
#------
# Use axis function only when axes = False in plot() function

axis(side = 1, 
     at = c(-1, -0.5, 0, 0.5, 1),
     labels = TRUE)

axis(side = 2, 
     at = c(-1, -0.5, 0, 0.5, 1),
     labels = TRUE)


#------
# Add labels to plot
#------
#/n carriage return character: plot title on several lines
# Add main title

title(main = "Biplot for PCs of park data", 
      line = 3,
      adj = 0)

# Add X and Y labels

title(xlab = paste("PC 1 (", 
                   round(summary(pc)$importance[2]*100, 
                         digits = 1),
                   "%)", 
                   sep = ""), 
      ylab = paste("PC 2 (", 
                   round(summary(pc)$importance[5]*100, 
                         digits = 1),
                   "%)", 
                   sep = ""), 
      line = 2,
      adj = 0.5)              # centered justified                  


#------
# Add points or objects to the plot
#------

points(x = pc$x[,1:6],
       pch = c(rep(16)),
               
       cex = 1,
       col = c(rep("orangered")))
        

#------
# Add ellipse to the plot
#------
# Load package

library(ellipse)

# Plot ellipse

polygon(ellipse(x = cor(pc$x[1:100, 1], pc$x[1:100, 2]),
                centre = colMeans(pc$x[1:100, 1:2]),
                level = 0.85),
        border = "gray10",
        lty = "solid",
        lwd = 1.5,
        col = adjustcolor("darkcyan", alpha.f = 0.20))

polygon(ellipse(x = cor(pc$x[101:200, 1], pc$x[101:200, 2]),
                centre = colMeans(pc$x[101:200, 1:2]),
                level = 0.85),
        border = "gray10",
        lty = "solid",
        lwd = 1.5,
        col = adjustcolor("orangered", alpha.f = 0.20))

#------
# Add second axis for variable vectors to the plot
#------
# Allow a second plot on the same graph. This will create a second axis without clearing the graphics device

par(new = TRUE, las = 1)

plot.window(xlim = c(-1, 1), 
            ylim = c(-1, 1), 
            asp = 1)

axis(side = 3, 
     at = c(-1, 0.5, 0, -0.5, 1), 
     labels = TRUE, 
     col = "navy",
     col.ticks = NULL,
     lwd = 2,
     col.axis = "navy")

axis(side = 4, 
     at = c(-1, 0.5, 0, -0.5, 1), 
     labels = TRUE, 
     col = "navy",
     col.ticks = NULL,
     lwd = 2,
     col.axis = "navy")

# Adding labels for second axis

mtext((text = "PC 1 rotations"), 
      side = 3,
      cex = 1,
      font = 2,
      family = "sans",
      col = "gray10", 
      line = 2) 

mtext((text = "PC 2 rotations"), 
      side = 4,
      cex = 1,
      font = 2,
      family = "sans",
      col = "gray10", 
      line = 2,
      las = 3) 


#------
# Draw a box around the plot and straight lines
#------

box()

# Add straight lines

abline(v = 0, h = 0, lty = 2, col = "grey25")


#------
# Add variable vectors or arrows to the plot
#------
# length = length of the edges of the arrow head (in inches)

arrows(x0 = 0, x1 = pc$rotation[,1], 
       y0 = 0, y1 = pc$rotation[,2], 
       col = "navy", 
       length = 0.08, 
       lwd = 2,
       angle = 30)


#------
# Add variable labels
#------
# pos =  a position specifier of the text. 1 below, 2 to the left of, 3 above, 4 to the right of the specified (x,y) coordinates.

text(x = pc$rotation[,1], y = pc$rotation[,2], 
     labels = row.names(pc$rotation), 
     cex = 1.2,
     font = 2,
     col = "gray10", 
     pos = c(4, 3, 2, 1, 3, 1))

# ------
# Add circle for the correlations of the original variables with the PCs
# ------

ucircle = cbind(cos((0:360)/180*pi), 
                sin((0:360)/180*pi))

polygon(ucircle, 
        lty= "solid", border = "gray10", lwd = 1)



#------
# Add legend
#------

# legend(x = "topleft", 
#      legend = c("1","2"),
#      pch = c(16, 17),
#      col = c("darkcyan", "orangered"),
#      text.font = 2,
#      cex = 1.0,
#      pt.cex = 1.0,
#      bty = "n",                     # the type of box to be drawn around the legend
#      x.intersp = 0.5,
#      y.intersp = 0.8,
#      xpd = FALSE,             # FALSE(plot region), TRUE(Figure region), NA(Device region)
#      adj = c(0, 0.25))



