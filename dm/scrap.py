
TODO: need to fix this file!!!!!


'''
see https://automatetheboringstuff.com/chapter11/

see http://blog.danwin.com/examples-of-web-scraping-in-python-3-x-for-data-journalists/
'''

#-----------------------web scrapping-----------------------------------------
# as usual,  to understand something start with simple examples...

from BeautifulSoup import BeautifulSoup
import re

#Create the soup
input = '''<html>
<head><title>Page title</title></head>
<body>
<p id="firstpara" align="center">This is paragraph <b>one</b>.
<p id="secondpara" align="blah">This is paragraph <b>two</b>.
</html>
<thead class="mainrow"><tr><th scope="col">Total enrollment</th><th scope="col">35,272</th></tr></thead>
'''
soup = BeautifulSoup(input)
print soup.prettify()

#Search the soup
titleTag = soup.html.head.title
print titleTag
print titleTag.string


aoktag = soup.findAll('title')
aoktag = soup.findAll(text="Total enrollment")
print aoktag

soup(text=re.compile(r'Total*'))



#------------------------------------------------

from mechanize import Browser
from BeautifulSoup import BeautifulSoup
import re
mech = Browser()

url = "http://nces.ed.gov/collegenavigator/?q=ucla&s=all&id=110662"
page = mech.open(url)
html = page.read()
soup = BeautifulSoup(html)

Nam = soup.findAll('span', attrs={'class': 'headerlg'}) 

#TotEn = soup.find(text='Total enrollment')
# text=true gets rid of the tags
#TotEnV = TotEn.findNext('th', text=True)

UEn = soup.find(text='Undergraduate enrollment')
UEnV = UEn.findNext('th', text=True)

GEn = soup.find(text='Graduate enrollment')
GEnV = GEn.findNext('th', text=True)

Web = soup.find(text='Website:&nbsp;&nbsp;')
WebV = Web.findNext('a', text=True)

DisV = "NO"
Dis = soup.find(text='Distance learning opportunities')
DisV = soup.find(text='Distance learning opportunities')

#re.sub("\D", "", val)
# \D matches any non-digit character so, the code above, is essentially replacing every non-digit character for the empty string

#print  'Total enrolment', val

table = {Web: WebV,  UEn: UEnV, GEn: GEnV, Dis: DisV }
for name, val in table.items():
     print '{0:10} ==> {1:10}'.format(name, val)



#------------------------------------------------------------
# some geocoding with google

import os

#os.system("libreoffice /home/aok/desk/career/cover/2011/DEC/testit.csv")

from time import sleep

import googlemaps
from googlemaps import GoogleMaps
gmaps = GoogleMaps('ABQIAAAA_bTF6jBJCV91-AeK3hTuARRd7SLIw_AFkyDEshsqvmDj9YqyERSyJPS04IT0Kt8XTZL-f3cnhwCI9w')
address = 'Constitution Ave NW & 10th St NW, Washington, DC'
lat, lng = gmaps.address_to_latlng(address)
print lat, lng
result = gmaps.geocode(address)
placemark = result['Placemark'][0]
details = placemark['AddressDetails']['Country']['AdministrativeArea']
zipcode = details['Locality']['PostalCode']['PostalCodeNumber']

#------------------------------------
#the actual program

import csv

import re
import mechanize
#import cookielib
from BeautifulSoup import BeautifulSoup
#import html2text

# Browser
br = mechanize.Browser()

# Browser options
br.set_handle_equiv(True)
br.set_handle_gzip(True)
br.set_handle_redirect(True)
br.set_handle_referer(True)
br.set_handle_robots(False)

# Follows refresh 0 but not hangs on refresh > 0
br.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=1)

# User-Agent (is this cheating?, ok?)
br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]

def remove_html_tags(data):
    p = re.compile(r'<.*?>')
    return p.sub('', data)

n='the university of texas at austin'
n='university of oregon'

def aok1(n):
     
    print n 
    #nn = 'us news national universities ' + n  
    ## gess it is better to give URL for google to find things
    nn = 'colleges.usnews.rankingsandreviews.com ' + n 
    br.open('http://google.com')
    br.select_form(nr=0)
    br.form['q'] = nn
    br.submit()
    br.follow_link(text_regex=re.compile("University"), nr=0)
    #br.follow_link(text_regex=re.compile("US News"), nr=0)
    # br.follow_link(text_regex=re.compile("U.S. News & World Report"), nr=0)
    html = br.response().read()
    soup = BeautifulSoup(html)
    Yr = soup.find(text='Year founded')
    YrV = Yr.findNext('span')
    YrV = YrV.string.strip()
    titleTag = soup.html.head.title
    usnews = titleTag.string
    # f = open('out.txt','w')
    # print >>f, YrV.string
    # f = open('out.txt','r')
    # a = f.read()
    
    # The site we will navigate into, handling it's session
    br.open('http://nces.ed.gov/collegenavigator/')
    
    # Select the first (index zero) form
    br.select_form(nr=1)
    
    # User credentials
    br.form['ctl00$cphCollegeNavBody$ucSearchMain$txtName'] = n
    
    # Login
    br.submit()
    html = br.response().read()
    soup = BeautifulSoup(html)
    #print soup.prettify()
    
    #list(br.links())
    #list(br.links(text_regex=re.compile("University"), nr=0))
    #br.find_link(text_regex=re.compile("Dallas"))
    
    br.follow_link(text_regex=re.compile("University"), nr=0)
    
    html = br.response().read()
    soup = BeautifulSoup(html)
    
    Nam = soup.find('span', attrs={'class': 'headerlg'}) 
    Nam = Nam.next
    Add = Nam.next.next
    #TotEn = soup.find(text='Total enrollment')
    # text=true gets rid of the tags
    #TotEnV = TotEn.findNext('th', text=True)
    
    UEn = soup.find(text='Undergraduate enrollment')
    UEnV = UEn.findNext('th', text=True)
    
    GEn = soup.find(text='Graduate enrollment')
    GEnV = GEn.findNext('th', text=True)
    
    Web = soup.find(text='Website:&nbsp;&nbsp;')
    WebV = Web.findNext('a', text=True)
    
    DisV = "NO"
    Dis = soup.find(text='Distance learning opportunities')
    DisV = soup.find(text='Distance learning opportunities')
    
    print '1'
    
    result = gmaps.geocode(Add)
    a = str(result)
    b = 21+ a.find('PostalCodeNumber')
    e =b + 5
    zipcode=a[b:e]
    
    print '2'
    
    br.open('http://quickfacts.census.gov/cgi-bin/qfd/lookup')
    br.select_form(nr=0)
    br.form['place'] = zipcode
    br.submit()
    br.follow_link(text_regex=re.compile("County"), nr=0)
    html = br.response().read()
    soup = BeautifulSoup(html)
    pp = soup.find(text=re.compile('Population, 2010'))
    pop = pp.next.next.next.next.next
    
    print '3'
    
    f = open('testit.tab','a')
    print >>f, Nam,'\t', usnews,'\t',zipcode,'\t', WebV,'\t', UEnV,'\t', GEnV,'\t', DisV,'\t', YrV,'\t',pop
    f.close()
    sleep(5)

# start a tab delim file with var names
mydata = ['nces name', 'usnews name', 'goo zip', 'url', 'undergrad', 'grad',
          'online', 'founded','2010 county pop']
myfile = open('testit.tab', 'w')
for line in mydata:
    myfile.write(line + '\t')

myfile.write('\n')
myfile.close()






#u = ['Auburn University', 'Florida State University', 'Georgia Southern University', 'Georgia State University', 'North Carolina State University', 'University of North Carolina Pembroke',  'University of North Carolina Charlotte', 'University of North Carolina Chapel Hill', 'University of North Carolina Greensboro',  'University of Mass Amherst', 'University of Mass Boston', 'University of Mass Lowell', 'University of Memphis','University of Missouri', 'Columbia University in the City of New York','University of New Hampshire', 'University of South Carolina', 'University of South Florida', 'University of Tenn  Chattanooga',   'University of West Florida', ]


u = ['Auburn University','Florida State University']

for line in u:
    aok1(line)

os.system("emacs testit.tab")









## SKIP, just do API for now; basic web scrapping  (just to show you some capabilities...)


# import urllib
# urllib.urlretrieve ('http://aok.us.to/class/data/goog.csv', 'goog.csv')

# from pandas import *
# df = DataFrame.from_csv('goog.csv', index_col=None)
# df['item']
# item = df['item']
# item

# and there lots of other useful stuff like that, 
# but you can do it in R or stata; let's do something different



# got google stocks?
#http://finance.google.com/finance?q=GOOG

# view source, look for "real time"
# note that stock price is after class="pr"
# <span class="pr">
# <span id="ref_694653_l">645.39</span>
# </span>


>>>BUGredo the stuff below, doesnt work; also remmeber taht mechanize doesnt work at the lab!! 


### scraping teaser :) [TODO guess move to later! too muc for 1st day! in anything sth much easuier!]
#go to website:
#http://finance.google.com/finance?q=    
#and add at the end stock, say GOOG:
#http://finance.google.com/finance?q=GOOG    
# and view page source and search for price say '737.80' in source, probably get several, among them:
#<meta itemprop="price"
#        content="737.80" />
# and perhaps easier:
#<span id="ref_304466804484872_l">737.80</span>


>>>THIS IS BROKEN!!! move this to later scrapping and fix later

https://www.google.com/finance?q=GOOG

#now py way
symbol = 'GOOG'
base_url = 'http://finance.google.com/finance?q='
content = urllib.request.urlopen(base_url + symbol).read()

#let's try different matches
m = re.search(r'<span id="ref_304466804484872_l">', str(content))
m.group(1)

m = re.search(r'<span id="ref_304466804484872_l">(.*)</span>', content)
m.group(1)

m = re.search(r'<span class="pr">\n.*>(.*)span', content)
m.group(1)

m = re.search(r'<span class="pr">\n.*>(.*)</span', content)
m.group(1)

symbol = 'GOOG'
base_url = 'http://finance.google.com/finance?q='
content = urllib.urlopen(base_url + symbol).read()
m = re.search(r'<span class="pr">\n.*>(.*)</span', content)
print symbol + ': ' + m.group(1)


def get_quote(symbol):
    base_url = 'http://finance.google.com/finance?q='
    content = urllib.urlopen(base_url + symbol).read()
    m = re.search(r'<span class="pr">\n.*>(.*)</span', content)
    if m:
        quote = m.group(1)
    else:
        quote = 'no quote available for: ' + symbol
    return quote

get_quote('RUTGERS')
get_quote('GOOG')
get_quote('AMZN')


from mechanize import Browser
from BeautifulSoup import BeautifulSoup
import re
br = Browser()

url = "http://nces.ed.gov/collegenavigator/?q=rutgers-camden"
br.open(url)
br.follow_link(text_regex=re.compile("University"), nr=0)
html = br.response().read()
soup = BeautifulSoup(html)

UEn = soup.find(text='Undergraduate enrollment')
UEnV = UEn.findNext('th', text=True)

print UEn + ':' + UEnV



#but need to search for the title :(
http://www.imdb.com/title/tt2488496/












### RU local install 


## [GUESS dont need this anymore] mechanize and beautifulsoup

#
#mkdir ~/py_pkg
#cd ~/py_pkg
#wget http://pypi.python.org/packages/source/m/mechanize/mechanize-0.2.5.tar.gz
#tar xvzf mechanize-0.2.5.tar.gz
#cd mechanize-0.2.5
#python2.6 setup.py install --home=~/py_pkg
#
#cd ~/py_pkg
#wget http://www.crummy.com/software/BeautifulSoup/bs4/download/beautifulsoup4-4.1.3.tar.gz 
#tar xvzf beautifulsoup4-4.1.3.tar.gz
#cd beautifulsoup4-4.1.3
#python2.6 setup.py install --home=~/py_pkg
#
##in python
#import sys
#sys.path.append("~/py_pkg")
#
#import mechanize, BeautifulSoup
#
#
### install easy_install 
#
#mkdir ~/py_pkg
#cd ~/py_pkg
#export PYTHONPATH=${PYTHONPATH}:/home/ru/ao264/py_pkg/lib/python
#
#wget http://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c8.tar.gz#md5=0e9bbe1466f3ee29588cc09d3211a010
#tar xfvz setuptools-0.6c8.tar.gz
#cd setuptools-0.6c8
#python setup.py build
#python setup.py install  --home=~/py_pkg
#
#/home/ru/ao264/py_pkg/bin/easy_install --install-dir=/home/ru/ao264/py_pkg  https://github.com/slimkrazy/python-google-places/zipball/master
#
#


##------------------------------UTD apache python modules install------------------
#wget http://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c8.tar.gz#md5=0e9bbe1466f3ee29588cc09d3211a010
#tar xfvz setuptools-0.6c8.tar.gz
#cd setuptools-0.6c8
#python setup.py build
#mkdir     /home/malthus/ajo021000/lib/
#mkdir     /home/malthus/ajo021000/lib/python/
#export PYTHONPATH=${PYTHONPATH}:/home/malthus/ajo021000/lib/python/
#
#python setup.py install  --home=~
#
## now insall with easy_install
#easy_install --install-dir=/home/malthus/ajo021000/lib/python/  mechanize






# wget http://pypi.python.org/packages/source/p/pip/pip-1.1.tar.gz#md5=62a9f08dd5dc69d76734568a6c040508
# tar xvzf pip-1.1.tar.gz
# cd pip-1.1
# python setup.py install  --home=~

# #now can install stuff with pip
# pip install mechanize


# import sys
# sys.path.append("/home/me/mypy")



#-------------------------------scrap------------------------------------------
import urllib
urllib.urlretrieve ('http://aok.us.to/class/data_mgmt/gss.csv', 'gss.csv')

df = DataFrame.from_csv('gss.csv', index_col=None)
print df.ix[:5, :10].to_string()  #first 5 rows of data; upto 10 vars


