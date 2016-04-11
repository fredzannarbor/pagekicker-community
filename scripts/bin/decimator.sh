#!/bin/bash

# converts long PDFs to 10-slide powerpoints

# assumes all PDFs are decrypted

#!/bin/bash

# requires  imagemagick, pdftotext, pdftk, ebook-convert, Cmdflesh.jar
# requires from repository: nerv3.py, wordcloudwrapper.sh


starttime=$(( `date +%s` ))

# parse the command-line very stupidly


. includes/set-variables

. $confdir"config.txt"
echo "running $environment config" > ~/which_xform

echo "version is " $SFB_VERSION

cd $scriptpath
echo "scriptpath is" $scriptpath

export PATH=$PATH:$JAVA_BIN

echo "PATH is" $PATH
# default values


pdfconverter="pdftotext"
outdir="tmp/$uuid/outdir"
reporttitle="Gist"
pdfinfile="no" 
pagekicker_tat_url="http://www.pagekicker.com/index.php/tat"
tldr="none"
toplabelfont="Futura-Std-Extra-Bold" # must be available font

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
	mkdir -m 755 tmp/$uuid
else
	uuid=$passuuid
	echo "received uuid " $uuid
fi

# file processing begins


if [ "$pdfinfile" = "no" ]; then
	wget "$pdfurl" -O tmp/$uuid/downloaded.pdf
	pdfinfile="tmp/$uuid/downloaded.pdf"
	echo "fetched file from internet"
else
	echo "pdfinfile is" $pdfinfile
	cp "$pdfinfile" tmp/$uuid/downloaded.pdf
	echo `ls -l tmp/$uuid/downloaded.pdf`
	echo "fetched file from local file system"
fi

if [ "$pdfconverter" = "pdftotext" ] ; then

echo $pdfconverter
	pdftotext -layout tmp/$uuid/downloaded.pdf tmp/$uuid/targetfile.txt
else
	ebook-convert tmp/$uuid/downloaded.pdf tmp/$uuid/targetfile.txt --no-images --new-pdf-engine
fi


# create standard presentation that is 10 or 12 slides long absolute max

# slide 1 cover
# pdftk "$pdfinfile" cat 1 output tmp/$uuid/outdir/1.pdf



convert \
-colorspace RGB \
-density 300 \
-size 3300x2550 xc:transparent \
-fill black \
-pointsize 30 \
-gravity Center \
-annotate +0+50 "$reporttitle" \
tmp/$uuid/titlepage.pdf

# create word cloud

bin/wordcloudwrapper.sh --txtinfile tmp/$uuid/targetfile.txt --wordcloud_width 3000 --wordcloud_height 2100 --outfile tmp/$uuid/wordcloud

# 3-5 summary slides


split -C 100K tmp/$uuid/targetfile.txt "tmp/$uuid/xtarget."

for file in "tmp/$uuid/xtarget."*
do
	python includes/nerv3.py $file $file"_nouns.txt"
        echo "ran nerv3 on $file" | tee --append $xform_log
        python includes/PKsum.py -l "$summary_length" -o $file"_summary.txt" $file
	sed -i 's/ \+ / /g' $file"_summary.txt"
	cp $file"_summary.txt" $file"_pp_summary.txt"
        echo "ran summarizer on $file" | tee --append $xform_log
        awk 'length>=50' $file"_pp_summary.txt" > tmp/$uuid/awk.tmp && mv tmp/$uuid/awk.tmp $file"_pp_summary.txt"
        echo "postprocessor threw away summary lines shorter than 50 characters" | tee --append $xform_log
	awk 'length<=4000' $file"_pp_summary.txt" > tmp/$uuid/awk.tmp && mv tmp/$uuid/awk.tmp $file"_pp_summary.txt"
        echo "postprocessor threw away summary lines longer than 4000 characters" | tee --append $xform_log
	cp $file"_pp_summary.txt" tmp/$uuid/pp_summary.txt
	cp $file"_summary.txt" tmp/$uuid/summary.txt
        done

# image montage

cd tmp/$uuid
$scriptpath/bin/montageur.sh --pdfinfile downloaded.pdf
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

convert -units pixelsperinch -density 300 -size 3300x2500 xc:white tmp/$uuid/canvas.png

# create slide 1

# header

convert -units pixelsperinch -density 300 -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 caption:"Decimator: long PDFs become 10 easy slides" tmp/$uuid/toplabel1.png

# sample image

mkdir -m 755 tmp/$uuid/pdf
convert -units pixelsperinch -density 300 tmp/$uuid/downloaded.pdf[0] tmp/$uuid/dl-0.jpg
convert tmp/$uuid/dl-0.jpg -bordercolor linen -border 8x8 \
          -background Linen  -gravity SouthEast -splice 10x10+0+0 \
          \( +clone -alpha extract -virtual-pixel black \
             -spread 50 -blur 0x3 -threshold 50% -spread 5 -blur 0x.7 \) \
          -alpha off -compose Copy_Opacity -composite \
          -gravity SouthEast -chop 10x10   tmp/$uuid/dl_torn.png
convert tmp/$uuid/dl_torn.png -resize 1000x2000 tmp/$uuid/dl_top_pane.png

# tldr 


	echo "TL;DR: ""$tldr" > tmp/$uuid/tldr.txt
	convert -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont"  caption:"TL;DR" tmp/$uuid/toplabel2.png
	convert xc:blue -size 3300x200 tmp/$uuid/bottomlabel2.png
	convert -background white -fill black -gravity west -size 1000x2000 -pointsize "96" caption:@tmp/$uuid/tldr.txt tmp/$uuid/tldr.png


# create montage of sample image + TLDR

montage  -units pixelsperinch -density 300 -size 3300x2100 tmp/$uuid/dl_top_pane.png tmp/$uuid/tldr.png tmp/$uuid/p1_montage.png
montage tmp/$uuid/dl_top_pane.png tmp/$uuid/tldr.png -geometry 1500x2000\>+100+100 tmp/$uuid/p1_montage.png
convert -units pixelsperinch -density 300 xc:blue -size 3300x200  tmp/$uuid/bottomlabel1.png
convert -units pixelsperinch -density 300 tmp/$uuid/canvas.png \
tmp/$uuid/toplabel1.png -gravity north -composite \
tmp/$uuid/p1_montage.png -gravity center -composite \
tmp/$uuid/bottomlabel1.png -gravity south -composite \
tmp/$uuid/home.png

#create word cloud slide

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont"  -pointsize 30 label:"Word Cloud" tmp/$uuid/toplabel3.png
convert -units pixelsperinch -density 300 xc:blue -size 3300x200  tmp/$uuid/bottomlabel3.png
convert -units pixelsperinch -density 300 tmp/$uuid/canvas.png \
tmp/$uuid/toplabel3.png -gravity north -composite \
tmp/$uuid/wordcloud.png -gravity center -composite \
tmp/$uuid/bottomlabel3.png -gravity south -composite \
tmp/$uuid/wordcloudslide.png

#create slide 4 image montage

if [ -e "tmp/$uuid/montage.jpg" ] ; then 

	convert -units pixelsperinch -density 300 -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont"  -pointsize 30 label:"Selected Images" tmp/$uuid/toplabel4.png
	convert -units pixelsperinch -density 300 xc:blue -size 3300x200  tmp/$uuid/bottomlabel4.png
	convert -units pixelsperinch -density 300 tmp/$uuid/canvas.png \
	tmp/$uuid/toplabel4.png -gravity north -composite \
	tmp/$uuid/shrunk_montage.png -gravity center -composite \
	tmp/$uuid/bottomlabel4.png -gravity south -composite \
	tmp/$uuid/montage.png
else
	echo "no images in target file, not building image slide"
fi

# create summary sentence slides

sed -n 1p tmp/$uuid/pp_summary.txt | cut -c 1-450 >> tmp/$uuid/sum1.txt 
sed -n 2p tmp/$uuid/pp_summary.txt | cut -c 1-450 >> tmp/$uuid/sum2.txt
sed -n 3p tmp/$uuid/pp_summary.txt | cut -c 1-450 >> tmp/$uuid/sum3.txt
echo -n "..." | tee --append tmp/$uuid/sum1.txt tmp/$uuid/sum2.txt tmp/$uuid/sum3.txt

convert -background white -fill black -gravity west -size 2000x2000 -pointsize "64" caption:@tmp/$uuid/sum1.txt tmp/$uuid/sum1.png
convert -background white -fill black -gravity west -size 2000x2000  caption:@tmp/$uuid/sum2.txt tmp/$uuid/sum2.png
convert -background white -fill black -gravity west -size 2000x2000  -pointsize "64" caption:@tmp/$uuid/sum3.txt tmp/$uuid/sum3.png
 
convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 label:"Sample Sentence 1 of 3" tmp/$uuid/sumtop1.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue tmp/$uuid/sumbot1.png
convert -units pixelsperinch -density 300 tmp/$uuid/canvas.png \
tmp/$uuid/sumtop1.png -gravity north -composite \
tmp/$uuid/sum1.png -gravity center -composite \
tmp/$uuid/sumbot1.png -gravity south -composite \
tmp/$uuid/sum1.png

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200  -font "$toplabelfont" -pointsize 30 label:"Sample Sentence 2 of 3" tmp/$uuid/sumtop2.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue tmp/$uuid/sumbot2.png
convert -units pixelsperinch -density 300 tmp/$uuid/canvas.png \
tmp/$uuid/sumtop2.png -gravity north -composite \
tmp/$uuid/sum2.png -gravity center -composite \
tmp/$uuid/sumbot2.png -gravity south -composite \
tmp/$uuid/sum2.png

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont"  -pointsize 30 label:"Sample Sentence 3 of 3" tmp/$uuid/sumtop3.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue tmp/$uuid/sumbot3.png
convert -units pixelsperinch -density 300 tmp/$uuid/canvas.png \
tmp/$uuid/sumtop3.png -gravity north -composite \
tmp/$uuid/sum3.png -gravity center -composite \
tmp/$uuid/sumbot3.png -gravity south -composite \
tmp/$uuid/sum3.png

# burst slide

convert tmp/$uuid/downloaded.pdf -thumbnail 'x300>' -border 2x2 tmp/$uuid/outfile.png
montage tmp/$uuid/outfile*.png -size 3100x2000\> tmp/$uuid/burst.png
convert tmp/$uuid/burst.png -resize 3100x2000 tmp/$uuid/big_burst.png

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 label:"Page Burst" tmp/$uuid/burst_top.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue tmp/$uuid/burst_bot.png

convert -units pixelsperinch -density 300 tmp/$uuid/canvas.png \
tmp/$uuid/burst_top.png -gravity north -composite \
tmp/$uuid/big_burst.png -gravity center -composite \
tmp/$uuid/burst_bot.png -gravity south -composite \
tmp/$uuid/pageburst.png


# sample pages slide

convert tmp/$uuid/downloaded.pdf[1] tmp/$uuid/p1.png
convert tmp/$uuid/downloaded.pdf[3] tmp/$uuid/p2.png

montage tmp/$uuid/p1.png tmp/$uuid/p2.png -geometry 1500x2000+100+100 -tile 2x1 tmp/$uuid/samplepages.png

convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 label:"Sample Pages" tmp/$uuid/pagestop.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue tmp/$uuid/pagesbot.png

convert -units pixelsperinch -density 300 tmp/$uuid/canvas.png \
tmp/$uuid/pagestop.png -gravity north -composite \
tmp/$uuid/samplepages.png -gravity center -composite \
tmp/$uuid/pagesbot.png -gravity south -composite \
tmp/$uuid/pages.png

# keywords slide

#clean up markdown of keyword files

sed '/^$/d' peoples.apiresults | sed 's/^/-/' | head -8  > tmp/$uuid/peoples
sed '/^$/d' places.apiresults | sed 's/^/-/' | head -8 > tmp/$uuid/places
sed '/^$/d' others.apiresults | sed 's/^/-/' | head -8 > tmp/$uuid/others

echo "People:" >> tmp/$uuid/peoples.txt
echo "Places:" >> tmp/$uuid/places.txt
echo "Others:" >> tmp/$uuid/others.txt

cat tmp/$uuid/peoples >> tmp/$uuid/peoples.txt
cat tmp/$uuid/places >> tmp/$uuid/places.txt
cat tmp/$uuid/others >> tmp/$uuid/others.txt

echo "(more ...)" | tee --append tmp/$uuid/peoples.txt tmp/$uuid/places.txt tmp/$uuid/others.txt

convert -units pixelsperinch -density 300 -background white -fill black -gravity west -size 800x1600 -pointsize 22  caption:@tmp/$uuid/peoples.txt tmp/$uuid/people.png
convert -units pixelsperinch -density 300  -background white -fill black -gravity west -size 800x1600 -pointsize 22 caption:@tmp/$uuid/places.txt tmp/$uuid/places.png
convert -units pixelsperinch -density 300 -background white -fill black -gravity west -size 800x1600 -pointsize 22 caption:@tmp/$uuid/others.txt tmp/$uuid/others.png

montage tmp/$uuid/people.png tmp/$uuid/places.png tmp/$uuid/others.png -geometry 800x1600+100+100 -tile 3x1 tmp/$uuid/keywords.png


convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200  -font "$toplabelfont" -pointsize 30 label:"Keywords" tmp/$uuid/keytop.png
convert -units pixelsperinch -density 300 -size 3300x200 xc:blue tmp/$uuid/keybot.png

convert -units pixelsperinch -density 300 tmp/$uuid/canvas.png \
tmp/$uuid/keytop.png -gravity north -composite \
tmp/$uuid/keywords.png -gravity center -composite \
tmp/$uuid/keybot.png -gravity south -composite \
tmp/$uuid/keywords.png


# create readability report slide

cp tmp/$uuid/downloaded.pdf tmp/$uuid/targetfile.pdf
pdftotext tmp/$uuid/targetfile.pdf tmp/$uuid/targetfile.txt
java -jar lib/CmdFlesh.jar tmp/$uuid/targetfile.txt > tmp/$uuid/rr.txt
sed -i 's/Averaage/Average/g' tmp/$uuid/rr.txt
echo "# Readability Report" >> tmp/$uuid/rr.md
cat tmp/$uuid/rr.txt >> tmp/$uuid/rr.md
cat assets/rr_decimator_explanation.md >> tmp/$uuid/rr.md
sed -i G tmp/$uuid/rr.md
pandoc tmp/$uuid/rr.md -o tmp/$uuid/rr.txt
convert -units pixelsperinch -density 300 -size 3100x2000 -background white -fill black label:@tmp/$uuid/rr.txt tmp/$uuid/rr.png
convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 caption:"Readability Report" tmp/$uuid/toplabel9.png
convert -units pixelsperinch -density 300 xc:blue -size 3300x200 tmp/$uuid/bottomlabel9.png
convert -units pixelsperinch -density 300 tmp/$uuid/canvas.png \
tmp/$uuid/toplabel9.png -gravity north -composite \
tmp/$uuid/rr.png -gravity center -composite \
tmp/$uuid/bottomlabel9.png -gravity south -composite \
tmp/$uuid/rrslide.png


echo "# Bonus Slide: Learn More About This PDF" >> tmp/$uuid/moreinfo.md
echo " Read the full text at ["$pdfurl"]("$pdfurl')' >> tmp/$uuid/moreinfo.md
echo "  " >> tmp/$uuid/moreinfo.md
echo "[Additional analysis tools at "$pagekicker_tat_url"]($pagekicker_tat_url)" >> tmp/$uuid/moreinfo.md
pandoc -t beamer -V theme:AnnArbor --latex-engine=xelatex tmp/$uuid/moreinfo.md -o tmp/$uuid/moreinfo.pdf


convert -units pixelsperinch -density 300 tmp/$uuid/home.png  tmp/$uuid/wordcloudslide.png tmp/$uuid/sum1.png tmp/$uuid/sum2.png tmp/$uuid/sum3.png tmp/$uuid/pageburst.png tmp/$uuid/pages.png tmp/$uuid/montage.png tmp/$uuid/keywords.png tmp/$uuid/rrslide.png  -size 3300x2550 tmp/$uuid/slidedeck.pdf

pdftk tmp/$uuid/slidedeck.pdf tmp/$uuid/moreinfo.pdf cat output tmp/$uuid/slides.pdf


# publish this slide to slideshare?


