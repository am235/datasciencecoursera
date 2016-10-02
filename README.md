---
title: "README"
author: "Andy Majumdar"
date: "Sunday, October 02, 2016"
output: html_document
---

This document illustrates the required project work details that is submitted as part of the
assignment.
The pre-requisite of running the run_analysis.R is to download the zipped version of the dataset and unarchive the dataset. Please ensure that the working directory (using the setwd) is set to the 
same folder where the "UCI HAR Dataset" folder is placed.

Sequence of the code:
1. Load raw data

2. Merge the dataset 
   (x and y values for the same source (training and test) are placed first)
   Source identified will distinguish whether data is from training or test.
   
   2.b. Label columns
   
3. Finding out the Mean and SD fields

4. Lookup to get the descriptive activity names

5. Appropriately labels the data set with descriptive names. (DataSetName: Detailed_Data_Set)

6. Creates a second, independent tidy data set with the average of each variable for each activity
and each subject. (DataSetName: Aggr_DataSet_by_act_sub)



