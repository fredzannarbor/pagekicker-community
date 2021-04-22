#!/bin/bash

. ../conf/config.txt

for file in *.pdf
do
# build print-size Word Cloud image

	pdf2txt $file > $file.txt

	echo "converted "$file "to txt"

	$JAVA_BIN -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -w 2550 -h 3300 < $file.txt > $file"printcloud.png" 2> /dev/null

	echo "created print word cloud for " $file

done

