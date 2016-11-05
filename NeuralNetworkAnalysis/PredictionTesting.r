library(xlsx)
library(neuralnet)
library(jtrans)
options(StringsAsFactors=F)
dataTraining <- read.xlsx("C:/Users/Oki.OKI-PC/Documents/Projek EPL/CORE_DATA_PL.xlsx",stringsAsFactors=F, 1)
dataTesting <- read.xlsx("C:/Users/Oki.OKI-PC/Documents/Projek EPL/CORE_DATA_PL.xlsx", stringsAsFactors=F,2)

#dataExtraction
dataTransform<-function(mydata, isDataTesting){

	if( isDataTesting == TRUE ){
		i = 24
		j = 43
		k = 64
	} else {
		i = 23
		j = 42
		k = 42
	}
	a=unname(unlist(mydata[1,]))
	colnames(mydata)<-a
	target_data = mydata[i:j,9:10]
	colnames(target_data) <- c("goal_dif","points")
	mydata = mydata[-(22:k),]
	mydata = mydata[-1,]
	mydata = mydata[,-51]
	mydata= mydata[,-39]
	mydata<-mydata[order(mydata[,2]),]
	training_data = mydata[,3:49]
	data = training_data
	data[,48:49] = target_data
	data <- lapply(data[,1:49],as.double)
	data  <-as.data.frame(data)
	data[,50]=mydata[,2]
	return(data)
}

train <- dataTransform(dataTraining, FALSE)
testdata <- dataTransform(dataTesting, TRUE)

#Filtering and Preprocessing
filterAndProcess<-function(datatrain,datatest){
	c <- c()
	corVal<-c()
	index = 1
	for(i in 1:47){
		if (abs(cor(datatrain[,i],datatrain[,49])) > 0.8 && i!=35){
			c[index] = i
			corVal[index] = abs(cor(datatrain[,i],datatrain[,49]))
			datatrain[,i]<- jtrans(datatrain[,i])$transformed
			datatest[,i]<- jtrans(datatest[,i])$transformed
			index = index +1
		}
	}
	returnedData <-list("datatrain" = datatrain,"datatest" = datatest, "matrix" = c)
	return(returnedData)
}

returnedData<-filterAndProcess(train,testdata)
inputTrain <-as.data.frame(returnedData$datatrain)
inputTest <-as.data.frame(returnedData$datatest)
c<-returnedData$matrix


f <- as.formula(paste("points~", paste(n[!n %in% "points"][c], collapse = " + ")))
creditnet <- neuralnet(f, inputTrain , hidden = 100)
predict = compute(creditnet,inputTest [,c])

ols <- aov(f,inputTrain )
pred.ols <- predict(ols,inputTest[,c])

predictedNN = predict$net.result
predictedLM = pred.ols


bmp('C:/Users/Oki.OKI-PC/Documents/Projek EPL/result.bmp',width = 10, height = 10, units = 'in', res = 300)

par(mfrow=c(2,1))
plot(testdata$points,predictedNN,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
text(testdata$points,predictedNN, labels=testdata$V50, cex= 0.7)
legend('bottomright',legend='NN',pch=18,col='red', bty='n')

plot(testdata$points,predictedLM,col='red',main='Real vs predicted using LM',pch=18,cex=0.7)
abline(0,1,lwd=2)
text(testdata$points,predictedLM, labels=testdata$V50, cex= 0.7)
legend('bottomright',legend='LM',pch=18,col='red', bty='n')
dev.off()

errorTable1 = abs(testdata$points - predicted2)
MSE.lm <- sum(errorTable1)/length(predicted2)
write.table(round(predicted2), "C:/Users/Oki.OKI-PC/Documents/Projek EPL/resultLM.txt", sep="\t")
print(MSE.lm)

errorTable2 = abs(testdata$points - predicted)
MSE.nn2 <- sum(errorTable2)/length(predicted)
write.table(round(predicted), "C:/Users/Oki.OKI-PC/Documents/Projek EPL/resultNN.txt", sep="\t")
print(MSE.nn2)


