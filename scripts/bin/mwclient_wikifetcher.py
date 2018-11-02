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

args = parser.parse_args()

input_file = args.infile
output_file = args.outfile
lang = args.lang
summary = args.summary
logging = args.logging
mediawiki_api_url = args.mediawiki_api_url
url_prefix = args.url_prefix
wiki_tuple = (url_prefix, mediawiki_api_url)
printline = "wiki_tuple value is{}".format(wiki_tuple)
print(printline)

wikipath = args.wikipath
site = mwclient.Site(wiki_tuple, path=wikipath)
print(site)
file = open(input_file, 'r').read().splitlines()
file2 = open(output_file, 'wb')
for line in file:
    try:
        print('seed is ' + line)
        page = site.pages[line]
        print(page)
        text = page.text()
        print(text)
    except:
        mwclient.errors.InvalidPageTitle
        continue
    file2.write(b'\n')
    print(text.encode('utf-8'))
    file2.write(b'\n')
    file2.write(b'# ' )
    file2.write(line.encode('utf-8'))
    file2.write(b'\n')
    file2.write(text.encode('utf-8'))
file2.close
