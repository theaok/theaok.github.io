''' 
(need to have google account)
go to
https://colab.research.google.com/
and click "start a new notebook"
'''

#get stats libraries
from statistics import *
import pandas as pd 


### very basic descriptive stats ###


#lets start with example from trochim:
#https://conjointly.com/kb/descriptive-statistics/

l=[15, 20, 21, 20, 36, 15, 25, 15] #make a list
 
l #print the list

len(l) #get N

sum(l) #sum

sum(l) / len(l) #mean


mean(l)
median(l)
mode(l)
stdev(l)
variance(l)

max(l)
min(l)
max(l)-min(l) #range


### loading real dataset, a csv file ###

'''
any software incl excel and spss can save as csv!
just make sure it is clean: one short alphanumeric header per column,  

let's do an example:

first download a dataset by clicking this link
https://drive.google.com/uc?id=1YH8DfzsQ8suZkVQBk7T9FTKvvm9Vyej8&export=download
then in colab at the very left click the folder icon for 'Files'
and click icon with an arrow to upload the file 
and right click on the file and copy path, and assign as an object "file":
'''
file='/content/Correlation  Research Methods Knowledge Base.csv'
dat=pd.read_csv(file) #read it in

dat #print it out 

dat["Height"]

dat["Height"].mean()
dat["Height"].median()
dat["Height"].mode()
dat["Height"].stdev()

dat["Height"].value_counts()
pd.crosstab(dat["Height"], dat["Self Esteem"],normalize='columns') # col prop (normalize columns)
#normalize='index') #row prop (normalize rows)
#normalize='all') #cell prop

dat["Height"].hist()
dat["Self Esteem"].hist()


########## correlation and scatterplot ############

#https://conjointly.com/kb/correlation-statistic/

dat.plot(kind='scatter', y='Self Esteem', x='Height')

dat.plot(kind='scatter', y='Height', x='Self Esteem')

dat[['Height','Self Esteem']].corr()
#dat.corr()



########## references ############


''' SAVING CSV ONLINE
for your own dataset can just save as csv somewhere online and feed the link like this
just upload to google drive and share it, and cp file id, eg:
1YH8DfzsQ8suZkVQBk7T9FTKvvm9Vyej8
and put into 
https://drive.google.com/uc?id=FILE-ID-GOES-HERE&export=download

#eg:
url="https://drive.google.com/uc?id=1YH8DfzsQ8suZkVQBk7T9FTKvvm9Vyej8&export=download"
dat=pd.read_csv(url) 
'''


''' NOTEBOOKS
a ton of free online shells or notebooks eg:

super simple shell:
https://www.python.org/shell/

notebook:
https://cocalc.com/projects/2ad3cb5d-fc12-479b-993c-e62c1e68071a/files/Welcome%20to%20CoCalc.ipynb?session=default

and notably google's colab (need to have goog acct):
https://colab.research.google.com/drive/1mJo0sJYI58rG63-IEjUOEFE_txQI9q3T

this would load your code from url, say github
https://notebooks.gesis.org/binder/



tried using this one:
https://mybinder.org/v2/gh/jupyterlab/jupyterlab-demo/try.jupyter.org

takes a minute to fire up [sometimes takes forever]

at top right click new-python3
'''



    
    
    
    
