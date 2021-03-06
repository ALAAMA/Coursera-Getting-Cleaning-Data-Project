
##optional step setWD('Your working directory')
## ie setwd("~/Downloads/Coursera-Getting-Cleaning-Data-Project")
##Download dataset to sub-directory "data"
if(!file.exists( "./data") ) { dir.create("./data") }
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/dataset.zip")

 ## Unzip dataSet under the sub-directory "data"
 unzip(zipfile="./data/dataset.zip",exdir="./data")

##=======================================
## Merges the training and the test sets into one data set.
##  read training,test , features vector and activity tables:
 x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
 y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
 subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
 x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
 y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
 subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
 features <- read.table('./data/UCI HAR Dataset/features.txt')
 activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')
      
 ## Assign column names:
 colnames(x_train) <- features[,2] 
 colnames(y_train) <-"activityId"
 colnames(subject_train) <- "subjectId"
 
 colnames(x_test) <- features[,2] 
 colnames(y_test) <- "activityId"
 colnames(subject_test) <- "subjectId"
 colnames(activityLabels) <- c('activityId','activityType')
 ##==========================================     
##Merge all data into one set:
all_train <- cbind(y_train, subject_train, x_train) ##column bind
all_test  <- cbind(y_test, subject_test, x_test)    ##column bind
dataSet1 <- rbind(all_train, all_test)              ##row bind all data set
      
###Get only the measurements on the mean
## and standard deviation for each measurement
colNames <- colnames(dataSet1)##Extract columns' names

##Create logical vector for activityId,subjectId,
##mean(contains the words 'mean') and standard deviation(contains workds 'std')
selected_col <- (grepl("activityId" , colNames) | 
                 grepl("subjectId"  , colNames) | 
                 grepl("mean"     , colNames)   | 
                 grepl("std"      , colNames) 
                 )
      
## Show all rows and only required columns  
 dataSet2 <- dataSet1[ , selected_col == TRUE] ##subset required cols
      
## Using descriptive activity names to name the activities in the data set:
## sql equivalent: select * from dateSet2 x, activityLabels y where x.activityId= y.activityId
 dataSet3 <- merge(dataSet2,
	          activityLabels,
                  by='activityId',
                  all.x=TRUE)
##=======================================      
## Appropriately labeling the data set with descriptive variable names.      
##Create a second, independent tidy data set 
##with the average of each variable for each activity and each subject:
##create second tidy data set 
## in sql language : select x.subjectId ,x.activityId ,mean(x.col1),mean(x.col2)...mean(x.coln) group by x.subjectId ,x.activityId;
tidy <- aggregate(. ~subjectId + activityId, ##compute the mean for all data  except  group by subjectId & activityId
                  data = dataSet3,##DataSet 
                  FUN = mean ##function 
                  )
tidy <- tidy[order(tidy$subjectId, tidy$activityId),] ## order tidy rows by subjectId,activityId
##======================================= 
 ##Write second tidy data set to text file at current working directory
 write.table(tidy, "tidy.txt", row.name=FALSE)
        
      
      
      
      
      
      
      
      
      
