#!/bin/bash
TMPDIR="/tmp/pagekicker/"
uuid="memecard"  && mkdir -p $TMPDIR"$uuid"
confdir="/home/fred/pagekicker-community/conf/"
memewidth=1200
memeheight=630
#USAGE age: $1 is input markdownfile $2 is tldr
backgroundcolor="white"
fillcolor="black"
headlinefont="GillSansStd"

# create title bar

convert -units pixelsperinch -density 300 -size 1000x50 -border 5 -background "$backgroundcolor" -font "$headlinefont" -fill "$fillcolor" -gravity center  caption:"$2" $TMPDIR$uuid/toplabel1.png

# prepend pagenumbering to tmp file

echo -e '\pagenumbering{gobble}\n' | cat - $1 > /tmp/out && mv /tmp/out $TMPDIR$uuid/tmpcard.md

# make pdf

cat $TMPDIR$uuid/tmpcard.md  | \
 pandoc  --latex-engine=xelatex --template=$confdir"pandoc_templates/nonumtemplate.tex" \
-o $TMPDIR$uuid/memecard.pdf -V "geometry:paperheight=8.5in"

# make png
convert -density 400  $TMPDIR$uuid/memecard.pdf  -trim $TMPDIR$uuid/memecard.png
# "if error issued here see comments in includes/1000x3000skyscraper.sh for explanation"


convert $TMPDIR$uuid/memecard.png -border 30 $TMPDIR$uuid/memecard.png
# put logo on 1000 px wide & trim
convert $scriptpath"assets/pk35pc.jpg" -resize 20% $TMPDIR$uuid/pksmall.jpg
convert $TMPDIR$uuid"/pksmall.jpg" -gravity center -background white -extent 1024x50 \
 $TMPDIR$uuid/memecardlogo.png

# make card
montage $TMPDIR$uuid/toplabel1.png \
$TMPDIR$uuid"/memecard.png" \
$TMPDIR$uuid/memecardlogo.png  \
-geometry "$memewidth"x"$memeheight" -border 10 -tile 1x10 -mode concatenate \
$TMPDIR$uuid/memecard.png

convert $TMPDIR$uuid"/memecard.png" -trim -border 30 $TMPDIR$uuid/memecard2.png
