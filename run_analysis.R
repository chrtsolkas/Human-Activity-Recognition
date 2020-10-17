# Load the reqiered packages
required_packages <- c("data.table",
                       "dplyr",
                       "stringr") 

# sapply(required_packages, require, character.only = TRUE, quietly = TRUE)
invisible(sapply(required_packages, require, character.only = TRUE))

# Get the original data file and unzip it
if( !file.exists("./UCI HAR Dataset")) {
  tmp <- tempfile()
  
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = tmp)
  
  unzip(tmp)
  
  unlink(tmp)
}

# Read feature labels
feature_labels <- fread("./UCI HAR Dataset/features.txt", col.names = c("FeatureCode", "FeatureName"), data.table = FALSE)

# Read activity labels
activity_labels <- fread("./UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityCode", "ActivityName"), data.table = FALSE)

# Read the training data

# Read the training subject ids
train_subjects <- fread("./UCI HAR Dataset/train/subject_train.txt", col.names = c("SubjectID"), data.table = FALSE)

# Read training activities
y_train <- fread("./UCI HAR Dataset/train/y_train.txt", col.names = c("ActivityCode"), data.table = FALSE)
# Join them with activity_labels on ActivityCode
y_train <- inner_join(y_train, activity_labels, by = "ActivityCode")

# Read training set measurements and label them from feature_labels
X_train <- fread("./UCI HAR Dataset/train/X_train.txt", col.names = feature_labels$FeatureName, data.table = FALSE)

# The subjects that belong to the training set
# unique(train_subjects)
# How many subjects?
# nrow(unique(train_subjects))

# Dimensionality check
# dim(train_subjects)
# dim(y_train)
# dim(X_train)

# Read the test data

# Read the test subject ids
test_subjects <- fread("./UCI HAR Dataset/test/subject_test.txt", col.names = c("SubjectID"), data.table = FALSE)

# Read test activities
y_test <- fread("./UCI HAR Dataset/test/y_test.txt", col.names = c("ActivityCode"), data.table = FALSE)
# Join them with activity_labels on ActivityCode
y_test <- inner_join(y_test, activity_labels, by = "ActivityCode")

# Read test set measurements and label them from feature_labels
X_test <- fread("./UCI HAR Dataset/test/X_test.txt", col.names = feature_labels$FeatureName, data.table = FALSE)

# The subjects that belong to the test set
# unique(test_subjects)
# How many subjects?
# nrow(unique(test_subjects))

# Dimensionality check
# dim(test_subjects)
# dim(y_test)
# dim(X_test)

# Detect the features of interest
featuresOfInterest <- feature_labels[str_detect(feature_labels$FeatureName, "mean\\(|std\\("),2]
#length(featuresOfInterest)

# Create the training set 
training_set <- X_train %>%
  select(all_of(featuresOfInterest)) %>%
  mutate(SubjectID = train_subjects$SubjectID,
         Activity = y_train$ActivityName) %>%
  relocate(SubjectID, Activity)

# names(training_set)
# sapply(training_set, class)

# Create the test set 
test_set <- X_test %>%
  select(all_of(featuresOfInterest)) %>%
  mutate(SubjectID = test_subjects$SubjectID,
         Activity = y_test$ActivityName) %>%
  relocate(SubjectID, Activity)

# names(test_set)
# sapply(test_set, class)

# Row bind the training and test sets to create out dataset
dataset <- bind_rows(training_set, test_set) %>%
  # Arrange by Subject
  arrange(SubjectID) %>%
  # Create factors
  mutate(SubjectID = factor(SubjectID),
         Activity = factor(Activity))

# Extra Checks
# dim(training_set)
# dim(test_set)
# dim(dataset)
# sapply(dataset, class)
# str(dataset)

# unique(dataset$SubjectID)
# sum(is.na(dataset))

names(dataset)

# Appropriately label the data set with descriptive variable names
dataset <- dataset %>%
  rename_with(~ sub('^t', 'Time-', .x)) %>% # Starts with t
  rename_with(~ sub('^f', 'Frequency-', .x)) %>% # strats with f
  rename_with(~ sub('Acc', 'Acceleration', .x)) %>% # Acceleration signals
  rename_with(~ sub('Gyro', 'Gyroscope', .x)) %>% # Gyroscope signals
  rename_with(~ sub('Mag', 'Magnitude', .x)) %>% # Magnitude of signals
  rename_with(~ sub('Jerk', '-Jerk', .x)) %>% # angular velocity derived in time -> Jerk signals
  rename_with(~ sub('BodyBody', 'Body', .x)) %>% # remove doubles
  rename_with(~ gsub('-std', '-Std', .x)) %>% 
  rename_with(~ gsub('-mean', '-Mean', .x)) %>%
  rename_with(~ gsub('[()]', '', .x)) # remove parenthesis

names(dataset)

tidy_dataset <- dataset %>%
  group_by(SubjectID, Activity) %>%
  summarise_at(vars(-group_cols()), mean)
  
# library(dataMaid)
# Sys.setlocale(category = "LC_TIME", locale = "en_US.UTF8")
# makeCodebook(tidy_dataset, replace = TRUE, codebook = TRUE, output = "html", render = FALSE,
#              reportTitle = "Codebook for the tidy dataset from the Human Activity Recognition Using Smartphones Data Set")

