library(dplyr)

## READING DATA

actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

subjTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

Xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("UCI HAR Dataset/test/y_test.txt")

Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")

## MERGING DATASETS

mergedXData <- rbind(Xtest, Xtrain)
mergedLabels <- rbind(Ytest, Ytrain)
mergedSubj <- rbind(subjTest, subjTrain)

colnames(mergedXData) <- features$V2 ## PROPERLY NAMING FEATURES

## EXTRACTING ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION

meanData <- mergedXData[grep("mean()", names(mergedXData), fixed = TRUE)]
stdData <- mergedXData[grep("std()", names(mergedXData), fixed = TRUE)]

## ADDING ACTIVITY LABELS COLUMN AND SUBJECT COLUMN
## FORMING FINAL DATASET

finalData <- cbind(meanData, stdData, mergedLabels, mergedSubj)
names(finalData)[(ncol(finalData)-1):ncol(finalData)] <- c("actLabel", "subject")

## PROPERLY NAMING ACTIVITY LABELS

finalData["actLabel"] <- actLabels[finalData$actLabel, "V2"]

## CREATING INDEPENDENT MEAN DATASET

avg_finalData <- group_by(finalData, subject, actLabel) %>% summarise_each(c("mean"))

## SAVING FINAL TABLE TO FILE 

write.table(avg_finalData, file = "avg-tidy-table.txt", row.name = FALSE)

