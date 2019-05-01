library('h2o')
h2o.init()
#see https://data.princeton.edu/wws509/datasets/#smoking

url <- "http://coursera.h2o.ai/data/smoking.csv"
data <- h2o.importFile(url)

data
summary(data)
h2o.sum(data[,3])

x = 1:2
y = 5
m = h2o.glm(x,y,data
            family = "possion",
            model_id ="smoking_p"
            #nfold=12,
            #fold_assignment = "Modulo")
m

m2 = h2o.glm(2,y,data,
             family = "possion",
             model_id = "smoking_2")
m2
