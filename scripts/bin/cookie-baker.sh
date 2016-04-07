#!/bin/bash

# fortune cookie baker

cookiename="$topic"_cookies

perl -w -p -e 's/\n/\n\%\n/' dough > cookies

strfile cookies cookiename

echo "created fortune cookie file "$cookiename

exit 0
