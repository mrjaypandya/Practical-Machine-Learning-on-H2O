library(h2o)
h2o.init()

data <- h2o.importFile("http://h2o-public-test-data.s3.amazonaws.com/smalldata/airlines/allyears2k_headers.zip")

parts <- h2o.splitFrame(data, c(0.8,0.1),seed = 69)
train <- parts[[1]]
valid <- parts[[2]]
test <- parts[[3]]


y <- "IsArrDelayed"

xAll <- setdiff(colnames(data),c(
  "ArrDelay","DepDelay","CarrierDelay","WeatherDelay","NASDelay","SecurityDelay","LateAircraftDelay",
  "IsDepDelay","IsArrDelay","ActualElapsedTime","ArrTime"
))

system.time(
  m_def <- h2o.deeplearning(xAll, y, train, validation_frame = valid)
)

m_def.performance(m_def,valid =TRUE)

plot(m_def)

m_200_epochs <- h2o.deeplearning(xAll, y, train, validation_frame = valid, epochs = 200, stopping_rounds = 5,
                                 stopping_tolerance = 0, stopping_metric = "logloss")
h2o.performance(m_200_epochs,valid = TRUE)

plot(m_200_epochs)

h2o.scoreHistory(m_200_epochs)


m_200x200x200 <- h2o.deeplearning(xAll, y, train, validation_frame = valid, epochs = 200, hidden = c(200,200,200))
h2o.performance(m_200x200x200, valid = TRUE)

plot(m_200x200x200)

h2o.scoreHistory(m_200x200x200)

system.time(
g <- h2o.grid("deeplearning",
              search_criteria = list(
                strategy = "RandomDiscrete",
                max_models = 4 #when testing with epochs = 0.01
                #max_model = 12
              ),
              hyper_params = list(seed = c(77),l1 = c(0,1e-6,3e-6,1e-5),l2 = c(0,1e-6,3e-6,1e-5),
                                  input_dropout_ratio = c(0,0.1,0.2,0.3),
                                  hidden_dropout_ratios = list(c (0,0),c(0.2,0.2),c(0.4,0.4),c(0.6,0.6))
              ),grid_id = "dl-test",
              x = x2,
              y = y,
              hidden = c(400,400),
              epochs = 0.01,
              training_frame = train,
              validation_frame  = valid,
              activation = "RectifiedWithDropout"
              ))
g