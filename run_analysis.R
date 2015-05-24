## This script downloads the UCI HAR Data Set and completes
## the following tasks.
##
## 1. Merges the training and test sets to create one data set
## 2. Extracts only the measurements on the mean and standard
## deviation for each measurement
## 3. Uses descriptive activity names to name the activities in 
## the dataset
## 4. Appropriately labels the data set with descriptive variable  names
## 5. From the data set in step 4, creates a second, independent tidy
## data set with the average of each variable for each activity
## and each subject


## init function sets up the environment

init <- function() {
  
  ## Import libraries
  library(data.table)
  library(dplyr)
  library(tidyr)

  ## Download and read file from internet
  getFile()
  
}


## getFile function downloads and extracts data from the archive

getFile <- function() {

  ## Confirm correct working directory or stop
  
  if(!file.exists("run_analysis.R")) {
    print("Please set working directory to root folder")
    stop()
  }
  
  ## Check for existence of UCIData directory - if not, create it
  
  if(!file.exists(file.path("UCIData"))) {
    dir.create(file.path("UCIData"))
  }
  
  ## Check for UCIDataset.zip - if not, download it
  
  filename <- file.path("UCIData", "UCIHARDataset.zip", 
        collapse = "")
  
  if(!file.exists(filename)) {    
    fileUrl <- paste(c("https://d396qusza40orc.cloudfront.net",
        "/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"), collapse = "")
    download.file(fileUrl, filename, method = "curl")
  }
  
  ## Check if archive has been unzipped - if not, unzip
  
  unzipped <- file.path("UCIData", "UCI HAR Dataset")
  if(!file.exists(unzipped)) {
    unzip(filename, exdir = file.path("UCIData"))
  }
  
  ## Set working directory to unzipped UCI HAR Dataset directory
  
  setwd(file.path("UCIData", "UCI HAR Dataset"))
  
}


## tidyTable function adds ids to the rows and labels columns for merging

tidyTable <- function(dt, tablename) {
  
  ## Inputs: dt - data.table, tablename - shortened name of data.table file
  ## Outputs: dt - modified data.table
  
  ## Rename V1 in data.table to appropriate name based on whether 
  ## data.table is Activity or Subject dataset
  
  if (length(grep("y", tablename)) > 0) {
    setnames(dt, "V1", "Activity")    
  } else if (length(grep("subject", tablename)) > 0) {
    setnames(dt, "V1", "Subject")
  }
  
  ## Add correct id column to data.table, depending on whether data.table is 
  ## train or test data
  
  if (length(grep("train", tablename)) > 0) {
    dt <- mutate(dt, id = seq(1:nrow(dt)))
  } else if (length(grep("test", tablename)) > 0) {
    lastRow <- (nrow(dt)+7352)
    dt <- mutate(dt, id = 7353:lastRow)
  }
  
  ## Set id as key for data.table for merging purposes
  
  setkey(dt, id)
  
  ## Return modified data.table
  
  return(dt)
}


## renameHeaders function renames the headers based on the features vector

renameHeaders <- function(dt, x) {
  
  ## Inputs: dt - data.table, x - character vector of all features
  ## Outputs: dt - modified data.table
    
  ## Step through vector x
  
  for(i in 1:length(x)) {
    
    ## Check whether feature is either mean or std measurement
    ## If so, update first letter to Time. or FFT. (Fast Fourier Transform)
    
    if(length(grep("mean", x[i])) > 0 | length(grep("std", x[i])) > 0) {      
      firstLetter <- substr(x[i], 1, 1)
      if(firstLetter == "t") {
        nextLetters <- substr(x[i], 2, nchar(x[i]))
        x[i] <- paste0("Time.", nextLetters, collapse = "")
      } else if (firstLetter == "f") {
        nextLetters <- substr(x[i], 2, nchar(x[i]))
        x[i] <- paste0("FFT.", nextLetters, collapse = "")
      }
      
      ## Replace unclear terms in the column headers
      
      x[i] <- sub("mean()", "mean", x[i], fixed = TRUE)
      x[i] <- sub("std()", "std", x[i], fixed = TRUE)
      x[i] <- sub("Freq()", "Freq", x[i], fixed = TRUE)
      x[i] <- sub("BodyBody", "Body", x[i])
      x[i] <- sub("Body", "Body.", x[i])
      x[i] <- sub("Gravity", "Gravity.", x[i])
      x[i] <- sub("Gyro", "Gyroscope.", x[i])
      x[i] <- sub("Acc", "Accelerometer.", x[i])
      x[i] <- sub("Jerk", "Jerk.", x[i])
      x[i] <- sub("Mag", "Magnitude.", x[i])
      
      ## Tidy column name output
      
      x[i] <- gsub("-", ".", x[i])
      x[i] <- gsub("..", ".", x[i], fixed = TRUE)
      
    }    
  }
  
  ## Set headers of data.table to correct names
  
  headers <- c("id", "Activity", "Subject", x)
  dt <- setnames(dt, colnames(dt), headers)
  
  ## Return modified data.table
  
  return(dt)
  
}


## renameActivities function renames activities based on the activities vector

renameActivities <- function(dt, x) {
  
  ## Inputs: dt - data.table, x - character vector of activities
  ## Outputs: dt - modified data.table
  
  ## Order the data.table
  
  dt <- arrange(dt, Activity, Subject)
  
  ## Step through x vector renaming Activity in data.table
  
  for (i in 1:6) {
    dt$Activity[dt$Activity == i] <- x[i]
  }
  
  ## Return modified data.table
  
  return(dt)
  
}


## summarizeData extracts mean and std measurements based on column headers

summarizeData <- function(dt) {

  ## Inputs: dt - data.table
  ## Outputs: dt - summarized data.table
  
  ## Select relevant columns
  
  mean <- grep("mean", colnames(dt))
  std <- grep("std", colnames(dt))  
  dt <- select(dt, 1:3, mean, std)
  
  ## Summarize data by Activity and Subject
  
  dt <- dt %>%
    group_by(Activity, Subject) %>%
    summarise_each(funs(mean))
  
  ## Remove redundant id column
  
  dt[, id:=NULL]
  
  ## Return summarized data.table
  
  return(dt)
  
}


## runAnalysis is the main function that begins the script

runAnalysis <- function() {
  
  ## Setup clean up
  
  wd <- getwd()
  prompt <- "Delete UCIData directory after script runs? (Y/N)"
  clean <- readline(prompt)
  
  ## Initialize the environment
  
  init()
  
  ## Step through UCIData directory and files to create data.tables for merging
  ## Create X_train, X_test, y_train, y_test, subject_train, subject_test 
  ## data.tables
  
  dirs <- list.dirs(recursive = FALSE)
  
  for (i in 1:length(dirs)) {
    files <- list.files(dirs[i])
    for (j in 1:length(files))  {
      if(length(grep(".txt", files[j])>0)) {
        
        ## Set tablename to shortened filename
        
        tablename <- files[j]
        tablename <- gsub(".txt", "", tablename)
        
        ## Read file to data.table and send to function tidyTable to be tidied
              
        file <- file.path(dirs[i],files[j])
        dt <- data.table(read.table(file))
        dt <- tidyTable(dt, tablename)
        
        ## Assign data.table to the appropriate name in the current environment
        
        assign(tablename, dt)      
      }
    }
  }
  
  ## Merge all of train and test data sets into separate train and test 
  ## data.tables
    
  test <- y_test %>%
      merge(subject_test) %>%
      merge(X_test) 
    
  train <- y_train %>%
      merge(subject_train) %>%
      merge(X_train)

  
  ## Merge train and test data.tables together into a single allData data.table 
  
  allData <- rbind(data = train, data = test)
  
  
  ## Create the features character vector for the renameHeaders function
  
  dt <- data.table(read.table("features.txt"))
  features <- as.character(dt[[2]])
  
  ## Create the activities character vector for the renameActivities function
  
  dt <- data.table(read.table("activity_labels.txt"))
  activities <- as.character(dt[[2]])
  
  ## Rename headers and activities
  
  allData <- renameHeaders(allData, features)
  allData <- renameActivities(allData, activities)
  
  
  ## Summarize data and writes output file
  
  summaryData <- summarizeData(allData)
  
  setwd(wd)
  write.table(summaryData,"tidydata.txt", row.name=FALSE)
   
  
  ## Clean up
  
  if (clean == "Y" | clean == "y") {
    prompt <- "Are you sure you want to delete the UCIData directory? (Y/N)"
    clean <- readline(prompt)
    
    ## Case sensitive check for second approval of data removal
    
    if (clean == "Y") {
      unlink("UCIData", recursive = TRUE)
    }
  }
  
  # Run test on output data.table to confirm output is still correct
  
  test <- readline("Do you want to run the test? (Y/N)")
  
  if (test == "Y" | test == "y"){
    source("run_tests.R")  
  }
  
}

## readOutputTable function provides a simple tool for the reviewer to view the
## final data.table

readOutputTable <- function() {
  
  ## Outputs: Loads View on and returns data.table dt
  
  if(!file.exists("tidydata.txt")) {
    print("Please set working directory to root folder")
    stop()
  }
  dt <- data.table(read.table("tidydata.txt", header = TRUE))
  
  View(dt)
  
  return(dt)
}
  