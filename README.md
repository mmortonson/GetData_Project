GetData_Project
===============

This is a course project for the Coursera "Getting and Cleaning Data" 
class [1]. The assignment is to write an R script that loads smartphone
activity data from the UCI Machine Learning Repository [2] and performs
the following steps:

1. Merge training and test sets.
2. Extract mean and standard deviation measurements.
3. Provide descriptive names for the activity types.
4. Label the measured variables with descriptive names.
5. Create a tidy data set [3] that contains the average value of each 
   variable for every combination of activity type and subject ID.

There are 30 subjects and 6 activity types, so the final tidy data set
has a total of 180 rows. The original data set has 561 feature variables,
but only 66 of these are mean or standard deviation variables; including
the activity and subject columns, the final tidy data set has 68 columns.

## Files

* `run_analysis.R`: This is the main script, which reads the initial data
  set, performs the steps listed above, and writes the tidy data set 
  (`tidydata.txt`).
* `CodeBook.md`: A code book describing the properties of the data 
  (variables, processing steps, etc.).
* `README.md`: This file.
* `tidydata.txt`: The tidy data output from the analysis script. This can
  be read into R with `read.table("tidydata.txt", header = TRUE)`.
* `required_data_files.txt`: A list of data directories and files that the 
  analysis script expects to find in the working directory. If the files 
  are not found, the script will download and unzip the data from the UCI
  Machine Learning Repository.


[1]: https://class.coursera.org/getdata-016/
[2]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
[3]: http://vita.had.co.nz/papers/tidy-data.pdf
