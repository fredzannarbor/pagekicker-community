# -*- coding: utf-8 -*-
"""
Created on Mon Jun 22 11:16:16 2015

@author: fred
"""
import csv
import sys
import os
from subprocess import call


f = sys.argv[1]
uuid = sys.argv[2]
row_no = int(sys.argv[3])
tmpdir="/tmp/pagekicker/"
if not os.path.exists(tmpdir):
    os.makedirs(tmpdir)
folder = tmpdir+uuid
csvfolder = folder+'/csv/'
if not(os.path.exists(csvfolder)):
    os.makedirs(csvfolder)
destination1 = folder + '/csv/row.editedby'
#destination2 = folder + '/csv/row.price'
destination3 = folder + '/csv/row.description'
destination4 = folder + '/csv/row.product_name'
#destination5 = folder + '/csv/row.jobprofile'
destination6 = folder + '/csv/row.seeds'
destination7 = folder + '/csv/row.imprint'
#destination8 = folder + '/csv/row.catid'

#destination1 = 'row.editedby'
#destination2 = 'row.price'
#destination3 = 'row.description'
#destination4 = 'row.product_name'
#destination5 = 'row.jobprofile'
#destination6 = 'row.seeds'
#destination7 = 'row.imprint'
#destination8 = 'row.catid'

f = open(f, 'rb')
f1 = open(destination1, 'w')
#f2 = open(destination2, 'w')
f3 = open(destination3, 'w')
f4 = open(destination4, 'w')
#f5 = open(destination5, 'w')
f6 = open(destination6, 'w')
f7 = open(destination7, 'w')
#f8 = open (destination8, 'w')


reader = csv.reader(f)
# print row_no #debug
try:
        rows = list(reader)
        #print rows[row_no]
        #print rows[row_no]
        editedby = rows[row_no][0]
        #price = rows[row_no][1]
        description = rows[row_no][1]
        product_name = rows[row_no][2]
        #jobprofile = rows[row_no][4]
        seeds = rows[row_no][3]
        imprint = rows[row_no][4]
        #catid = rows[row_no][7]
        print(editedby)
        #print price
        print(description)
        print(product_name)
        #print jobprofile
        print(seeds)
        print(imprint)
       # print catid
        f1.write(editedby)
       # f2.write(price)
        f3.write(description)
        f4.write(product_name)
        #f5.write(jobprofile)
        f6.write(seeds)
        f7.write(imprint)
       # f8.write(catid)
        # call (["ls", "-l"])

finally:
    f.close()       
    f1.close()
    #f2.close()
    f3.close()
    f4.close()
    #f5.close()
    f6.close()
    f7.close()
   # f8.close()