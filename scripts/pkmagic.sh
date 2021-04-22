#!/bin/bash

cd $scriptpath

# script runs as cron job to watch for and build books based on tweets with the  magic hashtags #zimzazmagic and #zzmgc

# search string is truncated at appearance of http or @ 

#clean up
rm seeds/pkmagic/4cron.txt

#twidge lsarchive -U zimzaz -lasu | grep '#pkmagic\|#ncpmgc' | cut -f 4 | sed -e 's/.*#pkmgc//' -e  's/.*#pkmagic//' -e 's/http.*//' -e 's/#pkend.*//' -e 's/^[ \t]*//' | sed 's/[ \t]*$//' | >> /home/bitnami/sfb-link/scripts/seeds/pkmagic/4cron.txt

twidge lsarchive -U PageKicker -lasu | grep '#pkmagic\|#ncpmgc' | cut -f 4 | sed -e 's/.*#pkmagic//' -e 's/.*#ncpmgc//'  -e 's/http.*//'  -e 's/#ncpend.*//' |sed 's/[ \t]*$//' | >> "seeds/zzmgc/4cron.txt"
#

"./SFB"$SFB_VERSION" --seedfile seeds/pkmagic/4cron.txt  --editedby "PageKicker™" --categoryid "14" --seedsource "#pkmagic"

# I don't remember what these lines do
#-e 's/@.*//' -e 's/^[ \t]*//'
# -lasu 

exit 0

