library(vegan)
library(tidyverse)

# load all data
setwd("C:/Users/riata/Documents/src/Polygence-Research-Project/") # set directory to file location
ibs = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/DistanceMatrix.csv", row=1) # get distance matrix data
nam = read.table("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/DolphinNames") # get dolphin name data
meta = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/Metadata.csv", fill=TRUE) # get metadata
envCSV = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/EnvironmentalData.csv", fill=TRUE, row=1) # get environmental data

ma = as.matrix(ibs)
envMa = as.matrix(envCSV)
# standardize data
envStand = decostand(envMa, "range")
envDF = as.data.frame(envStand)

# check if variables are correlated with each other
cor.test(envDF$Current.Direction, envDF$Current.Speed)
# Genetic.Cluster
# Current.Direction
# Current.Speed
# Current.Stability
# Polybrominated.Diphenyl.Ethers
# Polychlorinated.Biphenyls
# Avg.Sea.Surface.Temp
# Salinity
