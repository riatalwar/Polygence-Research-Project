library(vegan)
library(tidyverse)

# load all data
setwd("C:/Users/riata/Documents/src/Polygence-Research-Project/") # set directory to file location
envCSV = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/EnvironmentalData.csv", fill=TRUE, row=1) # get environmental data

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
