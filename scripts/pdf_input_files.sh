#!bin/bash 

# pdf-based book builder

# all front matter will be inserted here

# loop over pdf files

shopt -s nullglob
for f in tmp/$uuid/inputs/*.pdf
do
	#process each file

	# convert to 8.5 x 11
	# ocr text
	# run alchemy
	# cover builders
	# write metadata
	# build ebooks
	# distribute files

done
