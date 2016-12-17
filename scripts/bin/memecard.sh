#!/bin/bash


font="Adler"
memewidth=1200
memeheight=630

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

# make labels

convert -units pixelsperinch -density 300 -size 1000x50 -font "$font" -background black -fill white -gravity center -border 5  caption:"$tldr" $TMPDIR$uuid/toplabel1.png
convert -units pixelsperinch -density 300 -size 200x15 -font "Calibri" -background white -fill black -gravity southeast caption:"$SFB_VERSION" $TMPDIR$uuid/version.png

echo -e '\pagenumbering{gobble}\n' | cat - $TMPDIR$uuid/"tmp.md" > $TMPDIR$uuid/out && mv $TMPDIR$uuid/out $TMPDIR$uuid/"tmp.md"

# make pdf

cat $TMPDIR$uuid/"tmp.md"  | \
 pandoc  --latex-engine=xelatex --template=$confdir"pandoc_templates/nonumtemplate.tex" \
-o $TMPDIR$uuid/memecard.pdf
# -V "geometry:paperheight=5.0in" -V "geometry:paperwidth=7.0in"

# make png
convert -density 400  $TMPDIR$uuid/memecard.pdf  -trim $TMPDIR$uuid/memecard.png
# "if error issued here see comments in includes/1000x3000skyscraper.sh for explanation"


convert $TMPDIR$uuid/memecard.png -border 30 $TMPDIR$uuid/memecard.png
# put logo on 1000 px wide & trim
convert $scriptpath"assets/pk35pc.jpg" -resize 20% $TMPDIR$uuid/pksmall.jpg
convert $TMPDIR$uuid"/pksmall.jpg" -gravity west -background white -extent 1024x50 \
$TMPDIR$uuid/memecardlogo.png
 convert -gravity center $TMPDIR$uuid/memecardlogo.png -gravity southeast $TMPDIR$uuid/version.png -composite   $TMPDIR$uuid/bottom.png

# make card
montage $TMPDIR$uuid/toplabel1.png \
$TMPDIR$uuid"/memecard.png" \
$TMPDIR$uuid/bottom.png  \
-geometry "$memewidth"x"$memeheight" -border 10 -tile 1x10 -mode concatenate \
$TMPDIR$uuid/memecard.png

convert $TMPDIR$uuid"/memecard.png" -trim -border 30 $TMPDIR$uuid/memecardw1200.png
