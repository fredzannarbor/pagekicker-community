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
import os

mendeley = MendeleyClient('13a47f20711f5d5ffe8e8f4db1df1daa04f8bd9b6', '394d64a2907f23c7f6ea5d94fb386865')

try:
    mendeley.load_keys()
except IOError:
    mendeley.get_required_keys()
    mendeley.save_keys()

########################################
######## Public Resources Tests ########
########################################

print """

-----------------------------------------------------
Canonical document details
-----------------------------------------------------"""
response = mendeley.details('cbcca150-6cff-11df-a2b2-0026b95e3eb7')
pprint(response)

print """

-----------------------------------------------------
Canonical document details DOI look up
-----------------------------------------------------"""
response = mendeley.details('10.1371%2Fjournal.ppat.1000281', type='doi')
pprint(response)

print """

-----------------------------------------------------
Canonical document details PubMed Id look up
-----------------------------------------------------"""
response = mendeley.details('19910365', type='pmid')
pprint(response)

print """

-----------------------------------------------------
Categories
-----------------------------------------------------"""
response = mendeley.categories()
pprint(response)

print """

-----------------------------------------------------
Subcategories
-----------------------------------------------------"""
response = mendeley.subcategories(3)
pprint(response)

print """

-----------------------------------------------------
Search
-----------------------------------------------------"""
response = mendeley.search('phiC31', items=10)
pprint(response)

print """

-----------------------------------------------------
Tagged 'modularity'
-----------------------------------------------------"""
response = mendeley.tagged('modularity', items=5)
pprint(response)

print """

-----------------------------------------------------
Tagged 'test' in category 14
-----------------------------------------------------"""
response = mendeley.tagged('test', cat=14)
pprint(response)

print """

-----------------------------------------------------
Tagged 'modularity' in subcategory 'Bioinformatics'
-----------------------------------------------------"""
response = mendeley.tagged('modularity', subcat=455)
pprint(response)

print """

-----------------------------------------------------
Related
-----------------------------------------------------"""
response = mendeley.related('91df2740-6d01-11df-a2b2-0026b95e3eb7')
pprint(response)

print """

-----------------------------------------------------
Authored by 'Ann Cowan'
-----------------------------------------------------"""
response = mendeley.authored('Ann Cowan', items=5)
pprint(response)


print """

-----------------------------------------------------
Public groups
-----------------------------------------------------"""
response = mendeley.public_groups()
pprint(response)

groupId = '536181'
print """

-----------------------------------------------------
Public group details
-----------------------------------------------------"""
response = mendeley.public_group_details(groupId)
pprint(response)


print """

-----------------------------------------------------
Public group documents
-----------------------------------------------------"""
response = mendeley.public_group_docs(groupId)
pprint(response)


print """

-----------------------------------------------------
Public group people
-----------------------------------------------------"""
response = mendeley.public_group_people(groupId)
pprint(response)

print """

-----------------------------------------------------
Author statistics
-----------------------------------------------------"""
response = mendeley.author_stats()
pprint(response)


print """

-----------------------------------------------------
Papers statistics
-----------------------------------------------------"""
response = mendeley.paper_stats()
pprint(response)

print """

-----------------------------------------------------
Publications outlets statistics
-----------------------------------------------------"""
response = mendeley.publication_stats()
pprint(response)

###############################################
######## User Specific Resources Tests ########
###############################################

print """

-----------------------------------------------------
My Library authors statistics
-----------------------------------------------------"""
response = mendeley.library_author_stats()
pprint(response)

print """

-----------------------------------------------------
My Library tag statistics
-----------------------------------------------------"""
response = mendeley.library_tag_stats()
pprint(response)

print """

-----------------------------------------------------
My Library publication statistics
-----------------------------------------------------"""
response = mendeley.library_publication_stats()
pprint(response)

### Library ###
print 'Library'
print """

-----------------------------------------------------
My Library documents
-----------------------------------------------------"""
documents = mendeley.library()
pprint(documents)

print """

-----------------------------------------------------
Create a new library document
-----------------------------------------------------"""
response = mendeley.create_document(document=json.dumps({'type' : 'Book','title': 'Document creation test', 'year': 2008}))
pprint(response)
documentId = response['document_id']

print """

-----------------------------------------------------
Document details
-----------------------------------------------------"""
response = mendeley.document_details(documentId)
pprint(response)

print """

-----------------------------------------------------
Delete library document
-----------------------------------------------------"""
response = mendeley.delete_library_document(documentId)
pprint(response)

print """

-----------------------------------------------------
Documents authored
-----------------------------------------------------"""
response = mendeley.documents_authored()
pprint(response)

print """

-----------------------------------------------------
Create new folder
-----------------------------------------------------"""
response = mendeley.create_folder(folder=json.dumps({'name': 'Test folder creation'}))
pprint(response)
folderId = response['folder_id']

print """

-----------------------------------------------------
Create new child folder
-----------------------------------------------------"""
response = mendeley.create_folder(folder=json.dumps({'name': 'Test child folder creation', 'parent':folderId}))
pprint(response)

print """

-----------------------------------------------------
List folders
-----------------------------------------------------"""
folders = mendeley.folders()
pprint(folders)

print """

-----------------------------------------------------
Delete folder
-----------------------------------------------------"""
response = mendeley.delete_folder(folderId)
pprint(response)

print """

-----------------------------------------------------
Create public invite only group
-----------------------------------------------------"""
response = mendeley.create_group(group=json.dumps({'name':'Public invite only group', 'type': 'invite'}))
pprint(response)

print """

-----------------------------------------------------
Create public open group
-----------------------------------------------------"""
response = mendeley.create_group(group=json.dumps({'name':'My awesome public group', 'type': 'open'}))
pprint(response)

print """

-----------------------------------------------------
Create private group
-----------------------------------------------------"""
response = mendeley.create_group(group=json.dumps({'name':'Private group test', 'type': 'private'}))
pprint(response)
groupId = response['group_id']

print """

-----------------------------------------------------
Create new group folder
-----------------------------------------------------"""
response = mendeley.create_group_folder(groupId, folder=json.dumps({'name': 'Test folder creation'}))
pprint(response)
folderId = response['folder_id']

print """

-----------------------------------------------------
Create new child group folder
-----------------------------------------------------"""
response = mendeley.create_group_folder(groupId, folder=json.dumps({'name': 'Test child folder creation', 'parent':folderId}))
pprint(response)

print """

-----------------------------------------------------
List group folders
-----------------------------------------------------"""
folders = mendeley.group_folders(groupId)
pprint(folders)

print """

-----------------------------------------------------
Delete group folder
-----------------------------------------------------"""
response = mendeley.delete_group_folder(groupId, folderId)
pprint(response)

print """

-----------------------------------------------------
Current user's contacts
-----------------------------------------------------"""
response = mendeley.contacts()
pprint(response)

