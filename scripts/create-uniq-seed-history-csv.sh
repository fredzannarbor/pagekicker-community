#!/bin/bash
# assumes that this is located in scriptpath home

cat $LOCAL_DATA"seeds/history/seed-history.csv" | cut -d, -f1 |  uniq -c | sort > $LOCAL_DATA"seeds/history/stats-seeds.csv"

# cats the history file
# removes duplicate lines,
# and finally writes the result to an output file.
echo "sorted seed-history.csv and wrote to uniq.seed-history.csv"  >> logs/sfb_log.txt
exit
0
