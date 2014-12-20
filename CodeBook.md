Code book
=========

## Data and processing steps

The initial data set was downloaded from the UCI Machine Learning Repository
([http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]); the link contains a brief description of those data, and more 
detailed information is provided in the `README.txt` and 
`features_info.txt` files that are stored with the full data set.

The `run_analysis.R` script in this repo produces a reduced, tidy data set
that differs from the original data in three main ways:

* All data were combined in a single table (including training and test sets).
* Only measured variables corresponding to mean values or standard 
  deviations (identified by having 'mean()' or 'std()' in the original 
  variable names in `features.txt`) were retained. This reduces the 
  number of measured variables from 561 to 66.
* For all measurement variables, the tidy data set contains the average value
  for each combination of activity and subject. This reduces the number of
  rows from 10299 to 180 (30 subjects times 6 activity types).


## Variables

The first two columns of the tidy data set are:

1. `activity`: one of 6 character values describing the type of activity: 
   LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, and
   WALKING_UPSTAIRS.
2. `subject`: integers from 1 to 30 identifying the subject who 
   performed the activity.

Columns 3-68 each give the average value of a set of measurements 
corresponding to a particular activity and subject. (The original data
set has between 36 and 95 observations for each activity-subject pair.)
The names of these variables are composed of several parts, which can be
interpreted as follows:

* `time`/`freq`: whether the measurement is in the time domain or 
  frequency domain
* `Body`/`Gravity`: whether the signal is attributed to body motion 
  or gravitational force
* `Acc`/`Gyro`: which sensor the data came from (accelerometer or gyroscope)
* `Jerk`: if not included in the variable name, the measurement is 
  linear acceleration or angular velocity (depending on the sensor type); 
  if `Jerk` does appear in the name, then the measurement is the time 
  derivative of linear acceleration or angular velocity
* `mean`/`std`: whether the measurement in the original data set was a 
  mean value or standard deviation (in either case, the data were averaged
  within each activity-subject subset, so the values in the tidy data set
  are either means of means or means of standard deviations)
* `X`/`Y`/`Z`/`Mag`: the component of acceleration or angular velocity 
  measured (X, Y, or Z), or the magnitude of the 3-dimensional measurement
  computed with the Euclidean norm (`Mag`).

Note that all variables in the original data set were rescaled to the 
range [-1, 1], which explains why there are some negative values of 
standard deviations and magnitudes, and why the listed magnitudes are
not equal to the norms computed from the corresponding X, Y, and Z variables.

For more details, refer to `README.txt` and `features_info.txt` provided 
with the original data from the UCI Machine Learning Repository.
