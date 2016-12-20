# First let's retrieve the data sets
# Set the workspace 
# setwd("/Users/raze/Workspace/getting-and-cleaning-data")
# Train data
trainSet <- read.table("./data/train/X_train.txt")
dim(trainSet) # 7352 * 561 
# Train labels
trainLabels <- read.table("./data/train/y_train.txt")
# Train subject
trainSubject <- read.table("./data/train/subject_train.txt")
# Test set
testSet <- read.table("./data/test/X_test.txt")
dim(testSet) # 2947 * 561
# Test labels
testLabels <- read.table("./data/test/y_test.txt")
# Test subject
testSubject <- read.table("./data/test/subject_test.txt")
#
# 1. Merges the training and the test sets to create one data set.
#
# Let's join the data using rbind
mergedData <- rbind(trainSet, testSet)
dim(mergedData) # 10299 * 561
# Now merge the labels
mergedLabels <- rbind(trainLabels, testLabels)
dim(mergedLabels) # 10299 * 1 
# And finally the subjects
mergedSubjects <- rbind(trainSubject, testSubject)
dim(mergedSubjects) # 10299 * 1
# Get the variable names
varNames <- read.table("./data/features.txt")
# Remove hyphen
prettyNames <- gsub("-", "", varNames$V2)
# We need to change the variable names at this point because:
colnames(mergedData) <- prettyNames
#
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#
# Get the names with mean or standard deviation
nameIndexes <- grep("mean\\(\\)|std\\(\\)", names(mergedData))
length(nameIndexes) # 66
# Check that the names correspond
names(mergedData)[nameIndexes]
# Get the desired data
cleanData <- mergedData[,nameIndexes]
dim(cleanData) # 10299 * 66
# Let's keep cleaning the names
# Remove parenthesis
prettyNames <- names(cleanData)
prettyNames <- gsub("\\(\\)", "", prettyNames)
# Capitalize M
prettyNames <- gsub("mean", "Mean", prettyNames)
# Capitalize S
prettyNames <- gsub("std", "Std", prettyNames)
# Change the variable names
colnames(cleanData) <- prettyNames
# Check our pretty names
names(cleanData)
#
# 3. Uses descriptive activity names to name the activities in the data set
#
# Let's first merge with activities
activities <- read.table("./data/activity_labels.txt")
activities <- tolower(activities$V2)
# A simple function to retrieve the label
getLabel <- function(x){activities[x]}
cleanData <- cbind(mergedLabels, cleanData)
dim(cleanData) # 10299 * 67
# Rename activity field
names(cleanData)[1] <- "activity"
# Let's add the corresponding labels
cleanData$activity <- sapply(cleanData$activity, getLabel)
tail(cleanData$activity)
#
# 4. Appropriately labels the data set with descriptive variable names.
#
# Merge subject as well
cleanData <- cbind(mergedSubjects, cleanData)
dim(cleanData) # 10299 * 68
names(cleanData)[1] <- "subject"
# Let's check names
names(cleanData)
# It's necessary to write our clean data set?
# write.table(cleanData, "merged_data.txt")
#
# 5. From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable 
# for each activity and each subject.
#
# We'll use plyr to use ddply and numcolwise
library(plyr)
# nice
tidyDataFrame = ddply(cleanData, c("subject","activity"), numcolwise(mean))
# And finally write our second data frame
write.table(tidyDataFrame, "tidy_data.txt")