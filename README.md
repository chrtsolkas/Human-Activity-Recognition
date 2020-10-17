# Human Activity Recognition Dataset
This is the Getting and Cleaning Data Course Project. 

The purpose of this project is to demonstrate our ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

In our analysis we use the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The processing steps are the following:

1. First we download and unzip the database.

2. Then we read the feature and activity labels.

3. For the training data:

    * we read the subjects, 

    * we read the activities and we join them with the activity labels to get descriptive activity names, and

    * we read the measurements and label them with the feature labels.

4. We apply the same processing on the test data.

5. We find the features of interest by searching the feature labels for the phrases "mean(" and "std(".

6. We select only the features of interest from the training and test data and we obtain the training and test data sets.

7. We row bind the two data sets (training and test) and arrange them by subject id.

8. We appropriately label the data set with descriptive variable names.

9. We create an independent tidy data set with the average (mean) of each variable for each activity and each subject.

10. We write the tidy data set on disk.

11. Finally we generate the codebook.

The script [run_analysis.R](./run_analysis.R) contains detailed comments of the applied processing on the data sets.

The codebook was generated with the [dataMaid package](https://cran.r-project.org/web/packages/dataMaid/index.html)  with small modifications afterwards.

