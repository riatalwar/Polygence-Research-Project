import pandas as pd
import boto
import skbio
import matplotlib.pyplot as plt

# import the csv file directly from an s3 bucket
data = pd.read_csv('Polygence-Data\DistanceMatrix.csv')

# reset the index
data = data.set_index('Unnamed: 0')


# Compute the Principal Coordinates Analysis
my_pcoa = skbio.stats.ordination.pcoa(data.values)

# Show the new coordinates for our cities
print(my_pcoa.samples[['PC1', 'PC2']])


plt.scatter(my_pcoa.samples['PC1'],  my_pcoa.samples['PC2'])

for i in range(len(data.columns)):
  plt.text(my_pcoa.samples.loc[str(i),'PC1'],  my_pcoa.samples.loc[str(i),'PC2'], data.columns[i])

plt.show()