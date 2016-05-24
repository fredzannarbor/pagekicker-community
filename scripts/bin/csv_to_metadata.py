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
destination1 = folder + '/csv/row.catid'
destination4 = folder + '/csv/row.seeds'
destination5 = folder + '/csv/row.seeds'
destination6 = folder + '/csv/row.seeds'
destination7 = folder + '/csv/row.seeds'
destination8 = folder + '/csv/row.seeds'
f = open(f, 'rb')
f1 = open(destination1, 'w')
f3 = open(destination3, 'w')
f4 = open(destination4, 'w')
f5 = open(destination5, 'w')
f6 = open(destination6, 'w')
f7 = open(destination7, 'w')
f8 = open(destination8, 'w')


try:
    reader = csv.reader(f)  # creates the reader object
    for row in reader:   # iterates the rows of the file in orders
        catid = row[0]
        booktitle = row[2]
        print row[2]
        seeds = row[3]
        f1.write(catid)
        f3.write(booktitle)
        f4.write(seeds)
        
finally:
    f.close()      # closing
    f1.close()
    f3.close()
    f4.close()