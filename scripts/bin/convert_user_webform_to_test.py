# -*- coding: utf-8 -*-
"""
Created on Mon Jun 22 11:16:16 2015

@author: fred

Converts webform xml file submitted by user to anonymized format suitable 
for testing
"""

import fileinput
import re
import os

scriptpath_substitution = '<scriptpath>' + os.getcwd() + '</scriptpath>'
 
for line in fileinput.input():
    line = re.sub('<customer_email>.*</customer_email>','<customer_email>wfzimmerman@gmail.com</customer_email>', line.rstrip())
    line = re.sub('<scriptpath>.*</scriptpath>', scriptpath_substitution, line.rstrip())
    print(line)