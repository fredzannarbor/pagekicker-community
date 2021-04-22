#!/bin/bash

echo "decrypting all files in directory"
for file in *.pdf
do
	qpdf --decrypt $file decrypted/"dc."$file
done

