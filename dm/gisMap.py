#sibling: ~/teach/gis_int/shortGISworkshop/map.py

import os 
wd = 'C:\\Users\\ref\\Desktop\\junk' # may need to ADJUST wd = '/tmp' # may need to ADJUST

os.makedirs(wd)
os.getcwd() 
os.chdir(wd)
os.getcwd() 
os.listdir()



import pip
pip.main(['install', 'folium']) 
pip.main(['install', 'geopy']) 
#or:
#pip.main(['install', 'folium','--user']) 
#pip.main(['install', 'geopy','--user']) 


import urllib
import webbrowser
import folium as f
from folium.plugins import MarkerCluster, HeatMap

from geopy import geocoders  
g = geocoders.GoogleV3()
# g = geocoders.Nominatim() # goog bertter but limited queries per 24hrs



#import geopandas as gp
import pandas as pd

import json


##################
# FOLIUM LEAFLET #
##################

'''
saves maps as html using popular leaflet/openstreetmap engine; can print them
out then to pdf or paper, or just embed html on your website
'''

####examples from https://pypi.python.org/pypi/folium ; new syntax from https://media.readthedocs.org/pdf/folium/latest/folium.pdf

import webbrowser
webbrowser._tryorder
webbrowser.open('http://www.google.com')
webbrowser.open('m.html'); webbrowser.open('m.html') # can rerun it or simply refersh manually 
webbrowser._browsers.items()

# https://docs.python.org/3/library/webbrowser.html#webbrowser.register
webbrowser.get('chrome').open('http://www.google.com')
webbrowser.get('mozilla').open('http://www.google.com')
webbrowser.get('firefox').open('http://www.google.com')
webbrowser.get('windows-default').open('http://www.google.com')


m = f.Map(location=[45.5236, -122.6750]) #open street map is default
m.save('m.html')  #; webbrowser.open('m.html')
webbrowser.get('firefox').open_new_tab('m.html') #; webbrowser.open('m.html')

place = g.geocode("camden nj") #first geocode location  
place[1]

f.Map(location=place[1]).save('m.html'); webbrowser.open('m.html') # and map it; (refresh file in firefox)

# zomm more,focus on roads--instad of defaul 'open street map' use 'Stamen Toner'
f.Map(location=place[1], tiles='Stamen Toner', zoom_start=16).save('m.html'); webbrowser.open('m.html') 

# and little brighter
f.Map(location=place[1], tiles='Stamen Terrain', zoom_start=16).save('m.html'); webbrowser.open('m.html')

# lat/lon popup: .lat_lng_popover()
m=f.Map(location=place[1], zoom_start=16)
m.add_child(f.LatLngPopup())
m.save('m.html'); webbrowser.open('m.html')


###adding markup by hand--easy! good for few u/a


m = f.Map(location=g.geocode("401 cooper st camden nj")[1], zoom_start=14)
m.add_child(f.Marker(g.geocode("401 cooper st camden nj 08120")[1], popup='DPPA'))
m.add_child(f.Marker(g.geocode("321 cooper st camden nj 08102" )[1], popup='bbb'))
#m.add_child(f.CircleMarker(g.geocode("waterfront camden nj")[1], popup='waterfront'))
m.save('m.html'); webbrowser.open('m.html')

'''can pick color, icon
icons: http://www.w3schools.com/icons/bootstrap_icons_glyphicons.asp
colors: http://www.w3schools.com/colors/colors_names.asp
'''
m = f.Map(location=g.geocode("401 cooper st camden nj")[1], zoom_start=14)
m.add_child(f.Marker(g.geocode("401 cooper st camden nj")[1],
                     popup='DPPA1',icon = f.Icon(icon = 'cloud' ,color = 'green')))
m.add_child(f.CircleMarker(g.geocode("2 Riverside Dr, Camden, NJ 08103")[1], popup='waterfront',color='#8A2BE2',fill_color='#F0F8FF'))
m.save('m.html'); webbrowser.open('m.html')

#fixed polygon markers: 
m = f.Map(location=g.geocode("401 cooper st camden nj")[1], zoom_start=14)
m.add_child(f.RegularPolygonMarker(g.geocode("401 cooper st camden nj")[1],popup='DPPA',fill_color='#8A2BE2', number_of_sides=3, radius=25))
m.save('m.html'); webbrowser.open('m.html')

#lines

coordinates = [
    [42.3581, -71.0636],
    [37.7833, -122.4167]]

m = f.Map(location=[41.9, -97.3], zoom_start=4)
m.add_children(f.PolyLine(locations=coordinates,weight=8,popup='my commute'))
m.save('m.html'); webbrowser.open('m.html')

#or more real airplane-like--yes, they fly like that; remember earth is round
coordinates = [
    [42.3581, -71.0636],
    [42.82995815, -74.78991444],
    [43.17929819, -78.56603306],
    [43.40320216, -82.37774519],
    [43.49975489, -86.20965845],
    [41.4338549, -108.74485069],
    [40.67471747, -112.29609954],
    [39.8093434, -115.76190821],
    [38.84352776, -119.13665678],
    [37.7833, -122.4167]]

m = f.Map(location=[41.9, -97.3], zoom_start=4)
m.add_children(f.PolyLine(locations=coordinates,weight=8,popup='my commute'))
m.save('m.html'); webbrowser.open('m.html')


# MAYBE (apprently fancy kind of ugly though, and not usefull i guess)
'''
Vincent/Vega Markers
https://pypi.python.org/pypi/folium
'''


### many points, clustering, USEFUL! fancy!

#http://blog.dominodatalab.com/creating-interactive-crime-maps-with-folium/

urllib.request.urlretrieve('https://docs.google.com/uc?id=1k4TT6EvWpMYQCjO0dch3XPRj_zzagsqv&export=download', "SFPD_Incidents_-_Current_Year__2015_.csv")

crimedata = pd.read_csv('SFPD_Incidents_-_Current_Year__2015_.csv')

len(crimedata)

crimedata[1:3]

#for speed purposes
MAX_RECORDS = 1000

#create empty map zoomed in on San Francisco
m = f.Map(location=(37.76, -122.45), zoom_start=12)

loc = []
#add a marker for every record in the filtered data, use a clustered view
for each in crimedata[0:MAX_RECORDS].iterrows():  
    loc.append([each[1]['Y'],each[1]['X']]) 


loc[1:3]


m.add_children(MarkerCluster(locations=loc))
m.save('m.html'); webbrowser.open('m.html')
#very cool! hover over it--pups u in blue a polygon that the aggregate refers to!


#LATERcan also add popups, but guess for speed with so many obs, can ditch it; https://ocefpaf.github.io/python4oceanographers/blog/2015/12/14/geopandas_folium/



### heatmap http://www.jackboot7.com/visualizing-tweets.html

m = f.Map(location=(37.76, -122.45), zoom_start=12)
m.add_children(HeatMap(loc))
m.save('m.html'); webbrowser.open('m.html')


#a nicer alternative is google heatmap, but req api key and some java editing:
#https://developers.google.com/maps/documentation/javascript/examples/layer-heatmap


#############SKIP! for thematic just use  ~/teach/gis_int/shortGISworkshop/map.py BUT NOT IN THIS CLASS #######################
###################################### just take my regular qgis class #################################

#### thematic/choropleth maps


'''
WARNING/MARKETING: only scratchin a surface here; take my GIS class in fall

the idea is that you have some variable and want to show its values with colors
on a map:
GET regular data say in csv and it has to have same variable as in json to merge
GET json geometry/gegraphy/spatial data by googling it, say 'nj counties json' yields:
http://data.ci.newark.nj.us/dataset/new-jersey-counties-polygon/resource/95db8cad-3a8c-41a4-b8b1-4991990f07f3
and i saved it on my website, and we will pull from there

transfer from one geograpphic format to another is difficult! converting to json
doesnt work well! tends to be very long: say 7m coords; better just google json

conversion that doesnt work well:say shp to json:
import requests, zipfile, io
r = requests.get('http://people.hmdc.harvard.edu/~akozaryn/myweb/bounds_nj_shp.zip')
z = zipfile.ZipFile(io.BytesIO(r.content))
z.namelist()
z.extractall()
njcounties = gp.GeoDataFrame.from_file('nj_counties.shp')
with open('njcounties.json', 'w') as f: 
    f.write(njcounties.to_json())

or (doesnt work well either) using say https://ogre.adc4gis.com/

json data for states, counties, congres distr
http://eric.clst.org/Stuff/USGeoJSON

more elaboration:
https://blog.ouseful.info/2015/04/17/creating-interactive-election-maps-using-folium-and-ipython-notebooks/ 
https://pypi.python.org/pypi/folium

LATER: add polygon popups to thematic map so that can click it and get info like
with markers earlier
'''


##EX: unem and states

#for unemployment data try fred from api.py


urllib.request.urlretrieve('https://raw.githubusercontent.com/python-visualization/folium/master/examples/us-states.json', "us-states.json")

req = urllib.request.urlopen('https://raw.githubusercontent.com/python-visualization/folium/master/examples/us-states.json')
encoding = req.headers.get_content_charset()
obj = json.loads(req.read().decode(encoding))

for key in obj:
    print(key)

obj['type']

for key in obj['features'][1]:
    print(key)

obj['features'][1]['id']
#and open in webbrowser raw data--easy to see!!

m = f.Map(location=g.geocode("kansas")[1], zoom_start=5)
m.choropleth(geo_path='us-states.json', line_color='blue', fill_color='white', line_weight=1,fill_opacity=0.1)
m.save('m.html'); webbrowser.open('m.html')

urllib.request.urlretrieve('https://raw.githubusercontent.com/python-visualization/folium/master/examples/US_Unemployment_Oct2012.csv', "un.csv")

un= pd.read_csv('un.csv')
un

#have a look at geog data
geom=pd.read_json('us-states.json')
geom


m = f.Map(location=g.geocode("kansas")[1], zoom_start=5) #center in mid US
m.choropleth(geo_path='us-states.json',
data=un, columns=['State', 'Unemployment'], #1st is id, 2nd mapping
key_on='feature.id', #keys from json
 line_color='blue', 
 line_weight=1,fill_opacity=0.5,
#threshold_scale=[2,4,6,8,10],
fill_color='YlOrBr', # ‘BuGn’, ‘BuPu’, ‘GnBu’, ‘OrRd’, ‘PuBu’, ‘PuBuGn’, ‘PuRd’, ‘RdPu’, ‘YlGn’, ‘YlGnBu’, ‘YlOrBr’, and ‘YlOrRd’
legend_name = 'Number of') #doesnt wok on my firefox
m.save('m.html'); webbrowser.open('m.html')



##EX: nj counties



urllib.request.urlretrieve('http://people.hmdc.harvard.edu/~akozaryn/myweb/njCounties.geojson.json', "njCounties.geojson.json")

m = f.Map(location=g.geocode("new jersey")[1], zoom_start=7)
m.choropleth(geo_path='njCounties.geojson.json', line_color='blue', fill_color='white', line_weight=1,fill_opacity=0.1)
m.save('m.html'); webbrowser.open('m.html')

# now add some 'regular data', say from http://www.countyhealthrankings.org/rankings/data
urllib.request.urlretrieve('http://www.countyhealthrankings.org/sites/default/files/2014CountyHealthRankingsNationalData.xls', "2014CountyHealthRankingsNationalData.xls")

# FIPS as string so leading zeros are kept!
converters = {'FIPS': str} #we'll use count stringl; but just in case
df = pd.read_excel('2014CountyHealthRankingsNationalData.xls', 'Ranked Measure Data', skiprows=1, converters=converters)
df.head()
df.dtypes

#select relevant stuff
df['State'].value_counts()
len(df[df.State=='New Jersey'])
dfNJ=df[df.State=='New Jersey']
dfNJ

dfNJalc = dfNJ.copy()[['FIPS', 'County', '# Alcohol-Impaired Driving Deaths', '# Driving Deaths', '% Alcohol-Impaired']]
#df_out.dropna(inplace=True)
#df_out['# Alcohol-Impaired Driving Deaths'] = df_out['# Alcohol-Impaired Driving Deaths'].astype(int, copy=False)
#df_out['# Driving Deaths'] = df_out['# Driving Deaths'].astype(int, copy=False)
dfNJalc


#now have another look at json
#geom=pd.read_json('njCounties.geojson.json')
#geom.head() #not helpful, let's try another approach

import json
req = urllib.request.urlopen('http://people.hmdc.harvard.edu/~akozaryn/myweb/njCounties.geojson.json')
encoding = req.headers.get_content_charset()
obj = json.loads(req.read().decode(encoding))

for i in obj:  #lets loop over to get the elements
    print(i)


obj['type']

obj['features'][1]

for i in obj['features'][1]:
    print(i)

for i in obj['features'][1]['properties']:
    print(i)

obj['features'][1]['properties']['county'] #finally!

dfNJalc = dfNJalc.rename(columns={'County': 'county'}) #name nicely
dfNJalc = dfNJalc.rename(columns={'% Alcohol-Impaired': 'perAlcImp'}) #just ion case get rid of special chars

##maybe good idea to try merge first and see how it merges

#first simplify
len(obj['features'])
jsonCounties=[]
for i in range(0,len(obj['features'])):
    jsonCounties.append(obj['features'][i]['properties']['county'])

a=sorted(jsonCounties)
b=sorted(dfNJalc['county'])
#set(jsonCounties) & set(dfNJalc['county'])

check=pd.DataFrame(list(zip(a,b)),columns=['json', 'data'])
check['check'] = 0
check['check'][check['json'] == check['data']] = '1'
check

#and print a listing of values to be mapped
dfNJalc[['county','perAlcImp']].sort_values(by='perAlcImp')

## and finally the map
m = f.Map(location=g.geocode("new jersey")[1], zoom_start=8) #center in mid US
m.choropleth(geo_path='njCounties.geojson.json', 
data=dfNJalc, columns=['county', 'perAlcImp'], #1st is id, 2nd mapping
key_on='feature.properties.county', #ADJUST THIS!!
 line_color='blue', 
 line_weight=1,fill_opacity=0.5,
#threshold_scale=[2,4,6,8,10],
fill_color='YlOrBr', # ‘BuGn’, ‘BuPu’, ‘GnBu’, ‘OrRd’, ‘PuBu’, ‘PuBuGn’, ‘PuRd’, ‘RdPu’, ‘YlGn’, ‘YlGnBu’, ‘YlOrBr’, and ‘YlOrRd’
legend_name = 'Number of') #doesnt wok on my firefox
m.save('m.html'); webbrowser.open('m.html')


#maybe better lighter base
m = f.Map(location=g.geocode("new jersey")[1], zoom_start=10, tiles='Stamen Toner')
m.choropleth(geo_path='njCounties.geojson.json', 
data=dfNJalc, columns=['county', 'perAlcImp'], #1st is id, 2nd mapping
key_on='feature.properties.county', #ADJUST THIS!!
 line_color='blue', 
 line_weight=1,fill_opacity=0.5,
#threshold_scale=[2,4,6,8,10],
fill_color='YlOrBr', # ‘BuGn’, ‘BuPu’, ‘GnBu’, ‘OrRd’, ‘PuBu’, ‘PuBuGn’, ‘PuRd’, ‘RdPu’, ‘YlGn’, ‘YlGnBu’, ‘YlOrBr’, and ‘YlOrRd’
legend_name = 'Number of') #doesnt wok on my firefox
m.save('m.html'); webbrowser.open('m.html')


####################################
#2017  some more  ideas
'''
MATPLOTLIB AND GUESS BASEMAP (maybe, but guess better geoPandas or leaflet!):
this guy looks like he knows what he is doing and they look nice and not overly
complicatd, may have a closer look;
https://www.youtube.com/watch?v=ZIEyHdvF474&t=7s
https://github.com/croach/oreilly-matplotlib-course
https://github.com/croach/oreilly-matplotlib-course/blob/master/07%20-%20Mapping%20in%20matplotlib/0703%20-%20Creating%20a%20Choropleth.ipynb

looks like geopandas now better--see below
'''


############################################################################

###########
# vincent #
###########

'''
http://wrobstory.github.io/2013/10/mapping-data-python.html
http://vincent.readthedocs.org/en/latest/charts_library.html
'''


#####################################################################################

#### other ways to do thematic maps
'''
https://plot.ly/python/choropleth-maps/ 
seems quite heavy; was commercialized untill recently
meh they want api key--still not very open
and seems like no better than goog geo charts--still have to specify location as
a string;; doesnt seem to take coordinates for polygons--eg https://plot.ly/python/choropleth-maps/

goog Charts [MAYBE  have separate py code file for this and other charts--just
py code that will write html/java and pass on data and few options]
https://developers.google.com/chart/interactive/docs/gallery/geochart#marker-geocharts
[even stata package http://www.belenchavez.com/data-blog/stata-google-maps]
everything good; polygons: countries, most country provinces, us counties,
metros; can play with code: http://jsfiddle.net/f3sXW/1/
in general all these i guess:
https://developers.google.com/adwords/api/docs/appendix/geotargeting
https://developers.google.com/adwords/api/docs/appendix/cities-DMAregions?csw=1
cannot do towns or things like that--but then just do marker and color it like:
https://google-developers.appspot.com/chart/interactive/docs/gallery/geochart#region-geocharts
well actually can do any polygons, but some hacking:https://groups.google.com/forum/#!topic/google-visualization-api/KVGu--jjUpk

NO matplotlib basemap in py3k

java-script, no basemap, but yes popups, simple and clean 
https://d3-geomap.github.io/

not sure if mature enough; nice popups; no legend!
http://bokeh.pydata.org/en/latest/docs/gallery/choropleth.html#gallery-choropleth

and see geopandas below
'''




##################################################################################
#### geopandas: thematic maps 

#### 2017--yay looks like functionality now better :) incl legend :)
http://geopandas.org
geopandas.__version__ #make sure have have v 0.3!

>>>just for now run on rce rce powered anaconda thingey!!

looks useful
https://geohackweek.github.io/vector/06-geopandas-advanced/
http://geopandas.readthedocs.io/en/latest/reference.html#geopandas.GeoDataFrame.plot
for reference to options for plot :)

#LATER pysal
geopandas draws on pysal so may look at that too eg
http://darribas.org/gds_scipy16/ipynb_md/02_geovisualization.html
http://pysal.github.io/notebooks/


#######################OLD#############################################

#http://nbviewer.jupyter.org/github/geopandas/geopandas/blob/master/examples/choropleths.ipynb

# import matplotlib.pyplot as plt

# import requests, zipfile, io
# r = requests.get('http://people.hmdc.harvard.edu/~akozaryn/myweb/bounds_nj_shp.zip')
# z = zipfile.ZipFile(io.BytesIO(r.content))
# z.namelist()
# z.extractall()

# #schemes: equal_interval fisher_jenks
# import geopandas as gp
# m = gp.GeoDataFrame.from_file('nj_counties.shp')
# m.head()                       
# m.plot(column='POP2010', scheme='QUANTILES', k=5, colormap='OrRd',axes=None)
# plt.show()

# -----------------------------hacking by hand
# plt.show()

# m.legend()
# dir(a.patch)

# a=m.plot(column='POP2010', scheme='QUANTILES', k=3, colormap='OrRd',axes=None)
# a.properties()
# #a.patches.pop().properties() #all the info about patch! it pops patch so be careful

# patCol=[]
# for i in range(0,len(a.patches)):
#     patCol.append(a.patches.pop().get_facecolor())

# set(patCol) #colors in map

# but then still have to get the ranges for mapped variable and stick in the legend

# -----------------------

#SKIP: too clunky! and need pysal as dependency!
#a function to add legend
#http://nbviewer.jupyter.org/gist/jorisvandenbossche/d4e6efedfa1e4e91ab65
#import numpy as np
#
#
# def __pysal_choro(values, scheme, k=5):
#     """ Wrapper for choropleth schemes from PySAL for use with plot_dataframe
    
#         Parameters
#         ----------

#         values
#             Series to be plotted
            
#         scheme
#             pysal.esda.mapclassify classificatin scheme ['Equal_interval'|'Quantiles'|'Fisher_Jenks']
            
#         k
#             number of classes (2 <= k <=9)
            
#         Returns
#         -------
        
#         values
#             Series with values replaced with class identifier if PySAL is available, otherwise the original values are used
#     """
    
#     try:
#         from pysal.esda.mapclassify import Quantiles, Equal_Interval, Fisher_Jenks
#         schemes = {}
#         schemes['equal_interval'] = Equal_Interval
#         schemes['quantiles'] = Quantiles
#         schemes['fisher_jenks'] = Fisher_Jenks
#         s0 = scheme
#         scheme = scheme.lower()
#         if scheme not in schemes:
#             scheme = 'quantiles'
#             print('Unrecognized scheme: ', s0)
#             print('Using Quantiles instead')
#         if k < 2 or k > 9:
#             print('Invalid k: ', k)
#             print('2<=k<=9, setting k=5 (default)')
#             k = 5
#         binning = schemes[scheme](values, k)
#         values = binning.yb
#     except ImportError:
#         print('PySAL not installed, setting map to default')
        
#     return binning


# def plot_polygon(ax, poly, facecolor='red', edgecolor='black', alpha=0.5, linewidth=1):
#     """ Plot a single Polygon geometry """
#     from descartes.patch import PolygonPatch
#     a = np.asarray(poly.exterior)
#     # without Descartes, we could make a Patch of exterior
#     ax.add_patch(PolygonPatch(poly, facecolor=facecolor, alpha=alpha))
#     ax.plot(a[:, 0], a[:, 1], color=edgecolor, linewidth=linewidth)
#     for p in poly.interiors:
#         x, y = zip(*p.coords)
#         ax.plot(x, y, color=edgecolor, linewidth=linewidth)

# def plot_multipolygon(ax, geom, facecolor='red', edgecolor='black', alpha=0.5, linewidth=1):
#     """ Can safely call with either Polygon or Multipolygon geometry
#     """
#     if geom.type == 'Polygon':
#         plot_polygon(ax, geom, facecolor=facecolor, edgecolor=edgecolor, alpha=alpha, linewidth=linewidth)
#     elif geom.type == 'MultiPolygon':
#         for poly in geom.geoms:
#             plot_polygon(ax, poly, facecolor=facecolor, edgecolor=edgecolor, alpha=alpha, linewidth=linewidth)



# def plot_dataframe(s, column=None, colormap=None, alpha=0.5,
#                    categorical=False, legend=False, axes=None, scheme=None,
#                    k=5, linewidth=1):
#     """ Plot a GeoDataFrame

#         Generate a plot of a GeoDataFrame with matplotlib.  If a
#         column is specified, the plot coloring will be based on values
#         in that column.  Otherwise, a categorical plot of the
#         geometries in the `geometry` column will be generated.
        
#         Parameters
#         ----------
        
#         GeoDataFrame
#             The GeoDataFrame to be plotted.  Currently Polygon,
#             MultiPolygon, LineString, MultiLineString and Point
#             geometries can be plotted.
            
#         column : str (default None)
#             The name of the column to be plotted.
            
#         categorical : bool (default False)
#             If False, colormap will reflect numerical values of the
#             column being plotted.  For non-numerical columns (or if
#             column=None), this will be set to True.
            
#         colormap : str (default 'Set1')
#             The name of a colormap recognized by matplotlib.
            
#         alpha : float (default 0.5)
#             Alpha value for polygon fill regions.  Has no effect for
#             lines or points.
            
#         legend : bool (default False)
#             Plot a legend (Experimental; currently for categorical
#             plots only)
            
#         axes : matplotlib.pyplot.Artist (default None)
#             axes on which to draw the plot
            
#         scheme : pysal.esda.mapclassify.Map_Classifier
#             Choropleth classification schemes
            
#         k   : int (default 5)
#             Number of classes (ignored if scheme is None)
            
            
#         Returns
#         -------
        
#         matplotlib axes instance
#     """
#     import matplotlib.pyplot as plt
#     from matplotlib.lines import Line2D
#     from matplotlib.colors import Normalize
#     from matplotlib import cm
    
#     if column is None:
#         return plot_series(s.geometry, colormap=colormap, alpha=alpha, axes=axes)
#     else:
#         if s[column].dtype is np.dtype('O'):
#             categorical = True
#         if categorical:
#             if colormap is None:
#                 colormap = 'Set1'
#             categories = list(set(s[column].values))
#             categories.sort()
#             valuemap = dict([(k, v) for (v, k) in enumerate(categories)])
#             values = [valuemap[k] for k in s[column]]
#         else:
#             values = s[column]
#         if scheme is not None:
#             binning = __pysal_choro(values, scheme, k=k)
#             values = binning.yb
#             # set categorical to True for creating the legend
#             categorical = True
#             binedges = [binning.yb.min()] + binning.bins.tolist()
#             categories = ['{0:.2f} - {1:.2f}'.format(binedges[i], binedges[i+1]) for i in range(len(binedges)-1)]
#         cmap = norm_cmap(values, colormap, Normalize, cm)
#         if axes == None:
#             fig = plt.gcf()
#             fig.add_subplot(111, aspect='equal')
#             ax = plt.gca()
#         else:
#             ax = axes
#         for geom, value in zip(s.geometry, values):
#             if geom.type == 'Polygon' or geom.type == 'MultiPolygon':
#                 plot_multipolygon(ax, geom, facecolor=cmap.to_rgba(value), alpha=alpha, linewidth=linewidth)
#             elif geom.type == 'LineString' or geom.type == 'MultiLineString':
#                 plot_multilinestring(ax, geom, color=cmap.to_rgba(value))
#             # TODO: color point geometries
#             elif geom.type == 'Point':
#                 plot_point(ax, geom, color=cmap.to_rgba(value))
#         if legend:
#             if categorical:
#                 patches = []
#                 for value, cat in enumerate(categories):
#                     patches.append(Line2D([0], [0], linestyle="none",
#                                           marker="o", alpha=alpha,
#                                           markersize=10, markerfacecolor=cmap.to_rgba(value)))
#                 ax.legend(patches, categories, numpoints=1, loc='best')
#             else:
#                 # TODO: show a colorbar
#                 raise NotImplementedError
            
#             plt.draw()
#             return ax


# m.plot(column='POP2010', scheme='QUANTILES', k=3, colormap='OrRd')
# plot_dataframe(m, column='POP2010', scheme='QUANTILES', k=3,
#                     colormap='OrRd',  linewidth=1.0, legend=True)








