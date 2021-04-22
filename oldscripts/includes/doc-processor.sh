#!/bin/bash

processthisdir="tmp/$uuid/"

# processes arbitrary collection of files found in the fetched directory and creates ebook

echo "userdata directory is" $userdatadir

if [ "$userdatadir" = "none" ] ; then

	echo "no user files provided"

else
	# echo flat directories only for now -- in future, support directory userdata via find command
	# cp -R "$userdatadir" tmp/$uuid/user
	cp "$userdatadir"/* tmp/$uuid/user
	echo "user provided files are"
	ls -la tmp/$uuid/user

	# process docs in user-submitted folder 

	for file in $processthisdir/user/*
	do
	ebook-convert $file  $file"fromuser.txt" --pretty-print
	unoconv -f $file.html $file
	python includes/PKsum.py $file"fromuser.txt" -l "$summary_length"--output=$file".summary"
	done

cat "$processthisdir"user/*.html >  $processthisdir/cumulative.html
cat "$processthisdir"user/*.txt >  $processthisdir/cumulative.txt
cat "$processthisdir"user/*.summary > $processthisdir/all.summary.txt

fi

# xmlstarlet sel -t -v "/api/parse/@*" tmp/$uuid/$count.xml > tmp/$uuid/$count.html

# process docs in wiki download folder and turn them into html and txt

for file in "$processthisdir"wiki/*.json
do
cat $file | lib/jshon/jshon -e parse -e text -u |  sed 's|<a[^>]* href="[^"]*/|<a href="http://en.wikipedia.org/wiki/|g' > $file.html
ebook-convert $file.html $file.txt --pretty-print
python includes/PKsum.py  $file.txt  -l "$summary_length" --output=$file.summary
done

# echo building word cloud files


for file in $processthisdir/wiki/
do 
 $JAVA_BIN -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -w 1800 -h 2700 < $file > $file".cloudbase.png" 2>  /dev/null
done

cat "$processthisdir"wiki/*.html >> $processthisdir/cumulative.html
cat "$processthisdir"wiki/*.txt >> $processthisdir/cumulative.txt
cat "$processthisdir"wiki/*.summary > $processthisdir/all.summary.txt

unformattedwordcount=`wc -w < tmp/$uuid/cumulative.txt`
wordcount=`wc -w < tmp/$uuid/cumulative.txt | sed -e :a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta' ` # this adds commas for presentation
echo "unformattedwordcount is" $unformattedwordcount
echo "wordcount is " $wordcount

for file in $processthisdir"flickr/*.jpg"
do
xres=$(identify -format "%[fx:resolution.x]" $file)
yres=$(identify -format "%[fx:resolution.y]" $file)
echo "xres is" $xres
echo "yres is" $yres
if [ "$xres" -eq "72" ] ; then
	echo "xres is 72"
fi

done
