#!/bin/bash

# convert all pdfs in current directory to txt

for file in *.pdf
do
	pdftotext $file
	echo "converted "$file "to txt"
done
echo "done converting PDFs in this directory to txt"
exit
0
