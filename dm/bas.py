import os 
os.__version__

wd = 'C:\\Users\\ref\\Desktop\\junk' # may need to ADJUST
os.makedirs(wd)
os.getcwd() 
os.chdir(wd)
os.getcwd() 
os.listdir()



#### first install and load modules


## install


#import sys

#import os
#os.system('sudo pip3 urllib2')


#sys.path.append("/home/aok/.local/lib64/python3.3/site-packages")
#sys.path.append("C:\\Users\\ref\\Desktop") #could add a local library
#print(sys.path)  

import pip

#RU electronic classroom anaconda works like this
#pip.main(['install', 'pysal']) 
pip.main(['install', 'geopandas','--upgrade']) 
pip.main(['install', 'folium'])     

pip.main(['install', 'seaborn'])     

#pip.main(['install', 'pdfminer3k']) 
#pip.main(['install', 'PyPDF2'])     
pip.main(['install', 'geopy'])      
pip.main(['install', 'Jinja2'])     
pip.main(['install', 'pandas-datareader'])     
#pip.main(['install', 'python3-weather-api'])
pip.main(['install', 'weather-api'])
pip.main(['install', 'statsmodels'])     
     



#pip.main(['install', 'plotly'])    

##pip.main(['install', '--user', 'pysal'])
#pip.main(['install', '--user', 'geopandas'])
#pip.main(['install', '--user', 'folium'])
#pip.main(['install', '--user', 'PyPDF2'])
#pip.main(['install', '--user', 'pdfquery'])
#pip.main(['install', '--user', 'Jinja2'])
#pip.main(['install', '--user', 'geopy'])
#pip.main(['install', '--user', 'pyowm'])
#pip.main(['install', '--user', 'xlrd'])
#pip.main(['install', '--user', 'sqlalchemy'])
#pip.main(['install', '--user', 'openpyxl'])



#pip.main(['install', '--user', 'rauth']) #can install package urlib3 into loc lib
#pip.main(['install', '--user', 'cStringIO'])
# or can specify explicitly
#add http://stackoverflow.com/questions/7465445/how-to-install-python-modules-without-root-access

#pip.main(['install', '--user', 'matplotlib'])
#pip.main(['install', '--user', 'mechanize'])
#pip.main(['install', '--user', 'nltk'])
#pip.main(['install', '--user', 'rauth.service'])
#pip.main(['install', '--user', 'rauth'])


#for i in '$HOME/local', '$HOME/.local', '/home/aok/.local/', '/home/aok/.local/', '$HOME/.local/python3.3/site-packages', '/home/aok/.local/python3.3/site-packages', '$HOME/.local/.local/lib64/python3.3', '/home/aok/.local/lib64/python3.3/', '$HOME/.local/.local/lib64/python3.3/site-packages':
#    print(i)
#    sys.path.remove(i)

#sys.path.remove()


#find out path
#import os
#try:
#    user_paths = os.environ['PYTHONPATH'].split(os.pathsep)
#except KeyError:
#    user_paths = []
#
#user_paths


## can do it all online in py interpreter
'''
https://www.pythonanywhere.com sign up and select py 3.5
import sys
sys.path.append(".local/lib/python3.5/site-packages")
import pip
pip.main(['install', '--user', 'pymysql'])
etc...
'''


## load


import re
import numpy
import scipy
import urllib
import matplotlib
#import mechanize #doesnt work in RU elsectrinic livrary
import nltk
import time
import random
import os
from rauth.service import OAuth1Service, OAuth1Session 

import xml.etree
import json

import zipfile
import csv
import pandas
#import geopandas
#import geopandas ; geopandas.__version__  #get version of module
#import pysal

import sqlalchemy #sql stuff

#import plotly

import io

#import PyPDF2 # for pdf manipulations
#import pdfquery # pdf parsing

#both needed for xlsx http://nbviewer.jupyter.org/urls/bitbucket.org/hrojas/learn-pandas/raw/master/lessons/10%20-%20Lesson.ipynb
import openpyxl
import xlrd
import pylab

import jinja2 #needed for nice higghlighting in pandas

import matplotlib.pyplot as plt
import numpy as np
#import statsmodels

import geopy # geocoding


import folium #maps on leaflet


#import pyowm #api: weather



#### basics



# LATER polish this more...

# a very good basic intro (but for IT folks, not social scientist):
# http://code.google.com/edu/languages/google-python-class/

#---basics---

a = 6       # set a variable in this interpreter session; like stata macro 
a   # py is obj oriented lang; to print the object just run it;          
b = 'hello'
b
len(a)

a2 = str(a) #can convert to string
len(a2)
len(str(a)) #same more comapctly

len(b)

type(a)
type(b)
type(a2) 

dir()      # like stata's describe

del a
a

## help

#best as with stata: google (even works better here!!)
# usually fist hit is *docs*; and usually first few hits has  stackoverflow
# use stackoverflow: superb!!

help(len)  # for a function
help(sys)  # for a module 
dir(sys)   # dir() is like help() but gives a quick list of the defined symbols
help(sys.exit) # docs for the exit() function inside of sys

#can also use inspect: http://stackoverflow.com/questions/582056/getting-list-of-parameter-names-inside-python-function


## strings

c = 'HELLO'
s = 'hello'


## loops

for letter in s: # note the colon
    print(letter) # note the indent

for letter in s:
    for number in range(1,3):
        print(str(number) + ":" + letter)

# string methods http://docs.python.org/library/stdtypes.html#string-methods
# very useful--keep that reference in mind when you need to modify a string

c.lower()
s.upper()

s + ' there'

## subsetting

s[1:4]
s[1:]
s[-1]

s[4]
s[:4]
s[-4]
s[-4:]


## lists 

colors = ['red', 'blue', 'green']
colors[0]
colors[1:3]
len(colors)
sorted(colors)

for color in colors:
    print(color)

for color in colors:
    print('I like', color, '!')

what_do_i_like = []
what_do_i_like

for color in colors:
    what_do_i_like.append('I like '+ color+ ' !')

what_do_i_like
what_do_i_like[0]

for color in enumerate(colors):
    print(color)

for color in enumerate(colors):
    print(color[0])

for color in enumerate(colors):
    print(color[1])


del colors[1]
colors

#-------------------------SKIP the rest------------------------------------

## SKIP, just use loops;  list comprehension  https://developers.google.com/edu/python/sorting


# software = ['Qgis', 'Python']
# colors = ['red', 'blue', 'green']

# for s in software:
#     print(s)

# [s for s in software]
# [s.upper() for s in software]
# new_list = [s for s in software]
# new_list

# for s in software:
#     for c in colors:
#         print(s,c)

# [[s,c] for s in software for c in colors]
# list_of_lists = [[s,c] for s in software for c in colors]
# list_of_lists


## SKIP tuples:  can also have tuples; like lists but faster and immutable

# colors_tuple = ('red', 'blue', 'green')
# colors_tuple


## SKIP disctionaries: can select by key...


# # very useful, but keep in mind that the key must be unique, like say
# # FIPS code of county or county name and state...

# # say we got some data:
# cou = ['salem, nj', 'camden, nj', 'new york, ny']
# inc = ['50,000', '10,000', '90,000']

# #check if they are the same length...

# len(cou), len(inc)


## SKIP: pandas later instead;  let's make it into a dictionary; 

# first zip it into list of tuples
#cou_inc = zip(cou, inc)
#cou_inc

# and make it into a dictionary
#dict_inc = dict(cou_inc)
#dict_inc

#dict_inc['salem, nj']


# LATER add one more var, say unemployment...


### SKIP: write and read csv; will do pandas layter


#import csv
#
#
##first figure out path for say your desktop: right clisck sth on desktop-properties
# 
#path = '/tmp/' # ADJUST!
#path
#
#cou_inc # each inner tuple will be a separate row
#
#file = open(path+'myfile.csv', 'w')
#
#writer = csv.writer(file, dialect='excel')
#writer.writerow(['county','income'])   # header row
#writer.writerows(cou_inc)
#file.close()
#
## now you can open the file with text editor and convince yourself it workde
#
#file = open(path+'myfile.csv', 'r')
#reader = csv.reader(file, dialect='excel')
#data = [(row[0], row[1]) for row in reader] # using list comprehension 
#file.close()
#
#data[1]
#
#
## probably more useful to read it into a dict; remember: keys (1st # col) must be unique
#
#file = open(path+'myfile.csv', 'r')
#reader = csv.reader(file, dialect='excel')
#data = dict([(row[0], row[1]) for row in reader]) 
#file.close()
#
#data['camden, nj']
#



