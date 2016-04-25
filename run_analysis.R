## Course project: run_analysis.R                 April 19th 2016

# Data URL:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#This script should:

# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each
#    measurement.
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive variable names.
# 5. From the data set in step 4, create a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

# ==========================================================================================
# User's functions written for this project:

partition_by <- function(dataframe, freqs, FUN){
    # Function to evaluate FUN on each group of observations of dataframe.
    # The groups will result from clustering and partitioning the dataframe 
    # by a 2D cross frequency table, freqs.
    # The two control variables are in the two last columns of dataframe.
    nrows_df <- nrow(dataframe); ncols_df <- ncol(dataframe)-2
    dataframe <- arrange(dataframe, Activity,Subject)
    nrows_tb <- nrow(freqs); ncols_tb <- ncol(freqs)
    result <- matrix(0, nrow = nrows_tb*ncols_tb, ncol = ncols_df) # Initialization
    # This three for loops apply function FUN on each group
    for (j in 1:ncols_df){
        i0 <- 1
        for (i in 1:nrows_tb){
            for (k in 1:ncols_tb){
                ik <- dataframe[i0,ncols_df+2]
                i1 <- i0 + freqs[i,ik]-1
                result[(i-1)*ncols_tb+k,j] <- sapply(list(dataframe[i0:i1,j]),FUN)
                i0 <- i1+1
            }
        }
    }
    result <- data.frame(result)
    # Fill data in the first two columns:
    activ <- unique(dataframe[,c(ncols_df+1)])
    subj <- unique(dataframe[,c(ncols_df+2)])
    k <- 0; 
    col1 <- matrix(0,nrow = nrows_tb * ncols_tb, ncol = 1)
    col2 <- col1
    for (i0 in 1:nrows_tb){
        for (i1 in 1:ncols_tb){
            k <- k + 1
            col1[k] <- activ[i0]
            col2[k] <- subj[i1]
        }
    }
    # Add the first two columns to the new data frame.
    result <- cbind(col1,col2,result)
    rownames(result) <- NULL
    return(result)
}

# ==========================================================================================
# This R script is made of independent sections, according with the instructions
# from the assignment. Each should be executed independently, though following a
# logical sequence.

# ==========================================================================================
# Section A).- ONLY ONCE: download the data and unpack it so as to have a local repository.
# The downloaded repository is: ./data/UCI_HAR_Dataset.

if(!file.exists("./data")){dir.create("./data")}
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl1, destfile='./data/UCI_HAR_Dataset.zip')
# Unpacking was done out of this script.

# ==========================================================================================
# Section B).- Reading files:
library(dplyr)
y_train <- read.table('./data/UCI_HAR_Dataset/train/y_train.txt')
X_train <- read.table('./data/UCI_HAR_Dataset/train/X_train.txt', sep = "")
subject_train <- read.table('./data/UCI_HAR_Dataset/train/subject_train.txt')

y_test <- read.table('./data/UCI_HAR_Dataset/test/y_test.txt')
X_test <- read.table('./data/UCI_HAR_Dataset/test/X_test.txt', sep = "")
subject_test <- read.table('./data/UCI_HAR_Dataset/test/subject_test.txt')

features <- read.table('./data/UCI_HAR_Dataset/features.txt', sep = "", stringsAsFactors = FALSE)

# ==========================================================================================
# Section C: Join everything in a global data frame:
# Merges the training and the test sets to create one data set.
names(y_train) <- 'y'; names(subject_train) <- 'subject'
names(y_test) <- 'y'; names(subject_test) <- 'subject'
big_joint <- rbind(cbind(X_train,y_train,subject_train), cbind(X_test,y_test,subject_test))
# Some checking:
table(big_joint$subject) # Distribution of row frequency among the subjects (volunteers).
sum(table(big_joint$subject)) # Sum up row frequency of each subject. Equals dim(big_joint)[1]. 
mean(table(big_joint$subject))*1.28/60 # Mean time in minutes invested per subject in the experiment.

# ==========================================================================================
# Section D: Extracts only the measurements on the mean and standard deviation for each 
# measurement.
# Choose variable names containing "mean()" and "std()" expressions.
# but discard those with "meanFreq" pattern.
pre_chosen <- as.array(grep("mean()",features[,2]))
no_chosen <- as.array(grep("meanFreq",features[,2]))
chosen <- setdiff(pre_chosen,no_chosen)
chosen1 <- as.array(grep("std()",features[,2]))
chosen <- sort(union(chosen,chosen1))
# Add two last variables: y label and subject:
chosen <- union(chosen,c(562,563))
reduced_dataset <- select(big_joint, c(chosen))

# ==========================================================================================
# Section E: Use descriptive activity names to name the activities in the data set.
# This applies to the label 'y' column, the only one where activities appear:
act_names <- c("Walking","Walking upstairs","Walking downstairs","Sitting","Standing","Laying")
reduced_dataset <- mutate(reduced_dataset, y = act_names[y])

# ==========================================================================================
# Section F: Appropriately label the data set with descriptive variable names.
names(big_joint)[1:561] <- features[,2] # To prepare an afterward control of names.
original_reduced_names <- names(big_joint[c(chosen)]) # Selected names as given.
# Read file with new names:
approp_names <- read.table('./data/UCI_HAR_Dataset/New_names.txt', sep = ",", stringsAsFactors = FALSE)
# I consider the following way quite better than using select or rename in this case:
names(reduced_dataset)[1:length(chosen)] <- approp_names[,1] # Descriptive variable names.

# ==========================================================================================
# Section G: From the data set in section F, create a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
counters <- table(reduced_dataset$Activity,reduced_dataset$Subject)
# Create the requested data set via an ad hoc function:
grouped_dataset <- partition_by(reduced_dataset, counters, mean)
# Apply the long names to this computed dataset:
dims <- dim(grouped_dataset) 
names(grouped_dataset)[c(1,2)] <- c('Activity','Subject')
names(grouped_dataset)[c(3:dims[2])] <- approp_names[1:(dims[2]-2),1] 

# ==========================================================================================
# Write the file grouped_dataset for submission.
write.table(grouped_dataset, file = "./data/Output_dataset from step 5.txt",row.names = FALSE)
# Test the reading back:
read_test <- read.table("./data/Output_dataset from step 5.txt", header = TRUE)
View(read_test)
