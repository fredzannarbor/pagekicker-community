#!/usr/local/bin/python
###################################################
#ArXivFetcher.py
#Inputs:
#1)seeds for calls (can be multiples, contained in one string) 
#2) a uuid 
#3) number of results
#Outputs:
#1) 
#Attributes to add:
#1)accept multiple seed terms
# 
#######


import os, sys, codecs, urllib
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
#=================================================
def main():
	seed = str(sys.argv[1])
	uuid_path = str(sys.argv[2])
	results_num = sys.argv[3]
	os.chdir(uuid_path)
	title = ''
	pdf = ''
	url = 'http://export.arxiv.org/api/query?search_query=all:'+seed+'&start=0&max_results='+results_num+'&sortBy=relevance&sortOrder=descending'
	data = urllib.urlopen(url).read()
	tree = ET.fromstring(data)
	
	title_list = []
	pdf_list = []
	iternum = 0;
	titlenum = 0;
		
	for elem in tree.iterfind('.//{http://www.w3.org/2005/Atom}entry'):
			for subelem in elem.iterfind('.//{http://www.w3.org/2005/Atom}title'): 
				title = subelem.text
				title_list.append(title)
	for elem in tree.iterfind('.//{http://www.w3.org/2005/Atom}link[@type="application/pdf"]'):
		pdf = elem.attrib.get('href')
		pdf_list.append(pdf) 


	#pdf_url = tree[7][8].attrib.get('href')
	#title = tree[7][3].text
	if title != '':
		for i in range(len(title_list)):
			print title_list[i]
			print pdf_list[i]
	else:
		print 'No results found.'
	#print data
    
#=================================================
if __name__ == '__main__':
    main()
