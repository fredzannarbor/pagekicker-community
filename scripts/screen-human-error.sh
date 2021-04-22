#!/bin/bash

. ../conf/config.txt

echo "beginning to screen out naughty and duplicate seeds" >> $sfb_log

while read -r line; do 

if grep -qw "$line" "seeds/human-error.txt" ; then

	PK_ERR_CODE="human_error1"
	echo "looks like customer forgot to provide new phrases" | tee --append $sfb_log

	sendemail -t "$customer_email" \
		-m "This book build has been cancelled because it looks like you forgot to replace the dummy keyword phrases with real keywords" \
		-u "Build cancelled because dummy keyword phrases" \
		-f "$GMAIL_ID" \
		-cc "$GMAIL_ID" \
		-xu "$GMAIL_ID" \
		-xp "$GMAIL_PASSWORD" \
		-s smtp.gmail.com:587 \
		-o tls=yes 
		echo "exiting dummy" ; exit 0
else
	echo "congratulations $line is not a dummy phrase, and you are not a dummy"
fi

echo "I checked your seed phrasesto be sure you filled out the form correctly, and you did.  Good job, fellow sentient!" >> $TMPDIR$uuid/seeds/process.md

done <$1

exit 0
