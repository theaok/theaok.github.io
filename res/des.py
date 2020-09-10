'''
a ton of free online shells or notebooks eg:

super simple shell:
https://www.python.org/shell/

notebook:
https://cocalc.com/projects/2ad3cb5d-fc12-479b-993c-e62c1e68071a/files/Welcome%20to%20CoCalc.ipynb?session=default

and notably google's colab (need to have goog acct):
https://colab.research.google.com/drive/1mJo0sJYI58rG63-IEjUOEFE_txQI9q3T

this would load your code from url, say github
https://notebooks.gesis.org/binder/
'''




'''
lets just use this one:
https://mybinder.org/v2/gh/jupyterlab/jupyterlab-demo/try.jupyter.org


takes a minute to fire up

at top right click new-python3
'''

#import pandas as pd #get the library
from statistics import *


############## basic descriptive stats ######################

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



##########  correlation ############

#https://conjointly.com/kb/correlation-statistic/

import pandas as pd

# for your own dataset can just save as csv somewhere onlibe and feed the link like this
# just upload to google drive and share itand cp file id, eg:
# 1YH8DfzsQ8suZkVQBk7T9FTKvvm9Vyej8
# and put into 
# https://drive.google.com/uc?id=FILE-ID-GOES-HERE&export=download
#eg:

url="https://drive.google.com/uc?id=1YH8DfzsQ8suZkVQBk7T9FTKvvm9Vyej8&export=download"
dat=pd.read_csv(url) 

dat #print data

dat 

dat["Height"]

dat["Height"].hist()
dat["Self Esteem"].hist()

dat.plot(kind='scatter', y='Self Esteem', x='Height')

dat.plot(kind='scatter', y='Height', x='Self Esteem')

dat[['Height','Self Esteem']].corr()
#dat.corr()





    
    
    
    