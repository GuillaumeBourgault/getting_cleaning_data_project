#course: Getting and Cleaning Data
#session: 015, June 1st 2015
#Course project submission
#Student: Guillaume Bourgault
#script name: run_analysis.r
#setwd('C:\\data science\\getting_and_cleaning_data\\week 3')
library(dplyr)
library(gdata)
library(data.table)
#1. Merges the training and the test sets to create one data set.
#The script is in a folder that contains the UCI HAR Dataset folder
#reading the names of the columns
filename<- '.\\UCI HAR Dataset\\features.txt'
columns<-read.table(filename, sep = ' ')
colClasses<-rep('numeric', nrow(columns))
filename1<- '.\\UCI HAR Dataset\\test\\X_test.txt'
filename2<- '.\\UCI HAR Dataset\\train\\X_train.txt'
all_data = rbind(read.table(filename1, 
	colClasses = colClasses, 
	col.names = columns[,2]), 
	read.table(filename2, 
	colClasses = colClasses, 
	col.names = columns[,2]))
#2.Extracts only the measurements on the mean and standard deviation 
#for each measurement. 
all_data<-select(all_data, 
	contains('mean'), 
	-contains('meanFreq'), 
	-contains('gravityMean'), 
	-contains('AccMean'),
	contains('std'))
#3.Uses descriptive activity names to name the activities in the data set
filename<-'.\\UCI HAR Dataset\\activity_labels.txt'
activity_labels<-read.table(filename, col.names = c('label', 'activity'))
activity_labels<-activity_labels$activity
filename1<-'.\\UCI HAR Dataset\\test\\y_test.txt'
filename2<-'.\\UCI HAR Dataset\\train\\y_train.txt'
l<-rbind(read.table(filename1, col.names = 'label'), 
		read.table(filename2, col.names = 'label'))
activities<-activity_labels[l$label]
all_data<-mutate(all_data, 
	activity=factor(activities))
#4.Appropriately labels the data set with descriptive variable names. 
new_columns<-vector()
for (name in colnames(all_data)) {
	if (name == 'activity') {new_name<-'activity'
	} else {var<- substr(strsplit(name, '\\.')[[1]][1], 2, 100000)
			if (substr(name, 1,1)=='t'){tf <- 'time_domain'
			} else tf <- 'Fourier_domain'
			if (grepl('std', name)) ms <- 'standard_dev' else ms <- 'mean'
			if (grepl('X', name)) {
				dir<-'X'
			} else if (grepl('Y', name)) {
				dir<-'Y'
			} else if (grepl('Z', name)) {
				dir<-'Z'
			} else dir<- ''
			new_name<-paste(ms, var, tf, sep='-')
			if (!dir=='') new_name<-paste(new_name, paste('direction', dir, sep='_'), sep='-')
			}
	new_columns<-append(new_columns, new_name)
}
setnames(all_data, old=colnames(all_data), new=new_columns)
#5.From the data set in step 4, creates a second, independent tidy data 
#set with the average of each variable for each activity and each subject.
filename1<-'.\\UCI HAR Dataset\\test\\subject_test.txt'
filename2<-'.\\UCI HAR Dataset\\train\\subject_train.txt'
subjects<-rbind(read.table(filename1, col.names = 'subject'), 
		read.table(filename2, col.names = 'subject'))
all_data<-mutate(all_data, subject_ID=factor(subjects$subject))
clean<-aggregate(all_data, 
			by=list(subjectId = all_data$subject_ID, 
					activity = all_data$activity), 
			mean)[1:68]
write.table(clean, file = 'clean.txt', row.name=FALSE)