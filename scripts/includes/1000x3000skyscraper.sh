convert -units pixelsperinch -density 300 -background blue -fill Yellow -gravity center -pointsize 30 -font "$toplabelfont" caption:"$booktitle" $TMPDIR$uuid/toplabel1.png

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
convert -density 400 $TMPDIR$uuid/infocard.pdf -trim $TMPDIR$uuid/infocard.png
convert $TMPDIR$uuid/infocard.png -border 30 $TMPDIR$uuid/infocard.png

# put logo on 1000 px wide & trim
convert $scriptpath"assets/pk35pc.jpg" -resize 50% $TMPDIR$uuid/pksmall.jpg
convert $TMPDIR$uuid"/pksmall.jpg" -gravity center -background white -extent 1000x108 $TMPDIR$uuid/skyscraperlogo.png

# make skyscraper
montage $TMPDIR$uuid/toplabel1.png \
$TMPDIR$uuid"/cover/wordcloudcover.png" \
$TMPDIR$uuid"/infocard.png" \
$TMPDIR$uuid/skyscraperlogo.png  \
-geometry 1000x5000 -border 10 -tile 1x10 -mode concatenate \
$TMPDIR$uuid/skyscraper.png

convert $TMPDIR$uuid"/skyscraper.png" -trim -border 30 $TMPDIR$uuid/"$safe_product_name".skyscraper.png
