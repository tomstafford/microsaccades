import pandas as pd #dataframes

#load data
df=pd.read_csv('microsaccades.csv')
#column labels
df.columns=['index','N']

#extract which run each trial is from as new column
df['run']=df['index'].apply(lambda x: x.split("/")[1])

#show means for each run in the data
df.groupby('run').mean()