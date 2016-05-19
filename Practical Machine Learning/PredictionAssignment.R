#rm(list=ls())


library(caret)
library(randomForest)

trainDat <- read.csv("./data/pml-training.csv")
testDat <- read.csv("./data/pml-testing.csv")
dim(trainDat)
dim(testDat)

sum(complete.cases(trainDat))

# First, we remove columns that contain NA missing values.

trainDat <- trainDat[, colSums(is.na(trainDat)) == 0]
testDat <- testDat[, colSums(is.na(testDat)) == 0]
dim(trainDat)
dim(testDat)


# Next, we get rid of some columns that do not contribute much to the 
# accelerometer measurements.

classe <- trainDat$classe
trainRemove <- grepl("^X|timestamp|window", names(trainDat))
trainDat <- trainDat[, !trainRemove]
trainDat <- trainDat[, sapply(trainDat, is.numeric)]
trainDat$classe <- classe
testRemove <- grepl("^X|timestamp|window", names(testDat))
testDat <- testDat[, !testRemove]
testDat <- testDat[, sapply(testDat, is.numeric)]

dim(trainDat)
dim(testDat)
colnames(trainDat)
colnames(testDat)


set.seed(400703)
inTrain <- createDataPartition(trainDat$classe, p=0.70, list=F)
trainDat <- trainDat[inTrain, ]
valdnDat <- trainDat[-inTrain, ]

dim(trainDat)
dim(valdnDat)
dim(testDat)

#http://arxiv.org/pdf/1508.04409.pdf
## try ranger... for faster RF processing
library(ranger)

modelRF2 <-  ranger(classe ~ ., data = trainDat, 
                    write.forest = TRUE)
pred2 <- predict(modelRF2, valdnDat)
t2 <- table(predictions(pred2), valdnDat$classe)
t2

offset <- 5
acc2 <- c("A"=t2[1]/sum(t2[seq(from=1, to=25, by=offset)]),
          "B"=t2[7]/sum(t2[seq(from=2, to=25, by=offset)]),
          "C"=t2[13]/sum(t2[seq(from=3, to=25, by=offset)]),
          "D"=t2[19]/sum(t2[seq(from=4, to=25, by=offset)]),
          "E"=t2[25]/sum(t2[seq(from=5, to=25, by=offset)]))
round(acc2, 2)
#woah!!!

pred2 <- predict(modelRF2, testDat[,1:52])
testDat$classe <- predictions(pred2)
#printing the first 10 predictions
head(testDat[,c(1:4, 54)], n=10)
testDat[,c(1:4, 54)]

## one more technique
controlRf <- trainControl(method="cv", 5)
modelRf <- train(classe ~ ., data=trainDat, method="rf", 
                 trControl=controlRf, ntree=25)
modelRf

predictRf <- predict(modelRf, testDat)
confusionMatrix(testDat$classe, predictRf)

accuracy <- postResample(predictRf, testDat$classe)
accuracy


oose <- 1 - as.numeric(confusionMatrix(testDat$classe, predictRf)$overall[1])
oose


result <- predict(modelRf, testDat[, -c(53:54)])
result


table(testDat$classe, result)

library(corrplot)
corrPlot <- cor(trainDat[, -length(names(trainDat))])
str(corrPlot)
attributes(corrPlot)$dimnames[[1]] <- seq(1:(ncol(trainDat)-1))
attributes(corrPlot)$dimnames[[2]] <- seq(1:(ncol(trainDat)-1))
corrplot(corrPlot, method="color", tl.cex=0.6)

library(rpart)
library(rpart.plot)
treeModel <- rpart(classe ~ ., data=trainDat, method="class")
prp(treeModel) # fast plot
