#Download data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Comprimido")
unzip("./data/Comprimido")

#organize and read tables 

xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)
test_1 <- bind_cols(xtest, ytest, subject_test)

table(subject_test)

xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)
train_1 <- bind_cols(xtrain, ytrain, subject_train)

#give column titles

nombrecol <- read.csv("UCI HAR Dataset/features.txt", sep = " ", header = FALSE)[,2]
nombrecol
nombrecol <- make.names(nombrecol, unique = TRUE)
nombrecol <- c(nombrecol, "activity", "subject")

names(test_1) <- nombrecol
names(train_1) <- nombrecol

#### conversion to data frame and new column #####

test_1 <- as_tibble(test_1)
test_1 <- mutate(test_1, stage="test")

train_1 <- as_tibble(train_1)
train_1 <- mutate(train_1, stage="train")


#### 1. Merges the data. ####

train_test <- bind_rows(train_1, test_1)
names(train_test)

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement. ####

measure <- grep("mean|std", nombrecol, value = TRUE) %>% c("activity", "subject", "stage")
mean_std <- select(train_test, all_of(measure))

#### 3. Uses descriptive activity names to name the activities in the data set ####

etiqueta <- read.table("UCI HAR Dataset/activity_labels.txt")[, 2]
activity_label <- mutate(mean_std, activity_name = etiqueta[mean_std$activity])


#### 4. Appropriately labels the data set with descriptive variable names ####

al_clean <- activity_label
names(al_clean)<-gsub("\\.\\.\\.","_",names(al_clean)) 


#### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. ####

write.table(al_clean,"export_data.txt", row.names = FALSE)
