#************************************
# Final.R
#************************************

#************************************
# Part 1
#************************************

# For Windows:

datadir <- "C:/Users/Erik Skipper/Desktop/r-apma-6430/Data/App"
sourcedir <-"C:/Users/Erik Skipper/Desktop/r-apma-6430/R"

# For Mac:

# datadir <- "~/Desktop/r-apma-6430/Data/App"
# sourcedir <-"~/Desktop/r-apma-6430/R"

setwd(datadir)

app <- read.csv('app.csv',sep=',',header=T)

summary(app)

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

source("SPM_Panel.R")
source("PCAplots.R")
source("FactorPlots.R")
source("pc.glm.R")
source("ROC.R")
source("TestSet.R")

# Question 1

appbox <- ggplot(app, aes(y=Price)) + geom_boxplot()
appbox

appbox.outliers <- ggplot_build(appbox)$data[[1]]$outliers
names(ggplot_build(appbox)$data[[1]])
table(appbox.outliers)

# Answer = 1

# Question 2

app.tiny <- app

app.tiny$Platform<-as.factor(app.tiny$Platform)

uva.pairs(app.tiny[,c("Price","Platform","Develop","X5Star","CompSites","Date","Advert","Users")])

# Answer = E. Date

# Question 3

# Answer = Short Answer

# Question 4

app.interaction<-lm(Price~(Platform + Users)^2,data=app.tiny)
summary(app.interaction)
AIC(app.interaction)
summary(app.interaction)$adj.r.squared

# Answer = 208.1062, 0.3186976

# Question 5

app.main<-lm(Price~Platform + Develop + X5Star + CompSites + Date + Advert + Users,data=app.tiny)
summary(app.main)
AIC(app.main)
summary(app.main)$adj.r.squared

# Answer = 190.2863, 0.6522624

# Question 6

anova(app.interaction,app.main)

# Answer = B

# Question 7

par(mfrow=c(2,4))
plot(app.main,labels.id = NULL)
plot(app.main,labels.id = NULL, which=4)

p4<- gg_cooksd(app.main, label = TRUE, show.threshold = TRUE,
               threshold = "convention", scale.factor = 1) +
  xlab("Obs. Number")+ylab("Cook's distance") +
  ggtitle("Cook's distance plot")+
  theme(plot.title = element_text(hjust = 0.5), plot.caption = element_text(hjust = 0.5))

p4

ols_test_breusch_pagan(app.main)

# Answer = C, D

# Question 8

boxcox(app.main)
gg_boxcox(app.main)

# Question 9

# Answer = A, F

# Question 10

app.pca.cor <- princomp(app[,c("Price","Develop","X5Star","CompSites","Date","Users")], cor = T)
app.pca.cor
biplot(app.pca.cor, main="Biplot of 4 Metrics")
barplot(app.pca.cor$loadings[,1], main='PC1 Loadings')

# Answer = B, H

#************************************
# Part 2
#************************************

# For Windows:

datadir <- "C:/Users/Erik Skipper/Desktop/r-apma-6430/Data/Heart"
sourcedir <-"C:/Users/Erik Skipper/Desktop/r-apma-6430/R"

# For Mac:

# datadir <- "~/Desktop/r-apma-6430/Data/Heart"
# sourcedir <-"~/Desktop/r-apma-6430/R"

setwd(datadir)

heart <- read.csv('heart.csv',sep=',',header=T)

summary(heart)

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

source("SPM_Panel.R")
source("PCAplots.R")
source("FactorPlots.R")
source("pc.glm.R")
source("ROC.R")
source("TestSet.R")

# Question 11

# Answer = See PDF

# Question 12

heart.tiny <- heart

heart.tiny$sex <- as.factor(heart.tiny$sex)
heart.tiny$cp <- as.factor(heart.tiny$cp)
heart.tiny$fbs <- as.factor(heart.tiny$fbs)
heart.tiny$restecg <- as.factor(heart.tiny$restecg)
heart.tiny$diag <- as.factor(heart.tiny$diag)

heart.tiny.glm1 <-glm(diag~age + cp + sex, data=heart.tiny, family=binomial)
heart.tiny.null <- glm(diag~1, data = heart.tiny, family = binomial)
anova(heart.tiny.null, heart.tiny.glm1, test = "Chi")

# Answer = A

# Question 13

anova(heart.tiny.null, heart.tiny.glm1, test = "Chi")

# Answer = C

# Question 14

summary(heart.tiny.glm1)
(exp(heart.tiny.glm1$coefficients[2])-1)*100

# Answer = 6.14224

# Question 15

summary(heart.tiny.glm1)

# Answer = D

# Question 16

heart.tiny.glm2 <-glm(diag~age + cp + sex + restbps + chol + fbs, data=heart.tiny, family=binomial)
anova(heart.tiny.null, heart.tiny.glm2, test = "Chi")
anova(heart.tiny.glm1, heart.tiny.glm2, test = "Chi")

# Answer = C

# Question 17

anova(heart.tiny.null, heart.tiny.glm2, test = "Chi")
anova(heart.tiny.glm1, heart.tiny.glm2, test = "Chi")

# Answer = B, C

# Question 18

# heart.tiny$restecg <- as.factor(heart.tiny$restecg)

heart.tiny.glm3 <-glm(diag~age + cp + sex + restbps + chol + fbs + restecg, data=heart.tiny, family=binomial)
# anova(heart.tiny.null, heart.tiny.glm3, test = "Chi")

heart.tiny.glm3.step <- step(heart.tiny.glm3, trace = 0) 
summary(heart.tiny.glm3.step)

# Answer = A, B, C, F

# Question 19

heart.tiny.glm4 <-glm(diag~chol, data=heart.tiny, family=binomial)
# anova(heart.tiny.null, heart.tiny.glm4, test = "Chi")
# anova(heart.tiny.null, heart.tiny.glm3.step, test = "Chi")
anova(heart.tiny.glm4, heart.tiny.glm3.step, test = "Chi")

# Answer = C

# Question 20

heart.tiny.glm3.step.pred <- predict(heart.tiny.glm3.step, type = "response")
score.table(heart.tiny.glm3.step.pred, heart.tiny$diag, .5)

# Answer = 92, 52, 40

# Question 21

plot.roc(heart.tiny.glm3.step.pred, heart.tiny$diag, main = "ROC Curve - Heart Filter", col = "blue")
roc.plot.gg <- plot.roc.gg(heart.tiny.glm3.step.pred, heart.tiny$diag, "Main Effects")
roc.plot.gg

# Answer = 0.85

# Question 22

# Answer = A, D, E

# Question 23

heart.pca.cor <- princomp(heart.tiny[,c("age","restbps","chol")], cor = T)
heart.pca.cor
biplot(heart.pca.cor, main="Biplot of 4 Metrics")
barplot(heart.pca.cor$loadings[,1], main='PC1 Loadings')

corr_cumsum <- cumplot(heart.pca.cor, col = "blue")
corr_cumsum_plot <- ggplot(data=corr_cumsum, aes(x=Component,y=Proportion))  + geom_bar(stat="identity") + 
  ggtitle("Correlation Matrix")
corr_cumsum_plot
summary(corr_cumsum)

# Answer = 77

# Question 24

heart.pca.cor.glm75 <- pc.glm(heart.pca.cor, 75, heart.tiny$diag)
summary(heart.pca.cor.glm75)
heart.pca.cor.glm75.null <- pc.null(heart.pca.cor, 75, heart.tiny$diag)
anova(heart.pca.cor.glm75.null, heart.pca.cor.glm75, test = "Chi")

# Answer = A

# Question 25

AIC(heart.pca.cor.glm75)
AIC(heart.tiny.glm3.step)

# Answer = 511.4291, 397.2813

# Question 26

heart.pca.cor.glm75.pred <- predict(heart.pca.cor.glm75, type = "response")
score.table(heart.pca.cor.glm75.pred, heart.tiny$diag, .5)

# Answer = 143, 71, 72

# Question 27

# Answer = Final.R