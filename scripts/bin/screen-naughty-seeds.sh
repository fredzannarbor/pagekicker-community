#!/bin/bash

. ../conf/config.txt

# echo "beginning to screen out naughty and duplicate seeds" >> $sfb_log

while read -r line; do 

if grep -qw "$line" "seeds/disallowed-seeds.txt" ; then

	echo "the seed "$line "was disallowed" 
	disallowed=$disallowed"; "$line

	sendemail -t "$customer_email" \
		-m "These seeds have been removed from the build because they were disallowed or unrecognizable words ** $disallowed ** " \
		-u "Build cancelled because of disallowed word" \
		-f fred@pagekicker.com \
		-cc fred@pagekicker.com \
		-xu fred@pagekicker.com \
		-xp "VnenKBENvGa9" \
		-s smtp.gmail.com:587 \
		-o tls=yes 
		disallowed_seed="yes"
else
	echo "$line is not a naughty word -- your momma raised you right!"
	echo "$line" >> $TMPDIR$UUID/seeds/allowed_seeds.txt
fi

echo "I checked your seeds to be sure there were no naughty words -- your momma raised you right!" >> $TMPDIR$uuid/seeds/process.md

cp $TMPDIR$uuid/seeds/allowed_seeds.txt $TMPDIR$uuid/seeds/seeds.original

done <$1

exit 0
