# -*- codinwig: utf-8 -*-
"""
wikipedia text fetcher
Fred Zimmerman
fred@pagekicker.com
(c) PageKicker 2014

This temporary script file is located here:
/home/fred/.spyder2/.temp.py
"""

import argparse, wikipedia

parser = argparse.ArgumentParser()
parser.add_argument("--infile", help = "seed file", default = 'test')
parser.add_argument("--lang", help="wiki language bigram", default = 'en')
#parser.add_argument("--request_type", help="request type", default = 'sum')
parser.add_argument("--outfile", help = "path to outfile", default = 'outfile')
parser.add_argument("--summary", help = "true or false", action = "store_true")
args = parser.parse_args()

input_file = args.infile
output_file = args.outfile
lang = args.lang
summary = args.summary
# request_type = args.request_type
wikipedia.set_lang(lang)

file = open(input_file, 'r')
file2 = open(output_file, 'w')
for line in file:
    print  line,
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
    file2.write('\n')
    print a.encode('utf-8')
    # print b.encode('utf-8')
    file2.write('\n')
    file2.write('# ' )
    file2.write(line)
    file2.write('\n')
    file2.write(a.encode('utf-8'))
file2.close
