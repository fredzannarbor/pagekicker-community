#!/bin/bash

. ../conf/config.txt

echo "running jobprofile Noir"
/home/wfz/sfb/sfb-latest/trunk/scripts/SFB-production.sh --jobprofile Noir.jobprofile 1> /dev/null
echo "running jobprofile Hemingway"
/home/wfz/sfb/sfb-latest/trunk/scripts/SFB-production.sh --jobprofile Hemingway.jobprofile 1> /dev/null
echo "running countries seedfile (10 docs) with rows set to 1"
/home/wfz/sfb/sfb-latest/trunk/scripts/SFB-production.sh --seedfile seeds/test/countries --fetched_document_format "html" --rows 1
