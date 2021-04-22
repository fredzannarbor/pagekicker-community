#!/bin/bash

. ../conf/config.txt

cd $scriptpath

#clean up previous

rm $scriptpath"seeds/trends/google_screened.seed"
rm $scriptpath"seeds/trends/google_nodupes.seed"

while read i
do
if grep -q "$i" $LOCAL_DATA"seeds/history/seed-history.csv"
then 
	echo $i "has already been used to build a book" 
	echo $i "has already been used to build a book" >> $LOCAL_DATA"logs/seed.log"
	echo "" >> $scriptpath"seeds/trends/google_nodupes.seed"
  # figure out how to send an error report to the user here

else
	echo $i >> $scriptpath"seeds/trends/google_nodupes.seed"
	echo "seed" $i "was not a duplicate" $LOCAL_DATA"logs/seed.log"
fi
	
	done < seeds/trends/google

# only works for google right now!

sed '/^$/d' $scriptpath"seeds/trends/google_nodupes.seed" > $scriptpath"seeds/trends/google_screened.seed"	

echo "finished writing google_screened.seeds file at " `date +'%m/%d/%y%n %H:%M:%S'`>> $LOCAL_DATA"logs/seed.log"


exit 0
