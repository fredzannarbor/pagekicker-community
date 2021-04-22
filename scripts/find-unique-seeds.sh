#!/bin/bash
# assumes that this is located in scriptpath home

cat $LOCAL_DATA"seeds/history/seed-history.csv" | cut -d, -f1 | sed 's/[ \t]*$//' | sort | uniq  > $LOCAL_DATA"seeds/history/uniq.seed-history.csv"

# Concatenates the list files,
# removes duplicate lines,
# and finally writes the result to an output file.
echo "sorted seed-history.csv and wrote to  local-data/uniq.seed-history.csv"  | tee --append $sfb_log
exit
0
