#!/usr/local/bin/python
###################################################
# Fred Zimmerman
# 
# Goal: Named entity recognition script to pull names/place from text
# called as python nerv3.py text_path_or_file 
#
# Inputs:
# path - text file or directory containing text files
# output - output file name 
# Outputs:
# Output file written
#
###################################################

from __future__ import print_function
from alchemyapi import AlchemyAPI
import json
import argparse
import os

#=================================================
def listwrite(output_file,thelist):
    for item in thelist:
        item.encode('utf-8')
        output_file.write("%s\n" % item)

#=================================================
 
def main():

    tmpdir = "/tmp/pagekicker"

    #personal api key saved as api_key.txt
    parser = argparse.ArgumentParser()
    parser.add_argument('--infile', help = "target file or directory for NER")
    parser.add_argument('--outfile', help = "target file for output")
    parser.add_argument('--uuid', help = "uuid")
    args = parser.parse_args()
    
    in_file = args.infile
    out_file = args.outfile
    uuid = args.uuid
    folder = os.path.join(tmpdir, uuid)
    print(folder)
    cwd = os.getcwd()
    apikey_location = os.path.join(cwd, "api_key.txt")
    print(in_file)
    with open(in_file) as f:
        filetext = f.read()
    return filetext

filetext = main()

alchemyapi = AlchemyAPI()
       
response = alchemyapi.entities('text', filetext, {'sentiment': 1})

if response['status'] == 'OK':

    print(json.dumps(response, indent=4))

    for entity in response['entities']:
        print('text: ', entity['text'].encode('utf-8'))
        print('type: ', entity['type'])
        print('relevance: ', entity['relevance'])
        print('sentiment: ', entity['sentiment']['type'])
        if 'score' in entity['sentiment']:
            print('sentiment score: ' + entity['sentiment']['score'])
        print('')
else:
    print('Error in entity extraction call: ', response['statusInfo'])

#=================================================
if __name__ == '__main__':
    main()
