library('h2o')
h2o.init()

url <- "http://h2o-public-test-data.s3.amazonaws.com/smalldata/airlines/allyears2k_headers.zipv"
data <- h2o.importFile(url)

data.summary()
mean(data[,"AirTime"])
mean(data[,"AirTime"], na.rm = TRUE)
h2o.mean(data[,"AirTime"], na.rm = TRUE)

range(data[,"AirTime"],na.rm = TRUE)

h2o.hist(data[,"AirTime"])

mean(data[,c("ArrDelay","DepDelay")],na.rm = TRUE)

h2o.any(data[,"ArrDelay"]>360)
h2o.any(data[,"ArrDelay"]<480)

h2o.all(h2o.na_omit((data[,"ArrDelay"])<480))

h2o.cumsum(data[,"ArrDelay"], axis = 0)

h2o.cor(data[,"ArrDelay"],data[,"DepDelay"],na.rm = TRUE)


uc = as.character(data[,"UniqueCarrier"])

head(uc)
h2o.entropy(uc)
h2o.entropy(as.h2o("The qick brown fox jumps over the lazy"))
h2o.entropy(as.h2o("Something mandarin i think was here in video"))

  