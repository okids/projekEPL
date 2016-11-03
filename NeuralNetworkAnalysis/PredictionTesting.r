library(xlsx)
library(neuralnet)
options(StringsAsFactors=F)
mydata <- read.xlsx("C:/Users/Oki.OKI-PC/Documents/Projek EPL/CORE_DATA_PL.xlsx",stringsAsFactors=F, 1)
a=unname(unlist(mydata[1,]))
colnames(mydata)<-a
target_data = mydata[23:42,9:10]
colnames(target_data) <- c("goal_dif","points")
mydata = mydata[-(22:42),]
mydata = mydata[-1,]
mydata = mydata[,-51]
mydata= mydata[,-39]
training_data = mydata[,3:49]
data = training_data
data[,48:49] = target_data
index <- sample(1:nrow(data),round(1*nrow(data)))
train <- data[index,]
test <- data[-index,]
n <-names(train[,1:48])
train <- lapply(train,as.double)
test <- lapply(test,as.double)
train <-as.data.frame(train)



mydata2 <- read.xlsx("C:/Users/Oki.OKI-PC/Documents/Projek EPL/CORE_DATA_PL.xlsx", stringsAsFactors=F,2)
b=unname(unlist(mydata2[1,]))
colnames(mydata2)<-b
target_data2 = mydata2[24:43,9:10]
colnames(target_data2) <- c("goal_dif","points")
mydata2 = mydata2[-(22:64),]
mydata2 = mydata2[-1,]
mydata2 = mydata2[,-51]
mydata2 = mydata2[,-39]
training_data2 = mydata2[,3:49]
testdata = training_data2
testdata[,48:49] = target_data2

testdata  <- lapply(testdata,as.double)
testdata <- as.data.frame(testdata)



c <- c()
corVal<-c()
index = 1
for(i in 1:47){
	if (abs(cor(train[,i],train[,49])) > 0.7 && i!=35){
		c[index] = i
		corVal[index] = abs(cor(train[,i],train[,49]))
		train[,i]<- jtrans(train[,i])$transformed
		testdata [,i]<- jtrans(testdata [,i])$transformed
		index = index +1
	}
}




f <- as.formula(paste("points~", paste(n[!n %in% "points"][c], collapse = " + ")))
creditnet <- neuralnet(f, train, hidden = 100)
ols <- aov(f,train)
ridge.final <- lm.ridge (f,train)
par(mfrow=c(2,1))
testdata[,50]=mydata2[,2]
predict = compute(creditnet,testdata[,c])
pred.ols <- predict(ols,testdata[,c])
cf.ridge = coef(ridge.final) 
index=2
pred.ridge <- cf.ridge[1]
for (i in c){
	pred.ridge <- pred.ridge + cf.ridge[index]*testdata[,index]
}

predicted=predict$net.result
predicted2 = pred.ols

plot(testdata$points,predicted,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
text(testdata$points,predicted, labels=testdata$V50, cex= 0.7)
legend('bottomright',legend='NN',pch=18,col='red', bty='n')

plot(testdata$points,predicted2,col='red',main='Real vs predicted using LM',pch=18,cex=0.7)
abline(0,1,lwd=2)
text(testdata$points,predicted2, labels=testdata$V50, cex= 0.7)
legend('bottomright',legend='LM',pch=18,col='red', bty='n')


errorTable1 = abs(testdata$points - predicted2)
MSE.lm <- sum(errorTable1)/length(predicted2)
write.table(round(predicted2), "C:/Users/Oki.OKI-PC/Documents/Projek EPL/resultLM.txt", sep="\t")
print(MSE.lm)

errorTable2 = abs(testdata$points - predicted)
MSE.nn2 <- sum(errorTable2)/length(predicted)
write.table(round(predicted), "C:/Users/Oki.OKI-PC/Documents/Projek EPL/resultNN.txt", sep="\t")
print(MSE.nn2)

errorTable3 = abs(testdata$points - pred.ridge)
MSE.ridge <- sum(errorTable3)/length(pred.ridge)
write.table(round(pred.ridge), "C:/Users/Oki.OKI-PC/Documents/Projek EPL/resultRidge.txt", sep="\t")
print(MSE.ridge)


