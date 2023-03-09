library(randomForest)
library(vegan)
library(tidyverse)
require(caTools)

# load data
meta = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/Metadata.csv", fill=TRUE) # get metadata
envCSV = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/EnvironmentalData.csv", fill=TRUE, row=1) # get environmental data

# create standardized df
envMa = as.matrix(envCSV)
envStand = decostand(envMa, "range")
envDF = as.data.frame(envStand)
data <- left_join(meta, rownames_to_column(envDF), by=c("Origin"="rowname"), copy=TRUE) # merge environmental data with metadata by location

data$Genetic.Cluster <- factor(data$Genetic.Cluster)

# split data into test and train sets
sample = sample.split(data$Genetic.Cluster, SplitRatio = .75)
train = subset(data, sample == TRUE)
test  = subset(data, sample == FALSE, header=TRUE)

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
data %>% ggplot(aes(x = Genetic.Cluster, y = Current.Speed)) + geom_boxplot()
