# Getting-and-Cleaning-Data

This script downloads the UCI HAR Data Set (available 
[here](https://goo.gl/8Ges4M)). It is data  collected from the accelerometers 
from the Samsung Galaxy S smartphone. 

A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

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