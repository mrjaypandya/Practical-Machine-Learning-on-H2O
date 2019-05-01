library(h2o)
h2o.init()
train <- h2o.getFrame("people_train") # 788
valid <- h2o.getFrame("people_valid") # 118
test <- h2o.getFrame("people_test") # 94

y <- "income"
x <- setdiff(names(train),c ("id",y))

m1 <- h2o.gbm(x,y,train,
              model_id = "defaults_r",
              validation_frame = valid,
              ntree = 1000,
              max_depth = 10
)

h2o.performance(m1,train = TRUE)
h2o.performance(m1,valid = TRUE)
h2o.performance(m1,test)