library(randomForest)
library(vegan)
library(tidyverse)
require(caTools)

# load data
meta = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/Metadata.csv", fill=TRUE) # get metadata
meta = filter(meta, meta$Year.Captured.Stranded >= 2010) # filter to recent organism data
envCSV = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/EnvironmentalData.csv", fill=TRUE, row=1) # get environmental data

# create standardized df
envMa = as.matrix(envCSV)
envStand = decostand(envMa, "range")
envDF = as.data.frame(envStand)
metaenv <- left_join(meta, rownames_to_column(envDF), by=c("Origin"="rowname"), copy=TRUE) # merge environmental data with metadata by location

metaenv$Genetic.Cluster <- factor(metaenv$Genetic.Cluster)

# split data into test and train sets
sample = sample.split(metaenv$Genetic.Cluster, SplitRatio = .75)
train = subset(metaenv, sample == TRUE)
test  = subset(metaenv, sample == FALSE, header=TRUE)

# initialize random forest
rf <- randomForest(
  Genetic.Cluster ~ Current.Direction+Current.Speed+Current.Stability+Polybrominated.Diphenyl.Ethers+Polychlorinated.Biphenyls+Avg.Sea.Surface.Temp+Salinity,
  data=train
)

# get predictions
pred = predict(rf, newdata=test)
cm = table(test[,"Genetic.Cluster"], pred)
table(cm)
varImpPlot(rf)

# create boxplot of variable distribution
metaenv %>% ggplot(aes(group = Genetic.Cluster, y = Current.Speed)) + geom_boxplot()
