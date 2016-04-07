#!/bin/bash

while read acronym
do
	echo $acronym 
	wtf -f /usr/share/games/bsdgames/acronyms.climate $acronym >> results
done<~/Dropbox/methane/paper4/filtered_acronyms

