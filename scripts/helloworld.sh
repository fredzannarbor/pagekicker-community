#!/bin/bash
echo "hello world"  
sendemail -t "fred@pagekicker.com" \
	-u "hello world" \
	-m "hello wordl from Magento" \
	-f fred@pagekicker.com \
	-xu fred@pagekicker.com \
	-xp "f1r3comb" \
	-s smtp.gmail.com:587 \
	-o tls=yes 
exit 0
