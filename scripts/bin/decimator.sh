#!/bin/bash

# converts long PDFs to 10-slide powerpoints

# assumes all PDFs are decrypted

#!/bin/bash

# requires  imagemagick, pdftotext, pdftk, ebook-convert, Cmdflesh.jar
# requires from repository: nerv3.py, wordcloudwrapper.sh


starttime=$(( `date +%s` ))

echo "*********************DECIMATOR**********************"

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

. includes/set-variables.sh

echo "running $environment "

echo "version is " $SFB_VERSION

cd $scriptpath
echo "scriptpath is" $scriptpath

export PATH=$PATH:$JAVA_BIN

pdfconverter="pdftotext"
outdir="$TMPDIR$uuid/outdir"
reporttitle="Gist"
pdfinfile="no"
pagekicker_tat_url="http://www.pagekicker.com/index.php/tat"
tldr="none"
toplabelfontname="WatersTitlingPro-Bd"
toplabelfont="$toplabelfontname" # must be available font

# command line processing

while :
do
case $1 in
--help | -\?)
echo "requires user to provide path to directory containing one or more txt files"
exit 0  # This is not an error, the user requested help, so do not exit status 1.
;;
--pdfinfile)
pdfinfile=$2
shift 2
;;
--pdfinfile=*)
pdfinfile=${1#*=}
shift
;;
--pdfurl)
pdfurl=$2
shift 2
;;
--pdfurl=*)
pdfurl=${1#*=}
shift
;;
--outdir)
outdir=$2
shift 2
;;
--outdir=*)
outdir=${1#*=}
shift
;;
--reporttitle)
reporttitle=$2
shift 2
;;
--reporttitle=*)
reporttitle=${1#*=}
shift
;;
--tldr)
tldr=$2
shift 2
;;
tldr=*)
--tldr=${1#*=}
shift
;;
--passuuid)
passuuid=$2
shift 2
;;
--passuuid=*)
passuuid=${1#*=}
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

# Suppose some options are required. Check that we got them.

if [ ! "$pdfinfile" ]; then
  echo "ERROR: option '--pdfinfile' not given. See --help" >&2
   exit 1
fi

if [ ! "$passuuid" ] ; then
	echo "creating uuid"
	uuid=$(python  -c 'import uuid; print uuid.uuid1()')
	echo "uuid is" $uuid | tee --append $xform_log
	mkdir -p -m 755 $TMPDIR$uuid
else
	uuid=$passuuid
	echo "received uuid " $uuid
fi

# file processing begins

if [ "$pdfinfile" = "no" ]; then
	wget "$pdfurl" -O $TMPDIR$uuid/downloaded.pdf
	pdfinfile="$TMPDIR$uuid/downloaded.pdf"
	echo "fetched file from internet"
else
	echo "pdfinfile is" $pdfinfile
	cp "$pdfinfile" $TMPDIR$uuid/downloaded.pdf
	echo `ls -l $TMPDIR$uuid/downloaded.pdf`
	echo "fetched file from local file system"
fi

if [ "$pdfconverter" = "pdftotext" ] ; then

echo $pdfconverter
	pdftotext -layout $TMPDIR$uuid/downloaded.pdf $TMPDIR$uuid/targetfile.txt
else
	ebook-convert $TMPDIR$uuid/downloaded.pdf $TMPDIR$uuid/targetfile.txt --no-images --new-pdf-engine
fi
ls -lart $TMPDIR$uuid/targetfile.txt

# create standard presentation that is 10 or 12 slides long absolute max

# slide 1 cover
# pdftk "$pdfinfile" cat 1 output $TMPDIR$uuid/outdir/1.pdf



convert \
-colorspace RGB \
-density 300 \
-size 3300x2550 xc:transparent \
-fill black \
-pointsize 30 \
-gravity Center \
-annotate +0+50 "$reporttitle" \
$TMPDIR$uuid/titlepage.pdf

# create word cloud

bin/wordcloudwrapper.sh --txtinfile $TMPDIR$uuid/targetfile.txt --wordcloud_width 3000 --wordcloud_height 2100 --outfile $TMPDIR$uuid/wordcloud

# 3-5 summary slides


split -C 100K $TMPDIR$uuid/targetfile.txt $TMPDIR$uuid/xtarget.
echo $PYTHON_BIN

for file in $TMPDIR$uuid/xtarget.*
do
	"$PYTHON27_BIN" bin/nerv3.py $file $file"_nouns.txt" $uuid
        echo "ran nerv3 on $file" | tee --append $xform_log
        "$PYTHON_BIN" bin/PKsum.py -l "$summary_length" -o $file"_summary.txt" $file
	sed -i 's/ \+ / /g' $file"_summary.txt"
	cp $file"_summary.txt" $file"_pp_summary.txt"
        echo "ran summarizer on $file" | tee --append $xform_log
        awk 'length>=50' $file"_pp_summary.txt" > $TMPDIR$uuid/awk.tmp && mv $TMPDIR$uuid/awk.tmp $file"_pp_summary.txt"
        echo "postprocessor threw away summary lines shorter than 50 characters" | tee --append $xform_log
	awk 'length<=4000' $file"_pp_summary.txt" > $TMPDIR$uuid/awk.tmp && mv $TMPDIR$uuid/awk.tmp $file"_pp_summary.txt"
        echo "postprocessor threw away summary lines longer than 4000 characters" | tee --append $xform_log
	cat $file"_pp_summary.txt" >> $TMPDIR$uuid/pp_summary_all.txt
	cat $file"_summary.txt" >> $TMPDIR$uuid/summary_all.txt
        done

# image montage

cd $TMPDIR$uuid
"$scriptpath"bin/montageur.sh --pdfinfile $pdfinfile --passuuid $uuid
if [ -e "montage.jpg" ] ; then
	convert montage.jpg -resize 3000x2000\> shrunk_montage.png
	echo "built shrunk montage"
else
	echo "no images in target file, not building shrunk montage"
fi
cd $scriptpath
echo $(pwd)


# final summary (human provided)

# create slide background

convert -units pixelsperinch -density 300 -size 3300x2500 xc:white $TMPDIR$uuid/canvas.png

# create slide 1

# header

convert -units pixelsperinch -density 300 -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 caption:"Decimator: long PDFs become 10 easy slides" $TMPDIR$uuid/toplabel1.png

# sample image

mkdir -p -m 755 $TMPDIR$uuid/pdf
convert -units pixelsperinch -resize 1000x2000  -density 300 $TMPDIR$uuid/downloaded.pdf[0] $TMPDIR$uuid/dl-0.jpg
# convert $TMPDIR$uuid/dl-0.jpg -bordercolor linen -border 8x8 \
#           -background Linen  -gravity SouthEast -splice 10x10+0+0 \
#           \( +clone -alpha extract -virtual-pixel black \
#              -spread 50 -blur 0x3 -threshold 50% -spread 5 -blur 0x.7 \) \
#           -alpha off -compose Copy_Opacity -composite \
#           -gravity SouthEast -chop 10x10   $TMPDIR$uuid/dl_torn.png
# convert $TMPDIR$uuid/dl_torn.png -resize 1000x2000 $TMPDIR$uuid/dl_top_pane.png
cp $TMPDIR$uuid/dl-0.jpg $TMPDIR$uuid/dl_top_pane.png

# tldr

	echo "TL;DR: ""$tldr" > $TMPDIR$uuid/tldr.txt
	convert -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont"  caption:"TL;DR" $TMPDIR$uuid/toplabel2.png
	convert xc:blue -size 3300x200 $TMPDIR$uuid/bottomlabel2.png
	convert -background white -fill black -gravity west -size 1000x2000 -pointsize "96" caption:@$TMPDIR$uuid/tldr.txt $TMPDIR$uuid/tldr.png


# create montage of sample image + TLDR

montage  -units pixelsperinch -density 300 -size 3300x2100 $TMPDIR$uuid/dl-0.jpg $TMPDIR$uuid/tldr.png $TMPDIR$uuid/p1_montage.png
montage $TMPDIR$uuid/dl_top_pane.png $TMPDIR$uuid/tldr.png -geometry 1500x2000\>+100+100 $TMPDIR$uuid/p1_montage.png
convert -units pixelsperinch -density 300 xc:blue -size 3300x200  $TMPDIR$uuid/bottomlabel1.png
convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
$TMPDIR$uuid/toplabel1.png -gravity north -composite \
$TMPDIR$uuid/p1_montage.png -gravity center -composite \
$TMPDIR$uuid/bottomlabel1.png -gravity south -composite \
$TMPDIR$uuid/home.png

#create word cloud slide

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont"  -pointsize 30 label:"Word Cloud" $TMPDIR$uuid/toplabel3.png
convert -units pixelsperinch -density 300 xc:blue -size 3300x200  $TMPDIR$uuid/bottomlabel3.png
convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
$TMPDIR$uuid/toplabel3.png -gravity north -composite \
$TMPDIR$uuid/wordcloud.png -gravity center -composite \
$TMPDIR$uuid/bottomlabel3.png -gravity south -composite \
$TMPDIR$uuid/wordcloudslide.png

#create slide 4 image montage

if [ -e "$TMPDIR$uuid/montage.jpg" ] ; then

	convert -units pixelsperinch -density 300 -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont"  -pointsize 30 label:"Selected Images" $TMPDIR$uuid/toplabel4.png
	convert -units pixelsperinch -density 300 xc:blue -size 3300x200  $TMPDIR$uuid/bottomlabel4.png
	convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
	$TMPDIR$uuid/toplabel4.png -gravity north -composite \
	$TMPDIR$uuid/shrunk_montage.png -gravity center -composite \
	$TMPDIR$uuid/bottomlabel4.png -gravity south -composite \
	$TMPDIR$uuid/montage.png
else
	echo "no images in target file, not building image slide"
fi

# create summary sentence slides

sed -n 1p $TMPDIR$uuid/pp_summary_all.txt | cut -c 1-450 >> $TMPDIR$uuid/sum1.txt
sed -n 2p $TMPDIR$uuid/pp_summary_all.txt | cut -c 1-450 >> $TMPDIR$uuid/sum2.txt
sed -n 3p $TMPDIR$uuid/pp_summary_all.txt | cut -c 1-450 >> $TMPDIR$uuid/sum3.txt
echo -n "..." | tee --append $TMPDIR$uuid/sum1.txt $TMPDIR$uuid/sum2.txt $TMPDIR$uuid/sum3.txt

convert -background white -fill black -gravity west -size 2000x2000 -pointsize "64" caption:@$TMPDIR$uuid/sum1.txt $TMPDIR$uuid/sum1.png
convert -background white -fill black -gravity west -size 2000x2000  caption:@$TMPDIR$uuid/sum2.txt $TMPDIR$uuid/sum2.png
convert -background white -fill black -gravity west -size 2000x2000  -pointsize "64" caption:@$TMPDIR$uuid/sum3.txt $TMPDIR$uuid/sum3.png

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 label:"Sample Sentence 1 of 3" $TMPDIR$uuid/sumtop1.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue $TMPDIR$uuid/sumbot1.png
convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
$TMPDIR$uuid/sumtop1.png -gravity north -composite \
$TMPDIR$uuid/sum1.png -gravity center -composite \
$TMPDIR$uuid/sumbot1.png -gravity south -composite \
$TMPDIR$uuid/sum1.png

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200  -font "$toplabelfont" -pointsize 30 label:"Sample Sentence 2 of 3" $TMPDIR$uuid/sumtop2.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue $TMPDIR$uuid/sumbot2.png
convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
$TMPDIR$uuid/sumtop2.png -gravity north -composite \
$TMPDIR$uuid/sum2.png -gravity center -composite \
$TMPDIR$uuid/sumbot2.png -gravity south -composite \
$TMPDIR$uuid/sum2.png

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont"  -pointsize 30 label:"Sample Sentence 3 of 3" $TMPDIR$uuid/sumtop3.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue $TMPDIR$uuid/sumbot3.png
convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
$TMPDIR$uuid/sumtop3.png -gravity north -composite \
$TMPDIR$uuid/sum3.png -gravity center -composite \
$TMPDIR$uuid/sumbot3.png -gravity south -composite \
$TMPDIR$uuid/sum3.png

# burst slide

convert $TMPDIR$uuid/downloaded.pdf -thumbnail 'x300>' -border 2x2 $TMPDIR$uuid/outfile.png
montage $TMPDIR$uuid/outfile*.png -size 3100x2000\> $TMPDIR$uuid/burst.png
convert $TMPDIR$uuid/burst.png -resize 3100x2000 $TMPDIR$uuid/big_burst.png

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 label:"Page Burst" $TMPDIR$uuid/burst_top.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue $TMPDIR$uuid/burst_bot.png

convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
$TMPDIR$uuid/burst_top.png -gravity north -composite \
$TMPDIR$uuid/big_burst.png -gravity center -composite \
$TMPDIR$uuid/burst_bot.png -gravity south -composite \
$TMPDIR$uuid/pageburst.png


# sample pages slide

convert $TMPDIR$uuid/downloaded.pdf[1] $TMPDIR$uuid/p1.png
convert $TMPDIR$uuid/downloaded.pdf[3] $TMPDIR$uuid/p2.png

montage $TMPDIR$uuid/p1.png $TMPDIR$uuid/p2.png -geometry 1500x2000+100+100 -tile 2x1 $TMPDIR$uuid/samplepages.png

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 label:"Sample Pages" $TMPDIR$uuid/pagestop.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue $TMPDIR$uuid/pagesbot.png

convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
$TMPDIR$uuid/pagestop.png -gravity north -composite \
$TMPDIR$uuid/samplepages.png -gravity center -composite \
$TMPDIR$uuid/pagesbot.png -gravity south -composite \
$TMPDIR$uuid/pages.png

# keywords slide

#clean up markdown of keyword files

sed '/^$/d' $TMPDIR$uuid/People | sed 's/^/-/' | head -8  > $TMPDIR$uuid/peoples
sed '/^$/d' $TMPDIR$uuid/Places | sed 's/^/-/' | head -8 > $TMPDIR$uuid/places
sed '/^$/d' $TMPDIR$uuid/Other | sed 's/^/-/' | head -8 > $TMPDIR$uuid/others

echo "People:" >> $TMPDIR$uuid/peoples.txt
echo "Places:" >> $TMPDIR$uuid/places.txt
echo "Others:" >> $TMPDIR$uuid/others.txt

cat $TMPDIR$uuid/peoples >> $TMPDIR$uuid/peoples.txt
cat $TMPDIR$uuid/places >> $TMPDIR$uuid/places.txt
cat $TMPDIR$uuid/others >> $TMPDIR$uuid/others.txt

echo "(more ...)" | tee --append $TMPDIR$uuid/peoples.txt $TMPDIR$uuid/places.txt $TMPDIR$uuid/others.txt

convert -units pixelsperinch -density 300 -background white -fill black -gravity west -size 800x1600 -pointsize 22  caption:@$TMPDIR$uuid/peoples.txt $TMPDIR$uuid/people.png
convert -units pixelsperinch -density 300  -background white -fill black -gravity west -size 800x1600 -pointsize 22 caption:@$TMPDIR$uuid/places.txt $TMPDIR$uuid/places.png
convert -units pixelsperinch -density 300 -background white -fill black -gravity west -size 800x1600 -pointsize 22 caption:@$TMPDIR$uuid/others.txt $TMPDIR$uuid/others.png

montage $TMPDIR$uuid/people.png $TMPDIR$uuid/places.png $TMPDIR$uuid/others.png -geometry 800x1600+100+100 -tile 3x1 $TMPDIR$uuid/keywords.png


convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200  -font "$toplabelfont" -pointsize 30 label:"Keywords" $TMPDIR$uuid/keytop.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue $TMPDIR$uuid/keybot.png

convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
$TMPDIR$uuid/keytop.png -gravity north -composite \
$TMPDIR$uuid/keywords.png -gravity center -composite \
$TMPDIR$uuid/keybot.png -gravity south -composite \
$TMPDIR$uuid/keywords.png


# create readability report slide

cp $TMPDIR$uuid/downloaded.pdf $TMPDIR$uuid/targetfile.pdf
pdftotext $TMPDIR$uuid/targetfile.pdf $TMPDIR$uuid/targetfile.txt
java -jar lib/CmdFlesh.jar $TMPDIR$uuid/targetfile.txt > $TMPDIR$uuid/rr.txt
sed -i 's/Averaage/Average/g' $TMPDIR$uuid/rr.txt
echo "# Readability Report" >> $TMPDIR$uuid/rr.md
cat $TMPDIR$uuid/rr.txt >> $TMPDIR$uuid/rr.md
cat assets/rr_decimator_explanation.md >> $TMPDIR$uuid/rr.md
sed -i G $TMPDIR$uuid/rr.md
"$PANDOC_BIN" $TMPDIR$uuid/rr.md -o $TMPDIR$uuid/rr.txt
convert -units pixelsperinch -density 300 -size 3100x2000 -background white -fill black label:@$TMPDIR$uuid/rr.txt $TMPDIR$uuid/rr.png
convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 caption:"Readability Report" $TMPDIR$uuid/toplabel9.png
convert -units pixelsperinch -density 300 xc:blue -size 3300x200 $TMPDIR$uuid/bottomlabel9.png
convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
$TMPDIR$uuid/toplabel9.png -gravity north -composite \
$TMPDIR$uuid/rr.png -gravity center -composite \
$TMPDIR$uuid/bottomlabel9.png -gravity south -composite \
$TMPDIR$uuid/rrslide.png


echo "# Bonus Slide: Learn More About This PDF" >> $TMPDIR$uuid/moreinfo.md
echo " Read the full text at ["$pdfurl"]("$pdfurl')' >> $TMPDIR$uuid/moreinfo.md
echo "  " >> $TMPDIR$uuid/moreinfo.md
echo "[Additional analysis tools at "$pagekicker_tat_url"]($pagekicker_tat_url)" >> $TMPDIR$uuid/moreinfo.md
"$PANDOC_BIN" -t beamer -V theme:AnnArbor --latex-engine=xelatex $TMPDIR$uuid/moreinfo.md -o $TMPDIR$uuid/moreinfo.pdf


convert -units pixelsperinch -density 300 $TMPDIR$uuid/home.png  $TMPDIR$uuid/wordcloudslide.png $TMPDIR$uuid/sum1.png $TMPDIR$uuid/sum2.png $TMPDIR$uuid/sum3.png $TMPDIR$uuid/pageburst.png $TMPDIR$uuid/pages.png $TMPDIR$uuid/montage.png $TMPDIR$uuid/keywords.png $TMPDIR$uuid/rrslide.png  -size 3300x2550 $TMPDIR$uuid/slidedeck.pdf

pdftk $TMPDIR$uuid/slidedeck.pdf $TMPDIR$uuid/moreinfo.pdf cat output $TMPDIR$uuid/slides.pdf


# publish this slide to slideshare?
