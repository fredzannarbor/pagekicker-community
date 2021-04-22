#!/usr/local/bin/python
###################################################
# Jeffrey Herbstman
# nerv3.py
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

from watson_developer_cloud import AlchemyLanguageV1
import argparse
import xml.etree.ElementTree as ET
import requests
import codecs
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
	parser.add_argument('path', help = "target file or directory for NER")
	parser.add_argument('outfile', help = "target file for output")
	parser.add_argument('uuid', help = "uuid")
	args = parser.parse_args()

	in_file = args.path
	out_file = args.outfile
	uuid = args.uuid
	folder = os.path.join(tmpdir, uuid)
	print(folder)


	with open(in_file, 'rb') as f:
		text = f.read()

	AlchemyApi_Key = 'b887e176b6a650093c3d4ca635cd1b470be6584e'
	url = 'https://gateway-a.watsonplatform.net/calls/text/TextGetRankedNamedEntities'
	payload = { 'apikey': AlchemyApi_Key,
            'outputMode': 'xml',
            'text': text,
            'max_items': '3'
     }

	r = requests.post(url,payload)

	root = ET.fromstring(r)

	place_list = ['City', 'Continent', 'Country', 'Facility', 'GeographicFeature',\
	'Region', 'StateOrCounty']
	People = {}
	Places = {}
	Other = {}

	for entity in root.getiterator('entity'):
		if entity[0].text == 'Person':
			People[entity[3].text]=[entity[1].text, entity[2].text]
		elif entity[0].text in place_list:
			Places[entity[3].text] = [entity[1].text, entity[2].text]
		else:
			Other[entity[3].text] = [entity[1].text, entity[2].text]

	#print lists ordered by relevance
	Places_s = sorted(Places, key = Places.get, reverse = True)
	People_s = sorted(People, key = People.get, reverse = True)
	Other_s = sorted(Other, key = Other.get, reverse = True)

	with codecs.open(out_file, mode = 'w', encoding='utf-8') as o:
		listwrite(o, People_s)
		listwrite(o, Places_s)
		listwrite(o, Other_s)
	out_file = os.path.join(folder, 'People')
	with codecs.open(out_file, mode= 'w', encoding='utf-8') as o:
		listwrite(o, People_s)
	out_file = os.path.join(folder, 'Places')
	with codecs.open(out_file, mode= 'w', encoding='utf-8') as o:
		listwrite(o, Places_s)
	out_file = os.path.join(folder, 'Other')
	with codecs.open(out_file, mode= 'w', encoding='utf-8') as o:
		listwrite(o, Other_s)
#=================================================
if __name__ == '__main__':
    main()
