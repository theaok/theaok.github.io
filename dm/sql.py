
'''SQL, super easy! 
just a bunch of statements like
SELECT something  FROM somewhere WHERE something is soemthing
below few examples; after this class you can put SQL and Databases on your LinkedIN

for elaboration eg see:
http://www.w3schools.com/sql/default.asp
'''


''' GENERAL PYTHON SQL IDEAS:
http://stackoverflow.com/questions/4960048/python-3-and-mysql 
https://wiki.openstack.org/wiki/PyMySQL_evaluation

#pip.main(['install', '--user', 'mysqlclient'])
geuss needs mysql instyalled OSError: mysql_config not found :(

#mysql-connector-python doesnt seem to install
 pip.main(['install', '--user', 'mysql-connector-python'])
 import mysql-connector-python
 looks like comprehensive commands for interacting:
 https://dev.mysql.com/doc/connector-python/en/connector-python-examples.html

also see http://www.thegeekstuff.com/2016/06/mysql-connector-python
and (for updating or changing values, which is very useful!):
http://www.thegeekstuff.com/2016/06/mysql-update-command

practice sql online
http://www.sqlfiddle.com/
http://sqlzoo.net/
http://www.sqlcourse.com/

and see venn diagrams for join/merge:
http://stackoverflow.com/questions/406294/left-join-and-left-outer-join-in-sql-server
'''

import pip
pip.main(['install',  'pymysql'])

import pandas as pd
import pymysql.cursors

# connection = pymysql.connect(host='192.168.30.20',
#                              user='root',
#                              password='',
#                              db='world',
#                              charset='utf8mb4',
#                              cursorclass=pymysql.cursors.DictCursor)







####################   db4free.net     #######################





#kind of slow! especially phpMyAdmin
#lets also get a visual at https://db4free.net/phpMyAdmin
#create connection
connection = pymysql.connect(host='db4free.net',
                             user='aok123',
                             password='superadam',
                             db='adam',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)


###ex 1 table of emails and users


#query to create a table 
sql='''
CREATE TABLE `users` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `email` varchar(255) COLLATE utf8_bin NOT NULL,
    `password` varchar(255) COLLATE utf8_bin NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin
AUTO_INCREMENT=1 ;
'''

#executre above query
with connection.cursor() as cursor:
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)

# Create a new record
with connection.cursor() as cursor:
    sql = "INSERT INTO `users` (`email`, `password`) VALUES ('webmaster@python.org', 'very-secret')"
    cursor.execute(sql)
    # connection is not autocommit by default. So you must commit to save
    # your changes.
    connection.commit()


# Read a  record
with connection.cursor() as cursor:
    sql = "SELECT `id`, `password` FROM `users` WHERE `email`='webmaster@python.org'"
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)


### ex2 accounting stuff

#create new table
sql='''
CREATE TABLE `accounting` ( 
Revenue varchar(255), 
Free varchar(255), 
Paid varchar(255), 
Game varchar(255), 
Price varchar(255), 
Revenue2 varchar(255), 
ARPU_Index varchar(255), 
Daily_New_Users varchar(255), 
Daily_Active_Users varchar(255), 
ARPU varchar(255), 
Rank_Change varchar(255))
'''

with connection.cursor() as cursor:
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)


# Create a new record
with connection.cursor() as cursor:
    sql = "INSERT INTO `accounting` (`Revenue`, `Price`) VALUES (120, 190)"
    cursor.execute(sql)
    # connection is not autocommit by default. So you must commit to save
    # your changes.
    connection.commit()


#ok, say we have a bunch of data like:
data=[
(120,190),
(123,193),
(121,191),
(125,195),
(128,198),
]

data

#loop to insert 
for i in data:
    print(i)

for i in data:
    sql= "INSERT INTO `accounting` (`Revenue`, `Price`) VALUES " + str(i)
    print(sql)

with connection.cursor() as cursor:
    for i in data:
        sql= "INSERT INTO `accounting` (`Revenue`, `Price`) VALUES " + str(i)
        cursor.execute(sql)
        # connection is not autocommit by default. So you must commit to save
        # your changes.
    
    connection.commit()


# Read all records
with connection.cursor() as cursor:
    sql = "SELECT * FROM `accounting`"
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)

#save these records

df=pd.DataFrame(result)    

df

df.to_stata('stata.dta')



'''LATER
can read straignt into pandas
http://pandas.pydata.org/pandas-docs/stable/generated/pandas.read_sql_query.html
pandas.read_sql_query
'''



####################   https://www.freemysqlhosting.net    #######################


'''
Server: sql5.freemysqlhosting.net
Name: sql5116393
Username: sql5116393
Password: PHqqCVCBWI
Port number: 3306
'''

#can get visual at http://www.phpmyadmin.co/

connection = pymysql.connect(host='sql5.freemysqlhosting.net',
                             user='sql5116393',
                             password='PHqqCVCBWI',
                             db='sql5116393',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)



#create new table
sql='''
CREATE TABLE `dat-man` ( 
name varchar(255), 
salary varchar(255)) 
'''

with connection.cursor() as cursor:
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)


# Create a new record
with connection.cursor() as cursor:
    sql = "INSERT INTO `dat-man` (`name`, `salary`) VALUES ('bob', 50)"
    cursor.execute(sql)
    # connection is not autocommit by default. So you must commit to save
    # your changes.
    connection.commit()

# fetch bob's salary
with connection.cursor() as cursor:
    sql = "SELECT `salary` FROM `dat-man` WHERE `name`='bob'"
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)


#ok, say we have a bunch of data like:
data=[
('adam',60),
('joe',190),
('hilary',700),
('donald',400),
('bernie',195),
('carly',290),
]

data

#loop to insert 
for i in data:
    print(i)

for i in data:
    sql= "INSERT INTO `dat-man` (`name`, `salary`) VALUES " + str(i)
    print(sql)

with connection.cursor() as cursor:
    for i in data:
        sql= "INSERT INTO `dat-man` (`name`, `salary`) VALUES " + str(i)
        cursor.execute(sql)
        # connection is not autocommit by default. So you must commit to save
        # your changes.
    
    connection.commit()


# Read all records
with connection.cursor() as cursor:
    sql = "SELECT * FROM `dat-man`"
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)


# Read middle class folks
with connection.cursor() as cursor:
    sql = "SELECT * FROM `dat-man` WHERE `salary` >100 AND `salary` <200"
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)

#save these records
df=pd.DataFrame(result)    
df







##################### SKIP THE FOLLOWING #####################
#### early ideas


scroll to the bottom--thereis about databases:
https://plot.ly/python/


#can practice queries online
#http://sqlzoo.net/wiki/SQLZOO:SELECT_basics

#this one guess have to download :(
#https://launchpad.net/test-db/

#looks like a good source of sample databases
https://www.quora.com/Is-there-a-site-for-online-SQL-practice

see at the bottom 
http://statapython.blogspot.com/2014/03/recipes.html

or i can strat one--guess on my old pc already there

MySQLdb looks difficult for install maybe dont use it


this looks really good--try to use as an example
http://demo.phpmyadmin.net/master-http/

and then can try 
http://stackoverflow.com/questions/10065051/python-pandas-and-databases-like-mysql
http://www.rmunn.com/sqlalchemy-tutorial/tutorial.html

http://stackoverflow.com/questions/29355674/how-to-connect-mysql-database-using-pythonsqlalchemy-remotely

http://docs.sqlalchemy.org/en/rel_1_0/core/engines.html

http://docs.sqlalchemy.org/en/latest/faq/connections.html

http://stackoverflow.com/questions/10770377/howto-create-db-mysql-with-sqlalchemy

import pandas.io.sql as psql
import MySQLdb as db
from pandas.io.sql import frame_query
import pandas as pd

#from sqlalchemy import *
#import sqlalchemy
from sqlalchemy import create_engine


db = create_engine('sqlite:///tutorial.db')

#https://www.phpmyadmin.net/try/
db = create_engine('root@192.168.30.20')
engine = create_engine('mysql://root@192.168.30.20')


engine = create_engine(
      "mysql://root:@192.168.30.23/db?host=localhost?port=3306")


still looks like it requires MySQLdb!


see also 
http://www.rmunn.com/sqlalchemy-tutorial/tutorial.html

root@192.168.30.20


#http://nbviewer.jupyter.org/urls/bitbucket.org/hrojas/learn-pandas/raw/master/lessons/09%20-%20Lesson.ipynb:

import pandas as pd
import sys
from sqlalchemy import create_engine, MetaData, Table, select


# Parameters
ServerName = "RepSer2"
Database = "BizIntel"
TableName = "DimDate"

# Create the connection
engine = create_engine('mssql+pyodbc://' + ServerName + '/' + Database)
conn = engine.connect()

# Required for querying tables
metadata = MetaData(conn)

# Table to query
tbl = Table(TableName, metadata, autoload=True, schema="dbo")
#tbl.create(checkfirst=True)

# Select all
sql = tbl.select()

# run sql code
result = conn.execute(sql)

# Insert to a dataframe
df = pd.DataFrame(data=list(result), columns=result.keys())

# Close connection
conn.close()

print('Done')

