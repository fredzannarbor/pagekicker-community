#!/usr/bin/env python

from pprint import pprint
from mendeley_client import MendeleyClient
import json
import os
import string
import sys

mendeley = MendeleyClient('11c16fb7a31f44b76305c7dcaf8a880a04dbb5931', '01a184cb4b4de87c404040b1314bcf02')

try:
    mendeley.load_keys()
except IOError:
    mendeley.get_required_keys()
    mendeley.save_keys()

class MPub(object):
    
    def __init__(self, uuid, title, abstract, authors, keywords, publication, tags, url, year):
        self.uuid = uuid
        self.title = title
        self.abstract = abstract
        self.authors = authors
        self.keywords = keywords
        self.title = title
        self.tags = tags
        self.url = url
        self.year = year
    
    def __str__(self):
        return "(Mendeley Paper Object: %s)" % self.uuid
    
    def __repr__(self):
        return "(Mendeley Paper Object: %s)" % self.uuid


    
    def __ne__(self, other):
        return not self.__eq__(other)        

url = "http://en.wikipedia.org/wiki/Machine_learning"
url = sys.argv[1]
url_words = url.lower().rsplit('/', 1)[1].split('_')
keyword = string.join(url_words)

print "Retrieving documents tagged with '%s'" % keyword
docs = mendeley.tagged(keyword, items=20)
pub_list = []

print "Looking up document details."
for doc in docs['documents']:
    uuid = doc['uuid']
    doc_details = mendeley.details(uuid)
    
    title = doc_details.get('title', None)
    abstract = doc_details.get('abstract', None)
    
    author_data = doc_details.get('authors', None)
    if author_data:
        authors = []
        for author_record in author_data:
            authors.append((author_record['surname'], author_record['forename']))
    else:
        authors = None
    
    keyword_data = doc_details.get('keywords', None)
    if keyword_data:
        keywords = set(keyword_data)
    else:
        keywords = None
        
    tag_data = doc_details.get('tags', None)
    if tag_data:
        tags = set(tag_data)
    else:
        keywords = None
    
    publication = doc_details.get('publication_outlet', None)
    title = doc_details.get('title', None)
    
    url = doc_details.get('mendeley_url', None)
    if url:
        url = set(url)
    else:
        url = None
    year = int(doc_details.get('year', None))
    
    curr_pub = MPub(uuid, title, abstract, authors, keywords, publication, tags, url, year)
    pub_list.append(curr_pub)

# Data format for related docs:
# Dictionary mapping uuid's to a dictionary with keys: authors, title, year, count, url
related_doc_dict = dict()

print "Looking up suggestions for other related docs."
print ""
for pub_item in pub_list:
    related_docs = mendeley.related(pub_item.uuid, items=10)
    for related_doc in related_docs['documents']:
        uuid = related_doc['uuid']
        rel_doc_info = related_doc_dict.get(uuid, None)
        if rel_doc_info:
            rel_doc_info['count'] += 1
        else:
            rel_doc_info = dict()
            rel_doc_info['authors'] = related_doc['authors']
            rel_doc_info['title'] = related_doc['title']
            rel_doc_info['year'] = related_doc['year']
            rel_doc_info['url'] = related_doc['url']
            rel_doc_info['count'] = 1
        related_doc_dict[uuid] = rel_doc_info

related_list = sorted(related_doc_dict.values(), key = lambda doc:doc['count'])
related_list.reverse()

print "Related Papers"
print "--------------"
count = 0
for pub_item in pub_list:
    print "%d: %s - %d" % ((count+1), pub_item.title, pub_item.year, pub_item.url)
    count += 1
print ""

print "Found %d related papers to suggest." % len(related_list)

print "Suggested Related Papers"
print "------------------------"
f = open('tmp/wikitest.txt','w')
count = 0
for item in related_list:
    score = float(item['count'])/len(pub_list)
    if (count < 10):
        print f, "%d: %s - %d | Score: %f" % ((count + 1), item['title'], item['year'], item['url'],  score)
    count += 1
    #score = float(item['count'])/len(related_list)
    #if (score >= 0.5) and (count < 10):
    #    print "%d: %s - %d | Score: %f" % ((count+1), item['title'], item['year'], score)
    #    count += 1
print ""

# python mendeley-test.py http://en.wikipedia.org/wiki/Machine_learning

