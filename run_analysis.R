
# -----------------------------------------------
# Collect the labels used in each data set
# -----------------------------------------------
subject.labels = as.character(1:30)
activity.labels = c('walking', 
                    'walking.upstairs', 
                    'walking.downstairs', 
                    'sitting', 
                    'standing', 
                    'laying')
features.txt <- read.csv(file = './features.txt', 
                         header = FALSE, 
                         sep = ' ')
feature.labels <- as.character(features.txt$V2)
# Remove troublesome characters from feature labels
feature.labels <- gsub('\\(', '', feature.labels)
feature.labels <- gsub('\\)', '', feature.labels)
feature.labels <- gsub('\\-', '\\.', feature.labels)
feature.labels <- gsub('\\,', '\\.', feature.labels)
# Take note of the columns which should be included in the data set (as specified in the problem statement)
desired.columns <- grep('*.mean|*.std', feature.labels)[!(grep('*.mean|*.std', feature.labels) %in% grep('*Freq',feature.labels))]

# -----------------------------------------------

# -----------------------------------------------
# TRAINING SET
# -----------------------------------------------
  # Collect the subject measured in each observation
  # ---------------------------------------------
  subject_train.txt <- read.csv(file = './train/subject_train.txt', 
                                header = FALSE)
  subject.train <- subject_train.txt$V1
  subject.train <- factor(subject.train, 
                          levels = subject.labels, 
                          ordered = TRUE)
  # ---------------------------------------------

  # ---------------------------------------------
  # Collect the activity performed during of each observation
  #---------------------------------------------
  y_train.txt <- read.csv(file = './train/y_train.txt', 
                          header = FALSE)
  activity.train <- y_train.txt$V1
  activity.train <- factor(activity.train, levels = as.character(1:6))
  levels(activity.train) <- activity.labels
  # ---------------------------------------------

  # ---------------------------------------------
  # Collect the features of each observation
  # ---------------------------------------------
  X_train.txt <- read.fwf(file = './train/X_train.txt', 
                          widths = rep(16, 561), 
                          header = FALSE, 
                          col.names = feature.labels)

  # ---------------------------------------------
  # Build the training set
  # ---------------------------------------------
  X_train.txt <- X_train.txt[, desired.columns]
  training.set <- data.frame(Activity = activity.train,
                             Subject = subject.train)
  training.set <- cbind(training.set, X_train.txt)

# -----------------------------------------------
# TESTING SET
# -----------------------------------------------
  # Collect the subject measured in each observation
  # ---------------------------------------------
  subject_test.txt <- read.csv(file = './test/subject_test.txt', 
                              header = FALSE)
  subject.test <- subject_test.txt$V1
  subject.test <- factor(subject.test, 
                         levels = subject.labels, 
                         ordered = TRUE)
  # ---------------------------------------------
  # Collect the activity performed during of each observation
  # --------------------------------------------_
  y_test.txt <- read.csv(file = './test/y_test.txt', 
                         header = FALSE)
  activity.test <- y_test.txt$V1
  activity.test <- factor(activity.test, levels = as.character(1:6))
  levels(activity.test) <- activity.labels
  # ---------------------------------------------

  # ---------------------------------------------
  # Collect the features of each observation
  # ---------------------------------------------
  X_test.txt <- read.fwf(file = './test/X_test.txt', 
                         widths = rep(16, 561), 
                         header = FALSE, 
                         col.names = feature.labels)

  # ---------------------------------------------
  # Build the testing set
  # ---------------------------------------------
  X_test.txt <- X_test.txt[, desired.columns]
  testing.set <- data.frame(Activity = activity.test,
                            Subject = subject.test)
  testing.set <- cbind(testing.set, X_test.txt)

# ---------------------------------------------
# Merge the test and training data sets
# ---------------------------------------------
merged.set <- rbind(training.set, testing.set)

# ---------------------------------------------
# Build the Summary set
# ---------------------------------------------
# Group observations by activity then by subject. 
# For each group then compute the mean of each feature of interest 
library(dplyr)
summary.set <- summarise_each(group_by(merged.set, Activity, Subject), funs(mean))
write.table(summary.set, file = './summary.set.txt', row.names = FALSE)
