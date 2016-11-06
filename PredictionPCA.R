workingDir = "C:/Users/Oki.OKI-PC/Documents/projekEPL-master/projekEPL-master"
setwd(workingDir)
train = data_no_save
test = dataTest_saves
pca.train<-subset(train,select=-c(wins,goals,losses,points))
pca.test<-subset(test,select=-c(wins,goals,losses,points))
prin_comp <- prcomp(pca.train, scale. = T)
std_dev <- prin_comp$sdev
pr_var <- std_dev^2
prop_varex <- pr_var/sum(pr_var)
plot(prop_varex, xlab = "Principal Component",
     ylab = "Proportion of Variance Explained",
     type = "b")

train.data <- data.frame(Points = train[,'points'], prin_comp$x)
train.data <- train.data[,1:17]
library(rpart)
library(randomForest)
n=colnames(train.data)
f <- as.formula(paste("Points~", paste(n[!n %in% "Points"], collapse = " + ")))
rpart.model <- randomForest(f,data = train.data)
test.data <- predict(prin_comp, newdata = pca.test)
test.data <- as.data.frame(test.data)
test.data <- test.data[,1:17]
rf.prediction <- predict(rpart.model, test.data)
result<-as.data.frame(round(rpart.prediction))
points = test[,'points']
result<-cbind(result,points)
write.csv(result,'data/PCAresult.csv')
