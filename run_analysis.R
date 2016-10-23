## preparing all files
library(downloader)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./cousera3Ass")){dir.create("./cousera3Ass")}
download(url, dest="./cousera3Ass/dataset.zip", mode="wb") 
unzip ("./cousera3Ass/dataset.zip", exdir = "./cousera3Ass")
list.files(path = "./cousera3Ass/UCI HAR Dataset/test")

X_test <- read.table("./cousera3Ass/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./cousera3Ass/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./cousera3Ass/UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./cousera3Ass/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./cousera3Ass/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./cousera3Ass/UCI HAR Dataset/train/subject_train.txt")

## prepare 6 activity DF
activity_labels <- readLines("./cousera3Ass/UCI HAR Dataset/activity_labels.txt")
activity_labels2 <-strsplit(activity_labels," ")
activity_labels_df <- data.frame(activityID=integer(),activityName=character(),stringsAsFactors = F)
for(i in 1:6){activity_labels_df[i,1] <- activity_labels2[[i]][1]}
for(i in 1:6){activity_labels_df[i,2] <- activity_labels2[[i]][2]}
activity_labels_df$activityID <- as.integer(activity_labels_df$activityID)

## prepare 561 features DF
features <- readLines("./cousera3Ass/UCI HAR Dataset/features.txt")
features2 <-strsplit(features," ")
features_df <- data.frame(featID=integer(),featName=character(),stringsAsFactors = F)
for(i in 1:561){features_df[i,1] <- features2[[i]][1]}
for(i in 1:561){features_df[i,2] <- features2[[i]][2]}
features_df$featID <- as.integer(features_df$featID)

## Test Data - 1) modify y_test
library(data.table)
colnames(y_test)[1] <- "activityID"
y_test$rowID<-seq.int(nrow(y_test))
y_test$subjectNo <- subject_test$V1
y_test2 <- merge(y_test,activity_labels_df,by="activityID")
y_test2$rowName <- paste("Test",y_test2$rowID,y_test2$activityName,y_test2$subjectNo,sep="-")
library(plyr)
y_test2 <- arrange(y_test2,rowID)

##Test Data - 2) modify X_test
X_test2 <- X_test
colnames(X_test2) <- features_df$featName
rownames(X_test2) <- y_test2$rowName


## Train Data - 1) modify y_train
library(data.table)
colnames(y_train)[1] <- "activityID"
y_train$rowID<-seq.int(nrow(y_train))
y_train$subjectNo <- subject_train$V1
y_train2 <- merge(y_train,activity_labels_df,by="activityID")
y_train2$rowName <- paste("Train",y_test2$rowID,y_train2$activityName,y_train2$subjectNo,sep="-")
library(plyr)
y_train2 <- arrange(y_train2,rowID)

##Test Data - 2) modify X_test
X_train2 <- X_train
colnames(X_train2) <- features_df$featName
rownames(X_train2) <- y_train2$rowName

##Merge All Data
all_data1 <- rbind(X_test2,X_train2)

##check data
str(all_data1)
head(colnames(all_data1),20)
head(rownames(all_data1),20)

##Extract the columns containing mean() and std() and create new table
##Achieve requirement No. 1-4 
ind1 <- grep("mean()",features_df$featName,fixed = T)
ind2 <- grep("std()",features_df$featName,fixed = T)
ind <- c(ind1,ind2)
selected_data1 <- all_data1[,ind]

##Create categorized table
categorized <- strsplit(rownames(selected_data1),"-")
categorized_df <- data.frame(DataSet=character(),case=integer(),activity=character(),subject=integer(),stringsAsFactors = F)
for(i in 1:nrow(selected_data1)){categorized_df[i,1] <- categorized[[i]][1]}
for(i in 1:nrow(selected_data1)){categorized_df[i,2] <- categorized[[i]][2]}
for(i in 1:nrow(selected_data1)){categorized_df[i,3] <- categorized[[i]][3]}
for(i in 1:nrow(selected_data1)){categorized_df[i,4] <- categorized[[i]][4]}
categorized_df$subject <- as.integer(categorized_df$subject)

##Merge again and summarize
##Acheive requirement No. 5 
FinalData <- cbind(categorized_df,selected_data1)
FinalDataMean <- aggregate(FinalData[,-1:-4],list(byAct=FinalData$activity,bySub=FinalData$subject),mean)

##Export all files
write.table(FinalDataMean,"./tidy.txt",row.names = FALSE)