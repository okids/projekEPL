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
training_data = mydata[,3:50]
data = training_data
data[,49:50] = target_data
index <- sample(1:nrow(data),round(1*nrow(data)))
train <- data[index,]
test <- data[-index,]
n <-names(train[,1:48])
f <- as.formula(paste("points~", paste(n[!n %in% "points"], collapse = " + ")))
train <- lapply(train,as.double)
test <- lapply(test,as.double)

mydata2 <- read.xlsx("C:/Users/Oki.OKI-PC/Documents/Projek EPL/CORE_DATA_PL.xlsx", stringsAsFactors=F,2)
b=unname(unlist(mydata2[1,]))
colnames(mydata2)<-b
target_data2 = mydata2[24:43,9:10]
colnames(target_data2) <- c("goal_dif","points")
mydata2 = mydata2[-(22:64),]
mydata2 = mydata2[-1,]
mydata2 = mydata2[,-51]
training_data2 = mydata2[,3:50]
testdata = training_data2
testdata[,49:50] = target_data2
testdata  <- lapply(testdata,as.double)
testdata <- as.data.frame(testdata)


creditnet <- neuralnet(f, as.data.frame(train), hidden = 100, linear.output = TRUE, threshold = 0.01,stepmax = 1e+08, rep = 1, startweights = NULL,
learningrate.limit = NULL,
learningrate.factor = list(minus = 0.5, plus = 1.1),
learningrate=NULL, lifesign = "minimal",
lifesign.step = 1000, algorithm = "rprop+",
err.fct = "sse", act.fct = "logistic", exclude = NULL,
constant.weights = NULL, likelihood = FALSE)

predict = compute(creditnet,testdata[,1:48])
plot(testdata$points,predict$net.result,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN',pch=18,col='red', bty='n')
MSE.nn <- sum((testdata$points - predict$net.result)^2)/nrow(predict$net.result)
write.table(round(predict$net.result), "C:/Users/Oki.OKI-PC/Documents/Projek EPL/result.txt", sep="\t")
print(MSE.nn)



