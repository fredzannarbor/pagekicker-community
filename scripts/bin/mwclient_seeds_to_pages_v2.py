# -*- coding: utf-8 -*-
"""
wapackpedia text fetcher
Fred Zimmerman
wfzimmerman#gmail.com

converted to use mwclient library and enhanced to allow pointing at any 
MediaWiki endpoint URL

three variables specify the endpoint URL
--mediawiki_api_url "en.wikipedia.org" (no http)
--url_prefix "http" or "https"
--wikipath "/w/" is default -- path to API endpoint configured on Mediawiki server 

mwclient_seeds_to_pages.py is responsible for providing 
exact page names to infile page names must be exact, i.e. are case 
and punctuation sensitive

"""

import logging
import argparse
import mwclient
from collections import OrderedDict


logging.basicConfig(level=logging.WARNING)

parser = argparse.ArgumentParser()
parser.add_argument("--infile", help = "seed file", default = 'test')
parser.add_argument("--lang", help="wiki language bigram", default = 'en')
parser.add_argument("--request_type", help="request type", default = 'sum')
parser.add_argument("--outfile", help = "path to outfile", default = 'outfile')
parser.add_argument("--summary", help = "true or false", action = "store_false")
parser.add_argument("--logging", help = "true or false", action = "store_true")
parser.add_argument("--mediawiki_api_url", help = "true or false", default = 'en.wikipedia.org')
parser.add_argument("--url_prefix", help = "default wiki ssl value is https", default = 'https')
parser.add_argument("--wikipath", help = "mediawiki default is /w/api.php", default = '/w/')
parser.add_argument("--cats_file", help = "path to outfile", default = 'cats')
parser.add_argument("--extlinks_file", help = "path to save extlinks file", default = 'extlinks')

args = parser.parse_args()

input_file = args.infile
output_file = args.outfile
print('output_file is ')
print(output_file)
cats_file = args.cats_file
extlinks_file = args.extlinks_file
lang = args.lang
summary = args.summary
logging = args.logging
mediawiki_api_url = args.mediawiki_api_url
url_prefix = args.url_prefix
wiki_tuple = (url_prefix, mediawiki_api_url)
printline = "wiki_tuple value is{}".format(wiki_tuple)
print(printline)

def recursive_items(dictionary):
    for key, value in dictionary.items():
        if type(value) is OrderedDict:
            #print('match')
            yield from recursive_items(value)
        else:
            #print('no match')
            yield (key, value)

wikipath = args.wikipath
site = mwclient.Site(wiki_tuple, path=wikipath)
print(site)
file1 = open(input_file, 'r').read().splitlines()

for line in file1:
    try:
        #print('seed is ' + line)
        page = site.pages[line]
        d = site.api('query', generator='search', gsrsearch=line)
        #print(d)
        for key, value in recursive_items(d):
            if 'title' in key:
                print(value, file=open(output_file, 'a'))
        #pagetitle_list = page.pagetitle()
        #print(*pagetitle_list, sep='\n', file=open(output_file, "w"))
    except:
        mwclient.errors.InvalidPageTitle
        continue


