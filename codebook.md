---

##Codebook for the final project of the course Getting and Cleaning data
Read first the file readme.md

---


### Data source for the assignment
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

-------

### Original data
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

--------

### Final Output
Once run the file run_analysis.R the output is a file "Tidydata.txt" (see Readme.md for details on how to run the R file)

------


### Deatailed Process
The code does the following (as per project instructions)

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


---

* Step 1 - Merges the training and the test sets to create one data set.

I first read the train data

```
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"", stringsAsFactors=FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"", stringsAsFactors=FALSE)#subject id
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"", stringsAsFactors=FALSE)
x_train[, 562] <- y_train
x_train[, 563] <- subject_train
```

Then I merge the 3 datasets, since all of them have dim 7352 rows and the last 2 have only one colum I just create a new colum in the first one and attache the datasets (note the the first dataset has 561 so I create the columns 562 and 563 )

The same process is applied to the test data, the dimension of the testa data is 2947x561 + 2 columns (one for the y_test and one for the subject_test).

Finally I merge the 2 datasets (which has the same number of coumns 563)

```
data<-rbind(x_train,x_test)

```

----

* Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 

First I read the file "feature.txt" containing the names of the first 561 columns, then I rename the data columns with these names plus the two columns I added in the previous step "activity_id" + "sub_id" 

```
features <- read.table("UCI HAR Dataset/features.txt", col.names=c("feature_id", "feature_label"), stringsAsFactors=FALSE ) #dimension 561x2
colnames(data)<-c(features$feature_label,"activity_id", "sub_id")
```

Finally I extract only the columns with the words "mean" or "std"

--------

* Step 3 - Uses descriptive activity names to name the activities in the data set
I read the file  "activity_labels.txt" and I merge it with the dataset from previous step based on "activity_id"

```
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activity_id", "activity_label"),) #

data2 = merge(x=data1, y=activity_labels)
```

---

* Step 4 - Appropriately labels the data set with descriptive variable names. 

I renamed the variables in the following way


+ "()"" removed
+ "-"" removed
+ "std" changed in "Standard Deviation""
+ "mean"" changed in "Mean"
+ "BodyBody" changed in "Body"

--------

* Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

I aggregate the data by subject and activity calculating the mean.

Finally I save the data in the txt file "Tidy_Data.txt"

------------

### Variables
* For a description of the oringinal data check the "README.txt" in the UCI HAR Dataset folder

* tidy is the variable dataframe  produced at the end of Step 5 [dimension 180 obs x 81 variables] that goes to the file "TidyData.txt" 

* features is the variable containing all features from the data file "features.txt" (e.g tBodyAcc-mean()-X) [dimension 561 obs x 2 variables]

* activity_labels is the variable containing the activity names from the data file "activity_labesl.txt" (e.g "WALKING") [dimension 6 obs x 2 variables]

* Following are temporary data to keep track of the changes
    + data is the variable dataframe produced at the end of Step 1 [dimension 10299 obs x 563 variables]
    + data1 is the variable dataframe  produced at the end of Step 2 [dimension 10299 obs x 81 variables]
    + data2 is the variable dataframe  produced at the end of Step 3 [dimension 10299 obs x 82 variables]
