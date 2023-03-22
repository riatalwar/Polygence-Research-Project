library(vegan)
library(tidyverse)
meta = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/Metadata.csv", fill=TRUE) # get metadata
envCSV = read.csv("C:/Users/riata/Documents/src/Polygence-Research-Project/Polygence-Data/EnvironmentalData.csv", fill=TRUE, row=1) # get environmental data

envMa = as.matrix(envCSV)
envStand = decostand(envMa, "range")
envDF = as.data.frame(envStand)
data <- left_join(meta, rownames_to_column(envDF), by=c("Origin"="rowname"), copy=TRUE) # merge environmental data with metadata by location

data$Genetic.Cluster <- factor(data$Genetic.Cluster)

#T-Tests
#A t-test tests if the means of two different groups are
#actually statistically different. Basically, we want to know
#if the difference in environmental variables between genetic 
#cluster 1 and genetic cluster 2 are statistically different.
#This is a test that actually gives you "statistical significance",
#meaning we can confidently say things are or are not significantly
#different.

#TO run a test like this you need a "null" and "alternate"
#hypothesis. 
#The null hypothesis in these tests is always:
#The difference in means is equal to zero (e.g., the groups are NOT different)
#The goal is to "reject" this null hypothesis, and instead accept the
#"alternate" hypothesis:
#The difference in means is NOT equal to zero (e.g., our groups are significantly different)

##HOW TO DO IT###
#data here is your merged metadata and environmental data for the samples 
#I think it's called the same thing in your random forest code
group1_data = data[data$Genetic.Cluster == 1,]
group2_data = data[data$Genetic.Cluster == 2,]
#this is the actual test, you can replace Current.Speed with any variable
#that's in your dataframe
t.test(group1_data$Polybrominated.Diphenyl.Ethers, group2_data$Polybrominated.Diphenyl.Ethers)

#### HOW TO INTERPRET THIS######
#this prints out a t-statistic (5.09) and a p-value (5.5e-8) (your values may slightly differ if our data is different)
#Since this p-value is LESS than 0.05 we can reject the null hypothesis
#The printout also tells you this- we should *accept* the 
#alternate hypothesis (the true difference in means is
#NOT equal to 0). Thus for current speed our groups are significantly different!