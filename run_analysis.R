if (!require("data.table")) {
        install.packages("data.table")
}

if (!require("reshape2")) {
        install.packages("reshape2")
}

require("data.table")
require("reshape2")


fileurl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./data.zip")) {
        download.file(fileurl,destfile = "./data.zip")
        print("downloading")
}

if (!file.exists("./UCI HAR Dataset")) {
        unzip("./data.zip")
        print("Unzipping")
}


X_train<- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train<- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train<- read.table("./UCI HAR Dataset/train/subject_train.txt")


X_test<- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test<- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test<- read.table("./UCI HAR Dataset/test/subject_test.txt")


ActivityData<- rbind(X_train,X_test)
LabelSets<- rbind(Y_train,Y_test)
SubjectCodes<- rbind(subject_train,subject_test)


features <- read.table("./UCI HAR Dataset/features.txt")
feature_class <- grepl("mean|std", features$V2)

colnames(ActivityData)=features$V2
ActivityData<- ActivityData[,feature_class]


activity_Labels  <- read.table("./UCI HAR Dataset/activity_labels.txt")

Activity<- as.factor(LabelSets$V1)
levels(Activity)<- activity_Labels$V2

LabelSets<- data.frame(Activity)

colnames(SubjectCodes)<-"Subject_ID"
dataset<- cbind(SubjectCodes,LabelSets,ActivityData)


library(reshape2)

temp <- melt(dataset,id.vars=c("Subject_ID","Activity"))


final <- dcast(temp,Subject_ID + Activity ~ variable,mean)



write.table(final, file = "./tidy_data.txt",row.names = FALSE)


















