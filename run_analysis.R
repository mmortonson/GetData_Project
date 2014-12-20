# R version 3.1.2
library(dplyr)  # version 0.3.0.2 


## download and unzip data if necessary

required_files <- readLines("required_data_files.txt")
if(!all(file.exists(required_files))) {
    print("Some data files are missing. Downloading a new copy...", 
          quote = FALSE)
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                  "UCI HAR Dataset.zip", method = "curl")
    unzip("UCI HAR Dataset.zip")
}


## read in the data

# read feature and activity labels
features <- read.table("UCI HAR Dataset/features.txt",
                       stringsAsFactors = FALSE)[[2]]
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",
                              stringsAsFactors = FALSE)[[2]]

# make sure features have unique names (some appear multiple times)
name_counts <- table(features)
repeated_names <- names(name_counts[name_counts > 1])
for(i in 1:length(repeated_names)) {
    indices <- which(features == repeated_names[i])
    new_names <- paste(repeated_names[i], 1:length(indices), sep = "-")
    features[indices] <- new_names
}

# read the training and test data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt",
                      nrows = 7352, colClasses = "numeric",
                      comment.char = "")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",
                      nrows = 7352, colClasses = "numeric",
                      comment.char = "")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",
                            nrows = 7352, colClasses = "numeric",
                            comment.char = "")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt",
                     nrows = 2947, colClasses = "numeric",
                     comment.char = "")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",
                     nrows = 2947, colClasses = "numeric",
                     comment.char = "")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",
                           nrows = 2947, colClasses = "numeric",
                           comment.char = "")
# don't bother loading data in the Inertial Signals directories
# since they would all be excluded later anyway


## merge training and test data sets

# set column names using the features vector
names(X_train) <- features
names(X_test) <- features

# add subject and activity (y) to the main data frames (X)
X_train$subject <- subject_train[[1]]
X_train$activity <- y_train[[1]]
X_test$subject <- subject_test[[1]]
X_test$activity <- y_test[[1]]

# add a column identifying the training and test data
X_train$data.subset <- "train"
X_test$data.subset <- "test"

# put the data in dplyr data frame tbl format, then merge train and test
data_all <- rbind_list(tbl_df(X_train), tbl_df(X_test))


## extract mean and standard deviation measurements
# (note: I am interpreting this as only the variables that are 
#  mean values or standard deviations according to features_info.txt,
#  which excludes some other variables that happen to have 'Mean' as
#  part of the name)

# get all features with labels that include 'mean()' or 'std()'
# and also keep the subject and activity columns
data_mean_std <- select(data_all, contains("mean()"), contains("std()"),
                        subject, activity)


## give descriptive names to activities

# use activity_labels to replace activity integer codes with names
data_mean_std <- mutate(data_mean_std, 
                        activity = factor(activity_labels[activity]))


## give descriptive names to variables

# the variable names from features.txt are already fairly descriptive,
# so I will just clean up the names a little here

new_names <- names(data_mean_std)

# remove parentheses after 'mean' and 'std'
new_names <- sapply(new_names, function(x) gsub("()", "", x, fixed = TRUE))

# replace hyphens with periods
new_names <- sapply(new_names, function(x) gsub("-", ".", x, fixed = TRUE))

# replace 't' and 'f' with 'time.' and 'freq.' to make the meaning
# of these prefixes a little clearer
new_names <- sapply(new_names, function(x) gsub("^t", "time.", x))
new_names <- sapply(new_names, function(x) gsub("^f", "freq.", x))

# update variable names
names(data_mean_std) <- new_names


## create a tidy data set with the average of each variable
## for each activity and subject

data_average <- data_mean_std %>% 
    group_by(activity, subject) %>%
    summarise_each(funs(mean))

# this is now a tidy data set:
# - each row contains one observation (combination of subject and activity)
# - each column contains one variable (activity type, subject ID,
#   or the average of some measured value)
# - this is a single set of observations, so it makes sense to
#   store it all in one table

# I could rearrange the data further, e.g. combining each set of
# X/Y/Z/Mag columns into a single column and adding an extra column
# with values X/Y/Z/Mag, but it's unclear whether this would be any 
# tidier than the current format so I'll leave it as is

write.table(data_average, "tidydata.txt", row.name = FALSE)