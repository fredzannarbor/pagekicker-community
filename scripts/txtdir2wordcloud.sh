#!/bin/bash
for file in *.txt
do
	bin/wordcloudwrapper.sh $file
done
