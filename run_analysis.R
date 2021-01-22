library(dplyr)
library(tidyr)
library(readr)
library(plyr)
library(reshape)
##Features
features <- read.table("./Datasets/UCI HAR Dataset/features.txt")
feature_names <- features[,2]
features_mean_std <- filter(features, grepl('mean|std',V2))
features_mean_std_names <- features_mean_std[,2]

##Training Data
raw_train_data <- read.table("./Datasets/UCI HAR Dataset/train/X_train.txt") #561 variables
colnames(raw_train_data) <- feature_names
activity_train_data <- read.table("./Datasets/UCI HAR Dataset/train/y_train.txt") #Activity
colnames(activity_train_data) <- c("Activity")
subject_train <- read.table("./Datasets/UCI HAR Dataset/train/subject_train.txt") #person
colnames(subject_train) <- c("Subject")
train_data <- cbind(subject_train,activity_train_data,raw_train_data)

##Test Data
raw_test_data <- read.table("./Datasets/UCI HAR Dataset/test/X_test.txt") #561 variables
colnames(raw_test_data) <- feature_names
activity_test_data <- read.table("./Datasets/UCI HAR Dataset/test/y_test.txt") #Activity
colnames(activity_test_data) <- c("Activity")
subject_test <- read.table("./Datasets/UCI HAR Dataset/test/subject_test.txt") #person
colnames(subject_test) <- c("Subject")
test_data <- cbind(subject_test,activity_test_data,raw_test_data)

##Combined Data
data <- rbind(train_data,test_data)

##Melted Data
melted_data <- melt(data, id=c("Subject", "Activity"))

##Filtered Data
filtered_data <- subset(melted_data, variable %in% features_mean_std_names)

##Name Activities
activity_names <- read.table("./Datasets/UCI HAR Dataset/activity_labels.txt")
colnames(activity_names) <- c("Ref", "Activity")
tidy_df <- filtered_data
tidy_df['Activity'] <- lapply(filtered_data['Activity'], function(x) activity_names$Activity[match(x, activity_names$Ref)])


