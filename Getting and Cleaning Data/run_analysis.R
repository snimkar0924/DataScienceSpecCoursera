

### 1. Merges the training and the test sets to create one data set.

#read training data set
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# read testing data set
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# read feature vector
features <- read.table('./data/UCI HAR Dataset/features.txt')

# read activity labels
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# assigning colnames
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

one_data_set <- cbind.data.frame(rbind.data.frame(subject_train, subject_test),
                                 rbind.data.frame(y_train, y_test),
                                 rbind.data.frame(x_train, x_test))

one_data_set[1:5,]
dim(one_data_set)

#### end 1.

# 2. Extracts only the measurements on the mean and standard deviation 
#    for each measurement.
cols <- colnames(one_data_set)
head(cols)
muNsdCols <- c(grep("activityId", cols),
               grep("subjectId", cols),
               grep("mean()", cols), 
               grep("std()", cols))

one_data_set <- subset(one_data_set, select = muNsdCols)
colnames(one_data_set)
dim(one_data_set)

#### end 2.

# 3. Uses descriptive activity names to name the activities in the data set
one_data_set <- merge(activityLabels, one_data_set, by='activityId',
                      all.y=TRUE)
cols <- colnames(one_data_set)
head(cols)
#### end 3.

# 4. Appropriately labels the data set with descriptive variable names.
cols <-gsub("^t", "time", cols)
cols <-gsub("^f", "frequency", cols)
cols <-gsub("Acc", "Accelerometer", cols)
cols <-gsub("Gyro", "Gyroscope", cols)
cols <-gsub("Mag", "Magnitude", cols)
cols <-gsub("BodyBody", "Body", cols)
colnames(one_data_set) <- cols


#### end 4.

# 5. From the data set in step 4, create a second, 
# independent tidy data set with the average of each variable for 
# each activity and each subject.

tidy_data_set <-aggregate(. ~subjectId + activityId, one_data_set, mean)
tidy_data_set <-tidy_data_set[order(tidy_data_set$subjectId,
                                    tidy_data_set$activityId),]
dim(one_data_set)
dim(tidy_data_set)
write.table(tidy_data_set, file = "./tidydata.txt",row.name=FALSE)


