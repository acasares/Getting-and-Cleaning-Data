---
title: "README.md"
author: "acasares"
date: "24 de abril de 2016"
---
## Getting-and-Cleaning-Data
Repository to submit assignments from the homonymous Coursera course.

## Source of the data for this assignement: 
ESANN 2013 proceedings.
"A Public Domain Dataset for Human Activity Recognition Using Smartphones"
Authors: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.

## Scripts of this project:
I have build one script, named, as requested, "run\_analysis.R". In that file is also included one ad hoc written funcion, called "partition_by()". Both the script and the function are broadly commented, so that may be easily understood, and those comments may enhance this description.

## Description of the steps of the solution:
The script has been organized following closely the five steps given in the instructions of the project. Is made up in eight sections, that can be executed one by one from R Studio (by selecting the lines of code to be run and hitting ctrl-Enter). They are rather independent one from another, but in general must be executed following the sequence found in the instructions; in other words, consecutively.

# Section A).- Downloads the data to be unpacked so as to have a local repository.
This only needs to be done once, and should preferably be commented out afterwards. The unpacking of the data was made manually, outside the script, but the rest of the sections need access to this unpacked data.
The downloaded repository is: ./data/UCI_HAR_Dataset, in the working directory.

# Section B).- Reads files:  
Loads the dplyr package, which will be quite used, and reads the files X_train, y_train, subject_train, X_test, y_test, subject_test, with read.table(). Also with this function, reads the features.txt file, this time with the stringsAsFactors = FALSE options, to make its processing feasible.  

# Section C): Merges the training and the test sets to create one data set.
Joins the files that has been read in a global data frame, merging the training and the test sets to create one global dataset. In Machine Learning terminology, it is quite usual to split the data in two (and even three) sets, called "training" and "test", to perform the "learning" stage - of the model's parameters - upon the training data, and the corresponding "test" stage, which, upon different data, estimates the accuracy of the learning  to make predictions that are contrasted with the labeled answer ("y"). So, what we are doing in this section is reconstructing the original dataset from its two constituent parts.

The resultant dataset has been called "big_joint". It has 10299 observations and 563 variables, including the subject's estimation of the activity reflected in the observation data (customarily labeled 'y'), and the numerical identification of the subject himself (an integer from 1 to 30).

In C section some preliminar EDA work is done, about the frequency of observations for each subject; the consistency of its sum with the total number of rows of the dataset, and the estimation of the time each experiment would've lasted.

# Section D: Extracts only the variables corresponding to the mean and standard deviation for each measurement. 
For this, it chooses variable names containing "mean()" and "std()" expressions, but discarding those with the "meanFreq" pattern, based on the information found in the features_info.txt file (the initial CodeBook?), where there are explicitly appart the "mean(): Mean value", and "std(): Standard deviation" variables, from the "meanFreq(): Weighted average of the frequency components to obtain a mean frequency". Although at first instance I tried to use one regular expression to select all the desired variables and none other, with the grep() or grepl() function, it did not work, so I prefered to make three different searches, and find out the desired result using set operators. 
Besides those, the last two columns of the data (the activity and subject variables) were also added, with their former labels.
The extraction itself was done through a select() call, with the chosen column numbers, giving birth to a new data frame, called reduced_dataset, 10299 x 68.

# Section E: Uses descriptive activity names to name the activities in the data set.
In the initial data files, the 'y' column was codified numerically (1 to 6). In this section those numeric codes were replaced in that variable by its corresponding activity names, found in the file activity_labels.txt, using the mutate() function.

# Section F: Appropriately labels the data set with descriptive variable names.
Based on the paper at  http://www.i6doc.com/en/livre/?GCOI=28001100131010, written by the original authors of the study, in particular on its table # 2, I prepared a file called "New\_names.txt", read by the script in this section with the "stringsAsFactors = FALSE" option, and assigned as new names to the chosen variables in the new reduced\_dataset frame, obtained from the big_joint in section D. 

# Section G: Obtains a second, collapsed untidy data set.
From the data set in section F, creates a second, independent tidy data set
with the average of each variable for each activity and each subject.

Although at the beginning I planned to use the group\_by function of the dplyr package, perhaps with the split() / lapply() sequence, after some intents I decided it was more practical to write a function specifically for this goal, to be used in this G section. It is called "partition_by()", located at the beginning of the script file, and naturally, must have been "sourced" (cataloged) in the environment previously to the execution of section G.

The function has three formal arguments: dataframe, freqs, and FUN.

"dataframe" is the dataset that is going to be condensed to the grouped averaged format. 

The freqs argument is a table of frequencies obtained in the script by doing          table(reduced\_dataset$Activity,reduced_dataset$Subject). 
That is, it is a contingency table whose (i,j) entry tells us how many windows (observations) of type Activity has the Subject j labeled, for every activity and every subject. Its dimensions are 6 x 30, and the sum of all its elements correspond to the number of observations (10299).

FUN is the function to apply (as a matter of fact, only to be called with function "mean" is required, but calling it, for example, with "sum", made possible to do consistency tests between the reduced\_dataset and the finally obtained grouped_dataset).

What the first step of partition_by does is to reorder the observations, using arrange(), sorting them by the two key columns, activity and subject, so the dataframe gets ordered in such a way that all observations corresponding to the same subject inside an activity are placed together; while this primary group itself is placed, relatively to the other similar groups, in an order according with the subject numeric code, inside the bigest secondary group of the activity; and the secondary groups are also ordered alphabetically among its homologous accordingly with the name of the activity.

With that structure, what the function has to do, column by column, is only find the average of the respective variable among the primary groups, collapsing each of them to one row. This is implemented with three for loops and one call to sapply(), as can be seen in the code, using the information of freqs to know in advance how many observations has each primary group.

Afterwards it only rests to organize the data in the two key columns, and place them at the beginning of the data frame before return it to the calling script, that assigns the long descriptive names to the columns in the final dataframe, named grouped_dataset, whose dimensions are now 180 x 68.  

# Closure section:
A last, unnamed section, was added. This writes the final dataset, to be submitted, in the data directory, under the name "Output_dataset from step 5.txt"; and, just in case, also does a recovery test.

## On the tidyness of the solution:
I think the obtained dataset is tidy, because, as far as I see, obey the rules:
1. Each variable forms a column.
    As far as I see it, the x, y and z components of the measurements are different variables, whose relationship gives the shape of the whole function, not only one variable. So, this rule is fulfilled.

2. Each observation forms a row.
    If we adhere to the definition of observation for the activity predictive purposes of this experiment, initially each row corresponded to one monitor window in a sliding window frame: the two signals (time and frequency) reflected on the monitor during 2.56 secs, sampled in 128 points. Each signal is measured in many features, and the number of these, after some previous preprocessing, summing up both signals, was originally 561 and finally 66.)
    After the transformations made in Section G, each row corresponds to only one subject and activity, thus to that section of one experiment where the subject developed the activity in question, which would be the new definition of observation, obeying  the rule. In this case, each observation tries to condense, through the statistical parameters of average and standard deviation, from a minimum of 36 to a maximum of 95 of the original observations (windows), and the dataset may be useful in later analysis. 

3. Each type of observational unit forms a table.

And in the obtained dataset does not appear any of the following cases:
. Column headers are values, not variable names.
. Multiple variables are stored in one column.
. Variables are stored in both rows and columns.
. Multiple types of observational units are stored in the same table.
. A single observational unit is stored in multiple tables.

The third rule arose some doubt on me: Inside the same observation, during the experiment, the monitor window shows two different signals, captured by two different sensors of the Samsung phone: one for times and another for frequencies. So it could be argued that those two are two types of observational units stored in the same table. But, focused in the hypothesis of the experiment, the two are working together in predicting the activity, so they shouldn't be split apart, in two tables, without compromising the integrity of the model - though it could have been done easily with the select() function. It also would have required adding redundantly the Activity and Subject variables to both tables. Besides, the splitting case could have been observed as a proposal where the last untidy case appears. 

