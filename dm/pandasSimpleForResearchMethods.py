# a see parent: pandas.py

# first set dir
import os 
wd = 'C:\\Users\\ref\\Desktop\\junk' #  ADJUST
os.makedirs(wd)
os.getcwd() 
os.chdir(wd)
os.getcwd() 
os.listdir()


##################### pandas ################################

'''
many ideas from basic http://statapython.blogspot.com/

many great tutorials for self study:
https://pandas.pydata.org/pandas-docs/stable/tutorials.html


may also see:
http://www.dataschool.io/best-python-pandas-resources/
https://www.dataquest.io/blog/pandas-python-tutorial/

tuorials (just click on folder and may just go straight to one with solutions
and run them in Python):
https://github.com/guipsamora/pandas_exercises/tree/master/01_Getting_%26_Knowing_Your_Data
https://github.com/guipsamora/pandas_exercises/tree/master/06_Stats
https://github.com/guipsamora/pandas_exercises/tree/master/07_Visualization
'''



import pandas as p #so that can just say p instead of pandas
import urllib
import statsmodels.formula.api as smf
from statsmodels.iolib.summary2 import summary_col

pip.main(['install', 'seaborn'])     
import seaborn as sns

%matplotlib 
#this will pop out graphs from ipython; run beofre matplotlib!
# and will go back
#%matplotlib inline 
import matplotlib.pyplot as plt


### import/export to stats


urllib.request.urlretrieve("https://docs.google.com/uc?id=0B06htr9jYWh6eXlZN1lNMVVnNkU&export=download", "auto.csv")

auto=p.read_csv('auto.csv') 

auto.head()

auto.to_excel('auto.xlsx', sheet_name = 'testing', index = False)

excelTest1 = p.read_excel('gss.xlsx', 0)
excelTest1.head(2)


### basic des sta

auto
auto['make']
auto['make'][0] #py counts from zero!
auto['make'][0:5]

auto['mpg'][0:5]

max(auto['mpg'])
min(auto['mpg'])
auto['mpg'].max()
auto['mpg'].min()
auto['mpg'].median()
auto['mpg'].mean()
auto['mpg'].std()

#remember normal distribution from
# https://sites.google.com/site/adamokuliczkozaryn/res_met/des1.pdf?attredirects=0
# so here, assuming it, 95% obs are between mean+-2*std 

#boolean indexing
auto.make[auto.mpg<18] 

len(auto)
auto.shape #74 obs, 12 vars

auto.dtypes #list variables


# convert to numeric; TODO: adjust to specific variable in this dataset
# d.dtypes
# d.gradtime = d.gradtime.astype(float) #.fillna()
# d.dtypes
# d

auto.describe()
auto.describe().T #T just transposes

auto.sort_values(by='mpg')

auto[['make', 'price', 'mpg', 'rep78', 'foreign']].head(5) #first 5 obs

#http://pandas.pydata.org/pandas-docs/stable/missing_data.html
auto[auto.rep78.isnull()][['rep78']] #NaN stands for missing

auto[auto.rep78.isnull()][['make', 'price', 'mpg', 'rep78', 'foreign']] #missing on rep78


auto['rep78'].value_counts() #tabulation

auto['rep78'].value_counts().plot(kind='bar') #histogram

p.crosstab(auto.rep78, auto.foreign) # crosstab
p.crosstab(auto.rep78, auto.foreign,normalize='columns') # col prop (normalize columns)
p.crosstab(auto.rep78, auto.foreign,normalize='index') #row prop (normalize rows)
p.crosstab(auto.rep78, auto.foreign,normalize='all') #cell prop

auto.groupby(by=auto.foreign)['mpg'].mean() #mean by foreign

auto.mpg.corr(auto.weight) #corr mpg with weight
auto[['mpg','weight']].corr() #corr matrix

auto.plot(kind='scatter', y='mpg', x='weight')  #scatterplot

#scatterplot with labels :)
fig, ax = plt.subplots()
ax.scatter(auto['weight'],auto['mpg'] )

for i, txt in enumerate(auto['make']):
    ax.annotate(txt, (auto['weight'][i],auto['mpg'][i]),fontsize=8)



## can nicely print out with some highhlighting etc !

#http://pandas.pydata.org/pandas-docs/stable/style.html

html=auto.style.render()
f = open('myfile.html','w'); f.write(html); f.close()
#os.system('firefox myfile.html') #open in webbrowser

import pylab as pylab

html=auto.style.background_gradient(cmap=pylab.cm.Greens).render()
f = open('myfile.html','w'); f.write(html); f.close()
#os.system('firefox myfile.html') #reload in webborwser

html=auto.style.background_gradient(cmap=pylab.cm.hot).render()
f = open('myfile.html','w'); f.write(html); f.close()
#os.system('firefox myfile.html') #reload in webborwser

### manipulating data

auto = auto.rename(columns={'mpg': 'newMpg', 'make': 'newMake'}) #ren var
auto.dtypes

del auto['newMpg']

#new vars
auto['colOfOnes'] = 1
auto['colOfOnes']

#http://stackoverflow.com/questions/21733893/pandas-dataframe-add-a-field-based-on-multiple-if-statements
# Set a default value
#df['Age_Group'] = '<40'
## Set Age_Group value for all row indexes which Age are greater than 40
#df['Age_Group'][df['Age'] > 40] = '>40'
## Set Age_Group value for all row indexes which Age are greater than 18 and < 40
#df['Age_Group'][(df['Age'] > 18) & (df['Age'] < 40)] = '>18'
## Set Age_Group value for all row indexes which Age are less than 18
#df['Age_Group'][df['Age'] < 18] = '<18'

#a see http://stackoverflow.com/questions/19913659/pandas-conditional-creation-of-a-series-dataframe-column


#subsetting

auto['weight'][0] #note that py counts from zero!
auto['weight'][0:3] 

auto[['weight', 'length']][0:3]   #note that need to double [[ ]]


# quick graphs https://pandas.pydata.org/pandas-docs/stable/visualization.html
# see graph possibilities! https://matplotlib.org/gallery.html
# eg https://matplotlib.org/examples/showcase/bachelors_degrees_by_gender.html 
# is great for institutional research!!

######################

## regressions

#references:
# http://www.learndatasci.com/predicting-housing-prices-linear-regression-using-python-pandas-statsmodels/
# https://stackoverflow.com/questions/19991445/run-an-ols-regression-with-pandas-data-frame
# http://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html
# http://www.statsmodels.org/stable/index.html
# https://stackoverflow.com/questions/6148207/linear-regression-with-matplotlib-numpy

''' an example: (we will do another example with auto data)
import pandas as pd
import statsmodels.formula.api as smf
from statsmodels.iolib.summary2 import summary_col
x = [1, 3, 5, 6, 8, 3, 4, 5, 1, 3, 5, 6, 8, 3, 4, 5, 0, 1, 0, 1, 1, 4, 5, 7]
y = [0, 1, 0, 1, 1, 4, 5, 7,0, 1, 0, 1, 1, 4, 5, 7,0, 1, 0, 1, 1, 4, 5, 7]
d = { "x": pd.Series(x), "y": pd.Series(y)}
df = pd.DataFrame(d)
df['xsqr'] = df['x']**2  

df.plot(kind='scatter', x='x', y='y')  #scatterplot


mod = smf.ols('y ~ x', data=df)
res = mod.fit()
print(res.summary())

sns.regplot(x='x', y='y', data=df)

#note can also do it little more by hand which is instructive,
#predict values and plot them in statsmodels
#http://markthegraph.blogspot.com/2015/05/using-python-statsmodels-for-ols-linear.html

df['xcube'] = df['x']**3  

mod2= smf.ols('y ~ x + xsqr', data=df)
res2 = mod2.fit()
print(res2.summary())

mod3= smf.ols('y ~ x + xsqr + xcube', data=df)
res3 = mod3.fit()
print(res2.summary())

dfoutput = summary_col([res,res2,res3],stars=True)
print(dfoutput)
'''

#H0: bulky cars dont get good mpg

auto.plot(kind='scatter', y='mpg', x='weight')

mod = smf.ols('mpg ~ weight', data=auto)
res = mod.fit()
print(res.summary())

#if mpg goes up by 10, weight drops by about
sns.regplot(y='mpg', x='weight', data=auto)
#so if weight goes up by 500, then mpg drops by 3
500*-0.006
#note can also do it little more by hand which is instructive,
#predict values and plot them in statsmodels
#http://markthegraph.blogspot.com/2015/05/using-python-statsmodels-for-ols-linear.html

mod2 = smf.ols('mpg ~ weight + length', data=auto)
res2 = mod2.fit()
print(res2.summary())

mod3 = smf.ols('mpg ~ weight + length + headroom', data=auto)
res3 = mod3.fit()
print(res3.summary())

dfoutput = summary_col([res,res2,res3],stars=True)
print(dfoutput)
#ok, so conclude that mostly weight! can be lenghty with plenty of headroom
