# load data into R
dt <- read.csv("netflix.csv",header=TRUE)
tset <- read.csv("test_data.css",header=TRUE)
attach(dt)
attach(tset)

# train on sampled data
dta_size = nrow(dt)
sample_data <- sample(1:nrow(dt),size=dta_size)
training_data <- dt[sample_data]
dt = dt[-4]
dt = dt[-1]
High<- ifelse(is_rated>0,"Yes","No")
dt = data.frame(dt,High)

# build the model and predict
tree_model = tree(High ~ ., dt)
tree_predict = predict(tree_model,data=tset,type="class")

# plot the tree
plot(tree_model)
text(tree_model,pretty=0)


tset = tset[-4]
tset = tset[-1]
High<- ifelse(is_rated>0,"Yes","No")
tset = data.frame(tset,High)
tset_size = nrow(tset)
tree_valid = High[tset_size]

# to compute the difference between actual and prediction
mean(tree_predict != tree_valid)
