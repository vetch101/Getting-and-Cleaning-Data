# Course Project 

## Overview

This script downloads the UCI HAR Data Set (available 
[here](https://goo.gl/8Ges4M)). It is data collected from accelerometers 
from the Samsung Galaxy S smartphone.

Once downloaded, the script completes the following tasks:

1. Merges the training and test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation 
for each measurement
3. Uses descriptive activity names to name the activities inthe dataset
4. Appropriately labels the data set with descriptive variable  names
5. From the data set in step 4, creates a second, independent tidy data set 
with the average of each variable for each activity and each subject

The source code repository also contains a unit test to confirm that any 
modifications of the code continue to output the same data table.

## Summarized Data Set

The summarized dataset is provided as a data.table called tidy_data.txt in the 
root of the source code folder. 

The reviewer can check the summarized table output by sourcing the script
run_analysis.R and executing readOutputTable(). This function reads the 
tidy_data.txt file into a data.table, dt, outputs it to the RStudio environment,
and returns it to the console or any assigned variable.

The summarized dataset consists of 180 observations of 81 variables. 
These values are consolidated from a larger dataset of sensor data collected 
from the mobile devices from 30 subjects while in the process of completing 
6 different activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, 
STANDING, LAYING.

A full description of the original data is available at the site where the data 
was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

More information on the specifics of the summarized data set can be found in the
code book, Codebook.md.

## Script Explanation

The script is split into three main functions, five helper functions and two
test functions.

### Main Functions

**runAnalysis()**

runAnalysis is the main function that begins the script.

runAnalysis steps are listed below:

* Setup clean up to collect correct working directory and check if data should
	be deleted after the script runs
* Initialize the environment by calling init()
* Step through UCIData directory and files to select files for merging
* Set tablename to shortened filename (removing ".txt")
* Read file to data.table and send to function tidyTable() to be tidied
* Assign data.table to the appropriate name in the current environment
* This creates X_train, X_test, y_train, y_test, subject_train, subject_test 
	data.tables
* Merge all of train and test data sets into separate train and test 
	data.tables
* Merge train and test data.tables together into a single allData data.table
* Create the features character vector for the renameHeaders(dt, x) function
* Create the activities character vector for the renameActivities(dt, x) 
  function
* Rename headers and activities by executing renameHeaders(dt, x) and 
	renameActivities() on data.table allData, passing in the features and 
	activities vectors
* Execute summarizeData(dt) passing in allData and returning summaryData
* Write summaryData data.table output file to tidy_data.txt
* Clean up by returning to previous working directory
* Check to see if the UCIData directory should be removed
* Source("run_tests.R") to run tests on tidy_data.txt to test output is as 
	expected

**init()**

The init function sets up the environment.

init steps are listed below:

* Load the required libraries (data.table, dplyr and tidyr)
* Execute getFile()

**summarizeData(dt)**

The summarizeData function extracts mean and std measurements based on column 
headers.

* Inputs: dt - data.table
* Outputs: dt - summarized data.table

summarizeData steps are listed below:

* Select relevant columns based on mean and std in the column names
* Summarize data by Activity and Subject using group_by and summarise_each to 
   apply mean against all the readings for that Subject and Activity
* Remove redundant id column
* Return summarized data.table

**readOutputTable()**

The readOutputTable function provides a simple tool for the reviewer to view the
	final data.table.
  
* Outputs: Loads View on and returns data.table dt

readOutputTable steps are listed below:

* Check for tidy_data.txt file
* Reads tidy_data.txt to a data.table, dt
* Views dt in RStudio
* Returns dt

### Helper Functions

**getFile()**

The getFile function is a helper function for init(). It downloads and extracts 
data from the original archive file.

getFile steps are listed below:

* Check that R is in the appropriate working directory
* Check for the existence of the data directories and files
* Unzip the data directories and files if not available
* Set working directory to the UCI HAR Dataset directory

**tidyTable(dt, tablename)**

The tidyTable is a helper function for runAnalysis(). It adds ids to rows and 
labels columns on a data table for merging.

* Inputs: dt - data.table, tablename - shortened name of data.table file
* Outputs: dt - modified data.table

tidyTable steps are listed below:

* Rename V1 in data.table to appropriate name based on whether data.table is
	 Activity or Subject dataset
* Add correct id column to data.table, depending on whether data.table is 
	 train or test data
* Set id as key for data.table for merging purposes
* Return modified data.table

**renameHeaders(dt, x)**

The renameHeaders function is a helper function for runAnalysis(). It renames 
the column headers based on the passed in features character vector.

* Inputs: dt - data.table, x - character vector of all features
* Outputs: dt - modified data.table

renameHeaders steps are listed below:

* Step through vector x
* Check whether feature is either mean or std measurement
* Update first letter to either Time. or FFT. (Fast Fourier Transform(
* Replace unclear terms in column headers
* Tidy column name output by removing spurious hyphens and periods
* Set headers of data.table to correct names
* Return modified data.table

**renameActivities(dt, x)**

The renameActivities function is a helper function for runAnalysis(). It renames
actvities based on the passed in activities	vector.

* Inputs: dt - data.table, x - character vector of activities
* Outputs: dt - modified data.table

renameActivities steps are listed below:

* Order the data.table
* Step through x vector renaming Activity in data.table
* Return modified data.table

### Test Scripts

**run_tests.R**

The run_tests script sets up the testing environment.

run_tests steps are listed below:

* Load library RUnit
* Source run_analysis.R
* Select test script "test_output.R" in tests directory
* Run tests

**test_output.R**

The test_output script contains the test.

test_output steps are listed below:

* Check that new code modifications have not altered output
* Load original output data.table, "test_tidydata.txt" from tests directory
* Load new output "tidydata.txt"
* Check data.tables are identical

### Questions

Please feel free to direct any questions or queries to my Vetch101 account in
github.