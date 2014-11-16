#final project getting and cleaning data
#You should create one R script called run_analysis.R that does the following. 
#1 Merges the training and the test sets to create one data set.
#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names. 
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#setwd("C:/Users/pa041093/Desktop/TEMP")
setwd("~/Desktop/DATA SPECIALIZATION/3 - Getting and cleaning/")
#Step 1

#read the training data

#dim 7352x561
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"", stringsAsFactors=FALSE)
#dim 7352x1
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"", stringsAsFactors=FALSE)#subject id
#dim 7352x1
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"", stringsAsFactors=FALSE)
#I merge the 3 datasets, since the last 2 have only one row I just create a new colum in the first one and attache the datasets
x_train[, 562] <- y_train
x_train[, 563] <- subject_train
  
  

#repeat the same with the test data
#dim 2947x561
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"", stringsAsFactors=FALSE)
#dim 2947x1
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", quote="\"", stringsAsFactors=FALSE)#subject id
#dim 2947x1
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"", stringsAsFactors=FALSE)
#I merge the 3 datasets, since the last 2 have only one row I just create a new colum in the first one and attache the datasets
x_test[, 562] <- y_test
x_test[, 563] <- subject_test


#now I can merge the two big dataset,we can see they have the same number of columns 561+1+1

data<-rbind(x_train,x_test)


#Step 2

features <- read.table("UCI HAR Dataset/features.txt", col.names=c("feature_id", "feature_label"), stringsAsFactors=FALSE )  #561

#rename the headers of the columns
colnames(data)<-c(features$feature_label,"activity_id", "sub_id")

#extract the data with "mean" or "std"
temp<-grep("mean",names(data))
temp<-c(temp,grep("std",names(data)))
temp<-as.numeric(c(temp,562,563))#add last two columns with subject_id and activity_id

data1<-data[,temp]

rm(temp)

#Step 3

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activity_id", "activity_label"),) #

data2 = merge(x=data1, y=activity_labels)




#step 4

temp<-names(data2)

temp<-gsub("[()]", "", temp)
temp<-gsub("-", " ", temp)
temp<-gsub("mean", " Mean", temp)
temp<-gsub("std", " Standard Deviation", temp)
temp<-gsub("BodyBody", "Body", temp)

temp
colnames(data2)<-temp


#step 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy<-aggregate(data2, by=list(subject = data2$sub_id, activity = data2$activity_id), FUN=mean, na.rm=TRUE)

write.table(tidy, "Tidy_Data.csv", sep=",")
  