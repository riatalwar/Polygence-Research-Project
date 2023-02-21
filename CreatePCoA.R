library(vegan)
library(tidyverse)

# load all data
setwd("C:/Users/riata/Documents/src/Polygence-Research-Project/") # set directory to file location
ibs = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/DistanceMatrix.csv", row=1) # get distance matrix data
nam = read.table("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/DolphinNames") # get dolphin name data
meta = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/Metadata.csv", fill=TRUE) # get metadata
envData = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/EnvironmentalData.csv", fill=TRUE) # get environmental data

ma = as.matrix(ibs)

# create hierarchical clustering based on distance matrix
hc=hclust(as.dist(ma),"ave")
plot(hc)


# Plot in PCA space 
# Capscale creates a dbRDA - distance-based-RDA, this is similar to PCoA - object 
pp0=capscale(ma~1)
plot(pp0)

# get the scores from the object to plot in ggplot 
score_dist <- as.data.frame(pp0$CA$u)
score_dist$ID = rownames(score_dist)

metaenv <- left_join(meta, envData, by=c("Origin"="Location.Name")) # merge environmental data with metadata by location
score_meta <- left_join(score_dist, metaenv) # merge meta/environmental data on organism ID

# Color graph with gradient based on env variable (change var using color)
ggplot(score_meta, aes(x=MDS1, y =MDS2, color = Salinity..ppt.)) + 
  geom_point(size = 2, alpha = .8) + 
  theme_classic() + coord_equal() + 
  geom_hline(yintercept = 0, col = 'grey', lty = 'dashed') + 
  geom_vline(col = 'grey', xintercept = 0, lty = 'dashed')
