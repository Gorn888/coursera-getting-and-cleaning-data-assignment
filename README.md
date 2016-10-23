# coursera-getting-and-cleaning-data-assignment

###Instructor's objectives on running run_analysis.R script
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement.
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names.
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###Preparation / Warning
1. This assignment is made by Rstudio on Windows 8.1 64bit, so some command about file path should be different to MAC.
2. There are some packages other than baseR in my code, please use command install.packages() as following;
  - downloader
  - plyr
  - data.table

###My Instruction when using the code
1. Please install any packages above before running run_analysis.R script.
2. You don't have to worry about loading and reading files as I've already prepared all things in code.
3. Requirement No.1-4 are achieved on the code at line76 resulting in selected_data1 object
4. Requirement No.5 is achieved as a file "tidy.txt"

###Summary of coding process
1. Load and read file, then keep them as objects in R
2. Prepare activity dataframe (ID and Names)
3. Prepare features dataframe (ID and Names)
4. Create dataframe for row names and combine both row names and column names to test data
5. repeat No.4 for train data
6. Merge all data to achieve requirement No.1-4
7. Create new data frame for indexing two groups in requirement No.5 
8. Merge again and making mean summarization
9. Export file "tidy.txt"
