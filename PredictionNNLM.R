library(jtrans)
library(neuralnet)
workingDir = "C:/Users/Oki.OKI-PC/Documents/projekEPL-master/projekEPL-master"
setwd(workingDir)

filterAndProcess<-function(datatrain,datatest){
  c <- c()
  corVal<-c()
  index = 1
  for(i in 4:20){
    if (abs(cor(datatrain[,i],datatrain[,'points'])) > 0.7){
      c[index] = i
      corVal[index] = abs(cor(datatrain[,i],datatrain[,21]))
      datatrain[,i]<- jtrans(datatrain[,i])$transformed
      datatest[,i]<- jtrans(datatest[,i])$transformed
      index = index +1
    }
  }
  returnedData <-list("datatrain" = datatrain,"datatest" = datatest, "matrix" = c)
  return(returnedData)
}

train = data_no_save
testdata = dataTest_saves

returnedData<-filterAndProcess(train,testdata)
inputTrain <-(returnedData$datatrain)
inputTest <-(returnedData$datatest)
c<-returnedData$matrix

n=colnames(train)
f <- as.formula(paste("points~", paste(n[!n %in% "points"][c], collapse = " + ")))
creditnet <- neuralnet(f, inputTrain , hidden = 100)
predict = compute(creditnet,inputTest [,c])

ols <- aov(f,as.data.frame(inputTrain) )
pred.ols <- predict(ols,as.data.frame(inputTest[,c]))

predictedNN = predict$net.result
predictedLM = pred.ols


bmp('data/result.bmp',width = 10, height = 10, units = 'in', res = 300)

par(mfrow=c(2,1))
plot(testdata[,'points'],predictedNN,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
text(testdata[,'points'],predictedNN,labels=rownames(testdata), cex= 0.7)
legend('bottomright',legend='NN',pch=18,col='red', bty='n')

plot(testdata[,'points'],predictedLM,col='red',main='Real vs predicted using LM',pch=18,cex=0.7)
abline(0,1,lwd=2)
text(testdata[,'points'],predictedLM, rownames(testdata),cex= 0.7)
legend('bottomright',legend='LM',pch=18,col='red', bty='n')
dev.off()


errorTable1 = abs(testdata[,'points'] - predictedLM)
MSE.lm <- sum(errorTable1)/length(predictedLM)
points = testdata[,"points"]
predictedLM = as.data.frame(predictedLM)
predictedLM <-cbind(predictedLM,points)
write.csv(round(predictedLM), "data/resultLM.csv")
print(MSE.lm)

errorTable2 = abs(testdata[,'points'] - predictedNN)
MSE.nn2 <- sum(errorTable2)/length(predictedNN)
points = testdata[,"points"]
predictedNN = as.data.frame(predictedNN)
predictedNN <-cbind(predictedNN,points)
write.csv(round(predictedNN), "data/resultNN.csv")
print(MSE.nn2)


