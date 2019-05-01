library(h2o)
h2o.init()

x = seq(0,10,0.01)
y = jitter(sin(x),1000)
plot(x,y,type = 'l')

sinewave <- data.frame(a=x,b=y)

sinewave.h2o <-as.h2o(sinewave)

sinewave.h2o
tail(sinewave.h2o)

#opposite direction
d <- as.data.frame(sinewave.h2o)
head(d)