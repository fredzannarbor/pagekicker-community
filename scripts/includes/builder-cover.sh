# build cover

cp $scriptpath"assets/pk35pc.jpg"  "$TMPDIR"$uuid/pk35pc.jpg
cp $confdir"jobprofiles"/imprints/"$imprint"/"$imprintlogo"   "$TMPDIR"$uuid/cover/"$imprintlogo"

cp $confdir"jobprofiles"/signatures/$sigfile  "$TMPDIR"$uuid/$sigfile

#select wordcloud stopfile

if [ "$wikilang" = "en" ] ; then
	stopfile="$scriptpath""lib/IBMcloud/examples/pk-stopwords.txt"
elif [ "$wikilang" = "sv" ] ; then
	stopfile="$scriptpath""locale/stopwords/sv"
elif [ "$wikilang" = "it" ] ; then
	stopfile="$scriptpath""locale/stopwords/it"
else
	stopfile="$scriptpath""lib/IBMcloud/examples/pk-stopwords.txt"
fi

#rotate stopfile

if cmp -s "$scriptpath/lib/IBMcloud/examples/pk-stopwords.txt" $scriptpath"/lib/IBMcloud/examples/restore-pk-stopwords.txt" ; then
	echo "stopfiles are identical, no action"
else
	echo "Rotating stopfile into place"
	cp "$stopfile" "$scriptpath""lib/IBMcloud/examples/pk-stopwords.txt"
fi

# wordcloud is retired
#	"$JAVA_BIN" -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -w "1800" -h "1800" <  "$TMPDIR"$uuid/wiki/wiki4cloud.md >  "$TMPDIR"$uuid/cover/wordcloudcover.png 2> /dev/null

# convert -size 1800x2400 "$TMPDIR"$uuid/cover/wordcloudcover.png

#copying old stopfile backup  to overwrite rotated stopfile

if cmp -s "$scriptpath/lib/IBMcloud/examples/pk-stopwords.txt" $scriptpath"/lib/IBMcloud/examples/restore-pk-stopwords.txt" ; then
	echo "stopfiles are identical, no action"
else
	echo "Rotating old stopfile back in place"
	cp $scriptpath"/lib/IBMcloud/examples/restore-pk-stopwords.txt"  "$scriptpath/lib/IBMcloud/examples/pk-stopwords.txt"
fi

# set font & color

if [ "$coverfont" = "Random" ] ; then
	coverfont=`./bin/random-line.sh ../conf/fonts.txt`
	echo "random coverfont is " $coverfont

else
	coverfont=$coverfont
	echo "using specified cover font" $coverfont
fi


if [ "$covercolor" = "Random" ]; then
	covercolor=`./bin/random-line.sh ../conf/colors.txt`
	echo "random covercolor is " $covercolor
else
	covercolor=$covercolor
	echo "using specified covercolor "$covercolor

fi

echo "covercolor is" $covercolor
echo "coverfont is" $coverfont

#create base canvases

convert -size 1800x2400 xc:$covercolor  "$TMPDIR"$uuid/cover/canvas.png
convert -size 1800x800 xc:$covercolor   "$TMPDIR"$uuid/cover/topcanvas.png
convert -size 1800x400 xc:$covercolor   "$TMPDIR"$uuid/cover/bottomcanvas.png
convert -size 1800x800 xc:$covercolor   "$TMPDIR"$uuid/cover/toplabel.png
convert -size 1800x200 xc:$covercolor   "$TMPDIR"$uuid/cover/bottomlabel.png

# underlay canvas


# build top label

convert -background "$covercolor" -fill "$coverfontcolor" -gravity center -size 1800x2400 -font "$coverfont" caption:"$booktitle"  "$TMPDIR"$uuid/cover/topcanvas.png +swap -gravity center -composite  "$TMPDIR"$uuid/cover/toplabel.png

#build bottom label

echo "yourname is" $yourname
if [ "$yourname" = "yes" ] ; then
	editedby="$human_author"
else
	echo "robot name on cover"
fi
#editedby="PageKicker"
echo "editedby is" $editedby
convert  -background "$covercolor"  -fill "$coverfontcolor" -gravity south -size 1800x394 \
 -font "$coverfont"  caption:"$editedby" \
  "$TMPDIR"$uuid/cover/bottomcanvas.png  +swap -gravity center -composite  "$TMPDIR"$uuid/cover/bottomlabel.png

# resize imprint logo

convert  "$TMPDIR"$uuid/cover/"$imprintlogo" -resize x200  "$TMPDIR"$uuid/cover/"$imprintlogo"

# lay the labels on top of the target canvas

composite -gravity center "$TMPDIR"$uuid/cover/toplabel.png  "$TMPDIR"$uuid/cover/canvas.png  "$TMPDIR"$uuid/cover/step1.png
composite  -geometry +0+1800  "$TMPDIR"$uuid/cover/bottomlabel.png  "$TMPDIR"$uuid/cover/step1.png  "$TMPDIR"$uuid/cover/step2.png
composite  -gravity south -geometry +0+0  "$TMPDIR"$uuid/cover/"$imprintlogo"  "$TMPDIR"$uuid/cover/step2.png  "$TMPDIR"$uuid/cover/cover.png
convert "$TMPDIR$uuid/cover/cover.png" -border 36 -bordercolor white  "$TMPDIR$uuid/cover/bordercover.png"
convert "$TMPDIR$uuid/cover/bordercover.png"  "$TMPDIR$uuid/cover/$sku""ebookcover.jpg"
convert "$TMPDIR$uuid/cover/bordercover.png"  "$TMPDIR$uuid/ebookcover.jpg"
