# pyPdf available at http://pybrary.net/pyPdf/
from pyPdf import PdfFileWriter, PdfFileReader
import os

for fileName in os.listdir('.'):
    try:
        if fileName.lower()[-3:] != "pdf": continue
        input1 = PdfFileReader(file(fileName, "rb"))
   
        # print the title of document1.pdf
        print('##1', fileName, '##2', input1.getDocumentInfo().title)
    except:
        print('##1', fileName, '##2')
