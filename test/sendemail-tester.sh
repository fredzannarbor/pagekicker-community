#!/bin/bash

# tests whether sendemail is working on this system
# assumes existence of .pagekicker/config.txt file

if [ ! -f "$HOME"/.pagekicker/config.txt ]; then
	echo "config file not found, creating /home/<user>/.pagekicker, put config file there"
	mkdir -p -m 755 "$HOME"/.pagekicker
	echo "exiting"
	exit 1
else
	. "$HOME"/.pagekicker/config.txt
	echo "read config file from $HOME""/.pagekicker/config.txt"
fi


echo "software version number is" $SFB_VERSION


echo "completed reading config file and  beginning logging at" `date +'%m/%d/%y%n %H:%M:%S'` 

starttime=$(( `date +%s` ))


. includes/set-variables.sh

sendemail -t "wfzimmerman@gmail.com" \
		-u "test  email" \
		-m "Hi!" \
		-f "$GMAIL_ID" \
		-cc "$GMAIL_ID" \
		-xu "$GMAIL_ID" \
		-xp "$GMAIL_PASSWORD" \
		-s smtp.gmail.com:587 \
		-o tls=yes \
		-a ../test/tmpbody.md 
	
exit 0
