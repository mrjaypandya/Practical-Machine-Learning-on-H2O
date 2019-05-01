library(h2o)
h2o.init()

data <- h2o.importFile("http://h2o-public-test-data.s3.amazonaws.com/smalldata/airlines/allyears2k_headers.zip")

parts <- h2o.splitFrame(data, c(0.8,0.1),seed = 69)
train <- parts[[1]]
valid <- parts[[2]]
test <- parts[[3]]


y <- "IsArrDelayed"

xWithDep <-setdiff(colnames(data),c(
  "ArrDelay","IsArrDelayed",
  "ActualElapsedTime",
  "ArrTime",
  "TailNum"
))

system.time( #17 to 18s 
  m_DLR_def<-h2o.deeplearning(xWithDep, y,train,
                               validation_frame = valid,
                               model_id = "DLR_def",
                               variable_importance = TRUE)
                              
)
h2o.performance(m_DLR_def, valid = TRUE)
plot(m_DLR_def)

#h2o.varimp(m_DLR_def)
