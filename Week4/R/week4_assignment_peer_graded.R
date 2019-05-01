library(h2o)
h2o.init()

data <- h2o.importFile("http://coursera.h2o.ai/cacao.882.csv")

parts <- h2o.splitFrame(data, c(0.8,0.1),seed = 100)
train <- parts[[1]]
valid <- parts[[2]]
test <- parts[[3]]

y <-"Rating"
xall <-c("Maker","Origin","REF","Review Date","Cocoa Percent","Maker Location","Bean Type", "Bean Origin")
system.time(m_def <- h2o.deeplearning(xall, y, train, validation_frame = valid , model_id = "DLR_regress_baseline_R"))
h2o.performance(m_def,train)
h2o.performance(m_def,valid = TRUE)
h2o.performance(m_def,test) #Mean Residual Deviance :  0.2456058

h2o.saveModel(m_def,"/home/jay/H2o/Week4")
system.time(
  g_search <- h2o.grid("deeplearning",
                    search_criteria = list(
                      strategy = "RandomDiscrete",
                      max_models = 12
                    ),
                    hyper_params = list(seed = c(123),l1 = c(0,1e-6,3e-6,1e-5),l2 = c(0,1e-6,3e-6,1e-5),
                                        input_dropout_ratio = c(0,0.2,0.3,0.4),
                                        hidden_dropout_ratios = list(c (0,0),c(0.2,0.2),c(0.3,0.3))
                    ),grid_id = "dl-test",
                    x = xall,
                    y = y,
                    hidden = c(350,350),
                    epochs = 10,
                    training_frame = train,
                    validation_frame  = valid,
                    activation = "RectifierWithDropout"
  ))
g_search

best_model <- h2o.getModel(g_search@model_ids[[1]])
h2o.saveModel(best_model,"/home/jay/H2o/Week4")

h2o.performance(best_model,train)
h2o.performance(best_model,valid = TRUE)
h2o.performance(best_model,test) #Mean Residual Deviance :  0.1998122

##          Base model                    vs            Tunned Model (on test data)
#Mean Residual Deviance :  0.2456058                Mean Residual Deviance :  0.1998122

### Thus a substantial difference can be seen on test data