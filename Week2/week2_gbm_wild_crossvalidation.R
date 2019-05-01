library(h2o)
h2o.init()

train <- h2o.getFrame("people_train")
test <- h2o.getFrame("people_test")
valid <- h2o.getFrame("people_valid")

y <- "income"
x <- setdiff(names(train),c("id",y))
m3 <- h2o.gbm(x,y,train,model_id = "def9folds_r",nfolds = 9)
h2o.performance(m3, train = TRUE)
h2o.performance(m3, xval = TRUE)
h2o.performance(m3,test)
