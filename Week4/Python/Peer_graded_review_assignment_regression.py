import h2o
import matplotlib.pyplot as plt
h2o.init()

data = h2o.import_file("http://coursera.h2o.ai/cacao.882.csv")
train, test = data.split_frame([0.8],seed = 99)
print("%d/%d" % (train.nrows,test.nrows))

y = "Rating"
xRegress = ["Maker","Origin","REF","Review Date","Cocoa Percent","Maker Location","Bean Type","Bean Origin"]

from h2o.estimators.deeplearning import H2ODeepLearningEstimator

m_DLR_def_python = H2ODeepLearningEstimator(nfolds=5, 
                                            fold_assignment="Auto", 
                                            keep_cross_validation_models = True,
                                            variable_importances = True,
                                            model_id = "DLR_baseline")
m_DLR_def_python.train(xRegress,y,train)
m_DLR_def_python.model_performance(test)
m_DLR_def_python.varimp_plot(8)
m_DLR_def_python.plot()
m_DLR_def_python