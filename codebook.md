# Code Book

## Overview

The summarized dataset is provided as a data.table called tidydata.txt in the 
root of the source code folder. 

The reviewer can check the summarized table output by sourcing the script
run_analysis.R and executing readOutputTable(). This function reads the 
tidy_data.txt file into a data.table, dt, outputs it to the RStudio environment,
and returns it to the console or any assigned variable.

The summarized dataset consists of 180 observations of 81 variables. 
These values are consolidated from a larger dataset of multi-variate time series
sensor data collected from the mobile devices from 30 subjects while in the 
process of completing 6 different activities: WALKING, WALKING_UPSTAIRS, 
WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

Each observation is a row on the table, with the mean of each of the variables
consolidated per Activity and Subject in each column.

A full description of the original data is available at the site where the data 
was obtained: 
  
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Synopsis

The dataset is ordered by Activity and then by Subject (1 to 30). The original 
provider of the data collected values from the accelerometer and gyroscope 
on 3-axial raw signals of X, Y and Z by time captured at a constant rate of 50 
Hz. Data captured by time is denoted within the columns in the summarized 
dataset as "Time", with the body and gravity data denoted as "Body", and 
"Gravity", respectively, while the X, Y and Z values has "X", "Y" and "Z" in 
the column name. The data captured from the accelerometer and the gyroscope is 
denoted as "Accelerometer" and "Gyroscope". As with all the following variable 
names, the variable types are separated by periods (full stops).

The values were filterd with a median filter, and a 3rd order low pass 
Butterworth filter with a corner frequency of 20Hz to remove noise. The 
acceleration signal was then separated into body and gravity acceleration 
signals using another low pass Butterworth filter with a corner frequency of 
0.3 Hz.

The body linear acceleration signals were used with angular velocity to obtain 
Jerk signals. Also, the magnitude of these three dimensional signals were
calculated using the Euclidean norm. Jerk and magnitude measurements 
are denoted with "Jerk", and "Magnitude", respectively. 

Finally, a Fast Fourier Transform was applied to some of these signals. These
signals are denoted with "FFT" at the start of the column name.

These data are combined to provide mean, weighted average of the frequency 
components to obtain a mean frequency and standard deviation for some of these
data, denoted by "mean", "meanFreq" and "std" in the column name.

Thus, the column names are of the form:
  
* Activity
* Subject
* Time / FFT
* Body / Gravity
* Accelerometer / Gyroscope
* Jerk
* Magnitude
* mean / meanFreq / std
* X / Y / Z

The full list of variables is in the table below.

## Data Dictionary

| Column|Names                                          |Type               |Values                       |
|------:|:----------------------------------------------|:------------------|:----------------------------|
|      1|Activity                                       |Factor w/ 6 Levels |WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING|
|      2|Subject                                        |Int                |1 to 30                         |
|      3|Time.Body.Accelerometer.mean.X                 |num                |Normalized to between -1 and +1 |
|      4|Time.Body.Accelerometer.mean.Y                 |num                |Normalized to between -1 and +1 |
|      5|Time.Body.Accelerometer.mean.Z                 |num                |Normalized to between -1 and +1 |
|      6|Time.Gravity.Accelerometer.mean.X              |num                |Normalized to between -1 and +1 |
|      7|Time.Gravity.Accelerometer.mean.Y              |num                |Normalized to between -1 and +1 |
|      8|Time.Gravity.Accelerometer.mean.Z              |num                |Normalized to between -1 and +1 |
|      9|Time.Body.Accelerometer.Jerk.mean.X            |num                |Normalized to between -1 and +1 |
|     10|Time.Body.Accelerometer.Jerk.mean.Y            |num                |Normalized to between -1 and +1 |
|     11|Time.Body.Accelerometer.Jerk.mean.Z            |num                |Normalized to between -1 and +1 |
|     12|Time.Body.Gyroscope.mean.X                     |num                |Normalized to between -1 and +1 |
|     13|Time.Body.Gyroscope.mean.Y                     |num                |Normalized to between -1 and +1 |
|     14|Time.Body.Gyroscope.mean.Z                     |num                |Normalized to between -1 and +1 |
|     15|Time.Body.Gyroscope.Jerk.mean.X                |num                |Normalized to between -1 and +1 |
|     16|Time.Body.Gyroscope.Jerk.mean.Y                |num                |Normalized to between -1 and +1 |
|     17|Time.Body.Gyroscope.Jerk.mean.Z                |num                |Normalized to between -1 and +1 |
|     18|Time.Body.Accelerometer.Magnitude.mean         |num                |Normalized to between -1 and +1 |
|     19|Time.Gravity.Accelerometer.Magnitude.mean      |num                |Normalized to between -1 and +1 |
|     20|Time.Body.Accelerometer.Jerk.Magnitude.mean    |num                |Normalized to between -1 and +1 |
|     21|Time.Body.Gyroscope.Magnitude.mean             |num                |Normalized to between -1 and +1 |
|     22|Time.Body.Gyroscope.Jerk.Magnitude.mean        |num                |Normalized to between -1 and +1 |
|     23|FFT.Body.Accelerometer.mean.X                  |num                |Normalized to between -1 and +1 |
|     24|FFT.Body.Accelerometer.mean.Y                  |num                |Normalized to between -1 and +1 |
|     25|FFT.Body.Accelerometer.mean.Z                  |num                |Normalized to between -1 and +1 |
|     26|FFT.Body.Accelerometer.meanFreq.X              |num                |Normalized to between -1 and +1 |
|     27|FFT.Body.Accelerometer.meanFreq.Y              |num                |Normalized to between -1 and +1 |
|     28|FFT.Body.Accelerometer.meanFreq.Z              |num                |Normalized to between -1 and +1 |
|     29|FFT.Body.Accelerometer.Jerk.mean.X             |num                |Normalized to between -1 and +1 |
|     30|FFT.Body.Accelerometer.Jerk.mean.Y             |num                |Normalized to between -1 and +1 |
|     31|FFT.Body.Accelerometer.Jerk.mean.Z             |num                |Normalized to between -1 and +1 |
|     32|FFT.Body.Accelerometer.Jerk.meanFreq.X         |num                |Normalized to between -1 and +1 |
|     33|FFT.Body.Accelerometer.Jerk.meanFreq.Y         |num                |Normalized to between -1 and +1 |
|     34|FFT.Body.Accelerometer.Jerk.meanFreq.Z         |num                |Normalized to between -1 and +1 |
|     35|FFT.Body.Gyroscope.mean.X                      |num                |Normalized to between -1 and +1 |
|     36|FFT.Body.Gyroscope.mean.Y                      |num                |Normalized to between -1 and +1 |
|     37|FFT.Body.Gyroscope.mean.Z                      |num                |Normalized to between -1 and +1 |
|     38|FFT.Body.Gyroscope.meanFreq.X                  |num                |Normalized to between -1 and +1 |
|     39|FFT.Body.Gyroscope.meanFreq.Y                  |num                |Normalized to between -1 and +1 |
|     40|FFT.Body.Gyroscope.meanFreq.Z                  |num                |Normalized to between -1 and +1 |
|     41|FFT.Body.Accelerometer.Magnitude.mean          |num                |Normalized to between -1 and +1 |
|     42|FFT.Body.Accelerometer.Magnitude.meanFreq      |num                |Normalized to between -1 and +1 |
|     43|FFT.Body.Accelerometer.Jerk.Magnitude.mean     |num                |Normalized to between -1 and +1 |
|     44|FFT.Body.Accelerometer.Jerk.Magnitude.meanFreq |num                |Normalized to between -1 and +1 |
|     45|FFT.Body.Gyroscope.Magnitude.mean              |num                |Normalized to between -1 and +1 |
|     46|FFT.Body.Gyroscope.Magnitude.meanFreq          |num                |Normalized to between -1 and +1 |
|     47|FFT.Body.Gyroscope.Jerk.Magnitude.mean         |num                |Normalized to between -1 and +1 |
|     48|FFT.Body.Gyroscope.Jerk.Magnitude.meanFreq     |num                |Normalized to between -1 and +1 |
|     49|Time.Body.Accelerometer.std.X                  |num                |Normalized to between -1 and +1 |
|     50|Time.Body.Accelerometer.std.Y                  |num                |Normalized to between -1 and +1 |
|     51|Time.Body.Accelerometer.std.Z                  |num                |Normalized to between -1 and +1 |
|     52|Time.Gravity.Accelerometer.std.X               |num                |Normalized to between -1 and +1 |
|     53|Time.Gravity.Accelerometer.std.Y               |num                |Normalized to between -1 and +1 |
|     54|Time.Gravity.Accelerometer.std.Z               |num                |Normalized to between -1 and +1 |
|     55|Time.Body.Accelerometer.Jerk.std.X             |num                |Normalized to between -1 and +1 |
|     56|Time.Body.Accelerometer.Jerk.std.Y             |num                |Normalized to between -1 and +1 |
|     57|Time.Body.Accelerometer.Jerk.std.Z             |num                |Normalized to between -1 and +1 |
|     58|Time.Body.Gyroscope.std.X                      |num                |Normalized to between -1 and +1 |
|     59|Time.Body.Gyroscope.std.Y                      |num                |Normalized to between -1 and +1 |
|     60|Time.Body.Gyroscope.std.Z                      |num                |Normalized to between -1 and +1 |
|     61|Time.Body.Gyroscope.Jerk.std.X                 |num                |Normalized to between -1 and +1 |
|     62|Time.Body.Gyroscope.Jerk.std.Y                 |num                |Normalized to between -1 and +1 |
|     63|Time.Body.Gyroscope.Jerk.std.Z                 |num                |Normalized to between -1 and +1 |
|     64|Time.Body.Accelerometer.Magnitude.std          |num                |Normalized to between -1 and +1 |
|     65|Time.Gravity.Accelerometer.Magnitude.std       |num                |Normalized to between -1 and +1 |
|     66|Time.Body.Accelerometer.Jerk.Magnitude.std     |num                |Normalized to between -1 and +1 |
|     67|Time.Body.Gyroscope.Magnitude.std              |num                |Normalized to between -1 and +1 |
|     68|Time.Body.Gyroscope.Jerk.Magnitude.std         |num                |Normalized to between -1 and +1 |
|     69|FFT.Body.Accelerometer.std.X                   |num                |Normalized to between -1 and +1 |
|     70|FFT.Body.Accelerometer.std.Y                   |num                |Normalized to between -1 and +1 |
|     71|FFT.Body.Accelerometer.std.Z                   |num                |Normalized to between -1 and +1 |
|     72|FFT.Body.Accelerometer.Jerk.std.X              |num                |Normalized to between -1 and +1 |
|     73|FFT.Body.Accelerometer.Jerk.std.Y              |num                |Normalized to between -1 and +1 |
|     74|FFT.Body.Accelerometer.Jerk.std.Z              |num                |Normalized to between -1 and +1 |
|     75|FFT.Body.Gyroscope.std.X                       |num                |Normalized to between -1 and +1 |
|     76|FFT.Body.Gyroscope.std.Y                       |num                |Normalized to between -1 and +1 |
|     77|FFT.Body.Gyroscope.std.Z                       |num                |Normalized to between -1 and +1 |
|     78|FFT.Body.Accelerometer.Magnitude.std           |num                |Normalized to between -1 and +1 |
|     79|FFT.Body.Accelerometer.Jerk.Magnitude.std      |num                |Normalized to between -1 and +1 |
|     80|FFT.Body.Gyroscope.Magnitude.std               |num                |Normalized to between -1 and +1 |
|     81|FFT.Body.Gyroscope.Jerk.Magnitude.std          |num                |Normalized to between -1 and +1 |
