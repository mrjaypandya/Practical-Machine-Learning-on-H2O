library(h2o)
h2o.init()
set.seed(111) # Just set the seed randomly
N <- 2000
gradeTypes <- c(10,9,8,7,6,5) # Prediction of student's grade from few features
d <- data.frame(id = 1:N)
d$gradeType <- gradeTypes[
  (d$id %% length(gradeTypes)) 
  +1 #R indexes from 1
  ]
d$age = runif(N, min = 10, max = 22 )
d$parent_age = runif(N,min = 30, max = 55)

v = round(rnorm(N,mean = 6, sd =2.5)) # Setting Mean = 6 and Standard Devation = 2.5
v = pmax(v,0)
v = pmin(v,9)
table(v)
d$healthEating = v

v = 20000 + ((d$parent_age * 3)^ 2) # Based salary based on parent's age
v = v + (d$healthEating *500)
v = v + runif(N, 0, 5000)
d$income = round(v,-2) #Round to nearest $100

as.h2o(d,destination_frame = "Student")
student <- h2o.getFrame("Student")
summary(student) # will display the summary of dataset

# now splitting the dataset into train test and valid
student <- h2o.getFrame("Student")
parts <- h2o.splitFrame(
  student,
  c(0.8,0.1),
  destination_frames = c("student_train","student_valid","student_test"),
  seed = 123)
sapply(parts, nrow)
train <- parts[[1]]
valid <- parts[[2]]
test <- parts[[3]]

# now training GBM 
y <- "gradeType" # predicting grade of the student 
x <- setdiff(names(train),c ("id",y))
m1 <- h2o.gbm(x,y,train,
              model_id = "defaults_r_m1",
              validation_frame = valid
)
h2o.performance(m1,train = TRUE)
h2o.performance(m1,valid = TRUE)
h2o.performance(m1,test)
# now training GBM with overfitting
m2 <- h2o.gbm(x,y,train,
              model_id = "defaults_r_m2",
              validation_frame = valid,
              ntree = 2000,
              max_depth = 15
)
h2o.performance(m2,train = TRUE)
h2o.performance(m2,valid = TRUE)
h2o.performance(m2,test)