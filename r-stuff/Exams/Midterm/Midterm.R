#************************************
# Midterm.R
#************************************

# For Windows:

datadir <- "C:/Users/Erik Skipper/Desktop/r-apma-6430/Data/Housing-Prices"
sourcedir <-"C:/Users/Erik Skipper/Desktop/r-apma-6430/R"

# For Mac:

# datadir <- "~/Desktop/r-apma-6430/Data/Housing-Prices"
# sourcedir <-"~/Desktop/r-apma-6430/R"

setwd(datadir)

housing <- read.csv('housing-prices.csv',sep=',',header=T)

summary(housing)

# Libraries

library(ggplot2)
library(ggpubr)
library(ggbiplot)
library(lattice)
library(MASS)
library(lindia)
library(boot)
library(olsrr)

# .R Files

setwd(sourcedir)

source("PCAplots.R")
source("SPM_Panel.R")

# Question 1

# Get the values in the box plot for Price
housebox <- ggplot(housing, aes(y=Price)) + geom_boxplot()
housebox

# Possible values (i.e., names)
names(ggplot_build(housebox)$data[[1]])

# Get the outliers
outliers.one <- ggplot_build(housebox)$data[[1]]$outliers
outliers.one
table(outliers.one)

# Answer for Question 1: 
# 7

# Question 2-3

# Create a scatter plot
uva.pairs(housing[,c("Rooms","Baths","Size","Price")])

# Answer for Question 2:
# C. Size

# Answer for Question 3: 
# 0.84

# Question 4-9

# Answer for Question 4:
# B. y= B0+B1X1+e where X1 = Baths

# Create a main effects model using Baths
houses.lm1 <-lm(Price~Baths,data=housing)
summary(houses.lm1)

# Answer for Question 5:
# A. It is positive.

# Answer for Question 6:
# 95299

# Answer for Question 7:
# B. y= B0 + B1X1 + B2X2 + B3X3 + B4X4 + e where X1 = Baths, X2 = Rooms, X3 = 1 if Old; 0
# otherwise, X4 =Size

# Answer for Question 8:
# D. y= B0 + B1X1 + B2X2 + B3X1X2 + e where X1 = Size X2 = 1 if Old; 0 otherwise

# Answer for Question 9:
# Parameters: 4
# Coefficients: 3

# Question 10-12:

# Convert Age into a qualitative variable
age <- rep(0, nrow(housing))
age[which(housing$Age == "Old")] <- "Old"
age[which(housing$Age == "New")] <- "New"
age <- as.factor(age)
contrasts(age)

# Create a main effects model using Baths, Rooms, age, and Size
houses.lm2<-lm(Price~Baths + Rooms + age + Size,data=housing)
summary(houses.lm2)

# Create a partial F test
anova(houses.lm1,houses.lm2)

# Answer for Question 10:
# C. B2=B3=B4=0

# Answer for Question 11:
# C. 2.2e-16 ***

# Answer for Question 12:
# A. Reject the null hypothesis and therefore use the larger model with additional terms.

# Question 13-14

# Create a stepwise model from main effects + interaction model for Baths, Rooms, age, and Size
houses.lm3.step<-lm(Price~(Baths + Rooms + age + Size)^2,data=housing)
summary(houses.lm3.step)
AIC(houses.lm3.step)

# Answer for Question 13:
# 2504.967 or 2505

# Answer for Question 14:
# 4

# Question 15

# Plot it; you will have to press Enter/Return four times in the Console
plot(houses.lm3.step,labels.id = NULL)
# gg_diagnose(houses.lm3.step)
plot(houses.lm3.step,labels.id = NULL, which=4)

# Answer for Question 15:

# B. There is Non-constant variance in the residual vs. fitted.
# D. The QQ plot shows non-Gaussian tails.
# E. There is at least 1 influential points (Cook's D > 1.0).

# Question 16

# Create a Box-Cox plot or two
boxcox(houses.lm3.step)
gg_boxcox(houses.lm3.step)

# Answer for Question 16:
# C. Yes, I recommend a power transformation.

# Question 17-18

# Create a Cook's distance plot
plot(houses.lm3.step,labels.id = NULL, which=4)

# Create a nicer Cook's distance plot
p4<- gg_cooksd(houses.lm3.step, label = TRUE, show.threshold = TRUE,
               threshold = "convention", scale.factor = 1) +
  xlab("Obs. Number")+ylab("Cook's distance") +
  ggtitle("Cook's distance plot")+
  theme(plot.title = element_text(hjust = 0.5), plot.caption = element_text(hjust = 0.5))

p4

# Answer for Question 17:
# 64, 3, 3, 225000

# Answer for Question 18:
# D. Age

# Question 19-22

# PCA
houses.pca.cor <- princomp(housing[,c("Rooms","Baths","Size","Price")], cor = T)
houses.pca.cor
biplot(houses.pca.cor, main="Biplot of 4 Metrics")
barplot(houses.pca.cor$loadings[,1], main='PC1 Loadings')
barplot(houses.pca.cor$loadings[,2], main='PC2 Loadings')

# Answer for Question 19:
# A. Price
# D. Size

# Answer for Question 20:
# A. Rooms
# B. Baths
# C. Size

# Answer for Question 21:
# A. Price
# B. Rooms

# Answer for Question 22:
# C. Size

# Question 23

# Create a Scree plot
screeplot(houses.pca.cor, main = "Variance of each PC using Correlation Matrix")

# Answer for Question 23:
# A. The variance significantly drops from PC 1 to PC 2.

# Question 24

# More PCA
corr_cumsum <- cumplot(houses.pca.cor, col = "blue")
corr_cumsum_plot <- ggplot(data=corr_cumsum, aes(x=Component,y=Proportion))  + geom_bar(stat="identity") + 
  ggtitle("Correlation Matrix")
corr_cumsum_plot
summary(corr_cumsum)

# Answer for Question 24:
# 3

# Question 25-26

# Create a biplot
biplot(houses.pca.cor, main="Biplot of 4 Metrics")

# Answer for Question 25:
# C. Price and Size

# Answer for Question 26:
# A. Price and Rooms

# Question 27

library(ggfortify)

# Plotting it by Age/color
autoplot(houses.pca.cor, data = housing, colour = 'Age')

# Answer for Question 27:
# B. There is no pattern to the points in the biplot.

# Question 28

# Clear your Console, Environment, and Plots

# For Windows:

datadir <- "C:/Users/Erik Skipper/Desktop/r-apma-6430/Data/Country-Data"
sourcedir <-"C:/Users/Erik Skipper/Desktop/r-apma-6430/R"

# For Mac:

# datadir <- "~/Desktop/r-apma-6430/Data/Country-Data"
# sourcedir <-"~/Desktop/r-apma-6430/R"

setwd(datadir)

country <- read.csv('Country-data.csv',sep=',',header=T)

summary(country)

# Libraries

library(ggplot2)
library(ggpubr)
library(ggbiplot)
library(lattice)
library(MASS)
library(lindia)
library(boot)
library(olsrr)

# .R Files

setwd(sourcedir)

source("PCAplots.R")
source("SPM_Panel.R")

# Get the values in the box plot for child_mort
countrybox <- ggplot(country, aes(y=child_mort)) + geom_boxplot()
countrybox

# Possible values (i.e., names)
names(ggplot_build(countrybox)$data[[1]])

# Get the outliers
outliers.two <- ggplot_build(countrybox)$data[[1]]$outliers
outliers.two
table(outliers.two)

# Answer for Question 28:
# 4

# Question 29

# Since we know the "smallest" outlier is 149, get the index of the outliers that are >= 149
which(country$child_mort >= 149)
country$country[32]
country$country[33]
country$country[67]
country$country[133]

# Answer for Question 29:
# Haiti, Sierra Leone, Chad, Central African Republic

# Question 30

# Get the index of the country that has the lowest child_mort
which(country$child_mort == min(country$child_mort))
country$country[69]

# Answer for Question 30:
# Iceland

# Question 31

# Create a scatter plot
uva.pairs(country[,c("child_mort","exports","health","imports","income","inflation","life_expec","total_fer","gdpp")])

# Answer for Question 31:
# F. life_expec

# Question 32-34

# PCA
country.pca.cor <- princomp(country[,c("child_mort","exports","health","imports","income","inflation","life_expec","total_fer","gdpp")], cor = T)
country.pca.cor
biplot(country.pca.cor, main="Biplot of 9 Metrics")
barplot(country.pca.cor$loadings[,1], main='PC1 Loadings')

corr_cumsum <- cumplot(country.pca.cor, col = "blue")
corr_cumsum_plot <- ggplot(data=corr_cumsum, aes(x=Component,y=Proportion))  + geom_bar(stat="identity") + 
  ggtitle("Correlation Matrix")
corr_cumsum_plot
summary(corr_cumsum)

# Answer for Question 32:
# 5

# Answer for Question 33:
# G. total_fer

# Answer for Question 34:
# C. imports

# Question 35

country$country[92]
country$child_mort[92]

# Answer for Question 35:
# Luxembourg
# 2.8

# Question 36-38

# More PCA
barplot(country.pca.cor$loadings[,2], main='PC2 Loadings')
summary(country.pca.cor)
str(country.pca.cor)

country$country[134]
country$child_mort[134]

# Answer for Question 36:
# Singapore
# 2.8

# Answer for Question 37:
# C. 2

# Answer for Question 38:
# B. exports
# D. imports