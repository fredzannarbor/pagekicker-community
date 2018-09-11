# -*- coding: utf-8 -*-
"""
wikipedia text fetcher
Fred Zimmerman
wfzimmerman#gmail.com

enhanced to allow pointing at any MediaWiki endpoint URL


"""

import argparse, wikipedia

parser = argparse.ArgumentParser()
parser.add_argument("--infile", help = "seed file", default = 'test')
parser.add_argument("--lang", help="wiki language bigram", default = 'en')
#parser.add_argument("--request_type", help="request type", default = 'sum')
parser.add_argument("--outfile", help = "path to outfile", default = 'outfile')
parser.add_argument("--summary", help = "true or false", action = "store_true")
parser.add_argument("--mediawiki_api_url", help = "true or false", default = 'http://en.wikipedia.org/w/api.php')
args = parser.parse_args()

input_file = args.infile
output_file = args.outfile
lang = args.lang
summary = args.summary
mediawiki_api_url = args.mediawiki_api_url

test = 'mw url is ' + 'mediawiki_api_url'
print(test)

# request_type = args.request_type
wikipedia.set_lang(lang)

file = open(input_file, 'r')
file2 = open(output_file, 'wb')
for line in file:
    #print(line),
    try:
        a = wikipedia.summary(line)
        a = wikipedia.page(line)
        if args.summary:
            a = a.summary
        else:
            a = a.content
    except:
        wikipedia.exceptions.DisambiguationError
        wikipedia.exceptions.WikipediaException
        continue

    file2.write(b'\n')
    # print(a.encode('utf-8'))
    file2.write(b'\n')
    file2.write(b'# ' )
    file2.write(line.encode('utf-8'))
    file2.write(b'\n')
    file2.write(a.encode('utf-8'))
file2.close
