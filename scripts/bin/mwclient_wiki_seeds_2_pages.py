# -*- codinwig: utf-8 -*-
"""
MediaWiki seed expander
Fred Zimmerman
wfzimmerman#gmail.com

expands search seeds to exact MediaWiki page title

converted to use mwclient library and enhanced to allow pointing at any 
MediaWiki endpoint URL

three variables specify the endpoint URL
--mediawiki_api_url "en.wikipedia.org" (no http)
--url_prefix "http" or "https"
--wikipath "/w/" is default -- path to API endpoint configured on Mediawiki server 

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
print_wiki_tuple= "wiki_tuple value is{}".format(wiki_tuple)
print(print_wiki_tuple)

wikipath = args.wikipath
site = mwclient.Site(wiki_tuple, path=wikipath)
print(site)
file = open(input_file, 'r').read().splitlines()
#file2 = open(output_file, 'w')

with open(output_file, 'a+') as f2:
    with open(input_file, 'r') as f1:
        for line in f1:
            print('seed is ' + line)
            hits = site.search(line)
            print(*hits, file=open(output_file, "w+"))
        f1.close()
    f2.close()
   
