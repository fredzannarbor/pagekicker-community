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
#import os

mendeley = MendeleyClient('13a47f20711f5d5ffe8e8f4db1df1daa04f8bd9b6', '394d64a2907f23c7f6ea5d94fb386865')

try:
    mendeley.load_keys()
except IOError:
    mendeley.get_required_keys()
    mendeley.save_keys()



searchterm = input('Enter search term: ')
pprint(searchterm)

documents = mendeley.search(searchterm, items=20)
pprint(documents)

documents = mendeley.search(searchterm, items=20)
for i in range(0, len(documents)):
    docDetails =mendeley.details(documents[i]['uuid'])
    pprint(docDetails)

