#!/bin/bash



echo "****MEMECARD****"

if shopt -q  login_shell ; then

	if [ ! -f "$HOME"/.pagekicker/config.txt ]; then
		echo "config file not found, creating /home/<user>/.pagekicker, put config file there"
		mkdir -p -m 755 "$HOME"/.pagekicker
		echo "exiting"
		exit 1
	else
		. "$HOME"/.pagekicker/config.txt
		echo "read config file from login shell $HOME""/.pagekicker/config.txt"
	fi
else
	. /home/$(whoami)/.pagekicker/config.txt #hard-coding /home is a hack
	echo "read config file from nonlogin shell /home/$(whoami)/.pagekicker/config.txt"
fi

cd $scriptpath

TMPDIR="/tmp/pagekicker/"
uuid="memecard"  && mkdir -p $TMPDIR"$uuid"
confdir="$confdir"
memewidth=1200
memeheight=630
memebackgroundcolor="white"
memefillcolor="black"
memeheadlinefont="GillSansStd"

. includes/set-variables.sh

echo "version is" $SFB_VERSION


while :
do
case $1 in
--help | -\?)
echo "for help review source code for now"
exit 0  # This is not an error, the user requested help, so do not exit status 1.
;;
-U|--passuuid)
passuuid=$2
shift 2
;;
--passuuid=*)
passuuid=${1#*=}
shift
;;
-f|--infile)
infile=$2
shift 2
;;
--infile=*)
infile=${1#*=}
shift
;;
-t|--tldr)
tldr=$2
shift 2
;;
--tldr=*)
tldr=${1#*=}
shift
;;
-F|--font)
font=$2
shift 2
;;
--font=*)
font=${1#*=}
shift
;;
-w|--memewidth)
memewidth=$2
shift 2
;;
--memewidth=*)
memewidth=${1#*=}
shift
;;
-h|--memeheight)
memeheight=$2
shift 2
;;
--memeheight=*)
memeheight=${1#*=}
shift
;;
  --) # End of all options
            shift
            break
            ;;
        -*)
            echo "WARN: Unknown option (ignored): $1" >&2
            shift
            ;;
        *)  # no more options. Stop while loop
            break
            ;;

esac
done

if [ ! "$passuuid" ] ; then
	echo "creating uuid"
	uuid=$("$PYTHON_BIN"  -c 'import uuid; print(uuid.uuid1())')
	echo "uuid is" $uuid | tee --append $xform_log
	mkdir -p -m 777  "$TMPDIR"$uuid
else
	uuid=$passuuid
	echo "received uuid " $uuid
	mkdir -p -m 777  "$TMPDIR"$uuid
fi

cp "$infile" $TMPDIR$uuid/tmp.md

# create title bar & version label
echo $SFB_VERSION
convert -units pixelsperinch -density 300 -size 1000x50 -border 5 -background "$backgroundcolor" -font "$memeheadlinefont" -fill "$memefillcolor" -background "$memebackgroundcolor" -gravity center  caption:"$tldr" $TMPDIR$uuid/toplabel1.png
convert -units pixelsperinch -density 300 -size 500x25 -font "Calibri" -background white -fill black -gravity southeast caption:"$SFB_VERSION" $TMPDIR$uuid/version.png

# prepend pagenumbering to tmp file

echo -e '\pagenumbering{gobble}\n' | cat - $TMPDIR$uuid/"tmp.md" > $TMPDIR$uuid/out && mv $TMPDIR$uuid/out $TMPDIR$uuid/"tmp.md"

# make pdf

# make pdf

cat $TMPDIR$uuid/"tmp.md"  | \
 pandoc  --latex-engine=xelatex --template=$confdir"pandoc_templates/nonumtemplate.tex" \
-o $TMPDIR$uuid/memecard.pdf
# -V "geometry:paperheight=5.0in" -V "geometry:paperwidth=7.0in"

# make png of text
convert -density 400  $TMPDIR$uuid/memecard.pdf  -trim $TMPDIR$uuid/memecard.png
# "if error issued here see comments in includes/1000x3000skyscraper.sh for explanation"

# lay logo & version onto bottom label

convert $TMPDIR$uuid/memecard.png -border 30 $TMPDIR$uuid/memecard.png
# put logo on 1000 px wide & trim
convert $scriptpath"assets/pk35pc.jpg" -resize 20% $TMPDIR$uuid/pksmall.jpg
convert $TMPDIR$uuid"/pksmall.jpg" -gravity west -background white -extent 1024x50 \
$TMPDIR$uuid/memecardlogo.png
 convert -gravity center $TMPDIR$uuid/memecardlogo.png -gravity southeast $TMPDIR$uuid/version.png -composite   $TMPDIR$uuid/bottom.png

# lay image of text onto card background
montage $TMPDIR$uuid/toplabel1.png \
$TMPDIR$uuid"/memecard.png" \
$TMPDIR$uuid/bottom.png  \
-geometry "$memewidth"x"$memeheight" -border 10 -tile 1x10 -mode concatenate \
$TMPDIR$uuid/memecard.png

# create card for delivery to desitnation

convert $TMPDIR$uuid"/memecard.png" -trim -border 30 $TMPDIR$uuid/memecard_delivery.png

echo "built memecard and delivered it to $TMPDIR$uuid/memecard_delivery.png"
