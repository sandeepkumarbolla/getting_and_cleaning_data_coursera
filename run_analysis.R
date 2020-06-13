# run_analysis.R

#0. prepare LIBs
library(reshape2)
library(dplyr)


#1. merge {train, test} data set
# train data
x_train <- read.delim(file.choose())
y_train <-read.delim(file.choose())
s_train <- read.delim(file.choose())

# test data
x_test <- read.delim(file.choose())
y_test <-read.delim(file.choose())
s_test <- read.delim(file.choose())

# merge {train, test} data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)


#3. load feature & activity info
# feature info
feature <- read.delim(file.choose())

# activity labels
a_label <- read.delim(file.choose())



X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)


TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))



TidyData$code <- activities[TidyData$code, 2]


names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))




FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

str(FinalData)
