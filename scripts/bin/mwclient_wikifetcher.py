# -*- coding: utf-8 -*-
"""
wikipedia text fetcher
Fred Zimmerman
wfzimmerman#gmail.com

converted to use mwclient libtary
enhanced to allow pointing at any MediaWiki endpoint URL

fetches MW pages specified in --infile
mwclient_seeds_to_pages.py is responsible for providing exact page names to infile
page names must be exact, i.e. are case and punctuation sensitive

"""

import logging
import argparse
import mwclient
from mwclient.errors import APIError, InvalidPageTitle
import time

logging.basicConfig(level=logging.WARNING)

parser = argparse.ArgumentParser()
parser.add_argument("--infile", help = "seed file", default = 'test')
parser.add_argument("--lang", help="wiki language bigram", default = 'en')
#parser.add_argument("--request_type", help="request type", default = 'sum')
parser.add_argument("--outfile", help = "path to outfile", default = 'outfile')
parser.add_argument("--summary", help = "true or false", action = "store_true")
parser.add_argument("--logging", help = "true or false", action = "store_true")
parser.add_argument("--mediawiki_api_url", help = "true or false", default = 'http://en.wikipedia.org/w/api.php')
parser.add_argument("--client_certificate", help = "path to SSL certificate", default = None)
args = parser.parse_args()

input_file = args.infile
output_file = args.outfile
lang = args.lang
summary = args.summary
logging = args.logging
mediawiki_api_url = args.mediawiki_api_url
client_certificate = args.client_certificate
print(client_certificate)

if client_certificate is None:
    site = mwclient.Site(mediawiki_api_url)
    print(site)
else:
    site = mwclient.Site(mediawiki_api_url, client_certificate=(client_certificate))
    print(site)

file = open(input_file, 'r').read().splitlines()
file2 = open(output_file, 'wb')
for line in file:
    try:
        print(line)
        page = site.pages[line]
        print(page)
        text = page.text()
        print(text)
    # print(text)
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
