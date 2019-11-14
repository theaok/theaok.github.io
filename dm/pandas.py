# a see child: pandasSimpleForResearchMethods.py
import os 
wd = 'C:\\Users\\ref\\Desktop\\junk' # may need to ADJUST
os.makedirs(wd)
os.getcwd() 
os.chdir(wd)
os.getcwd() 
os.listdir()



#### SKIP: deosntwork at RU library: run stata in python; from https://github.com/sechilds/stataconf2015

# import sys
# import subprocess as sp
# from threading import Thread
# from queue import Queue, Empty

# class Stpy:
#     """A running instance of Stata as a subprocess.

#     An instance of this class can be used to run Stata commands.
#     The instance holds a persistence Stata process, so the memory
#     is preserved between commands.

#     """
#     def __init__(self):
#         """Constructor method for the stpy class.
        
#         This starts Stata running on a separate thread, where it waits
#         until commands are sent to it via the `write` method.
        
#         """
#         # Open stata as pipe; make a queue for non-blocking. Start the thread.
#         self.proc = sp.Popen(['stata-mp'], stdin=sp.PIPE, stdout=sp.PIPE, bufsize=1) #may need to adjust!
        
#         self.qu = Queue()
        
#         self.thread = Thread(target = self.enqueue_output, args = (self.proc.stdout,
#             self.qu))
#         self.thread.daemon = True
#         self.thread.start()
        
#         # Read the initial stdout content.
#         self.genout()
        
#     def enqueue_output(self, out, queue):
#         while True:
#             # Read 1 byte at a time in thread.
#             self.thread = out.read(1).decode()
#             queue.put(self.thread)
#         out.close()
    
#     def buffer_output(self, sbuf=[]):
#         # Try to read byte.
#         try:  char = self.qu.get(timeout=1)
#         except Empty:
#             # Catch 2 x newline, followed by ". ". Stata's done with the output.
#             if ''.join(sbuf) == "\n\n. ":
#                 return False # Done, Stata passes control back to user.
#             # Pass if we are not done.
#             else:
#                 pass # Waiting...
#         else:
#             # Keep a small internal rotating buffer which can catch the '\n\n. '
#             # instruction.
#             if len(sbuf) >= 4:
#                 del sbuf[0]
#             sbuf.append(char)
#             return(char)
    
#     def genout(self):
#         """Read the content of stdout."""
#         ch = self.buffer_output()
#         while ch:
#             print(ch, end='')
#             ch = self.buffer_output()
    
#     def write(self, command):
#         """Pass a stata command to the running Stata instance.
        
#         Call this method with a string that you wish to pass to Stata.
#         The method adds a newline to the end, then passes it to Stata.
#         The output from Stata is returned via the standard output.
#         """
#         # Write command in bytes plus newline then flush.
#         self.proc.stdin.write(bytes(command + "\n", 'ascii'))
#         self.proc.stdin.flush()
        
#         self.genout()


# ## play with stata

# #to avoid typing sw all the time may #delimit ;

# stata=Stpy()
# s=stata.write

# s('sysuse auto,clear')
# s('des')
# s('reg mpg price')


# #should be able to get easily output from stata to python
# # http://stackoverflow.com/questions/5136611/capture-stdout-from-a-script-in-python
# #http://stackoverflow.com/questions/16571150/how-to-capture-stdout-output-from-a-python-function-call
# #or simply write on hd and then read into python



##################### pandas ################################

'''
note:  pandas is kind of like stata, or more like r, but not really much like
the rest of python but helps a lot with traditinal data

may also see:
http://www.dataschool.io/best-python-pandas-resources/
https://www.dataquest.io/blog/pandas-python-tutorial/

https://pandas.pydata.org/pandas-docs/stable/tutorials.html

tuorials (just click on folder and may just go straight to one with solutions
and run them in Python):
https://github.com/guipsamora/pandas_exercises/tree/master/01_Getting_%26_Knowing_Your_Data
https://github.com/guipsamora/pandas_exercises/tree/master/06_Stats
https://github.com/guipsamora/pandas_exercises/tree/master/07_Visualization

'''



#many ideas from basic http://statapython.blogspot.com/
#many great tutorials for self study:
#https://pandas.pydata.org/pandas-docs/stable/tutorials.html



### basic dtaa mgmt like in stata
import os
import pandas as p #so that can just say p instead of pandas
import numpy as np
import statsmodels.formula.api as smf
from statsmodels.iolib.summary2 import summary_col


pip.main(['install', 'seaborn'])     
import seaborn as sns

%matplotlib #this will pop out graphs from ipython; run beofre matplotlib!
# and will go back
#%matplotlib inline 
import matplotlib.pyplot as plt


# Make the graphs a bit prettier, and bigger
p.set_option('display.mpl_style', 'default') 
p.set_option('display.line_width', 5000) 
p.set_option('display.max_columns', 60) 
#figsize(15, 5)



## paths, listing dir, ectc



''' https://automatetheboringstuff.com/chapter9/ '''


#fix path
#wd='/tmp/'
wd = 'C:\\Users\\ref\\Desktop\\junk'

''' stata:
cd /tmp
pwd
ls
'''
os.getcwd()  
os.chdir(wd) 
os.getcwd() 
os.listdir() #http://stackoverflow.com/questions/3207219/how-to-list-all-files-of-a-directory-in-python
             #http://stackoverflow.com/questions/11968976/list-files-in-only-the-current-directory



### lists to pandas and pandas to lists

d = {'a' : [1,2,3], 'b' : [4,5,6]}
df = pd.DataFrame(d)
df
df['c'] = df['a'] + df['b']
df[(df['a'] > 1) & (df['b'] < 5)]
df[(df['a'] > 1) | (df['b'] < 5)]
pd.crosstab(df['a'], df['b'])


guys=['joe','bob','bernie','ted']
salaries=[20, 50, 70, 180]
married=[0, 1, 0, 1]

guysSalaries=list(zip(guys, salaries, married))
guysSalaries #a list of tuples: tuple is like list but immutable and uses ()


df=p.DataFrame(guysSalaries) #dataframe from list of tuples
df.columns=['guys', 'salaries','married'] #give col names
df

df['guys']


df=df.append(p.DataFrame([['carly','2','5']],columns=['guys', 'salaries','married']))

d = {'salaries':'10','married':'1','guys':'hilary'} #doesnt have to be in right order
d
df=df.append([d])



listAgain=list(df['guys']) #back to list again
listAgain

listAgain2=guysSalaries[['guys', 'salaries']].values.tolist()
listAgain2

df2 = df.copy() # df2=df may just operate on the same thing, safer to copy 

### import/export to stats


import urllib #weird, guess need to have os and pandas imported for this to work
urllib.request.urlretrieve("https://docs.google.com/uc?id=1YpkQ-RgAQfB_4olxtbfRWnVmKwkXml5N&export=download", "auto.dta")
auto=p.read_stata('auto.dta') 

auto.to_stata('stata.dta')

auto.to_excel('auto.xlsx', sheet_name = 'testing', index = False)


excelTest1 = p.read_excel('auto.xlsx', 0)
excelTest1.head(2)


'''
CSV
https://pandas.pydata.org/pandas-docs/stable/generated/pandas.read_csv.html
fixed_df = p.read_csv('../data/bikes.csv', sep=',') # header = 2,encoding='latin1'

df.to_csv(file_name,  encoding='utf-8')
df.to_csv(file_name, sep='\t', encoding='utf-8') #tab delimit

SAS
http://pandas.pydata.org/pandas-docs/stable/generated/pandas.read_sas.html
df = pd.read_sas('sas_xport.xpt')
df = pd.read_sas('sas.sas7bdat')

GOOG BIG QUERY (kind of like databases/sql)
http://pandas.pydata.org/pandas-docs/stable/api.html#google-bigquery
https://cloud.google.com/bigquery/what-is-bigquery

HTML
http://pandas.pydata.org/pandas-docs/stable/api.html#html
'''



### basic des stat stuff as in stata



dir(auto)

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

#boolean indexing
auto.make[auto.mpg<18] 


len(auto) #stata: count
auto.shape #74 obs, 12 vars

auto.dtypes #stata: des


# convert to numeric; TODO: adjust to specific variable in this dataset
# d.dtypes
# d.gradtime = d.gradtime.astype(float) #.fillna()
# d.dtypes
# d



auto.describe() #stata: sum
auto.describe().T #T jhust transposes

auto.sort_values(by='mpg')

#stata: l make price mpg rep78 foreign in 1/5'
auto[['make', 'price', 'mpg', 'rep78', 'foreign']].head(5) #first 5 obs

#http://pandas.pydata.org/pandas-docs/stable/missing_data.html
auto[auto.rep78.isnull()][['rep78']] #NaN stands for missing

#stata: l make price mpg rep78 foreign if rep78==.
auto[auto.rep78.isnull()][['make', 'price', 'mpg', 'rep78', 'foreign']] #missing on rep78


# stata: ta rep78, plot //remember stata can do plot too of tab in ascii
auto.groupby('rep78').count()
auto['rep78'].value_counts()
auto['rep78'].value_counts().plot(kind='bar')


# stata: ta rep78 foreign
p.crosstab(auto.rep78, auto.foreign) # crosstab
p.crosstab(auto.rep78, auto.foreign,normalize='columns') # col prop (normalize columns)
p.crosstab(auto.rep78, auto.foreign,normalize='index') #row prop (normalize rows)
p.crosstab(auto.rep78, auto.foreign,normalize='all') #cell prop

#stata: bys foreign: sum mpg
auto.groupby(by=auto.foreign)['mpg'].mean() #mean by foreign

#stata: corr mpg wei
auto.mpg.corr(auto.weight) 
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

#stata: ren mpg newMpg
auto = auto.rename(columns={'mpg': 'newMpg', 'make': 'newMake'}) #ren var
auto.dtypes

#stata: drop newMpg
del auto['newMpg']


#new vars
auto['colOfOnes'] = 1
auto['colOfOnes']

auto['colOfOnes'][1]
#auto['colOfOnes'][1]=2 #not good do other way, some warning
auto.at[1,'colOfOnes'] = 10 #https://stackoverflow.com/questions/13842088/set-value-for-particular-cell-in-pandas-dataframe
auto['colOfOnes'][1]

auto['colOfOnes'].replace(1,2,inplace=True)
# can also replace more than one at once, eg
# data['sex'].replace([0,1],['Female','Male'],inplace=True)
# see https://stackoverflow.com/questions/31888871/pandas-replacing-column-values
auto.replace(-999,np.nan,inplace=True) #replace all -999 with missing
auto.fillna('-', inplace=True) #replace missing with '-'

#this is super useful to get rid of missing just keep finite stuff duh!!
auto = auto[np.isfinite(auto['colOfOnes'])]
auto.reset_index(inplace=True) #sometimes things go wrong bc index is not reset!

#https://stackoverflow.com/questions/27117773/pandas-replace-values
auto.loc[auto['colOfOnes'] <5, 'colOfOnes']  = '22'
auto.loc[auto['foreign'] =='Domestic', 'colOfOnes']  = '100'
auto[['foreign','colOfOnes']]

##another way--skip
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


#BUG this doesnt work for some reason, maybe missing or sth...
# s('gen weigh2=weight^2')
# auto['weight2'] =  auto['weight']**2

#this is really cool: by sort egen mean count lol
df[['col1', 'col2', 'col3', 'col4']].groupby(['col1', 'col2']).agg(['mean', 'count'])

#subsetting
'''
l weight in 1
l weight in 1/3
di weight[1]
'''
auto['weight'][0] #note that py counts from zero!
auto['weight'][0:3] 
auto[['weight', 'length']][0:3]   #note that need to double [[ ]]

# can subset on condition
df3[(df3['real_name'] = 'Steven Balin')]
df.loc[df['column_name'] == some_value]

    
### labelling #TODO--see pandas docs

#Value Labels: Python doesn't have value labels, but it has something even more useful, dicts.  
#(I suspect that, under the covers, Stata is using hashes, which is what dicts really are, for value labels.  
#The idea is to use a dict to map some or all of the values for a variable. 




### append/merge http://pandas.pydata.org/pandas-docs/stable/merging.html



#make some dataset
d1 = p.DataFrame({'id': ['1',  '2',  '3',  '4'],
                   'A': ['A0', 'A1', 'A2', 'A3'],
                   'B': ['B0', 'B1', 'B2', 'B3']
                   })


d2 = p.DataFrame({'id': ['1', '2', '5', '6'],
                   'A': ['A4', 'A5', 'A6', 'A7'],
                   'C': ['C4', 'C5', 'C6', 'C7']
                   })


d1
d2

appended = p.concat([d1, d2])
appended

mergedOuter = p.merge(d1, d2, how='outer', on=['id']) #outer=keep all
mergedOuter

mergedInner = p.merge(d1, d2, how='inner', on=['id']) #inner=keep match
mergedInner

mergedLeft = p.merge(d1, d2, how='left', on=['id']) #left=keep all from 1st
mergedLeft

mergedRight = p.merge(d1, d2, how='right', on=['id']) #right=keep all from 2nd
mergedRight

######################
#reshape
#pd.wide_to_long(df, ['x'], i='i', j='j')

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

from statsmodels.iolib.summary2 import summary_col
dfoutput = summary_col([res,res2,res3],stars=True)
print(dfoutput)
#ok, so conclude that mostly weight! can be lenghty with plenty of headroom
