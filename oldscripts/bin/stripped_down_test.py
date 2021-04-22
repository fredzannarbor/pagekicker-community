#!/usr/bin/env python

"""
Mendeley Open API Example Client

Copyright (c) 2010, Mendeley Ltd. <copyright@mendeley.com>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

For details of the Mendeley Open API see http://dev.mendeley.com/

Example usage:

python test.py

"""

from pprint import pprint
from mendeley_client import MendeleyClient
import json
# import os
import string
# import sys


mendeley = MendeleyClient('13a47f20711f5d5ffe8e8f4db1df1daa04f8bd9b6', '394d64a2907f23c7f6ea5d94fb386865')

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


print("""

-----------------------------------------------------
List folders
-----------------------------------------------------""")
folders = mendeley.folders()
pprint(folders)

folderid = input('Enter folder id: ')
pprint(folderid)

response = mendeley.create_folder(folder=json.dumps({'name': 'Recent Docs to Review', 'parent':folderid}))
# pprint(response)
print("Created Review Child Folder")
reviewchildfolderid = response['folder_id']

docs = mendeley.folder_documents(folderid)
pprint(docs)
print("Retrieving documents from selected folder")
pub_list = []
pprint(pub_list)

# from wikiradar.py

# Dictionary mapping uuid's to a dictionary with keys: authors, title, year, count
related_doc_dict = dict()

details = mendeley.document_details(documents['document_ids'][0])

print("Looking up suggestions for related docs.")
print("")
for pub_item in pub_list:
    pprint(pub_item)
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
            rel_doc_info['count'] = 1
        related_doc_dict[uuid] = rel_doc_info

related_list = sorted(list(related_doc_dict.values()), key = lambda doc:doc['count'])
related_list.reverse()

print("Related Papers")
print("--------------")
count = 0
for pub_item in pub_list:
    print("%d: %s - %d" % ((count+1), pub_item.title, pub_item.year))
    count += 1
print("")

print("Found %d related papers to suggest." % len(related_list))

print("Suggested Related Papers")
print("------------------------")
count = 0
for item in related_list:
    year = float(item['year'])
    score = float(item['count'])/len(pub_list)
    #if (count < 20):
    #get recent docs instead
    if (year > 2009):
        print("%d: %s - %d | Score: %f" % ((count + 1), item['title'], item['year'], score))
    count += 1
    score = float(item['count'])/len(related_list)
    if (score >= 0.5) and (count < 10):
        print("%d: %s - %d | Score: %f" % ((count+1), item['title'], item['year'], score))
        count += 1
print("")

# then upload suggested drelated papersto for Review folder



