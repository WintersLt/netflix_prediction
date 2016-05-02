set.seed(44)
users <- nf6k$user_id
movies <- nf6k$movie_id
samp_users <- sample(x = users, size = 500000, replace = TRUE)
samp_movies <- sample(x = movies, size = 500000, replace = TRUE)
samp1 <- cbind(samp_users, samp_movies)
samp1 <- unique(samp1)
samp1 <- as.data.frame(samp1)

is_rated <- c(rep(FALSE, nrow(samp1)))
samp1 <- cbind(samp1, is_rated)
colnames(samp1) <- c("user_id", "movie_id", "is_rated")
samp1 <- merge(x = samp1, y = nf6k, by = c("user_id", "movie_id"), all.x = TRUE)
samp1 <- samp1[, c(1,2,4)]
samp1$rating <- (is.na(samp1$rating) == FALSE)

all_movies <- read.csv(file = "C:/Users/akash/Desktop/Acad/ML/Project/movies.csv", header = FALSE, sep = ',',stringsAsFactors = F, colClasses = c("numeric", "numeric", "character"))
colnames(all_movies) <- c("movie_id", "year", "title")

samp1 <- merge(x = samp1, y = all_movies, by = "movie_id", all.x = T)
samp2 <- nf6k[, c(1,2,3,5,6)]
samp2$rating <- TRUE
colnames(samp2) <- colnames(samp1)
training_set <- rbind(samp2,samp1)


# for(i in 1:nrow(samp1)){
# #for(i in 1:3){
#   tmp <- nf6k[(nf6k$user_id == samp1[i,1]), ];
#   tmp <- tmp[tmp$movie_id == samp1[i,2],];
#   if(nrow(tmp) > 0)
#     samp1[i,3] <- TRUE;
# }

