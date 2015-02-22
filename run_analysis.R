library("dplyr")

# Set working directory
setwd("~/R-Programme/Smartphone")

# Step 1: Merges the training and the test sets to create one data set

# Load train data
trainData <- read.table("./train/X_train.txt")
trainLabel <- read.table("./train/y_train.txt")
trainSubject <- read.table("./train/subject_train.txt")

# Load test data
testData <- read.table("./test/X_test.txt")
testLabel <- read.table("./test/y_test.txt")
testSubject <- read.table("./test/subject_test.txt")

#Join test and train data
joinData <- rbind(trainData, testData)
joinLabel <- rbind(trainLabel, testLabel)
joinSubject <- rbind(trainSubject, testSubject)
# Merge joinData with joinLabel and joinSubjet
mergedData <- cbind(joinSubject, joinLabel, joinData)

# step 2: Extracts only the measurements on the mean and standard deviation for each measurement
# Load features data
features <- read.table("./features.txt")
# Read only rows with expresion mean() or std()
meanStd <- grep("mean\\(\\)|std\\(\\)", features[, 2])
# Select only values mean() or std() from the joinData table
joinData <- joinData[, meanStd]
# Set column name with the expressions from the features file
names(joinData) <- features[meanStd, 2]

# Step3: Uses descriptive activity names to name the activities in the data set
# Load activity data
activity <- read.table("./activity_labels.txt")
# Set activity labels in joinLabel table
joinLabel[, 1] <- activity[joinLabel[, 1], 2]
# Set column name
names(joinLabel) <- "activity"

# Step 4: Appropriately labels the data set with descriptive activity names
names(joinSubject) <- "subject"
cleanData <- cbind(joinSubject, joinLabel, joinData)
#Remove "()"
names(cleanData) <- gsub("\\(\\)", "", names(cleanData))
#Replace "-" by "_"
names(cleanData)<- gsub("-", "_", names(cleanData))

#Write 1st dataset
#write.table(cleanedData, "merged_data.txt",row.name=FALSE)

# Step 5: Creates an independent tidy data set with the average of each variable for each activity and each subject. 
result<-cleanData %>% group_by(subject, activity) %>% summarise_each(funs(mean))
#Write 2nd dataset
write.table(result, "data_with_means.txt", row.name=FALSE)

