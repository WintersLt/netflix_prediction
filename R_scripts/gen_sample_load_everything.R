gen_sample <- read.table(file = "C:/Users/akash/Desktop/Acad/ML/Project/features/generated_sample_updated.csv", sep = ",", header = FALSE, colClasses = c("numeric", "numeric", "numeric","character"))
colnames(gen_sample) <- c("user_id", "movie_id", "rating", "rating_date")
m_num_avg <- read.csv(file = "C:/Users/akash/Desktop/Acad/ML/Project/features/movie/movie_avg_and_num_rating.csv", header = F, colClasses = c(rep("numeric",3)))
colnames(m_num_avg) <- c("movie_id", "m_avg_rating", "m_num_ratings")

gen_sample <- sqldf("SELECT movie_id, user_id, rating, m_avg_rating, m_num_ratings from gen_sample JOIN m_num_avg USING(movie_id)")
u_avg_rating <- read.csv(file = "C:/Users/akash/Desktop/Acad/ML/Project/features/user/user_avg_rating.csv", header = F, colClasses = c(rep("numeric",2)))
colnames(u_avg_rating) <- c("user_id", "u_avg_rating")
gen_sample <- sqldf("SELECT movie_id, user_id, rating, m_avg_rating, m_num_ratings, u_avg_rating from gen_sample JOIN u_avg_rating USING(user_id)")

u_ratings <- read.csv(file = "C:/Users/akash/Desktop/Acad/ML/Project/features/user/user_num_rating_6months.csv", header = F, colClasses = c(rep("numeric",2)))
colnames(u_ratings) <- c("user_id", "u_past_6months")
u_total_ratings <- read.csv(file = "C:/Users/akash/Desktop/Acad/ML/Project/features/user/user_num_ratings.csv", header = F, colClasses = c(rep("numeric",2)))
colnames(u_total_ratings) <- c("user_id", "u_total_ratings")
u_ratings <- sqldf("SELECT user_id, u_past_6months/u_total_ratings, u_total_ratings from u_ratings JOIN u_total_ratings USING(user_id)")
colnames(u_ratings) <- c("user_id", "u_past_6months", "u_total_ratings")
gen_sample <- sqldf("SELECT movie_id, user_id, rating, m_avg_rating, m_num_ratings, u_avg_rating, u_past_6months, u_total_ratings from gen_sample JOIN u_ratings USING(user_id)")


answers_yr <- read.csv(file = "C:/Users/akash/Desktop/Acad/ML/Project/answers_yr.csv", header = FALSE, colClasses = c(rep("numeric", 4)))
colnames(answers_yr) <- c("user_id", "movie_id", "ans_rating", "year")

answers_yr <- sqldf("SELECT DISTINCT answers_yr.movie_id as movie_id, user_id, ans_rating, year, u_avg_rating, u_past_6months, u_total_ratings from answers_yr JOIN gen_sample USING(user_id)")
answers_yr <- sqldf("SELECT DISTINCT answers_yr.movie_id as movie_id, answers_yr.user_id as user_id, ans_rating, year,  answers_yr.u_avg_rating, answers_yr.u_past_6months, answers_yr.u_total_ratings, m_avg_rating, m_num_ratings from answers_yr JOIN gen_sample USING(movie_id)")

is_rated <- (gen_sample$rating != 0)
is_rated <- as.numeric(is_rated)
gen_sample <- cbind(gen_sample, is_rated)
is_rated <- as.numeric(answers_yr$ans_rating != 0)
answers_yr <-  cbind(answers_yr, is_rated)

all_movies <- read.csv(file = "C:/Users/akash/Desktop/Acad/ML/Project/movies.csv", header = FALSE, sep = ',',stringsAsFactors = F, colClasses = c("numeric", "numeric", "character"))