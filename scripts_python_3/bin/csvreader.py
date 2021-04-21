# reads rows of csv one at a time 
# code by @martineau 
# http://stackoverflow.com/questions/38489761/how-can-i-select-only-a-particular-row-in-a-csv-file

import csv
from contextlib import contextmanager
import sys
import itertools
import os

@contextmanager
def multi_file_manager(files, mode='w'):
    """ Context manager for multiple files. """
    files = [open(file, mode) for file in files]
    yield files
    for file in files:
        file.close()

def csv_read_row(filename, n):
    """ Read and return nth row of a csv file, counting from 1. """
    with open(filename, 'r') as f:
        reader = csv.reader(f)
        return next(itertools.islice(reader, n-1, n))

if len(sys.argv) != 4:
    print('usage: utility <csv filename> <uuid> <target row>')
    sys.exit(1)

tmpdir = "/tmp/pagekicker"
f = sys.argv[1]
uuid = sys.argv[2]
target_row = int(sys.argv[3])
folder = os.path.join(tmpdir, uuid)


destinations= [folder+dest for dest in ('/csv/row.editedby', 
'/csv/row.booktitle', 
'/csv/row.seeds', 
'/csv/row.imprint', '/csv/row.add_this_content')]

with multi_file_manager(destinations, mode='w') as files:
    row = csv_read_row(f, target_row)
    #editedby, booktitle, seeds, imprint = row[0], row[2], row[3], row[4]
    for i,j in zip(list(range(5)), (0, 2, 3, 4, 5)):
        files[i].write(row[j]+'\n')
