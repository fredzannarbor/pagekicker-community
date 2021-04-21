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
parser.add_argument("--cats_file", help = "path to outfile", default = 'cats')
parser.add_argument("--extlinks_file", help = "path to outfile", default = 'extlinks')
parser.add_argument("--images_file", help = "path to outfile", default = 'images')
parser.add_argument("--backlinks_file", help = "path to outfile", default = 'backlinks')


args = parser.parse_args()

input_file = args.infile
output_file = args.outfile
cats_file = args.cats_file
extlinks_file = args.extlinks_file
backlinks_file = args.backlinks_file
images_file = args.images_file
lang = args.lang
summary = args.summary
logging = args.logging
mediawiki_api_url = args.mediawiki_api_url
url_prefix = args.url_prefix

wikipath = args.wikipath
site = mwclient.Site('en.wikipedia.org', scheme='https')
print('site is', site)
file1 = open(input_file, 'r').read().splitlines()
"""
file2 = open(output_file, 'w')
file3 = open(cats_file, 'w')
file4 = open(extlinks_file, 'w')
file5 = open(backlinks_file, 'w')
file6 = open(images_file, 'w') 
"""
for line in file1:
    try:

        page = site.pages[line]
        print('fetching page', page)
        text = page.text()
        print(text, sep='\n', file=open(output_file, "w"))
        cats = page.categories()
        print(ecats, sep='\n', file=open(extlinks_file, "w"))
        

        extlinks = page.extlinks()

        print(extlinks, sep='\n', file=open(extlinks_file, "w"))
        backlinks = page.backlinks()
        print(backlinks, sep='\n', file=open(backlinks_file, "w"))
        images = page.images()
        print(images, sep='\n', file=open(images_file, "w"))
    except:
        mwclient.errors.InvalidPageTitle
        continue
    file2.write('\n')
    file2.write('\n')
    file2.write('# ' )
    file2.write(str(line))
    file2.write('\n')
    file2.write(str(text))
    
    file3.write('\n')
    file3.write('\n')
    file3.write('# ' )
    file3.write(line)
    file3.write('\n')
    file3.write(str(cats))
    
    file4.write('\n')
    file4.write('\n')
    file4.write('# ' )
    file4.write(line)
    file4.write('\n')
    file4.write(str(extlinks))

    file5.write('\n')
    file5.write('\n')
    file5.write('# ' )
    file5.write(line)
    file5.write('\n')
    file5.write(str(backlinks))

    file6.write('\n')
    file6.write('\n')
    file6.write('# ' )
    file6.write(line)
    file6.write('\n')
    file6.write(str(images))
   
file2.close
file3.close
file4.close
file5.close
file6.close
