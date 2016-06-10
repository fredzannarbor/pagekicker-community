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

#gonna need to install AlchemyAPI
import AlchemyAPI
import argparse
import xml.etree.ElementTree as ET
import collections
import codecs
import os
#from IPython import embed 
#=================================================
def listwrite(output_file,thelist):
	for item in thelist:
		item.encode('utf-8')
		output_file.write("%s\n\n" % item)

#=================================================
 
def main():
	#personal api key saved as api_key.txt
	parser = argparse.ArgumentParser()
	parser.add_argument('path', help = "target file or directory for NER")
	parser.add_argument('output', help = "target file for output")
	args = parser.parse_args()
	
	in_file = args.path
	out_file = args.output
	cwd = os.getcwd()
	apikey_location = os.path.join(cwd, "api_key.txt")
	
	with open(in_file) as f:
		text = f.read()
		
	alchemyObj = AlchemyAPI.AlchemyAPI()
	alchemyObj.loadAPIKey(apikey_location)

	result = alchemyObj.TextGetRankedNamedEntities(text)

	root = ET.fromstring(result)

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
  	out_file = 'peoples'
	with codecs.open(out_file, mode= 'w', encoding='utf-8') as o:
          listwrite(o, People_s)
  	out_file = 'places'
    	with codecs.open(out_file, mode= 'w', encoding='utf-8') as o:
         listwrite(o, Places_s)
  	out_file = 'others'
	with codecs.open(out_file, mode= 'w', encoding='utf-8') as o:
          listwrite(o, Other_s)
#=================================================
if __name__ == '__main__':
    main()