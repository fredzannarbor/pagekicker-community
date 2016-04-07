#!/usr/bin/env python

"""
Mendeley Open API Download File Example Client

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

python test-download.py

"""

from pprint import pprint
from mendeley_client import MendeleyClient
import json
import os
import sys
import string
import httplib


mendeley = MendeleyClient('<insert_consumer_key_here>', '<insert_secret_key_here>')

try:
    mendeley.load_keys()
except IOError:
    mendeley.get_required_keys()
    mendeley.save_keys()

docId = raw_input('Insert document id: ')
fileHash = raw_input('Insert file hash: ')
## If you want to download a group document, then introduce the group id and then call download_file_group instead 
#groupId = raw_input('Insert group id: ')

response = mendeley.download_file(docId, fileHash)

if response.has_key('error'):
    sys.exit(response['error'])

if response.has_key('data'):
    data = response['data']

if response.has_key('filename'):
    fn = response['filename']

print fn

f = open(fn, 'w+b')

f.write(data)

f.close()
