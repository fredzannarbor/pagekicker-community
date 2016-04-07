#!/bin/bash

# Generate a current unix timestamp
#
createtime=$(( `date +%s` ))

echo "createtime is " $createtime

special_from=$createtime

# Adjust the timestamp above by +4 hours

hours=4

special_lasts_sec=$(( $hours * 60 * 60 ))

echo "special lasts for this number of seconds" $special_lasts_sec

(( special_to =  createtime + special_lasts_sec ))

echo "special expires at " $special_to

echo "special expires at" `date -d @$special_to +'%m/%d/%y%n %H:%M:%S'`

exit
0
