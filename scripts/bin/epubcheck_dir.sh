#!/bin/bash

for file in *.epub
do
	echo "validating " $file
	java -jar /home/fred/sfb/sfb-latest/trunk/scripts/lib/epubcheck-3.0/epubcheck-3.0.jar "$file" 
	echo "exit status for file" $file "was" $? | tee --append epubcheck_err
done
