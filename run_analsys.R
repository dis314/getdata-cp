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
mergedData <- cbind(mergedXData, mergedLabels)
mergedSubj <- rbind(subjTest, subjTrain)
mergedData <- cbind(mergedData, mergedSubj)

## PROPERLY NAMING FEATURES

colnames(mergedData) <- c(as.character(f), "actLabel", "subject")


## EXTRACTING ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION

meanData <- mergedData[grep("mean()", names(mergedData), fixed = TRUE)]
stdData <- mergedData[grep("std()", names(mergedData), fixed = TRUE)]

## MERGING RESULTS

finalData <- cbind(meanData, stdData, mergedData$actLabel, mergedData$subject)
names(finalData)[(ncol(finalData)-1):ncol(finalData)] <- c("actLabel", "subject")

 ## PROPERLY NAMING ACTIVITY LABELS

finalData["actLabel"] <- actLabels[finalData$actLabel, "V2"]

 
## CREATING INDEPENDENT MEAN DATASET

avg_finalData <- group_by(finalData, subject, actLabel) %>% summarise_each(c("mean"))
write.table(avg_finalData, file = "avg-tidy-dataset.txt")

