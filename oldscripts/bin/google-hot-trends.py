#! /usr/bin/env python

from BeautifulSoup import BeautifulSoup
import urllib.request, urllib.error, urllib.parse,re

cont=urllib.request.urlopen('http://www.google.com/trends/hottrends?sa=X')
#use google.co.in for india searches

soup = BeautifulSoup(cont)

col= soup.findAll('a',href=re.compile('.+sa=X'))

for x in col:
    print(x.string)
