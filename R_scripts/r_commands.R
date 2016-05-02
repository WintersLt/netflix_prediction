# Load Data
#nf6k[(is.na(nf6k$release_yr) == TRUE),]
#nf6k <- read.table(file = "C:/Users/akash/Desktop/Acad/ML/Project/our_sampe_500k.csv", sep = ",", header = FALSE, colClasses = c("numeric", "numeric", "numeric","Date", "character", "character"))
#colnames(nf6k) <- c("movie_id", "user_id", "rating", "rate_date", "release_yr", "title")

#nf6k$release_yr <- as.numeric(nf6k$release_yr)

answers_yr <- read.csv(file = "C:/Users/akash/Desktop/Acad/ML/Project/answers_yr.csv", header = FALSE, colClasses = c(rep("numeric", 4)))

#source('C:/Users/akash/Desktop/Acad/ML/Project/sample.R', echo=T)
prediction <- c(rep(0, nrow(answers_yr)))
training_set <- training_set[,c(1,2,3,4)]
colnames(answers_yr) <- c("user_id", "movie_id", "rating", "year")
for (i in 1:nrow(answers_yr)) {
#for (i in 1:10) {
  test_set <- answers_yr[i,]
  #colnames(test_set) <- colnames(training_set)
  curr_user <- answers_yr[i, 1];
  user_hist <- training_set[(training_set$user_id == curr_user),];
  if(nrow(user_hist) == 0){
    prediction[i] <- -1
    next;
  }
  model1 <- glm(rating ~ year , data = user_hist, family = binomial(link = "logit"))
  predTst <- predict(model1, test_set, type="response")
  summary(model1)
  predRes <- cut(predTst, breaks=c(-Inf, 0.5, Inf), labels=c(0, 1))
  #print(predRes)
  prediction[i] <- as.numeric(predRes)
}