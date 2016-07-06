# -*- coding: utf-8 -*-
"""
Created on Mon Jun 22 11:16:16 2015

@author: fred
"""
import csv
import sys

f = sys.argv[1]
uuid = sys.argv[2]
tmpdir="/tmp/pagekicker/"
folder = tmpdir+uuid
# os.mkdir(folder)

destination3 = folder + '/csv/row.booktitle'
destination1 = folder + '/csv/row.editedby'
destination4 = folder + '/csv/row.seeds'
destination5 = folder + '/csv/row.imprint'
f = open(f, 'rb')
f1 = open(destination1, 'w')
f3 = open(destination3, 'w')
f4 = open(destination4, 'w')
f5 = open(destination5, 'w')

try:
    reader = csv.reader(f)  # creates the reader object
    for row in reader:   # iterates the rows of the file in orders
        editedby = row[0]
        booktitle = row[2]
        print row[2]
        seeds = row[3]
        imprint = row[4]
        f1.write(editedby)
        f3.write(booktitle)
        f4.write(seeds)
        f5.write(imprint)
        
finally:
    f.close()      # closing
    f1.close()
    f3.close()
    f4.close()
    f5.close()