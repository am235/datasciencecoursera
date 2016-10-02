library(plyr)

# Directories and files
uci_hd <- "UCI\ HAR\ Dataset"
feature_file <- paste(uci_hd, "/features.txt", sep = "")
activity_lbl_file <- paste(uci_hd, "/activity_labels.txt", sep = "")
x_train_file <- paste(uci_hd, "/train/X_train.txt", sep = "")
y_train_file <- paste(uci_hd, "/train/y_train.txt", sep = "")
subjectnames_train_file <- paste(uci_hd, "/train/subject_train.txt", sep = "")
x_test_file  <- paste(uci_hd, "/test/X_test.txt", sep = "")
y_test_file  <- paste(uci_hd, "/test/y_test.txt", sep = "")
subjectnames_test_file <- paste(uci_hd, "/test/subject_test.txt", sep = "")


##################################################################
# 1. Load raw data
##################################################################
features <- read.table(feature_file, colClasses = c("character"))
activity_labels <- read.table(activity_lbl_file, col.names = c("ActivityId", "Activity"))
x_train <- read.table(x_train_file)
y_train <- read.table(y_train_file)
subject_train <- read.table(subjectnames_train_file)
x_test <- read.table(x_test_file)
y_test <- read.table(y_test_file)
subject_test <- read.table(subjectnames_test_file)

##################################################################
# 2. Merge the dataset
##################################################################

# Adding the sensor data: Test & Train
training_data <- cbind(cbind(x_train, subject_train), y_train)
training_data["source"] <- "training"
test_data <- cbind(cbind(x_test, subject_test), y_test)
test_data["source"] <- "test"
sensor_data <- rbind(training_data, test_data)

# Label columns
sensor_labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"),c(564, "source"))[,2]
names(sensor_data) <- sensor_labels

############################################################################################
# 3. Finding out the Mean and SD fields

sensor_data_mean_std <- sensor_data[,grepl("mean|std|Subject|ActivityId|source", names(sensor_data))]

###########################################################################
# 4. Lookup to get the descriptive activity names
###########################################################################

sensor_data_mean_std <- join(sensor_data_mean_std, activity_labels, by = "ActivityId", match = "first")
sensor_data_mean_std <- sensor_data_mean_std[,-1]

##############################################################
# 5. Appropriately labels the data set with descriptive names.
##############################################################

# Remove parentheses
names(sensor_data_mean_std) <- gsub('\\(|\\)',"",names(sensor_data_mean_std), perl = TRUE)
# Make syntactically valid names
names(sensor_data_mean_std) <- make.names(names(sensor_data_mean_std))
# Make clearer names
names(sensor_data_mean_std) <- gsub('Acc',"Acceleration",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Gyro',"AngularSpeed",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Mag',"Magnitude",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('^t',"TimeDomain.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('^f',"FrequencyDomain.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('\\.mean',".Mean",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('\\.std',".StandardDeviation",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Freq\\.',"Frequency.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Freq$',"Frequency",names(sensor_data_mean_std))
write.table(sensor_data_mean_std, file = "sensor_data_mean_std.txt")


######################################################################################################################
# 6. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
######################################################################################################################

sensor_avg_by_act_sub = ddply(sensor_data_mean_std, c("Subject","Activity"), numcolwise(mean))
write.table(sensor_avg_by_act_sub, file = "sensor_avg_by_act_sub.txt")

