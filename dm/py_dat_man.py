





#TODO see some of the py books i have


#### older stuff: TODO: reoragnize


#LATER may make these into defs...

#TODO just use urllib, not urllib2 or urlib3!!
req = urllib2.urlopen('http://sites.google.com/site/adamokuliczkozaryn/gis_int/bounds_nj_shp.zip')
local_file = open(directory + 'b.zip', 'wb')
local_file.write(req.read())
local_file.close()

zf = zipfile.ZipFile(directory + 'b.zip')
for member in zf.infolist():
    zf.extract(member,directory)


req = urllib2.urlopen('http://sites.google.com/site/adamokuliczkozaryn/gis_int/all_homes.csv')
local_file = open(directory + 'all_homes.csv', 'w')
local_file.write(req.read())
local_file.close()

reader = csv.reader(open(directory + 'all_homes.csv'), delimiter=',', quotechar='"')
reg_data = {row[0]: row[2] for row in reader} # BUG on apps
reg_data = dict([(row[0], row[2]) for row in reader]) 
w
# better yet, more general:
reader = csv.reader(open(directory + 'all_homes.csv'), delimiter=',', quotechar='"')
reg_data = [tuple(row) for row in reader]
for i in reg_data:
    print i

# or the best i guess:
reader = csv.reader(open(directory + 'all_homes.csv'), delimiter=',', quotechar='"')
reg_data = dict([(row[0], row) for row in reader]) 


#TODO
#see ~/papers/qol_us_counties/qol_us_counties.py

#http://www.countyhealthrankings.org/rankings/data
#http://www.countyhealthrankings.org/sites/default/files/2010%20County%20Health%20Rankings%20National%20Data.xls




#TODO move this to graphs!!!


# Random test data
np.random.seed(123)
all_data = [np.random.normal(0, std, 100) for std in range(1, 4)]

fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12, 5))

# rectangular box plot
bplot1 = axes[0].boxplot(all_data,
                         vert=True,   # vertical box aligmnent
                         patch_artist=True)   # fill with color

# notch shape box plot
bplot2 = axes[1].boxplot(all_data,
                         notch=True,  # notch shape
                         vert=True,   # vertical box aligmnent
                         patch_artist=True)   # fill with color

# fill with colors
colors = ['pink', 'lightblue', 'lightgreen']
for bplot in (bplot1, bplot2):
    for patch, color in zip(bplot['boxes'], colors):
        patch.set_facecolor(color)

# adding horizontal grid lines
for ax in axes:
    ax.yaxis.grid(True)
    ax.set_xticks([y+1 for y in range(len(all_data))], )
    ax.set_xlabel('xlabel')
    ax.set_ylabel('ylabel')

# add x-tick labels
plt.setp(axes, xticks=[y+1 for y in range(len(all_data))],
         xticklabels=['x1', 'x2', 'x3', 'x4'])

plt.show()
