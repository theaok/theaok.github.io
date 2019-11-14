import os 
wd = 'C:\\Users\\ref\\Desktop\\junk' # may need to ADJUST
os.makedirs(wd)
os.getcwd() 
os.chdir(wd)
os.getcwd() 
os.listdir()

import re


'''
https://automatetheboringstuff.com/chapter7/     

http://code.google.com/edu/languages/google-python-class/regular-expressions.html

regexp are vey similar in stata

the power of regexp: they can specify patterns, not just fixed characters
a, X, 9, < -- ordinary characters: match themselves exactly.

The meta-characters: do  not match themselves , they have special
meanings:

. (a period) matches any single character except newline '\n'
\w  matches a "word" character: a letter or digit or underbar [a-zA-Z0-9_]
\W (upper case W) matches any non-word character.
\b boundary between word and non-word
\s  matches a single whitespace character:space, newline, return, tab, form [ \n\r\t\f]
\S (upper case S) matches any non-whitespace character.
\t, \n, \r  tab, newline, return
\d  digit [0-9]

^  start, $  end -- match the start or end of the string

\ -- inhibit the "specialness" of a character.
So, for example, use \. to match a period or \\ to match a slash.
If you are unsure if a character has special meaning, such as '@',
you can put a slash in front of it, \@,
to make sure it is treated just as a character 

* zero or more
+ one or more

'''


## Search for pattern 'iii' in string 'piiig'.
  ## All of the pattern must match, but it may appear anywhere.
  ## On success, match.group() is matched text.
re.search(r'iii', 'piiig').group()
re.search(r'igs', 'piiig').group()

## . = any char but \n
re.search(r'..g', 'piiig').group() 

## \d = digit char, \w = word char
re.search(r'\d\d\d', 'p123g').group() 
re.search(r'\w\w\w', '@@abcd!!').group() 

## i+ = one or more i's, as many as possible.
re.search(r'pi+', 'piiig').group() 

## Finds the first/leftmost solution, and within it drives the +
## as far as possible (aka 'leftmost and largest').
## In this example, note that it does not get to the second set of i's.
re.search(r'i+', 'piigiiii').group() 

## \s* = zero or more whitespace chars
## Here look for 3 digits, possibly separated by whitespace.
re.search(r'\d\s*\d\s*\d', 'xx1 2   3xx').group() 

re.search(r'\d\s*\d\s*\d', 'xx12  3xx').group()

re.search(r'\d\s*\d\s*\d', 'xx123xx').group()

## ^ = matches the start of string, so this fails:
re.search(r'^b\w+', 'foobar').group()
## but without the ^ it succeeds:
re.search(r'b\w+', 'foobar').group()

str = 'purple alice-b@google.com monkey dishwasher'
re.search(r'\w+@\w+', str).group()

re.search(r'[\w-]+@[\w\.]+', str).group()

match = re.search('([\w-]+)@([\w.]+)', str)
match.group()   ## 'alice-b@google.com' (the whole match)
match.group(1)  ## 'alice-b' (the username, group 1)
match.group(2)  ## 'google.com' (the host, group 2)

## Suppose we have a text with many email addresses
str = 'purple alice@google.com, blah monkey bob@abc.com blah dishwasher'

## Here re.findall() returns a list of all the found email strings
re.findall(r'[\w-]+@[\w\.]+', str) ## ['alice@google.com', 'bob@abc.com']
re.findall(r'([\w-]+)@([\w\.]+)', str)

## SKIP: Rutgers people do not use bib here; bibtex parsing example


# import urllib
# import sys
# import  re

# # my bibtex file has 600 entries -- to make sense of it you need to
# # parse it; yes you can use 3rd party sofware to do that, but how
# # about flexibility and customizing it -- there is no software to do
# # exactly what you want -- you need to write on your own; and it's so
# # easy in Python

# #fOpen = open('/home/aok/desk/papers/root/tex/ebib.bib','r')
# #fOpen = open('/home/aok/desk/py/dat/bib.bib','r')
# urllib.urlretrieve ('http://aok.us.to/class/data/bib.bib', 'bib.bib')
# fOpen = open('bib.bib','r')

# bib = fOpen.read()
# fOpen.close()



# #FIXME make sure that every article has keywords --count/len or something!!!
# b = re.findall(r'@.*{(.*),',bib)
# k = re.findall(r'.*keywords.*{(.*)}',bib)
# #FIXME as of now titles and everything else has to be one line...
# t = re.findall(r'.*title.*{(.*)}',bib)
# b
# k
# bk = dict(zip(b,k))
# bt = dict(zip(b,t))

# # def p_a(d):
# #     for k in d:
# #         my_string = d[k]
# #         spl = [x.strip() for x in my_string.split(',')]
# #         for i in spl:
# #             print i
# #         print '-----' 


# def sk(d,v):
#     for k in d:
#         my_string = d[k]
#         spl = [x.strip() for x in my_string.split(',')]
#         for i in spl:
#             if i == v:
#                 print k

# #later: instead of printing, better return a _list_, NOT a value like here:
# # def reverse_lookup(d, v):
# #     for k in d:
# #         if d[k] == v:
# #             return k
# #     raise ValueError
# # so that it can be matched wit titles dictionary etc...

# sk(bk,'US')
# sk(bk,'welf')
