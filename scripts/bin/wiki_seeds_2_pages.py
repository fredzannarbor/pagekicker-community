# -*- codinwig: utf-8 -*-
"""
wikipedia text fetcher
Fred Zimmerman
fred@pagekicker.com
(c) PageKicker 2014

"""

import argparse
import codecs
import sys
import time
import wikipedia

parser = argparse.ArgumentParser()
parser.add_argument("--infile", help = "seed file", default = 'test')
parser.add_argument("--lang", help="wiki language bigram", default = 'en')
parser.add_argument("--request_type", help="request type", default = 'sum')
parser.add_argument("--outfile", help = "path to outfile", default = 'outfile')
parser.add_argument("--summary", help = "true or false", action = "store_true")
parser.add_argument("--pagehits", help = "path to list of page hits", default = 'pagehits')
parser.add_argument("--mediawiki_api_url", help = "true or false", default = 'http://en.wikipedia.org/w/api.php')
args = parser.parse_args()

input_file = args.infile
output_file = args.outfile
pagehits = args.pagehits
lang = args.lang
summary = args.summary
request_type = args.request_type
mediawiki_api_url = args.mediawiki_api_url
wikipedia.set_lang(lang)

test = 'mw url is ' + mediawiki_api_url
print(test)

file1 = open(input_file, 'r')
file3 = codecs.open(pagehits,'w','utf-8')
for line in file1:
    print(line)
    try:
        seedhits = wikipedia.search(line)

    except:
        wikipedia.exceptions.DisambiguationError
        wikipedia.exceptions.WikipediaException
        continue

    for i in seedhits:
        file3.write(i+'\n')
    file3.close
