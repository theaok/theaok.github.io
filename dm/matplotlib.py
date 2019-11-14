import os 
wd = 'C:\\Users\\ref\\Desktop\\junk' # may need to ADJUST
os.makedirs(wd)
os.getcwd() 
os.chdir(wd)
os.getcwd() 
os.listdir()


'''
i love these plots! one of the very reasons for python!!

remember stata galleries; see http://matplotlib.org/gallery.html
this is matplotlib, bt mostly packaged as in pandas (though some extensions, fixes done
using native matplotlib 

for useful options and elaboration see
http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.plot.html

OTHER IDEAS:

seaborn:
https://stanford.edu/~mwaskom/
https://stanford.edu/~mwaskom/software/seaborn/examples/
https://stanford.edu/~mwaskom/software/seaborn/tutorial/distributions.html
kind of cute, but matplotlib seems much more mature (and integrated with pandas)

vincent:
http://wavedatalab.github.io/datawithpython/visualize.html
nothing super special; already have most of stuff like that; but can do thematic
maps; so may be wroth revisiting--see gisMap.py

pandas: ugly excel: kind of ok, but i do not like anything excel
http://pandas-xlsxwriter-charts.readthedocs.org/ 

can also try panda's rplot, especially trellis:
http://pandas.pydata.org/pandas-docs/version/0.14.1/rplot.html
http://pandasplotting.blogspot.com/
http://stackoverflow.com/questions/14349055/making-matplotlib-graphs-look-like-r-by-default

plot.ly--no--seegisMap.py

per dendogram classification tree see scipy.py
'''


import pylab as plt
import pandas as pd
import urllib  #weird, guess need to have os and pandas imported for this to work

import string #for annotating pouints in scatter

urllib.request.urlretrieve("https://docs.google.com/uc?id=1YpkQ-RgAQfB_4olxtbfRWnVmKwkXml5N&export=download", "auto.dta")
auto=pd.read_stata('auto.dta') 
auto.head()


### bar charts


auto[['make', 'price']][0:3]

ax=auto[['make', 'price']][0:3].plot(kind='bar', rot=90)
plt.savefig('fig.pdf') #eps, jpeg, jpg, pdf, pgf, png, ps, raw, rgba, svg, svgz, tif, tiff
plt.show()


ax=auto[['make', 'price']][0:3].plot(kind='bar', rot=90, title='my title')
ax.set_xlabel("x label")
ax.set_ylabel("y label")

ax=auto[['make', 'price']][0:3].plot(kind='bar', rot=90)
ax.set_xticklabels(auto.make); plt.show()

ax=auto[['make', 'price']][0:3].plot(kind='barh')
ax.set_yticklabels(auto.make); plt.show()

ax=auto[['make', 'price','weight']][0:7].plot(kind='barh') #stacked=True
ax.set_yticklabels(auto.make); plt.show()
 
ax=auto[['make', 'price','weight']][0:7].sort('price').plot(kind='barh')

ax=auto[['make', 'price','weight']][0:7].plot(kind='barh') 
#.sort('price') if sort then cannot set ytikz--they would be in wrong order!!
ax.set_yticklabels(auto.make); plt.show()

# counts/freq by cat
auto.rep78.value_counts().plot(kind='barh')
plt.show()


### histograms

auto[['price']].plot(kind='hist'); plt.show()
auto[['price']].plot(kind='hist', bins=20); plt.show()


### scatter plots

#run this in regular console, not Ipython so that can pop up and zoom in!
auto.plot.scatter(x='weight', y='length'); plt.show() #note that can zoom in etc

auto.plot.scatter(x='weight', y='length',c='price', s=70); plt.show()
#this is really neat! a see http://stats.stackexchange.com/questions/11984/how-can-i-remove-the-z-order-bias-of-a-coloured-scatter-plot
# i love it! no way to do someting like that in stata!

#label points

def label_point_orig(x, y, val, ax):
    a = pd.concat({'x': x, 'y': y, 'val': val}, axis=1)
    print(a)
    for i, point in a.iterrows():
        ax.text(point['x'], point['y'], str(point['val']),fontsize=7, color='black')

plt.scatter(auto.weight, auto.length,s=5)
label_point_orig(auto.weight, auto.length, auto.make, plt)
plt.show()


# another way: scatterplot with labels :)
fig, ax = plt.subplots()
ax.scatter(auto['weight'],auto['mpg'] )

for i, txt in enumerate(auto['make']):
    ax.annotate(txt, (auto['weight'][i],auto['mpg'][i]),fontsize=8)


### box plot

#so crisp so nice!!
auto.boxplot(column='mpg',by='foreign'), plt.show() #of course foreing have better mpg
auto.boxplot(column='mpg',by='foreign',vert=False), plt.show()
auto.boxplot(column='mpg',by='rep78',vert=False), plt.show()



#################################################################################

#### matplotlib: grids, subplots, and layout



# sometimes can simply add 'by', but for some plots only
auto.price.hist(by=auto.foreign);plt.show()
auto.price.hist(by=auto.rep78, figsize=(8, 8)); plt.show()
# but with native matplotlib  can do  any graph and layout



### first adding text; http://matplotlib.org/users/text_intro.html


#note that in stata can add tex too: scatter mpg price, text(20 1000 "hello", color(black))

%matplotlib 
#this will pop out graphs from ipython; run beofre matplotlib!
# and will go back
#%matplotlib inline 

import matplotlib.pyplot as plt

fig = plt.figure()
fig.suptitle('bold figure suptitle', fontsize=14, fontweight='bold')

ax = fig.add_subplot(111) #1x1grid; 1st plot
#fig.subplots_adjust(top=0.85) #add spaing between title and ax title
ax.set_title('axes title')

ax.set_xlabel('xlabel')
ax.set_ylabel('ylabel')

ax.text(3, 8, 'boxed italics text in data coords', style='italic',
        bbox={'facecolor':'red', 'alpha':0.5, 'pad':10})

ax.text(2, 6, r'an equation: $E=mc^2$', fontsize=15)

ax.plot([2], [1], 'o') #put a point
ax.annotate('annotate', xy=(2, 1), xytext=(3, 4), #put arrow
            arrowprops=dict(facecolor='black', shrink=0.05))

ax.axis([0, 10, 0, 10]) #axes 0-10
plt.show()


### second, empty layout


''' alternative ideas; skip
plt.subplots(1, 2, figsize=(6, 4)); plt.subplots_adjust(wspace=0.3, hspace=.3);plt.show()

following: http://stackoverflow.com/questions/3584805/in-matplotlib-what-does-the-argument-mean-in-fig-add-subplot111

#eg: 224=2x2 grid,4th subplot;    '234=2x3 grid, 4th subplot
fig = plt.figure()
fig.add_subplot(221)   #top left
fig.add_subplot(222)   #top right
fig.add_subplot(223)   #bottom left
fig.add_subplot(224)   #bottom right 
plt.show()

fig = plt.figure()
fig.add_subplot(221)   #top left
fig.add_subplot(222)   #top right
fig.add_subplot(224)   #bottom right 
plt.show()
'''
fig = plt.figure()
ax1 = plt.subplot2grid((2,1), (0,0)); ax1.text(.5,.5,'ax1') #2x1grid; 0,0 graph
ax2 = plt.subplot2grid((2,1), (1,0)); ax2.text(.5,.5,'ax2') #2x1grid; 1,0 graph
plt.show()

fig = plt.figure()
fig.suptitle('bold figure suptitle', fontsize=14, fontweight='bold')
ax1 = plt.subplot(121) ; ax1.text(.5,.5,'ax1') #1x2grid 1st graph
ax2 = plt.subplot(122) ; ax2.text(.5,.5,'ax2') #1x2grid 2nd graph
plt.show()

#asymmetrical arrangements http://matplotlib.org/users/gridspec.html
fig = plt.figure()
ax1 = plt.subplot2grid((3,3), (0,0), colspan=3); ax1.text(.5,.5,'ax1')
ax2 = plt.subplot2grid((3,3), (1,0), colspan=2); ax2.text(.5,.5,'ax2')
ax3 = plt.subplot2grid((3,3), (1, 2), rowspan=2); ax3.text(.5,.5,'ax3')
ax4 = plt.subplot2grid((3,3), (2, 0)); ax4.text(.5,.5,'ax4')
ax5 = plt.subplot2grid((3,3), (2, 1)); ax5.text(.5,.5,'ax5')
plt.show()


## native matplotlib syntax for graphing

fig = plt.figure()
plt.subplots_adjust(hspace=0.2) #adjust horiz space between graphs

ax1 = plt.subplot(211, title='foreign') #2x1grid 1st graph
plt.scatter(auto[auto.foreign=='Foreign'].weight, auto[auto.foreign=='Foreign'].length)

ax2 = plt.subplot(212, sharex=ax1, sharey=ax1, title='doemstic') #2x1grid 2nd graph
plt.scatter(auto[auto.foreign=='Domestic'].weight, auto[auto.foreign=='Domestic'].length)

xticklabels = ax1.get_xticklabels() #+ ax2.get_xticklabels() #drop labelling of 1st x axis
plt.setp(xticklabels, visible=False)
plt.show()

## pandas syntax for graphing

fig = plt.figure()
plt.subplots_adjust(hspace=0.2) #adjust horiz space between graphs

ax1 = plt.subplot(211, title='foreign') #2x1grid 1st graph
auto[auto.foreign=='Foreign'].plot(ax=ax1, kind='scatter', x='weight', y='length')

ax2 = plt.subplot(212, sharex=ax1, sharey=ax1, title='doemstic') #2x1grid 2nd graph
auto[auto.foreign=='Domestic'].plot(ax=ax2,kind='scatter', x='weight', y='length') 

xticklabels = ax1.get_xticklabels() #+ ax2.get_xticklabels() #drop labelling of 1st x axis
plt.setp(xticklabels, visible=False)
plt.show()




#################################################################################
####fancy!

###3d

from mpl_toolkits.mplot3d import Axes3D

#run this in regular console, not Ipython so that can pop up and zoom in!
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
p = ax.scatter(auto.weight, auto.length, auto.mpg, s=60, c=auto.price)
ax.set_xlabel("weight")
ax.set_ylabel("length")
ax.set_zlabel("mpg")
fig.colorbar(p) #add colbar
plt.show() #fancy but perhaps not very useful




### cute lines http://www.randalolson.com/2014/06/28/how-to-make-beautiful-data-visualizations-in-python-with-matplotlib/



import matplotlib.pyplot as plt  
import pandas as pd  
  
# Read the data into a pandas DataFrame.    
gender_degree_data = pd.read_csv("http://www.randalolson.com/wp-content/uploads/percent-bachelors-degrees-women-usa.csv")    
  
# These are the "Tableau 20" colors as RGB.    
tableau20 = [(31, 119, 180), (174, 199, 232), (255, 127, 14), (255, 187, 120),    
             (44, 160, 44), (152, 223, 138), (214, 39, 40), (255, 152, 150),    
             (148, 103, 189), (197, 176, 213), (140, 86, 75), (196, 156, 148),    
             (227, 119, 194), (247, 182, 210), (127, 127, 127), (199, 199, 199),    
             (188, 189, 34), (219, 219, 141), (23, 190, 207), (158, 218, 229)]    
  
# Scale the RGB values to the [0, 1] range, which is the format matplotlib accepts.    
for i in range(len(tableau20)):    
    r, g, b = tableau20[i]    
    tableau20[i] = (r / 255., g / 255., b / 255.)    

# You typically want your plot to be ~1.33x wider than tall. This plot is a rare    
# exception because of the number of lines being plotted on it.    
# Common sizes: (10, 7.5) and (12, 9)    
plt.figure(figsize=(12, 14))    
  
# Remove the plot frame lines. They are unnecessary chartjunk.    
ax = plt.subplot(111)    
ax.spines["top"].set_visible(False)    
ax.spines["bottom"].set_visible(False)    
ax.spines["right"].set_visible(False)    
ax.spines["left"].set_visible(False)    
  
# Ensure that the axis ticks only show up on the bottom and left of the plot.    
# Ticks on the right and top of the plot are generally unnecessary chartjunk.    
ax.get_xaxis().tick_bottom()    
ax.get_yaxis().tick_left()    
  
# Limit the range of the plot to only where the data is.    
# Avoid unnecessary whitespace.    
plt.ylim(0, 90)    
plt.xlim(1968, 2014)    
  
# Make sure your axis ticks are large enough to be easily read.    
# You don't want your viewers squinting to read your plot.    
plt.yticks(range(0, 91, 10), [str(x) + "%" for x in range(0, 91, 10)], fontsize=14)    
plt.xticks(fontsize=14)    
  
# Provide tick lines across the plot to help your viewers trace along    
# the axis ticks. Make sure that the lines are light and small so they    
# don't obscure the primary data lines.    
for y in range(10, 91, 10):    
    plt.plot(range(1968, 2012), [y] * len(range(1968, 2012)), "--", lw=0.5, color="black", alpha=0.3)    

# Remove the tick marks; they are unnecessary with the tick lines we just plotted.    
plt.tick_params(axis="both", which="both", bottom="off", top="off",    
                labelbottom="on", left="off", right="off", labelleft="on")    
  
# Now that the plot is prepared, it's time to actually plot the data!    
# Note that I plotted the majors in order of the highest % in the final year.    
majors = ['Health Professions', 'Public Administration', 'Education', 'Psychology',    
          'Foreign Languages', 'English', 'Communications\nand Journalism',    
          'Art and Performance', 'Biology', 'Agriculture',    
          'Social Sciences and History', 'Business', 'Math and Statistics',    
          'Architecture', 'Physical Sciences', 'Computer Science',    
          'Engineering']    
  
for rank, column in enumerate(majors):    
    # Plot each line separately with its own color, using the Tableau 20    
    # color set in order.    
    plt.plot(gender_degree_data.Year.values,    
             gender_degree_data[column.replace("\n", " ")].values,    
             lw=2.5, color=tableau20[rank])    
    
    # Add a text label to the right end of every line. Most of the code below    
    # is adding specific offsets y position because some labels overlapped.    
    y_pos = gender_degree_data[column.replace("\n", " ")].values[-1] - 0.5    
    if column == "Foreign Languages":    
        y_pos += 0.5    
    elif column == "English":    
        y_pos -= 0.5    
    elif column == "Communications\nand Journalism":    
        y_pos += 0.75    
    elif column == "Art and Performance":    
        y_pos -= 0.25    
    elif column == "Agriculture":    
        y_pos += 1.25    
    elif column == "Social Sciences and History":    
        y_pos += 0.25    
    elif column == "Business":    
        y_pos -= 0.75    
    elif column == "Math and Statistics":    
        y_pos += 0.75    
    elif column == "Architecture":    
        y_pos -= 0.75    
    elif column == "Computer Science":    
        y_pos += 0.75    
    elif column == "Engineering":    
        y_pos -= 0.25    
    
    # Again, make sure that all labels are large enough to be easily read    
    # by the viewer.    
    plt.text(2011.5, y_pos, column, fontsize=14, color=tableau20[rank])    

# matplotlib's title() call centers the title on the plot, but not the graph,    
# so I used the text() call to customize where the title goes.    
  
# Make the title big enough so it spans the entire plot, but don't make it    
# so big that it requires two lines to show.    
  
# Note that if the title is descriptive enough, it is unnecessary to include    
# axis labels; they are self-evident, in this plot's case.    
plt.text(1995, 93, "Percentage of Bachelor's degrees conferred to women in the U.S.A."    
         ", by major (1970-2012)", fontsize=17, ha="center")    
  
# Always include your data source(s) and copyright notice! And for your    
# data sources, tell your viewers exactly where the data came from,    
# preferably with a direct link to the data. Just telling your viewers    
# that you used data from the "U.S. Census Bureau" is completely useless:    
# the U.S. Census Bureau provides all kinds of data, so how are your    
# viewers supposed to know which data set you used?    
plt.text(1966, -8, "Data source: nces.ed.gov/programs/digest/2013menu_tables.asp"    
         "\nAuthor: Randy Olson (randalolson.com / @randal_olson)"    
         "\nNote: Some majors are missing because the historical data "    
         "is not available for them", fontsize=10)    

# Finally, save the figure as a PNG.    
# You can also save it as a PDF, JPEG, etc.    
# Just change the file extension in this call.    
# bbox_inches="tight" removes all the extra whitespace on the edges of your plot.    

plt.show()
#plt.savefig("percent-bachelors-degrees-women-usa.png", bbox_inches="tight")  


#######################################################
####seaborn

'''
kind of like stata, esasy to use, more canned than matplotlib
has nice heatmaps eg min7 https://www.youtube.com/watch?v=6Pzg-UY1VDg
nice jointplot (overaly of hist) min8
'''

pip.main(['install', 'seaborn'])     
import seaborn as sns

urllib.request.urlretrieve("https://docs.google.com/uc?id=0B06htr9jYWh6eXlZN1lNMVVnNkU&export=download", "auto.csv")
auto=p.read_csv('auto.csv') 

##linear regfit with ci

sns.regplot(y='mpg', x='weight', data=auto) 

# http://seaborn.pydata.org/examples/multiple_regression.html
sns.set()

# Load the example tips dataset
iris = sns.load_dataset("iris")

# Plot tip as a function of toal bill across days
g = sns.lmplot(x="sepal_length", y="sepal_width", hue="species",
               truncate=True, size=5, data=iris)

# Use more informative axis labels than are provided by default
g.set_axis_labels("Sepal length (mm)", "Sepal width (mm)")



#http://seaborn.pydata.org/examples/pairgrid_dotplot.html

sns.set(style="whitegrid")

# Load the dataset
crashes = sns.load_dataset("car_crashes")

# Make the PairGrid
g = sns.PairGrid(crashes.sort_values("total", ascending=False),
                 x_vars=crashes.columns[:-3], y_vars=["abbrev"],
                 size=10, aspect=.25)

# Draw a dot plot using the stripplot function
g.map(sns.stripplot, size=10, orient="h",
      palette="Reds_r", edgecolor="gray")

# Use the same x axis limits on all columns and add better labels
g.set(xlim=(0, 25), xlabel="Crashes", ylabel="")

# Use semantically meaningful titles for the columns
titles = ["Total crashes", "Speeding crashes", "Alcohol crashes",
          "Not distracted crashes", "No previous crashes"]

for ax, title in zip(g.axes.flat, titles):

    # Set a different title for each axes
    ax.set(title=title)

    # Make the grid horizontal instead of vertical
    ax.xaxis.grid(False)
    ax.yaxis.grid(True)

sns.despine(left=True, bottom=True)


## http://seaborn.pydata.org/examples/regression_marginals.html

sns.set(style="darkgrid", color_codes=True)

tips = sns.load_dataset("tips")
g = sns.jointplot("total_bill", "tip", data=tips, kind="reg",
                  xlim=(0, 60), ylim=(0, 12), color="r", size=7)



##################################EXAMPLES
'''
http://willgeary.github.io/data/2016/05/18/when-does-crime-happen-in-new-york-city.html
http://willgeary.github.io/data/2016/05/19/causes-of-death-in-new-york.html
'''

############################OTHER######################################
'''
http://holoviews.org/gallery/index.html looks really cool for interactive
visualization!
'''



################################### SKIP THE FOLLOWING ###########################



import matplotlib
matplotlib.style.use('ggplot')
import numpy as np
from pylab import *


val = 3+10*rand(5)    # the bar lengths
pos = arange(5)+.5    # the bar centers on the y axis
val
pos

barh(pos,val, align='center')
yticks(pos, ('Tom', 'Dick', 'Harry', 'Slim', 'Jim'))
xlabel('Performance')
title('How fast do you want to go today?')
grid(True)
show()

barh(pos,val, xerr=rand(5), ecolor='r', align='center')
yticks(pos, ('Tom', 'Dick', 'Harry', 'Slim', 'Jim'))
xlabel('Performance')
show()



df4 = pd.DataFrame({'a': np.random.randn(1000) + 1, 'b': np.random.randn(1000), 'c': np.random.randn(1000) - 1}, columns=['a', 'b', 'c'])
df4

df4.plot.hist(stacked=True, bins=20), plt.show()

### time series data: line plot 

prng = pd.period_range('1990Q1', '2000Q4', freq='Q-NOV')
prng #quarterly dates
ts = pd.Series(np.random.randn(len(prng)), prng)
ts #made up some randeom data
ts.index = (prng.asfreq('M', 'e') + 1).asfreq('H', 's') + 9 
#+1 day is 1; +9 hour is 9
ts

df = pd.DataFrame(np.random.randn(44, 4), index=ts.index, columns=list('ABCD'))
df
df = df.cumsum() #cumulative sum
df.plot(); plt.show()


#######
# OLD #
#######



# most of this comes from http://matplotlib.org/examples

#!/usr/bin/env python
import numpy as np
import pylab as P

#
# The hist() function now has a lot more options
#

#
# first create a single histogram
#
mu, sigma = 200, 25
x = mu + sigma*P.randn(10000)

# the histogram of the data with histtype='step'
n, bins, patches = P.hist(x, 50, normed=1, histtype='stepfilled')
P.setp(patches, 'facecolor', 'g', 'alpha', 0.75)

# add a line showing the expected distribution
y = P.normpdf( bins, mu, sigma)
l = P.plot(bins, y, 'k--', linewidth=1.5)

P.show()


#
# create a histogram by providing the bin edges (unequally spaced)
#
P.figure()

bins = [100,125,150,160,170,180,190,200,210,220,230,240,250,275,300]
# the histogram of the data with histtype='step'
n, bins, patches = P.hist(x, bins, normed=1, histtype='bar', rwidth=0.8)

P.show()


#
# now we create a cumulative histogram of the data
#
P.figure()

n, bins, patches = P.hist(x, 50, normed=1, histtype='step', cumulative=True)

# add a line showing the expected distribution
y = P.normpdf( bins, mu, sigma).cumsum()
y /= y[-1]
l = P.plot(bins, y, 'k--', linewidth=1.5)

# create a second data-set with a smaller standard deviation
sigma2 = 15.
x = mu + sigma2*P.randn(10000)

n, bins, patches = P.hist(x, bins=bins, normed=1, histtype='step', cumulative=True)

# add a line showing the expected distribution
y = P.normpdf( bins, mu, sigma2).cumsum()
y /= y[-1]
l = P.plot(bins, y, 'r--', linewidth=1.5)

# finally overplot a reverted cumulative histogram
n, bins, patches = P.hist(x, bins=bins, normed=1,
    histtype='step', cumulative=-1)


P.grid(True)
P.ylim(0, 1.05)

P.show()



#
# histogram has the ability to plot multiple data in parallel ...
# Note the new color kwarg, used to override the default, which
# uses the line color cycle.
#
P.figure()

# create a new data-set
x = mu + sigma*P.randn(1000,3)

n, bins, patches = P.hist(x, 10, normed=1, histtype='bar',
                            color=['crimson', 'burlywood', 'chartreuse'],
                            label=['Crimson', 'Burlywood', 'Chartreuse'])
P.legend()

#
# ... or we can stack the data
#
P.figure()

n, bins, patches = P.hist(x, 10, normed=1, histtype='bar', stacked=True)

P.show()

#
# we can also stack using the step histtype
#

P.figure()

n, bins, patches = P.hist(x, 10, histtype='step', stacked=True, fill=True)

P.show()

#
# finally: make a multiple-histogram of data-sets with different length
#
x0 = mu + sigma*P.randn(10000)
x1 = mu + sigma*P.randn(7000)
x2 = mu + sigma*P.randn(3000)

# and exercise the weights option by arbitrarily giving the first half
# of each series only half the weight of the others:

w0 = np.ones_like(x0)
w0[:len(x0)/2] = 0.5
w1 = np.ones_like(x1)
w1[:len(x1)/2] = 0.5
w2 = np.ones_like(x2)
w2[:len(x2)/2] = 0.5



P.figure()

n, bins, patches = P.hist( [x0,x1,x2], 10, weights=[w0, w1, w2], histtype='bar')

P.show()





# This example comes from the Cookbook on www.scipy.org.  According to the
# history, Andrew Straw did the conversion from an old page, but it is
# unclear who the original author is.
import numpy as np
import matplotlib.pyplot as plt

a = np.linspace(0, 1, 256).reshape(1,-1)
a = np.vstack((a,a))

# Get a list of the colormaps in matplotlib.  Ignore the ones that end with
# '_r' because these are simply reversed versions of ones that don't end
# with '_r'
maps = sorted(m for m in plt.cm.datad if not m.endswith("_r"))
nmaps = len(maps) + 1

fig = plt.figure(figsize=(5,10))
fig.subplots_adjust(top=0.99, bottom=0.01, left=0.2, right=0.99)
for i,m in enumerate(maps):
    ax = plt.subplot(nmaps, 1, i+1)
    plt.axis("off")
    plt.imshow(a, aspect='auto', cmap=plt.get_cmap(m), origin='lower')
    pos = list(ax.get_position().bounds)
    fig.text(pos[0] - 0.01, pos[1], m, fontsize=10, horizontalalignment='right')

plt.show()
