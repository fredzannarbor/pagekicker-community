#!/bin/bash

. ../conf/config.txt

# echo "beginning to screen out naughty and duplicate seeds" >> $sfb_log

while read -r line; do 

if grep -q "$line" "seeds/disallowed-seeds.txt" ; then 
	echo "ncp_err_code:disallowed the seed "$line "was disallowed" | tee --append $sfb_log
  # figure out how to send an error report to the user here
	pk_err_code="disallowed"
	echo "pk_err_code is" $pk_err_code
sendemail -t "$customer_email" \
	-m "This book build has been cancelled because the seeds included the disallowed word $line" \
	-f fred@pagekicker.com \
	-cc fred@pagekicker.com \
	-xu fred@pagekicker.com \
	-xp "f1r3comb" \
	-s smtp.gmail.com:587 \
	-o tls=yes 

#elif grep -q "$line" $LOCAL_DATA"seeds/history/seed-history.csv"
#then 
	echo "ncp_err_code:duplicate the seed "$line " is a duplicate"  | tee --append $sfb_log

 # # figure out how to send an error report to the user here

else
#	echo $line | tee --append $LOCAL_DATA"allowed/allowed-history.txt"
	echo "pass"
fi

done <$ 1

exit 0
