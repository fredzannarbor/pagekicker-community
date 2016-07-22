# -*- codinwig: utf-8 -*-
"""
universal argparser for PageKicker
runs at top of all bash scripts to parse positional parametters

"""

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--infile", help = "seed file", default = 'test')
parser.add_argument("--lang", help="wiki language bigram", default = 'en')
parser.add_argument("--request_type", help="request type", default = 'sum')
parser.add_argument("--outfile", help = "path to outfile", default = 'outfile')
parser.add_argument("--summary", help = "true or false", action = "store_true")
parser.add_argument("--pagehits", help = "path to list of page hits", default = 'pagehits')
args = parser.parse_args()

input_file = args.infile
print(input_file)

