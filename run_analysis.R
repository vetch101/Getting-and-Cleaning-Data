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

## init sets up the environment

init <- function() {
  ## Import libraries
  library(data.table)
  library(dplyr)
  library(tidyr)
  
  ## Download and read data
  getFile()
  getData()
}

## getFile pulls down the file and extracts the data from the archive

getFile <- function() {

      if(!file.exists(file.path(getwd(),"data"))) {
        dir.create(file.path(getwd(),"data"))
      }
      fileUrl <- paste(c("https://d396qusza40orc.cloudfront.net",
          "/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"), collapse = "")
      filename <- file.path(getwd(), "data", "UCIHARDataset.zip", 
            collapse = "")
      unzipped <- file.path(getwd(), "data", "UCI HAR Dataset")
      if(!file.exists(filename)) {
        download.file(fileUrl, filename, method = "curl")
      }
      if(!file.exists(unzipped)) {
        unzip(filename, exdir = file.path(getwd(), "data"))
      }
      setwd(file.path("data", "UCI HAR Dataset"))
}

## getData creates the variables we work with

getData <- function() {
  
  dt <- data.table(read.table("features.txt"))
  features <- as.character(dt[[2]])
  assign("features", features, envir = globalenv())
  
  dirs <- list.dirs(recursive = FALSE)
  
  for (i in 1:length(dirs)) {
    files <- list.files(dirs[i])
    for (j in 1:length(files))  {
      if(length(grep(".txt", files[j])>0)) {
        varname <- files[j]
        varname <- gsub(".txt", "", varname)        
        file <- file.path(dirs[i],files[j])
        dt <- data.table(read.table(file))
        dt <- tidyTable(dt, varname)
        assign(varname, dt, envir = globalenv())      
      }
    }
  }
  
}

## tidyTable adds ids to the rows and labels columns for merging

tidyTable <- function(dt, varname) {
  if (length(grep("y", varname)) > 0) {
    setnames(dt, "V1", "Activity")    
  } else if (length(grep("subject", varname)) > 0) {
    setnames(dt, "V1", "Subject")
  }
  
  if (length(grep("train", varname)) > 0) {
    dt <- mutate(dt, id = seq(1:nrow(dt)))
  } else if (length(grep("test", varname)) > 0) {
    lastRow <- (nrow(dt)+7352)
    dt <- mutate(dt, id = 7353:lastRow)
  }  
  setkey(dt, id)
  dt
}

## mergeData function merges the training and test sets into one data set

mergeData <- function() {
  
  test <- mergeTables(y_test, "Test")
  train <- mergeTables(y_train, "Train")
  data <- rbind(data = train, data = test)
  
  
  
  data <- renameHeaders(data)
  data <- renameActivities(data)
  
  data
  
}

## mergeTables merges all the Testing and Training tables

mergeTables <- function(dt, testOrTrain) {
  
  if(testOrTrain == "Test") {
    
    dt <- dt %>%
      merge(subject_test) %>%
      merge(X_test) 
    
  } else if(testOrTrain == "Train") {
    
    dt <- dt %>%
      merge(subject_train) %>%
      merge(X_train)
  }
  
  dt
  
}

# renameHeaders renames the headers based on the features data table

renameHeaders <- function(dt) {
  
  x <- features
  
  for(i in 1:length(x)) {
    if(length(grep("mean", x[i])) > 0 | length(grep("std", x[i])) > 0) {      
      firstLetter <- substr(x[i], 1, 1)
      if(firstLetter == "t") {
        nextLetters <- substr(x[i], 2, nchar(x[i]))
        x[i] <- paste0("Time.", nextLetters, collapse = "")
      } else if (firstLetter == "f") {
        nextLetters <- substr(x[i], 2, nchar(x[i]))
        x[i] <- paste0("FFT.", nextLetters, collapse = "")
      }
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
      x[i] <- gsub("-", ".", x[i])
      x[i] <- gsub("..", ".", x[i], fixed = TRUE)
    }    
  }
  
  features <- x
  
  headers <- c("id", "Activity", "Subject", features)
  dt <- setnames(dt, colnames(dt), headers)
  dt
}

# renameActivities renames the activities based on their description

renameActivities <- function(dt) {
  
  dt <- arrange(dt, Activity, Subject)
  
  activities <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
  
  for (i in 1:6) {
    dt$Activity[dt$Activity == i] <- activities[i]
  }
  
  dt
  
}


# summarizeData extracts the mean and std values from the measurements

summarizeData <- function(dt) {

  mean <- grep("mean", colnames(dt))
  std <- grep("std", colnames(dt))
  
  dt <- select(dt, 1:3, mean, std)
  
  dt <- dt %>%
    group_by(Activity, Subject) %>%
    summarise_each(funs(mean))
  
  dt[, id:=NULL]
  
  dt
}

# Main function

runAnalysis <- function() {
  wd <- getwd()
  init()
  allData <- mergeData()  
  summaryData <- summarizeData(allData)
  setwd(wd)
  write.table(summaryData,"tidydata.txt")
}