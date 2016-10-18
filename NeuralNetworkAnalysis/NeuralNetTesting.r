library(xlsx)
library(neuralnet)
mydata <- read.xlsx("C:/Users/Oki.OKI-PC/Documents/Projek EPL/CORE_DATA_PL.xlsx", 1)
target_data = mydata[23:42,9:10]
colnames(target_data) <- c("goal_dif","points")
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
index <- sample(1:nrow(data),round(0.75*nrow(data)))
train <- data[index,]
test <- data[-index,]
n <-names(train)
f <- as.formula(paste("points~", paste(n[!n %in% "points"], collapse = " + ")))
train = lapply(train,as.numeric)
test = lapply(test,as.numeric)
creditnet <- neuralnet(f, as.data.frame(train), hidden = 10, lifesign = "minimal", linear.output = FALSE, threshold = 0.1)
datatest = as.data.frame(test)
predict = compute(creditnet,datatest[,1:49])
