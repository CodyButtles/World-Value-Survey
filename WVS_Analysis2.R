rm(list=ls())

library(rpart)
library(pmml)
library(caret)
#Load in Data
WVSData<- read.csv("C:\\Users\\Cody\\OneDrive - UWSP\\DAC310\\WV_US.csv",header=TRUE,sep=",")

############# 2 ###################
#Narrow down Variables
myData<-WVSData[c("V23","V55","V56","V59","V102","V152","V238","V240")]
head(myData)

############### 3 ##################
#Removed NA from V23
myData<-myData[which(myData$V23!=-99),]
head(myData)

############# 4 #################
#Replace -99 with mode
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

myData$V55[myData$V55==-99]<-getmode(myData$V55)
myData$V56[myData$V56==-99]<-getmode(myData$V56)
myData$V59[myData$V59==-99]<-getmode(myData$V59)
myData$V102[myData$V102==-99]<-getmode(myData$V102)
myData$V152[myData$V152==-99]<-getmode(myData$V152)
myData$V238[myData$V238==-99]<-getmode(myData$V238)
myData$V240[myData$V240==-99]<-getmode(myData$V240)
head(myData)

########### 5 ################
#V240 Dummy
myData$DummyV240<-myData$V240
myData$DummyV240[myData$DummyV240==2]<-0
head(myData)

############### 6 ######################
#Regroup V238
myData$V238Regrouped<-myData$V238
myData$V238Regrouped[myData$V238Regrouped==1]<-'1&2'
myData$V238Regrouped[myData$V238Regrouped==2]<-'1&2'
myData$V238Regrouped[myData$V238Regrouped==4]<-'4&5'
myData$V238Regrouped[myData$V238Regrouped==5]<-'4&5'
myData$V238Regrouped[myData$V238Regrouped==3]<-'3'
head(myData)

#Dummy V238
myData$V238D1<-ifelse(myData$V238Regrouped=='1&2',1,0)
myData$V238D2<-ifelse(myData$V238Regrouped=='3',1,0)
head(myData)

############ 7 #################
#Create Simple statistics, no dummy
summary(myData[c('V23','V55','V56','V59','V102','V152','V238','V240')])

############ 8 ################
# create bar plots for each predictor
barplot(table(myData$V55),main='V55 Count of Responses')
barplot(table(myData$V56),main='V56 Count of Responses')
barplot(table(myData$V59),main='V59 Count of Responses')
barplot(table(myData$V102),main='V102 Count of Responses')
barplot(table(myData$V152),main='V152 Count of Responses')
barplot(table(myData$V238Regrouped),main='V238 Regrouped Count of Responses')
barplot(table(myData$V240),main='V240 Count of Responses')
barplot(table(myData$DummyV240),main='V240 Dummy Count of Responses(0-F, 1-M)')
head(myData)

############### 9 ###############
#Random Number seed
set.seed(12345679)

############ 10 ##############
#Partition the data
randIndex<-sample(1:nrow(myData)) #randomizing the indices for the data
cutPoint<-floor(2*nrow(myData)/3)
inTrain<-randIndex[1:cutPoint]
inTest<-randIndex[(cutPoint+1):length(randIndex)]

trainData<-myData[inTrain,]
testData<-myData[inTest,]

########## 11 #######################################################################
#Regression Model
regModel<- lm(V23~ V55+V56+V59+V102+V152+V238D1+V238D2+DummyV240,data = trainData)
summary(regModel)

res<-predict(regModel,testData)

actuals_preds <- data.frame(cbind(actuals=testData$V23, predicteds=res))  # make actuals_predicteds dataframe.
correlation_accuracy <- cor(actuals_preds)  # 65%
cor.test(actuals_preds$actuals,actuals_preds$predicteds)

min_max_accuracy <- mean(apply(actuals_preds, 1, min) / apply(actuals_preds, 1, max))  
# => 87.13%, min_max accuracy
mape <- mean(abs((actuals_preds$predicteds - actuals_preds$actuals))/actuals_preds$actuals)  
# => 24.46%, mean absolute percentage deviation

plot(actuals_preds$actuals,actuals_preds$predicteds,pch=16,col=2,xlab = "Actual Response",ylab = "Predicted Response",main = "Regression Model Predicted and Actual",cex.axis=0.75)

######### 12 ##################################################################################
#sAVE pmml
regPMML<-pmml(regModel)
saveXML(regPMML,"C:\\Users\\cbutt641\\OneDrive - UWSP\\DAC310\\Homework\\HW2\\HW2PMML.pmml")

######## 13 ####################################################################################
#two more models split by gender
################################################################################################
fData<-myData[which(myData$DummyV240==0),]
mData<-myData[which(myData$DummyV240==1),]

#Random Number seed
set.seed(12345677)

#Partition the data
#FEMALE
frandIndex<-sample(1:nrow(fData)) #randomizing the indices for the data
fcutPoint<-floor(2*nrow(fData)/3)
finTrain<-frandIndex[1:fcutPoint]
finTest<-frandIndex[(fcutPoint+1):length(frandIndex)]

ftrainData<-fData[finTrain,]
ftestData<-fData[finTest,]
#MALE
mrandIndex<-sample(1:nrow(mData)) #randomizing the indices for the data
mcutPoint<-floor(2*nrow(mData)/3)
minTrain<-mrandIndex[1:mcutPoint]
minTest<-mrandIndex[(mcutPoint+1):length(mrandIndex)]

mtrainData<-mData[minTrain,]
mtestData<-mData[minTest,]


#Regression Model
#FEMALE
fregModel<- lm(V23~V55+V56+V59+V102+V152+V238,data = ftrainData)
summary(fregModel)

fRes<-predict(fregModel,ftestData)

factuals_preds <- data.frame(cbind(actuals=ftestData$V23, predicteds=fRes))  # make actuals_predicteds dataframe.
fcorrelation_accuracy <- cor(factuals_preds)  # 37.43%

cor.test(factuals_preds$actuals,factuals_preds$predicteds)

#MALE
mregModel<- lm(V23~V55+V56+V59+V102+V152+V238,data = mtrainData)
summary(mregModel)

mRes<-predict(mregModel,mtestData)

mactuals_preds <- data.frame(cbind(actuals=mtestData$V23, predicteds=mRes))  # make actuals_predicteds dataframe.
mcorrelation_accuracy <- cor(mactuals_preds)  # 49.96%

cor.test(mactuals_preds$actuals,mactuals_preds$predicteds)
#correlation_accuracy^2

###Evaluating Gender Model as a whole###
gender_pred<-rbind(factuals_preds,mactuals_preds)
cor.test(gender_pred$actuals,gender_pred$predicteds)

gender_min_max_accuracy <- mean(apply(gender_pred, 1, min) / apply(gender_pred, 1, max))  
# => 87.64%, min_max accuracy
gender_mape <- mean(abs((gender_pred$predicteds - gender_pred$actuals))/gender_pred$actuals)  
# => 17.94%, mean absolute percentage deviation
plot(gender_pred$actuals,gender_pred$predicteds,pch=16,col=2,xlab = "Actual Response",ylab = "Predicted Response",main = "Gender Regression Model Predicted and Actual",cex.axis=0.75)


########## 14 ############################################################################
#three more models split by gender
##########################################################################################
data12<-myData[which(myData$V238Regrouped=='1&2'),]
data3<-myData[which(myData$V238Regrouped=='3'),]
data45<-myData[which(myData$V238Regrouped=='4&5'),]
head(data12)
#Random Number seed
set.seed(12345677)

#Partition the data
#1&2 Group
randIndex12<-sample(1:nrow(data12)) #randomizing the indices for the data
cutPoint12<-floor(2*nrow(data12)/3)
inTrain12<-randIndex12[1:cutPoint12]
inTest12<-randIndex12[(cutPoint12+1):length(randIndex12)]

trainData12<-data12[inTrain12,]
testData12<-data12[inTest12,]
#3 Group
randIndex3<-sample(1:nrow(data3)) #randomizing the indices for the data
cutPoint3<-floor(2*nrow(data3)/3)
inTrain3<-randIndex3[1:cutPoint3]
inTest3<-randIndex3[(cutPoint3+1):length(randIndex3)]

trainData3<-data3[inTrain3,]
testData3<-data3[inTest3,]
#4&5 Group
randIndex45<-sample(1:nrow(data45)) #randomizing the indices for the data
cutPoint45<-floor(2*nrow(data45)/3)
inTrain45<-randIndex12[1:cutPoint45]
inTest45<-randIndex45[(cutPoint45+1):length(randIndex45)]

trainData45<-data45[inTrain45,]
testData45<-data45[inTest45,]


#Regression Model
#1&2 Group
regModel12<- lm(V23~V55+V56+V59+V102+V152+V240,data = trainData12)
summary(regModel12)

res12<-predict(regModel12,testData12)

actuals_preds12 <- data.frame(cbind(actuals=testData12$V23, predicteds=res12))  # make actuals_predicteds dataframe.
correlation_accuracy12 <- cor(actuals_preds12)  # 28.56%
correlation_accuracy12^2

#3 Group
regModel3<- lm(V23~V55+V56+V59+V102+V152+V240,data = trainData3)
summary(regModel3)

res3<-predict(regModel3,testData3)

actuals_preds3 <- data.frame(cbind(actuals=testData3$V23, predicteds=res3))  # make actuals_predicteds dataframe.
correlation_accuracy3 <- cor(actuals_preds3)  # 42.92%
correlation_accuracy3^2

#4&5 Group
regModel45<- lm(V23~V55+V56+V59+V102+V152+V240,data = trainData45)
summary(regModel45)

res45<-predict(regModel45,testData45)

actuals_preds45 <- data.frame(cbind(actuals=testData45$V23, predicteds=res45))  # make actuals_predicteds dataframe.
correlation_accuracy45 <- cor(actuals_preds45)  # 54.63%
correlation_accuracy45^2

###Evaluate 238 Model
econ_pred<-rbind(actuals_preds12,actuals_preds3,actuals_preds45)
cor.test(econ_pred$actuals,econ_pred$predicteds)

econ_min_max_accuracy <- mean(apply(econ_pred, 1, min) / apply(econ_pred, 1, max))  
# => 87.06%, min_max accuracy
econ_mape <- mean(abs((econ_pred$predicteds - econ_pred$actuals))/econ_pred$actuals)  
# => 21.62%, mean absolute percentage deviation
plot(econ_pred$actuals,econ_pred$predicteds,pch=16,col=2,xlab = "Actual Response",ylab = "Predicted Response",main = "Economic Class Regression Model Predicted and Actual",cex.axis=0.75)

################Comparing Min Max Accuracies and MAPE#############################################
min_max_accuracy
gender_min_max_accuracy
econ_min_max_accuracy

mape
gender_mape
econ_mape

cor(actuals_preds)
cor(mactuals_preds)
cor(factuals_preds)
cor(actuals_preds12)
cor(actuals_preds3)
cor(actuals_preds45)

