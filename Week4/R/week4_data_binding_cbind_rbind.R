library(h2o)
h2o.init()

data <- h2o.importFile("http://h2o-public-test-data.s3.amazonaws.com/smalldata/airlines/allyears2k_headers.zip")

parts <- h2o.splitFrame(data, c(0.8,0.1),seed = 69)
train <- parts[[1]]
valid <- parts[[2]]
test <- parts[[3]]

#different way to extract some rows.
# I.e. Just like you do in normal R, or Python+pandas

train2 <- data[1:35255,] # First 35,255 rows -not random !

h2o.ls() #show the data object on the h2o server
train2 <- h2o.assign(train2,"first35255")

#same goes for column

ncol(data) #31
dates <- data[,1:4] #First 4 columns out of 31 columns'
airports <- data[,c('Origin','Dest')]

ncol(airports)
ncol(dates)
#use cbind to join("bind") columns

a_and_b <- h2o.cbind(airports,dates)

dim(a_and_b) # New 6-columns table created at this point

#use r-bind to join ("bind") row

restored_data <- h2o.rbind(train,valid, test)
dim(restored_data)
dim(data) #same!

head(restored_data[,1:4]) #Different
head(data[,1:4])