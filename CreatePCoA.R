library(vegan)
library(tidyverse)
library(pheatmap)

# load all data
setwd("C:/Users/riata/Documents/src/Polygence-Research-Project/") # set directory to file location
ibs = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/DistanceMatrix.csv", row=1) # get distance matrix data
nam = read.table("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/DolphinNames") # get dolphin name data
meta = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/Metadata.csv", fill=TRUE) # get metadata
meta = filter(meta, meta$Year.Captured.Stranded >= 2010) # filter to recent organism data
envCSV = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/EnvironmentalData.csv", fill=TRUE, row=1) # get environmental data

# standardize data
envStand = decostand(envMa, "range")
envDF = as.data.frame(envStand)

# join data
metaenv <- left_join(meta, rownames_to_column(envDF), by=c("Origin"="rowname"), copy=TRUE) # merge environmental data with metadata by location

ma = as.matrix(ibs)
ma = subset(ma, rownames(ma) %in% metaenv$ID, colnames(ma) %in% metaenv$ID) # TODO
envMa = as.matrix(envCSV)


# create hierarchical clustering based on distance matrix
# hc = hclust(as.dist(ma),"ave")
# plot(hc)

pheatmap(ma)

# Plot in PCA space 
# Capscale creates a dbRDA - distance-based-RDA, this is similar to PCoA - object 
pp0 = capscale(ma~1)
plot(pp0)

# get the scores from the object to plot in ggplot 
score_dist <- as.data.frame(pp0$CA$u)
score_dist$ID = rownames(score_dist)

score_meta <- left_join(score_dist, metaenv) # merge meta/environmental data on organism ID
score_meta <- filter(score_meta, !is.na(score_meta$Origin))

# Color graph with gradient based on env variable (change var using color)
ggplot(score_meta, aes(x=MDS1, y =MDS2, color = Polychlorinated.Biphenyls)) + 
  geom_point(size = 2, alpha = .8) + 
  theme_classic() + coord_equal() + 
  geom_hline(yintercept = 0, col = 'grey', lty = 'dashed') + 
  geom_vline(col = 'grey', xintercept = 0, lty = 'dashed')

# Create RDA for specific variables
ma.sub = ma[rownames(ma) %in% metaenv$ID, colnames(ma) %in% metaenv$ID]
rda=capscale(ma.sub~Genetic.Cluster+Current.Direction+Current.Speed+Current.Stability+Polybrominated.Diphenyl.Ethers+Polychlorinated.Biphenyls+Avg.Sea.Surface.Temp+Salinity, metaenv)
plot(rda, type="p")
adonis2(ma.sub~Genetic.Cluster+Current.Direction+Current.Speed+Current.Stability+Polybrominated.Diphenyl.Ethers+Polychlorinated.Biphenyls+Avg.Sea.Surface.Temp+Salinity, metaenv)
# LIST OF VARIABLES
# Genetic.Cluster
# Current.Direction
# Current.Speed
# Current.Stability
# Polybrominated.Diphenyl.Ethers
# Polychlorinated.Biphenyls
# Avg.Sea.Surface.Temp
# Salinity

# Get coordinates of points on plot
coords <- data.frame(score_meta$ID, score_meta$MDS1, score_meta$MDS2)
write.csv(coords, file="C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/Coordinates.csv", row.names = FALSE)


# boxplot(Avg.Sea.Surface.Temp ~ Genetic.Cluster, metaenv)