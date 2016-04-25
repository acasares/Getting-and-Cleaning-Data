## Code Book:
24 - Abril - 2016

# Abstract:
This document updates the available codebook (file features_info.txt), whose information comes in the first part, with the data to indicate all the variables and summaries calculated, along with units and any other relevant information.
Thus, it is pretended that in this codebook you can find a description of all the variables, the data, and any transformations or work performed to clean up the data.

# Presentation of features and data from the initial document:

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ.
tGravityAcc-XYZ.

tBodyAccJerk-XYZ.

tBodyGyro-XYZ.
tBodyGyroJerk-XYZ.
tBodyAccMag.
tGravityAccMag.
tBodyAccJerkMag.
tBodyGyroMag.
tBodyGyroJerkMag.
fBodyAcc-XYZ.
fBodyAccJerk-XYZ.
fBodyGyro-XYZ.
fBodyAccMag.
fBodyAccJerkMag.
fBodyGyroMag.
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

## Updates and transformations performed on the original data:

During this assignment, the following work has been done on the data:

1.- A reduced set of variables was chosen, extracting only the measurements on the mean and standard deviation for each measurement. That is, from the above list of variables estimated from the signals, the first two were extracted:
mean(): Mean value
std(): Standard deviation
This dataset (called reduced\_dataset in the run_analysis.R script) has 66 estimated variables, plus the 'y' and 'subject'.

2.- The coded information about the activity: {1,2,3,4,5,6} was decodified according with the content of the given file activity\_labels.txt. That is: 
1: Walking
2: Walking upstairs
3: Walking downstairs
4: Sitting
5: Standing
6: Laying

3.- Descriptive variable names were assigned to the chosen variables and to the 'y' variable:
In order to do this, the table 2 of the original project paper:"A Public Domain Dataset for Human Activity Recognition (HAR) Using Smartphones", was consulted. In there are presented the generic names of the signals obtained from the smartphone sensors, in the two existent domains: time and frequency.

Using that generic names, and the original name of the data, the following nomenclature for the chosen variables was developed and applied:

 1.- Body Acceleration mean time in X
 2.- Body Acceleration mean time in Y
 3.- Body Acceleration mean time in Z
 4.- Body Acceleration time std. deviation in X
 5.- Body Acceleration time std. deviation in Y
 6.- Body Acceleration time std. deviation in Z
 7.- Gravity Acceleration mean time in X
 8.- Gravity Acceleration mean time in Y
 9.- Gravity Acceleration mean time in Z
10.- Gravity Acceleration time std. deviation in X
11.- Gravity Acceleration time std. deviation in Y
12.- Gravity Acceleration time std. deviation in Z
13.- Body Acceleration Jerk mean time in X
14.- Body Acceleration Jerk mean time in Y
15.- Body Acceleration Jerk mean time in Z
16.- Body Acceleration Jerk time std. deviation in X
17.- Body Acceleration Jerk time std. deviation in Y
18.- Body Acceleration Jerk time std. deviation in Z
19.- Body Angular Speed mean time in X
20.- Body Angular Speed mean time in Y
21.- Body Angular Speed mean time in Z
22.- Body Angular Speed time std. deviation in X
23.- Body Angular Speed time std. deviation in Y
24.- Body Angular Speed time std. deviation in Z
25.- Body Angular Acceleration mean time in X
26.- Body Angular Acceleration mean time in Y
27.- Body Angular Acceleration mean time in Z
28.- Body Angular Acceleration time std. deviation in X
29.- Body Angular Acceleration time std. deviation in Y
30.- Body Angular Acceleration time std. deviation in Z
31.- Body Acceleration Magnitude mean time
32.- Body Acceleration Magnitude time std. deviation
33.- Gravity Acceleration Magnitude mean time
34.- Gravity Acceleration Magnitude time std. deviation
35.- Body Acceleration Jerk Magnitude mean time
36.- Body Acceleration Jerk Magnitude time std. deviation
37.- Body Angular Speed Magnitude mean time
38.- Body Angular Speed Magnitude time std. deviation
39.- Body Angular Acceleration Magnitude mean time
40.- Body Angular Acceleration Magnitude time std. deviation
41.- Body Acceleration mean freqency in X
42.- Body Acceleration mean freqency in Y
43.- Body Acceleration mean freqency in Z
44.- Body Acceleration frequency std. deviation in X
45.- Body Acceleration frequency std. deviation in Y
46.- Body Acceleration frequency std. deviation in Z
47.- Body Acceleration Jerk mean frequency in X
48.- Body Acceleration Jerk mean frequency in Y
49.- Body Acceleration Jerk mean frequency in Z
50.- Body Acceleration Jerk frequency std. deviation in X
51.- Body Acceleration Jerk frequency std. deviation in Y
52.- Body Acceleration Jerk frequency std. deviation in Z
53.- Body Angular Speed mean frequency in X
54.- Body Angular Speed mean frequency in Y
55.- Body Angular Speed mean frequency in Z
56.- Body Angular Speed frequency std. deviation in X
57.- Body Angular Speed frequency std. deviation in Y
58.- Body Angular Speed frequency std. deviation in Z
59.- Body Acceleration Magnitude mean frequency
60.- Body Acceleration Magnitude frequency std. deviation
61.- Body Acceleration Jerk Magnitude mean frequency
62.- Body Acceleration Jerk Magnitude frequency std. deviation
63.- Body Angular Speed Magnitude mean frequency
64.- Body Angular Speed Magnitude frequency std. deviation
65.- Body Angular Acceleration Magnitude mean frequency
66.- Body Angular Acceleration Magnitude frequency std. deviation
67.- Activity
68.- Subject

The criteria was to eliminate most abbreviatures (std. was kept because it is standard) and try to express in plain english (or at least on what I think it is so) the significance of each variable, making explicit if it is a time or a frequency variable.

The units of these variables are: seconds for the time variables (1-40); Hz. for the frequency ones, (41-66), while the 67 and 68 are categorical variables.

4.- With the dataset built from the original data, joining the training and the test information, which was dimensioned 10299 x 563, a second, independent tidy data set was created applying the
three previously mentioned steps, and finally substituting all the observations per activity and subject with the average of each variable for each activity and each subject. That final dataset was called grouped\_dataset, and has dimensions 180 x 68. 
For easiness of reading, the variables were sorted in such a way as to positionate the Activity and Subject as the first two columns of the data frame. 


