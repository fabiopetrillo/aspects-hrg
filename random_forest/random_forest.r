
install.packages('randomForest')
library(randomForest)

# @hidden_cell
# The following code accesses a file in your IBM Cloud Object Storage. It includes your credentials.
# You might want to remove those credentials before you share the notebook.

library("aws.s3")
obj <- get_object(
    object = "aspects_ds.csv",
    bucket = "newrtest-donotdelete-pr-grgumnsmj9jcea",
    key = "ae4d9d37927e4c40a3d784c6c2ee040e",
    secret = "e901a9a6d4e6e54867664cd7d5d30c36962203f6ec2df437",
    check_region = FALSE,
    base_url = "s3-api.us-geo.objectstorage.service.networklayer.com")
df_data_1 <- read.csv(text = rawToChar(obj))
head(df_data_1)

aspects = df_data_1[c("score", "team", "business", "management.people", "management.feature", "production")]
aspects['team'] = aspects['team'][is.nan(aspects['team'])] <- 1
head(aspects)

aspects$score = as.factor(aspects$score)
data_set_size = floor(nrow(aspects)*0.8)
index <- sample(aspects)
training <- data[index,]
training <- data[-index,]

rf <- randomForest(score ~ ., data = training, mtry=4, ntree=301, importance=TRUE)

plot(rf)

result <- data.frame(aspects$score, predict(aspects,testing[,1:11],type="response"))

plot(result)
