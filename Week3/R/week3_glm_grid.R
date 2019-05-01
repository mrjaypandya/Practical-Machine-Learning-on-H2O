library('h2o')
h2o.init()

url <- "http://h2o-public-test-data.s3.amazonaws.com/smalldata/airlines/allyears2k_headers.zip"
data <- h2o.importFile(url)

nrow(data)

parts <- h2o.splitFrame(data,c(0.8,0.1),seed = 69)

train <- parts[[1]] #35255
valid <- parts[[2]] #4272
#test <- parts[[3]] #4451

h2o.describe(data)
y <- "IsArrDelayed"
xForeheadSlap <- setdiff(colnames(data),y)

xAll <- setdiff(colnames(data),c(
  "ArrDelay","DepDelay","CarrierDelay","WeatherDelay","NASDelay","SecurityDelay","LateAircraftDelay","IsDepDelayed","IsArrDelayed",
  "ActualElapsedTime"))

xLikely <- c("Month","DayOfWeek","UniqueCarrier","Origin","Dest","Distance","Cancelled","Diverted")

system.time(m_def <- h2o.glm(xAll, y, train, validation_frame = valid, family = "binomial"))

h2o.performance(m_def,valid = TRUE )

g <- h2o.grid("glm",
              search_criteria = list(strategy = "RandomDiscrete", max_models = 8, max_runtime_secs = 30),
              hyper_params = list( alpha = seq(0,0.99,0.01)),
              grid_id = "random8",
              x=xAll,
              y=y,
              training_frame = train,
              validation_frame = valid,
              family = "binomial",
              lambda_search = TRUE)
g

g2 <- h2o.grid("glm",
               search_criteria = list(strategy = "Cartesian"),
               hyper_params = list( alpha = c(0,0.2,0.4,0.5,0.6,0.8,0.99)),
               grid_id = "all7",
               x=xLikely,
               y=y,
               training_frame = train,
               validation_frame = valid,
               family = "binomial",
               lambda_search = TRUE)
g2