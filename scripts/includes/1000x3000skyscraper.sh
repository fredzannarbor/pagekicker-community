convert -units pixelsperinch -density 300 -size 1000x200 -background blue -fill Yellow -gravity center  -font "$toplabelfont" caption:"$booktitle" $TMPDIR$uuid/toplabel1.png
sed -i '1i # Important Proper Nouns and Key Terms'  "$TMPDIR"$uuid/all_nouns.txt
sed -i '1i \'  "$TMPDIR"$uuid/all_nouns.txt
sed -i G  "$TMPDIR"$uuid/all_nouns.txt
echo '\pagenumbering{gobble}' > $TMPDIR$uuid/all_nouns_sky.txt
echo "  " >> $TMPDIR$uuid/all_nouns_sky.txt
sed -n 1,25p $TMPDIR$uuid/all_nouns.txt >> $TMPDIR$uuid/all_nouns_sky.txt
cp  "$TMPDIR"$uuid/all_nouns.txt  "$TMPDIR"$uuid/all_nouns.md
cp  "$TMPDIR"$uuid/all_nouns_sky.txt  "$TMPDIR"$uuid/all_nouns_sky.md

echo -e '\pagenumbering{gobble}\n' | cat - $TMPDIR$uuid/sources.md > /tmp/out && mv /tmp/out $TMPDIR$uuid/sources.md

# make pdf

cat $TMPDIR$uuid/topics_covered.md $TMPDIR$uuid/pp_summary_sky.md $TMPDIR$uuid/sources.md | pandoc  --latex-engine=xelatex --template=$confdir"pandoc_templates/nonumtemplate.tex" -o $TMPDIR$uuid/infocard.pdf -V "geometry:paperheight=22.0in"

# make png
/usr/bin/convert  $TMPDIR$uuid/infocard.pdf -density 400 -trim $TMPDIR$uuid/infocard.png
echo "if error issued here see comments in includes/1000x3000skyscraper.sh for comments"
# if imagemagick  is installed from source, previous line may issue warning
# that configuration file for delegates is missing.  if the command is
# working correctly to produce trimmed infocard you can ignore
# the warning--this means that the correct delegate program is already
# on the system.  if the command is not producing the trimmed infocard
# you need to fix the problem with ImageMagick.  There are a number o
# ways you can do this -- Google is your friend --  change convert to hard
# code to a version of IM that works (which is done here) -- fix the IM configuration -- or
# specify the delegate in the IM command line.

if [ -z "$add_this_image" ]; then
  echo "using wordcloud image"
  cp $TMPDIR$uuid"/cover/wordcloudcover.png" $TMPDIR$uuid/skyscraperimage.png
  convert $TMPDIR$uuid/skyscraperimage.png $TMPDIR$uuid/skyscraperimage.jpg
else
  echo "using user provided image"
  convert "$add_this_image" $TMPDIR$uuid/skyscraperimage.jpg
fi

convert $TMPDIR$uuid/infocard.png -border 5 $TMPDIR$uuid/infocard.png
# put logo on 1000 px wide & trim
convert $scriptpath"assets/pk35pc.jpg" -resize 50% $TMPDIR$uuid/pksmall.jpg
convert $TMPDIR$uuid"/pksmall.jpg" -gravity center -background white -extent 1000x108 $TMPDIR$uuid/skyscraperlogo.png
# make skyscraper
montage $TMPDIR$uuid/toplabel1.png \
$TMPDIR$uuid/skyscraperimage.jpg \
$TMPDIR$uuid"/infocard.png" \
$TMPDIR$uuid/skyscraperlogo.png  \
-geometry 1000x5000 -border 10 -tile 1x10 -mode concatenate \
$TMPDIR$uuid/skyscraper.jpg

convert $TMPDIR$uuid"/skyscraper.jpg" -trim -border 30 $TMPDIR$uuid/"$safe_product_name".skyscraper.jpg
