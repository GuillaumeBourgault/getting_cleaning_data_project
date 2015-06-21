Description of the script "run_analysis.r"
course: Getting and Cleaning Data
session: 015, June 1st 2015
Course project submission
Student: Guillaume Bourgault
The working directory should contain:
	-the script run_analysis.r
	-the folder "UCI HAR Dataset", as downloaded at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The following steps are followed
1
The name of the variables are loaded from features.txt
The files X_test.txt and X_train.xtx are read by the read.table function
The classes of the columns are numeric, and the column names are the ones found in feature.txt.  
The two data frames are merged using rbind().  
The result is all_data
2
The function select() from the plyr package allows to select columns based on their containing or not containing certain strings.  
The variables containing "mean" and "std" are selected
This also selects variables with "meanFreq", "gravitiyMean" and "AccMean", that should not be included.  
The result of the select is stored in all_data.  
3
The names of the activities are read from activity_labels.txt.  
The activity corresponding to each row is found in y_train.txt and y_test.txt.  
The vector containing numbers for activities should contain descriptive labels instead.  
The fonction merge() is used to get the dataframe activities.  
The column of activities containing the descriptive labels is forced in all_data using the mutate() function.  
4
If the variable starts with "t", it is a "time_domain' variable.  
If the variable starts with "f", it is a "Fourier_domain' variable. 
The name "std" is replaced by "standard_dev".  
If there is a direction (X, Y or Z), it is also detected.  
These features are rearranged with the following pattern:
[mean or standard_dev]-[variable_name]-[time_domain or Fourier_domain]-[direction_X-Y-Z]
This makes for long but easily understandable variable names.  
5
The id of the subjects are loaded from subject_test.txt and subject_train.txt.  
They are then forced in all_data with the mutate() function.  
The aggregate() function takes the mean of every variable.  
Variables are group by subject_ID and activity.  

