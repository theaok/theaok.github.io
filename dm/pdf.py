import os 
wd = 'C:\\Users\\ref\\Desktop\\junk' # may need to ADJUST
os.makedirs(wd)
os.getcwd() 
os.chdir(wd)
os.getcwd() 
os.listdir()


#first get pdf docs


import urllib.request

aok='https://sites.google.com/site/adamokuliczkozaryn/docs/okulicz_kozaryn_cv.pdf?attredirects=0'

pj='http://www.caldercenter.org/sites/default/files/Jargowsky%20CV.pdf'

urllib.request.urlretrieve(aok, "aok.pdf")
urllib.request.urlretrieve(pj, "pj.pdf")
#file = urllib.request.urlopen(url).read() #opens file


# SKIP: depreciated, was py2: see PyPDF2 below for py3
# ####  practical stuff


# ## rotate pdf pages

# ** splitting

# #first split into pieces: gs -sDEVICE=pdfwrite -dSAFER -o outname.%d.pdf altemeyer\ The\ Other\ Authoritarian\ Personality.pdf

# ** rotating; find someting newer

# #http://unix.stackexchange.com/questions/18603/rotate-pdf-pages-90-degree-for-even-pages-and-90-degree-for-odd-pages
# #https://www.binpress.com/tutorial/manipulating-pdfs-with-python/167
# python2
# import os
# from pyPdf import PdfFileWriter, PdfFileReader

# file='outname.22.pdf'

# input = PdfFileReader(open(file, 'rb'))
# output = PdfFileWriter()
# for i in range(0,input.getNumPages()): #looping as in original, but here just 1p
#     output.addPage(input.getPage(i).rotateClockwise(180 if i%2==0 else -180))

# with open('newfile.pdf', 'wb') as f:
#     output.write(f)

# os.rename('newfile.pdf', file)

# ** merging

# #for some reason doesnt work!
# #gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=finished.pdf outname*


# #http://stackoverflow.com/questions/3444645/merge-pdf-files

# def append_pdf(input,output):
#     [output.addPage(input.getPage(page_num)) for page_num in range(input.numPages)]

# output = PdfFileWriter()

# for i in range(1,23):
#     print i
#     ff="outname."+str(i)+".pdf"
#     append_pdf(PdfFileReader(file(ff,"rb")),output)

# output.write(file("CombinedPages.pdf","wb"))




#### note that can also do docx https://automatetheboringstuff.com/chapter13/


#### note that can do quite a bit with excel https://automatetheboringstuff.com/chapter12/


#### extracting info from pdf
'''
tools specifically for  cv: https://github.com/Impactstory/cv-parser
and more: https://www.google.com/search?q=python+parse+cv&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a
'''



### PyPDF2
'''
can do much more, powerful!!: decrypt, add pages, merge pdf, etc https://automatetheboringstuff.com/chapter13/
'''

import PyPDF2
pdfFileObj = open('aok.pdf', 'rb')
pdfReader = PyPDF2.PdfFileReader(pdfFileObj)
pdfReader.numPages

pageObj = pdfReader.getPage(0)
pageObj

pageObj.extractText()




###pdfminer
'''
and an example here:
http://zevross.com/blog/2014/04/09/extracting-tabular-data-from-a-pdf-an-example-using-python-and-regular-expressions/

and detailed description of pdfminer:
http://www.unixuser.org/~euske/python/pdfminer/index.html

some description here
https://www.binpress.com/tutorial/manipulating-pdfs-with-python/167

http://davidmburke.com/2014/02/04/python-convert-documents-doc-docx-odt-pdf-to-plain-text-without-libreoffice/

https://quantcorner.wordpress.com/2014/03/16/parsing-pdf-files-with-python-and-pdfminer/
'''

##PY 2

# from subprocess import Popen, PIPE
# #from docx import opendocx, getdocumenttext
# #http://stackoverflow.com/questions/5725278/python-help-using-pdfminer-as-a-library
# from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
# from pdfminer.converter import TextConverter
# from pdfminer.layout import LAParams
# from pdfminer.pdfpage import PDFPage

# from io import StringIO

# def convert_pdf_to_txt(path):
#     rsrcmgr = PDFResourceManager()
#     retstr = StringIO()
#     codec = 'utf-8'
#     laparams = LAParams()
#     device = TextConverter(rsrcmgr, retstr, codec=codec, laparams=laparams)
#     fp = open(path, 'rb')
#     interpreter = PDFPageInterpreter(rsrcmgr, device)
#     password = ""
#     maxpages = 0
#     caching = True
#     pagenos=set()
#     for page in PDFPage.get_pages(fp, pagenos, maxpages=maxpages, password=password,caching=caching, check_extractable=True):
#         interpreter.process_page(page)
#     fp.close()
#     device.close()
#     str = retstr.getvalue()
#     retstr.close()
#     return str


# # text=convert_pdf_to_txt('cv.pdf')


# # import codecs
# # with codecs.open('myfile.txt','w',encoding='utf8') as f:
# #     f.write(text)
# import io
# with io.open('myfile.txt','w',encoding='utf8') as f:
#     f.write(text)



from pdfminer.pdfparser import PDFParser, PDFDocument
from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
from pdfminer.converter import PDFPageAggregator
from pdfminer.layout import LAParams, LTTextBox, LTTextLine

fp = open('pj.pdf', 'rb')
parser = PDFParser(fp)
doc = PDFDocument()
parser.set_document(doc)
doc.set_parser(parser)
doc.initialize('')
rsrcmgr = PDFResourceManager()
laparams = LAParams()
device = PDFPageAggregator(rsrcmgr, laparams=laparams)
interpreter = PDFPageInterpreter(rsrcmgr, device)
# Process each page contained in the document.
for page in doc.get_pages():
    interpreter.process_page(page)
    layout = device.get_result()
    for lt_obj in layout:
        if isinstance(lt_obj, LTTextBox) or isinstance(lt_obj, LTTextLine):
            print(lt_obj.get_text())





### pdfquery; SKIP: buggy at least for CVs, cannot do anything useful there; on the other hand should be pretty fancy


# #https://pypi.python.org/pypi/pdfquery
# #can be used to find text in specific place in pdf or below etc specific other text
# import pdfquery

# pdf = pdfquery.PDFQuery("cv.pdf")

# pdf.load()
# pdf.get_layout(1)



### perhaps best just use libreoffice to open pdf
