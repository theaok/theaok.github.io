import os 
wd = 'C:\\Users\\ref\\Desktop\\junk' # may need to ADJUST
os.makedirs(wd)
os.getcwd() 
os.chdir(wd)
os.getcwd() 
os.listdir()

'''
books:
Mining the Social Web
http://shop.oreilly.com/product/0636920030195.do

Programming Collective Intelligence 
http://shop.oreilly.com/product/9780596529321.do

oreilly.com has 50% off promotions often; can also get used for about $10; or
often for free--just google

can search for apis here:
http://www.programmableweb.com/category/all/apis?keyword=stocks
and in general see http://www.programmableweb.com/

API example with restaurants
http://nealcaren.github.io/sushi_bars.html

'''
 
##https://data.nj.gov/ also may see http://www.hackjersey.com/public-data/
#can download tradiotional data  or use api eg open in web browser:
# https://data.nj.gov/resource/swjq-h2b6.json?full_name=REBER,%20FREDERICK
# https://data.nj.gov/resource/swjq-h2b6.xml?full_name=REBER,%20FREDERICK
# see noaa example below how to parse it



##http://api.rutgers.edu/

# Nextbus
# Events
# Dining
# Sports
# Recreation
# Places
# Schedule of Classes




### pandas API: stocks and various traditional soc sci data 

#https://pandas-datareader.readthedocs.io/en/latest/remote_data.html


import pip
pip.main(['install', 'pandas-datareader'])  
pip.main(['install','statsmodels'])  

import pandas_datareader.data as web
import datetime


## yahoo stocks 





In [5]: f = web.DataReader("F", 'yahoo', start, end)

In [6]: f.ix['2010-01-04']


start = datetime.datetime(2016, 4, 1)
end = datetime.datetime(2016, 4, 7)
y = web.DataReader("GOOG", 'yahoo', start, end)
y
dir(y) #check what is in there
y['High']['2016-04-04']
y.ix['2016-04-04']





## world bank; very handy!

from pandas_datareader import wb
wb.search('gdp.*capita.*const').iloc[:,:2] #iloc[:,:2] returns relevant columns
dat = wb.download(indicator='NY.GDP.PCAP.KD', country=['US', 'CA', 'MX'], start=2005, end=2008)
dat

''' as of 2019 breaks :(
wb.search('cell.*%').iloc[:,:2]
ind = ['NY.GDP.PCAP.KD', 'IT.MOB.COV.ZS']
dat = wb.download(indicator=ind, country='all', start=2011, end=2011).dropna()
dat.columns = ['gdp', 'cellphone']
print(dat.tail())

import numpy as np
import statsmodels.formula.api as smf
mod = smf.ols("cellphone ~ np.log(gdp)", dat).fit()
print(mod.summary())
'''

wb.search('gov.*debt').iloc[:,:2]
dat = wb.download(indicator='GC.DOD.TOTL.GD.ZS', country=['AUS', 'DEU', 'FRA','USA'], start=1995, end=2011).dropna()

dat
dir(dat)
dat.index
dat.values

dat.index[0]
dat.values[0]

dat.to_csv('mycsv.csv')

#for colab
from google.colab import files
files.download('mycsv.csv') 



## oecd

## eurostat


## fred data

'''
browse or use search box at https://research.stlouisfed.org/fred2/categories
say https://research.stlouisfed.org/fred2/series/GFDEBTN
so the code is 'GFDEBTN' as at the end of url or in that website
'''
import pandas_datareader.data as web
import datetime
start = datetime.datetime(2010, 1, 1)
end = datetime.datetime(2020, 1, 1)

web.DataReader('GFDEBTN', 'fred', start, end)

#https://research.stlouisfed.org/fred2/series/UNRATE
data = web.DataReader('UNRATE', 'fred', start, end)
data.plot()
import matplotlib.pyplot as plt
plt.savefig('a.pdf')
#plt.show()

data.to_csv('mycsv.csv')

inflation = web.DataReader(["CPIAUCSL", "CPILFESL"], "fred", start, end)
inflation.head()


#---------------------------------SKIP THE REST-------------------------------------------

###geocoding (turning address into coordinates (latitude, longitude)) 


from geopy import geocoders  

##Using the GoogleV3 geocoder:

g = geocoders.GoogleV3()
place = g.geocode("401 cooper st camden nj")  
place
place[0]
place[1]
place[1][0]
place[1][1]

## distance

#LATER: see docs: can get walking, driving, etc distances!

from geopy import distance  
A = g.geocode('philadelphia,pa')[1]  
B = g.geocode('camden, nj')[1]  
distance.distance(A, B).miles  

A = g.geocode('philadelphia,pa')[1]  
B = g.geocode('trenton, nj')[1]  
distance.distance(A, B).miles  

# from my office to DPPA main
A = g.geocode('401 cooper st camden nj')[1]  
B = g.geocode('321 cooper st camden nj')[1]  
distance.distance(A, B).meters  

#application: 
#students disctance from home to school may affect attendance, gpa, dropout



pip.main(['install', 'weather-api'])


from weather import Weather
weather = Weather()

location = weather.lookup_by_location('dublin')

#see what else is there
dir(location)
location.wind()
location.atmosphere()
location.astronomy()

location.condition().text()


#see what else is there
dir(location.condition())
location.condition().temp()


dir(condition.text())

forecasts = location.forecast()
for forecast in forecasts:
    print(forecast.text())
    print(forecast.date())
    print(forecast.high())
    print(forecast.low())

####################################SKIP########################################





#### noaa (weather stuff): and simple program for weather :)





###xml


#using some xml parsing; don't worry about it too much, just follow example
#if you are interested in xml data: http://www.diveintopython3.net/xml.html

import xml.etree.ElementTree as etree
import urllib

#first get lat lon
lat=g.geocode('401 cooper st camden nj')[1][0]  
lon=g.geocode('401 cooper st camden nj')[1][1]  

#then create a url with lat and lon
url='http://forecast.weather.gov/MapClick.php?lat=' + str(lat) + '&lon=' + str(lon) + '&FcstType=xml'

url #open in web browser

#then download that webpage
tree = etree.parse(urllib.request.urlopen(url)) #downloads web page
root = tree.getroot() 

#and explore it--bunch of tags #show correspondences in webbrowser
for r in root:
    print(r)

#skip first2

for r in root[2:]:
    print(r)


for r in root[2:]: #show correspondences in webbrowser; remember count from 0
    for i in r:
        print(i.tag)

#in webbrowser, we see that <valid> tag contains day; so we extract that, e.g.:

root[2][0].text #show correspondence in webbrowser

#and  temperature is in

root[2][3].text #show correspondenced in webbrowser

#and  description is in

root[2][4].text

# so can loop over

for r in root[2:]:
    print(r[0].text,r[3].text)  #ah sometimes <pop> is missing and we don't get temp right

#but can count from the end :)
for r in root[2:]:
    print(r[0].text,r[-2].tag)

for r in root[2:]:
    print(r[0].text,r[-2].text)


##so now can wrap the whole thing into a program!

def hello(name):
    print('what a nice day', name,'!')


hello('adam')


def weather(location):  #just putting in here previous lines; remember to indent!
    lat=g.geocode(location)[1][0]  
    lon=g.geocode(location)[1][1]  
    #then create a url with lat and lon
    url='http://forecast.weather.gov/MapClick.php?lat=' + str(lat) + '&lon=' + str(lon) + '&FcstType=xml'
    
    #then download that webpage
    tree = etree.parse(urllib.request.urlopen(url)) #downloads web page
    root = tree.getroot() 
    for r in root[2:]:
        print(r[0].text,r[-2].text)


weather('401 cooper st camden nj')
weather('trenton, nj')
weather('dallas, tx')
weather('tampa,fl')


#can also easily adjust it, say just text for today--just figure out what we need:

root[2][0].text
root[2][4].text


def weather2(location):
    lat=g.geocode(location)[1][0]  
    lon=g.geocode(location)[1][1]  
    #then create a url with lat and lon
    url='http://forecast.weather.gov/MapClick.php?lat=' + str(lat) + '&lon=' + str(lon) + '&FcstType=xml'
    
    #then download that webpage
    tree = etree.parse(urllib.request.urlopen(url)) #downloads web page
    root = tree.getroot() 
    print('weather for',root[2][0].text,'in',location,': ',root[2][-1].text)


weather2('trenton, nj')
weather2('dallas,tx')



### and can do same thing in json


import json

url='http://forecast.weather.gov/MapClick.php?lat=' + str(lat) + '&lon=' + str(lon) + '&FcstType=json'
url
#http://forecast.weather.gov/MapClick.php?lat=39.9473403&lon=-75.1218172&FcstType=json

req = urllib.request.urlopen(url)
encoding = req.headers.get_content_charset()
obj = json.loads(req.read().decode(encoding))

obj #print it out, messy

for i in obj:  #lets loop over to get the elements
    print(i)

for i in obj['time']:
    print(i)

obj['time']['startPeriodName']
obj['time']['startValidTime']


for i in obj['data']:
    print(i)

obj['data']['text']
obj['data']['temperature']


len(obj['time']['startValidTime'])
len(obj['data']['temperature'])

time=(obj['time']['startValidTime'])
temp=(obj['data']['temperature'])

timeTemp=list(zip(time, temp))

timeTemp # a list of tuples

for i in timeTemp:
    print(i) 

import pandas as p
df=p.DataFrame(timeTemp)
df.to_csv('mycsv.csv')


# and make it into def


def jsonWeather(location):
    lat=g.geocode(location)[1][0]  
    lon=g.geocode(location)[1][1]  
    #then create a url with lat and lon
    url='http://forecast.weather.gov/MapClick.php?lat=' + str(lat) + '&lon=' + str(lon) + '&FcstType=json'
    
    req = urllib.request.urlopen(url)
    encoding = req.headers.get_content_charset()
    obj = json.loads(req.read().decode(encoding))
    
    time=(obj['time']['startValidTime'])
    temp=(obj['data']['temperature'])
    
    timeTemp=list(zip(time, temp))
    
    for i in timeTemp:
        print(i) 

jsonWeather('401 cooper st')    


## SKIP: requires key;  weather http://stackoverflow.com/questions/1474489/python-weather-api  


# #singn up! http://home.openweathermap.org/users/sign_up
# #https://github.com/csparpa/pyowm/wiki/Usage-examples
# import pyowm
# owm = pyowm.OWM('79dea9d5ce034c12087c634beb7482d8') #put your own key here!
# obs = owm.weather_at_place('camden,nj')
# obs.get_location() #make sure our location got looked up right!

# w = obs.get_weather()
# dir(w)

# w.get_wind()
# w.get_humidity()
