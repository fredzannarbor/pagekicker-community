#!/bin/bash

# stand-alone version of xform.sh routine that
# extracts, analyzes, and summarizes images from permissioned PDF documents

# requires pdfimages, imagemagick, fdupes

# confpath is hard-coded to /opt/bitnami ...

# input: PDF file OR url
# output: unique jpgs, zip, montage

#defaults before command line
source ~/.bashrc
starttime=$(( `date +%s` ))

xformlog="$logdir$uuid"/xform_log

echo "-D-D-D-D-D-D-D-D" | tee --append $xform_logdat
echo "starting Document Analysis Tools Stand-alone"

dat="yes"
# default values


TMPDIR="/tmp/pagekicker/"
buildtarget="$mediatargetpath"
stopimagefolder="none" #default
maximages="4" #default
thumbxsize=120 #default
thumbysize=120 #default
outfile="montage.jpg"
montageurdir="montageur"
flickr="off"
frontmatter="on"
backmatter="on"
montageur="off"

echo "parameter 1 is " $1
echo "parameter 2 is" $2
echo "parameter 3 is" $3
echo "parameter 4 "is $4


while :
do
case $1 in
--help | -\?)
echo "requires PDF filename; example: dat.sh filename"
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
--stopimagefolder)
stopimagefolder=$2
shift 2
;;
--stopimagefolder=*)
stopimagefolder=${1#*=}
shift
;;
--maximages)
maximages=$2
shift 2
;;
--maximages=*)
maximages=${1#*=}
shift
;;
--outfile)
outfile=$2
shift 2
;;
--outfile=*)
outfile=${1#*=}
shift
;;
--environment)
environment=$2
shift 2
;;
--environment=*)
environment=${1#*=}
shift
;;
--montageurdir)
montageurdir=$2
shift 2
;;
--montageurdir=*)
montageurdir=${1#*=}
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
--url)
url=$2
shift 2
;;
--url=*)
url=${1#*=}
shift
;;
--xmldirectoryname)
xmldirectoryname=$2
shift 2
;;
--xmldirectoryname=*)
xmldirectoryname=${1#*=}
shift
;;
--xmlbasefile)
xmlbasefile=$2
shift 2
;;
--xmlbasefile=*)
xmlbasefile=${1#*=}
shift
;;
--flickr)
flickr=$2
shift 2
;;
--flickr=*)
flickr=${1#*=}
shift
;;
--frontmatter)
frontmatter=$2
shift 2
;;
--frontmatter=*)
frontmatter=${1#*=}
shift
;;
--backmatter)
backmatter=$2
shift 2
;;
--backmatter=*)
backmatter=${1#*=}
shift
;;
--cli)
cli=$2
shift 2
;;
--cli=*)
cli=${1#*=}
shift
;;
--buildtarget)
buildtarget=$2
shift 2
;;
--buildtarget=*)
buildtarget=${1#*=}
shift
;;
--getwiki)
getwiki=$2
shift 2
;;
--getwiki=*)
getwiki={1#*=}
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

if [ ! "$passuuid" ] ; then
	echo "creating uuid"
	uuid=$(python  -c 'import uuid; print uuid.uuiddat-1()')
	echo "uuid is" $uuid | tee --append $xform_log
	mkdir -p -m 755 $TMPDIR$uuid
else
	uuid=$passuuid
	echo "received uuid " $uuid
	mkdir -p -m 755 $TMPDIR$uuid
fi


. ../conf/config.txt
echo "loaded  $environment config file at " $datenow | tee --append $xform_log


. $scriptpath"includes/set-variables.sh"

echo "software id in" "$environment" "is" $SFB_VERSION

cd $scriptpath
echo "scriptpath is" $scriptpath

#$export PATH=$PATH:/opt/bitnami/java/bin

#echo "PATH is" $PATH

echo "xmldirectoryname is" $xmldirectoryname
echo "xmlbasename is "$xmlbasefile

if [ "$xmldirectoryname" ] ; then
	xmlfilename=$xmldirectoryname/$xmlbasefile

else

	echo "no xml file specified, so using default.xml file and looking for url"
	xmlfilename="bin/dat/xml/default.xml"
fi

submissionid=$(xmlstarlet sel -t -v "/item/id" "$xmlfilename")
environment=$(xmlstarlet sel -t -v "/item/environment" "$xmlfilename")
echo "environment is" $environment
customer_email=$(xmlstarlet sel -t -v "/item/customer_email" "$xmlfilename")
jobprofilename=$(xmlstarlet sel -t -v "/item/jobprofilename" "$xmlfilename")
echo "jobprofilename is" $jobprofilename
customtitle=$(xmlstarlet sel -t -v "/item/customtitle" "$xmlfilename")
byline=$(xmlstarlet sel -t -v "/item/byline" "$xmlfilename")
imprint=$(xmlstarlet sel -t -v "/item/imprint" "$xmlfilename")
LANG=$(xmlstarlet sel -t -v "/item/lang" "$xmlfilename")
uploaded_tat_file=$(xmlstarlet sel -t -v "/item/uploaded_tat_file" "$xmlfilename")
wordcloud_width=$(xmlstarlet sel -t -v "/item/wordcloud_width" "$xmlfilename")
wordcloud_height=$(xmlstarlet sel -t -v "/item/wordcloud_height" "$xmlfilename")
wordcloud_submit=$(xmlstarlet sel -t -v "/item/wordcloudat-d_submit" "$xmlfilename")
echo "uploaded_tat_file is" $uploaded_tat_file | tee --append $xform_log
getwiki=$(xmlstarlet sel -t -v "/item/getwiki" "$xmlfilename")
# echo "wordcloud_width"=$wordcloud_width "and height =" $wordcloud_height
# summarizer flags


summarizer_on=$(xmlstarlet sel -t -v "/item/summarizer" "$xmlfilename")
summary_length=$(xmlstarlet sel -t -v "/item/summary_length" "$xmlfilename")
positive_seeds=$(xmlstarlet sel -t -v "/item/positive_seeds" "$xmlfilename")
positive_seed_weight=$(xmlstarlet sel -t -v "/item/positive_seed_weight" "$xmlfilename")
negative_seeds=$(xmlstarlet sel -t -v "/item/negative_seeds" "$xmlfilename")
negative_seed_weight=$(xmlstarlet sel -t -v "/item/negative_seed_weight" "$xmlfilename")
summarizer_ngram_threshold=$(xmlstarlet sel -t -v "/item/summarizer_ngram_threshold" "$xmlfilename")
decimator_requested=$(xmlstarlet sel -t -v "/item/decimator_requested" "$xmlfilename")
tldr=$(xmlstarlet sel -t -v "/item/tldr" "$xmlfilename")
url=$(xmlstarlet sel -t -v "/item/url" "$xmlfilename")
echo "summarizer on is" $summarizer_on | tee --append $xform_log
echo "summary length is" $summary_length | tee --append $xform_log
echo "positive_seeds were" $positive_seeds| tee --append $xform_log
echo "positive_seed_weight was" $positive_seed_weight| tee --append $xform_log
echo "negative_seeds were" $negative_seeds| tee --append $xform_log
echo "negative_seed_weight was "$negative_seed_weight| tee --append $xform_log
echo "summarizer_ngram_threshold was" $summarizer_ngram_threshold| tee --append $xform_log
echo "url to fetch is" $url | tee --append $xform_log        
imagekeyword=$(xmlstarlet sel -t -v "/item/imagekeyword" "$xmlfilename")

. ../conf/jobprofiles/"$jobprofilename"".jobprofile"
. ../conf/jobprofiles/imprints/$imprint/$imprint".imprint"
echo "$jobprofile"
echo "$imprint"
echo $WEBFORMSXML_HOME

export LANG

if [ -n "$url" ] ; then 
	echo "downloading file" $url " from Internet" | tee --append $xform_log
	wget --tries=45 "$url" -O $TMPDIR$uuid/downloaded_wget_file.pdf

else

	echo "uploaded file" $uploaded_tat_file "from user's computer" | tee --append $xform_log

fi

a=$submissionid
submissionid_base="${a%.*}"
echo "submissionid_base is" $submissionid_base
if  [ -z "$url" ] ; then
	echo "WEBFORMSHOME is" $WEBFORMSHOME

	cp $WEBFORMSHOME$submissionid_base/300/*/$uploaded_tat_file $TMPDIR$uuid/$uploaded_tat_file 
	cp $WEBFORMSHOME$submissionid_base/300/*/$uploaded_tat_file $scriptpath/scr/debug

else

	echo "renaming uploaded_tat to downloaded_wget"
	uploaded_tat_file="downloaded_wget_file.pdf"

fi

if [ "$decimator_requested" = "Decimator only" ] ; then
	echo "running Decimator only"
	mkdir -p -m 755 $TMPDIR$uuid/decimator
	bin/decimator.sh --pdffile "$TMPDIR$uuid/$uploaded_tat_file" --outdir "$TMPDIR$uuid/decimator" --passuuid "$uuid" --tldr "$tldr"
	sendemail -t "$customer_email" \
	-u "Decimator Result" \
	-m "PageKicker's Document Analysis Robots living on "$MACHINE_NAME "and using version " $SFB_VERSION " of the PageKicker software have analyzed your file " $uploaded_tat_file " in job" $uuid \
       ".  The Decimator slide deck is attached here."  \
	-f "$GMAIL_ID" \
	-cc "$GMAIL_ID" \
	-xu "$GMAIL_ID" \
	-xp "VnenKBENvGa9" \
	-s smtp.gmail.com:587 \
	-o tls=yes \
	-a $TMPDIR$uuid/slides.pdf

	exit 0
elif [ "$decimator_requested" = "Include Decimator" ] ; then
	echo "running Decimator,then rest of TAT"
	bin/decimator.sh --pdffile "$TMPDIR$uuid/$uploaded_tat_file" --outdir "$TMPDIR$uuid/decimator"
else
	echo "Decimator off, proceeding with TAT"
fi

# get basename
filename=$(basename "$TMPDIR$uuid/$uploaded_tat_file")
filename="${filename%.*}"
echo "filename is" $filename  | tee --append $xform_log
# get filename extension
rawextension=$(echo $TMPDIR$uuid/$uploaded_tat_file |  sed 's/.*\.//')
echo "raw extension is" $rawextension | tee --append $xform_log
extension=$(echo $rawextension | tr '[:upper:]' '[:lower:]')
echo "lowercase extension is " $extension | tee --append $xform_log

# make sure there are txt and pdf target files

if [ "$extension" = "txt" ] ; then
	cp $TMPDIR$uuid/$uploaded_tat_file $TMPDIR$uuid/targetfile.txt
	echo "file was .txt so copied it to targetfile"	 | tee --append $xform_log

elif [ "$extension" = "mobi" ] ; then
	xvfb-run --auto-servernum ebook-convert $TMPDIR$uuid/$uploaded_tat_file $TMPDIR$uuid/target.pdf
	echo "converted mobi to pdf" | tee --append $xform_log
	pdftotext $TMPDIR$uuid/mobiconvert.pdf $TMPDIR$uuid/targetfile.txt
	echo "converted resulting PDF to txt" | tee --append $xform_log

elif [ "$extension" = "azw" ] ; then
	xvfb-run --auto-servernum ebook-convert $TMPDIR$uuid/$uploaded_tat_file $TMPDIR$uuid/target.pdf
	echo "converted azw to pdf" | tee --append $xform_log
	pdftotext $TMPDIR$uuid/azwconvert.pdf $TMPDIR$uuid/targetfile.txt
	echo "converted resulting PDF to txt" | tee --append $xform_log

elif [ "$extension" = "epub" ] ; then
	xvfb-run --auto-servernum ebook-convert $TMPDIR$uuid/$uploaded_tat_file $TMPDIR$uuid/target.pdf
	echo "converted epub to pdf" | tee --append $xform_log
	xvfb-run --auto-servernum ebook-convert $TMPDIR$uuid/$uploaded_tat_file $TMPDIR$uuid/targetfile.txt
	echo "converted epub to txt" | tee --append $xform_log

elif [ "$extension" = "pdf" ] ; then
	pdftotext $TMPDIR$uuid/$uploaded_tat_file  $TMPDIR$uuid/targetfile.txt
	cp $TMPDIR$uuid/$uploaded_tat_file $TMPDIR$uuid/target.pdf
	echo "ran pdftotext and copied $TMPDIR$uuid/target.pdf" | tee --append $xform_log
	ls -la $TMPDIR$uuid

else
	unoconv -f txt $TMPDIR$uuid/$uploaded_tat_file
	cp $TMPDIR$uuid/$filename".txt" $TMPDIR$uuid/targetfile.txt
	unoconv -f pdf $TMPDIR$uuid/$uploaded_tat_file -o $TMPDIR$uuid/target.pdf
	echo "file was neither txt, mobi, nor PDF, so converted it to PDF using unoconv" | tee --append $xform_log
	echo "file might contain images so converted it to PDF for montageur" | tee --append $xform_log
fi

if [ "$extension" = "txt" ] ; then
	montageur_success="1" # exit fail
	echo "file was txt, no images, so skipping montageur" | tee --append $xform_log
else
	echo "copying working files into montageur directory" | tee --append $xform_log
	mkdir -p -m 755 $TMPDIR$uuid/montageur
	$scriptpath"bin/montageur.sh" --pdfinfile "$TMPDIR$uuid/target.pdf" --stopimagefolder "$scriptpath"userassets/oreilly/stopimages --passuuid "$uuid" --environment "$environment" --montageurdir "montageur" --maximages "5" --tmpdir "$TMPDIR" --stopimagefolder "none"
	montageur_success="$?"
	if [ "$montageur_success" = 1 ] ; then
		echo "montageur exited with status 1 no images found, skipping montage processing and returning to scriptpath directory" | tee --append $xform_log
	else
		# echo "processing montages"
		cp $TMPDIR$uuid/$montageurdir/montage.jpg $TMPDIR$uuid/montage.jpg
		cp $TMPDIR$uuid/$montageurdir/portrait*.jpg $TMPDIR$uuid
		cp $TMPDIR$uuid/montageurtopn/montagetopn.jpg $TMPDIR$uuid/montagetopn.jpg
		# make montage PDF pages
		for i in $TMPDIR$uuid/portrait*.jpg; do
		convert $i  -density 300 -units pixelsperinch -gravity center -extent 2550x3300 "$i".pdf
		done
		convert $TMPDIR$uuid/montagetopn.jpg -density 300 -units pixelsperinch -gravity center -extent 2550x3300 $TMPDIR$uuid/montagetopn.pdf
		cd $TMPDIR$uuid ; pdftk portrait*.jpg.pdf cat output portraits.pdf; cd $scriptpath
	fi

echo "processed montages, proceeding to text analysis" | tee --append $xform_log

fi

# convert uploaded file to markdown

"$PANDOC_BIN" -t markdown $TMPDIR$uuid/targetfile.txt -o $TMPDIR$uuid/body.md

# run acronym filter

$scriptpath/bin/acronym-filter.sh --txtinfile $TMPDIR$uuid/targetfile.txt > $TMPDIR$uuid/acronyms.txt

# external loop to run NER and summarizer on split file

split -C 50K $TMPDIR$uuid/targetfile.txt "$TMPDIR$uuid/xtarget."

for file in "$TMPDIR$uuid/xtarget."*
do

python $scriptpath"includes/nerv3.py" $file $file"_nouns.txt" 
echo "ran nerv3 on $file" | tee --append $xform_log
python includes/PKsum.py -l "$summary_length" -o $file"_summary.txt" $file
sed -i 's/ \+ / /g' $file"_summary.txt"
cp $file"_summary.txt" $file"_pp_summary.txt"
echo "ran summarizer on $file" | tee --append $xform_log
awk 'length>=50' $file"_pp_summary.txt" > $TMPDIR$uuid/awk.tmp && mv $TMPDIR$uuid/awk.tmp $file"_pp_summary.txt"
#echo "postprocessor threw away summary lines shorter than 50 characters" | tee --append $xform_log
awk 'length<=4000' $file"_pp_summary.txt" > $TMPDIR$uuid/awk.tmp && mv $TMPDIR$uuid/awk.tmp $file"_pp_summary.txt"
#echo "postprocessor threw away summary lines longer than 4000 characters" | tee --append $xform_log
#echo "---end of summary section of 140K bytes---" >> $file"_pp_summary.txt"
#echo "---end of summary section of 140K bytes---" >> $file"_summary.txt"
cat $file"_pp_summary.txt" >> $TMPDIR$uuid/pp_summary.txt
cat $file"_summary.txt" >> $TMPDIR$uuid/summary.txt
#sleep 3
done
ls $TMPDIR$uuid/xtarget.*nouns* > $TMPDIR$uuid/testnouns
cat $TMPDIR$uuid/xtarget.*nouns* > $TMPDIR$uuid/all_nouns.txt
sort $TMPDIR$uuid/all_nouns.txt | uniq > $TMPDIR$uuid/sorted_uniqs.txt
sed -i '1i # Unique Proper Nouns and Key Terms \n' $TMPDIR$uuid/sorted_uniqs.txt
sed -i '2i \' $TMPDIR$uuid/sorted_uniqs.txt
sed -i G $TMPDIR$uuid/sorted_uniqs.txt
cp $TMPDIR$uuid/sorted_uniqs.txt $TMPDIR$uuid/sorted_uniqs.md
sed -i '1i # Programmatically Generated Summary \' $TMPDIR$uuid/pp_summary.txt
sed -i G $TMPDIR$uuid/pp_summary.txt
sed -i '1i # Programmatically Generated Summary \' $TMPDIR$uuid/summary.txt
sed -i G $TMPDIR$uuid/summary.txt

if [ `wc -c < $TMPDIR$uuid/pp_summary.txt` = "0" ] ; then
	echo using "unpostprocessed summary bc wc pp summary = 0"
else
	cp $TMPDIR$uuid/pp_summary.txt $TMPDIR$uuid/summary.md
fi

# readability report

java -jar lib/CmdFlesh.jar $TMPDIR$uuid/targetfile.txt > $TMPDIR$uuid/rr.txt
sed -i 's/Averaage/Average/g' $TMPDIR$uuid/rr.txt
echo "# Readability Report" > $TMPDIR$uuid/rr.md
cat $TMPDIR$uuid/rr.txt >> $TMPDIR$uuid/rr.md
cat assets/rr_explanation.md >> $TMPDIR$uuid/rr.md
"$PANDOC_BIN" $TMPDIR$uuid/rr.md -o $TMPDIR$uuid/rr.html
sed -i G $TMPDIR$uuid/rr.md


echo "ran readability report" | tee --append $xform_log

# wordcloud

java -jar lib/IBMcloud/ibm-word-cloud.jar -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -h "5100" -w "6600" < $TMPDIR$uuid/targetfile.txt > $TMPDIR$uuid/wordcloudbig.png

java -jar lib/IBMcloud/ibm-word-cloud.jar -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -h "3100" -w "2400" < $TMPDIR$uuid/targetfile.txt > $TMPDIR$uuid/wc_front.png

echo "built wordclouds" | tee --append $xform_log

# build page burst

#convert $TMPDIR$uuid/downloaded.pdf -thumbnail 'x300>' -border 2x2 $TMPDIR$uuid/outfile.png
#montage $TMPDIR$uuid/outfile*.png -size 3100x2000\> $TMPDIR$uuid/burst.png
#convert $TMPDIR$uuid/burst.png -resize 3100x2000 $TMPDIR$uuid/big_burst.png

#convert -units pixelsperinch -density 300  -background blue -fill Yellow -gravity west -size 3300x200 -font "$toplabelfont" -pointsize 30 label:"Page Burst" $TMPDIR$uuid/burst_top.png
#convert -units pixelsperinch -density 300 -size 3300x200 xc:blue $TMPDIR$uuid/burst_bot.png

#convert -units pixelsperinch -density 300 $TMPDIR$uuid/canvas.png \
#$TMPDIR$uuid/burst_top.png -gravity north -composite \
#$TMPDIR$uuid/big_burst.png -gravity center -composite \
#$TMPDIR$uuid/burst_bot.png -gravity south -composite \
#$TMPDIR$uuid/pageburst.png


# flickr

if [ "$flickr" = "on" ] ; then

	mkdir -p -m 755 $TMPDIR$uuid/flickr

	python includes/Flickr_title_fetcher.py $TMPDIR$uuid/titles.txt $TMPDIR$uuid/flickr/
	python includes/Flickr_seed_fetcher.py "$imagekeyword" $TMPDIR$uuid/flickr/
	echo "fetched Flickr images on " $imagekeyword | tee --append $xform_log

else

	echo "flickr search was off" | tee --append $xform_log

fi

cp assets/PageKicker_cmyk300dpi.png $TMPDIR$uuid/PageKicker_cmyk300dpi.png
cp ../conf/jobprofiles/imprints/$imprint/$imprintlogo $TMPDIR$uuid/$imprintlogo

if [ "$frontmatter" = "off" ] ; then 

	echo "not building front matter" | tee --append $xform_log
else

	echo "copyright page for this imprint is" $imprintcopyrightpage
	cp ../conf/jobprofiles/imprints/$imprint/$imprintcopyrightpage $TMPDIR$uuid/$imprintcopyrightpage
	# save reports as PDFs

	"$PANDOC_BIN" $TMPDIR$uuid/summary.md -o $TMPDIR$uuid/summary.pdf --latex-engine=xelatex
	"$PANDOC_BIN" $TMPDIR$uuid/all_nouns.txt -o $TMPDIR$uuid/all_nouns.pdf --latex-engine=xelatex
	"$PANDOC_BIN" $TMPDIR$uuid/$imprintcopyrightpage -o $TMPDIR$uuid/copyright_notice.pdf --latex-engine=xelatex
	"$PANDOC_BIN" $TMPDIR$uuid/rr.md -o $TMPDIR$uuid/rr.pdf --latex-engine=xelatex
	"$PANDOC_BIN" $TMPDIR$uuid/sorted_uniqs.txt -o $TMPDIR$uuid/sorted_uniqs.pdf --latex-engine=xelatex

# build wordcloud page


	convert -size 2550x3300 xc:white $TMPDIR$uuid/wc_canvas.jpg 
	convert $TMPDIR$uuid/wc_canvas.jpg $TMPDIR$uuid/wc_front.png -resize 2550x3300 -density 300 -gravity center -composite $TMPDIR$uuid/wordcloud.pdf

	echo "about to build title page"
# (PageKicker_cmyk300dpi.png)
	echo "# "$customtitle > $TMPDIR$uuid/titlepage.md
	echo "# "$editedby >> $TMPDIR$uuid/titlepage.md
	echo "# Enhanced with Text Analytics by PageKicker Robot" $jobprofilename >> $TMPDIR$uuid/titlepage.md

	#if [ -z ${tldr+x} ]; 
	#	then echo "tldr is unset"; 
	#else
	#	echo "# " 'TL;DR:' "$tldr" >> $TMPDIR$uuid/titlepage.md
	#fi
	# echo '![imprint logo]'($imprintlogo)'\' >> $TMPDIR$uuid/titlepage.md
	echo '\pagenumbering{roman}' >> $TMPDIR$uuid/titlepage.md
	echo '\newpage' >> $TMPDIR$uuid/titlepage.md
	# build "also by this Robot Author"
	echo "  " >> $TMPDIR$uuid/titlepage.md
	echo "  " >> $TMPDIR$uuid/titlepage.md
	echo "# Also by PageKicker Robot" $lastname >>  $TMPDIR$uuid/titlepage.md
	cat $confdir"jobprofiles/bibliography/"$lastname/$lastname"_titles.txt" >> $TMPDIR$uuid/titlepage.md
	echo "  " >> $TMPDIR$uuid/titlepage.md
	echo "  " >> $TMPDIR$uuid/titlepage.md
	"$PANDOC_BIN" $TMPDIR$uuid/titlepage.md -o $TMPDIR$uuid/titlepage.pdf --variable fontsize=12pt --latex-engine=xelatex
	cd $scriptpath

	echo "# About the Robot Author" > $TMPDIR$uuid/robot_author.md
	echo "# $lastname" >> $TMPDIR$uuid/robot_author.md
	cat "$authorbio" >> $TMPDIR$uuid/robot_author.md
	cp ../conf/jobprofiles/authorphotos/$authorphoto $TMPDIR$uuid

	echo "built author page"

	# build "Acknowledgements"

	cp assets/acknowledgements.md $TMPDIR$uuid/acknowledgements.md
	echo "sigfile is" $sigfile
	cp ../conf/jobprofiles/signatures/$sigfile $TMPDIR$uuid

	echo "  " >> $TMPDIR$uuid/acknowledgements.md
	echo "  " >> $TMPDIR$uuid/acknowledgements.md

	echo '![author-sig]'"("$sigfile")" >> $TMPDIR$uuid/acknowledgements.md

	echo "built acknowledgments"

	# assemble front matter



	cat $TMPDIR$uuid/titlepage.md assets/newpage.md $TMPDIR$uuid/$imprintcopyrightpage assets/newpage.md $TMPDIR$uuid/robot_author.md assets/newpage.md $TMPDIR$uuid/acknowledgements.md assets/newpage.md $TMPDIR$uuid/summary.md assets/newpage.md $TMPDIR$uuid/rr.md assets/newpage.md $TMPDIR$uuid/sorted_uniqs.md > $TMPDIR$uuid/textfrontmatter.md
	cd $TMPDIR$uuid; "$PANDOC_BIN" textfrontmatter.md --latex-engine=xelatex -o textfrontmatter.pdf ; cd $scriptpath

	echo "assembled front matter"

	# add wordcloud page to front matter


	if [ "$montageur_success" = 0 ] ; then 

		pdftk $TMPDIR$uuid/textfrontmatter.pdf $TMPDIR$uuid/wordcloud.pdf  output $TMPDIR$uuid/$uuid"_frontmatter.pdf"
	# temporarily removed $TMPDIR$uuid/portraits.pdf from front matter as does not seem overly useful
  
	else

		pdftk $TMPDIR$uuid/textfrontmatter.pdf $TMPDIR$uuid/wordcloud.pdf output $TMPDIR$uuid/$uuid"_frontmatter.pdf"

	fi

	echo "appended PDF wordcloud page to PDF front matter"	

	# add front matter to complete text

	#resize uploaded file to letter size

	# gs -sDEVICE=pdfwrite -sPAPERSIZE=letter -dFIXEDMEDIA -dPDFFitPage -dCompatibilityLevel=1.4 -o  $TMPDIR$uuid/lettersize_upload.pdf $TMPDIR$uuid/$uploaded_tat_file
	cp $TMPDIR$uuid/$uploaded_tat_file $TMPDIR$uuid/lettersize_upload.pdf

	pdftk $TMPDIR$uuid/$uuid"_frontmatter.pdf" $TMPDIR$uuid/lettersize_upload.pdf output $TMPDIR$uuid/$uuid"_front_body.pdf"

fi
if [ "$backmatter" = "off" ] ; then
	echo "not building back matter" | tee --append $xform_log
else

	# build back matter beginning with flickr 

	if [ "$flickr" = "on" ] ; then

		cd $TMPDIR$uuid/flickr
		for file in *.md
		do
		       cat $file >> allflickr.md
		       echo '\newpage' >> allflickr.md
		       echo "" >> allflickr.md
		done
		cp *.jpg ..
		cp allflickr.md ..
		cd ..
		"$PANDOC_BIN" -o images.pdf allflickr.md
		cd $scriptpath
		echo "converted flickr md files to pdf pages with images" | tee --append $xform_log
		
	else
		echo "didn't  process flickr files" | tee --append $xform_log
	fi

	# assemble keyword reference appendix

	if [ "$getwiki" = "yes" ] ; then

		sed '/^$/d' $TMPDIR$uuid/all_nouns.txt | sort | uniq -i > $TMPDIR$uuid/seeds
		"$PYTHON_BIN" bin/wikifetcher.py --infile "$TMPDIR$uuid/seeds" --outfile "$TMPDIR$uuid/wikisummaries.md" --lang "en" 
		cp $TMPDIR$uuid/wikisummaries.md $TMPDIR$uuid/original.md 
		sed -e s/\=\=\=\=/xyxyxyxy/g -e s/\=\=\=/xyxyxy/g -e s/\=\=/xyxy/g -e s/xyxyxyxy/\#\#\#\#/g -e s/xyxyxy/\#\#\#/g -e s/xyxy/\#\#/g $TMPDIR$uuid/wikisummaries.md > $TMPDIR$uuid/wikiall.md
		grep -v '\\x' $TMPDIR$uuid/wikiall.md > $TMPDIR$uuid/wikisafe.md # stripping certain escape characters
		cp $TMPDIR$uuid/wikisafe.md $TMPDIR$uuid/wikisummaries.md
		"$PANDOC_BIN" -o $TMPDIR$uuid/wikisummaries.pdf $TMPDIR$uuid/wikisummaries.md --latex-engine=xelatex

	else
		# getwiki =no speeds up performance a lot since fetcher need not run
		touch $TMPDIR$uuid/wikisummaries.md
	fi

	# assemble back matter
	cp $TMPDIR$uuid/wikisummaries.pdf $TMPDIR$uuid/backmatter.pdf

	# flick photos

	# indexes

	# appendixes

	# cp $TMPDIR$uuid/images.pdf $TMPDIR$uuid/backmatter.pdf # temporary, just until more back matter parts are added

	pdftk $TMPDIR$uuid/$uuid"_front_body.pdf" $TMPDIR$uuid/backmatter.pdf output $TMPDIR$uuid/$uuid"_all.pdf"
fi

#build epub with TOC

cd $TMPDIR$uuid
"$PANDOC_BIN" -S -o full_wtoc.epub titlepage.md \
"$imprintcopyrightpage" \
robot_author.md \
summary.md \
rr.md \
sorted_uniqs.md \
body.md \
wikisummaries.md
# temporarily removed flickr/all.md

echo "getwiki is" $getwiki

if [ "$getwiki" = "yes" ] ; then

	"$PANDOC_BIN" -s -S -o research_report.docx titlepage.md \
	"$imprintcopyrightpage" \
	robot_author.md \
	summary.md \
	rr.md \
	sorted_uniqs.md \
	wikisummaries.md

else 
  
	"$PANDOC_BIN" -s -S -o research_report.docx titlepage.md \
	"$imprintcopyrightpage" \
	robot_author.md \
	summary.md \
	rr.md \
	sorted_uniqs.md \

fi

cd $scriptpath

# deliver epub to Magento download builder

ls -la $TMPDIR$uuid/full*
cp $TMPDIR$uuid/full_wtoc.epub "$buildtarget"/full_wtoc.epub

ls -la $buildtarget"f*"

#deliver *Metadata files* to Magento

mkdir -p -m 755 $mediatargetpath$uuid
cp $TMPDIR$uuid/wordcloudbig.png $mediatargetpath$uuid/$sku"wordcloudbig.png"
cp $TMPDIR$uuid/summary.txt $mediatargetpath$uuid/$sku"summary.txt"
cp $TMPDIR$uuid/all_nouns.txt $mediatargetpath$uuid/$sku"all_nouns.txt"
cp $TMPDIR$uuid/rr.pdf $mediatargetpath$uuid/$sku"rr.pdf"
cp $TMPDIR$uuid/acronyms.txt $mediatargetpath$uuid/$sku"acronyms.txt"

if [ "$montageur_success" = 0 ] ; then
	cp $TMPDIR$uuid/montage.jpg $mediatargetpath$uuid/$sku"montage.jpg"
	cp $TMPDIR$uuid/montagetopn.jpg $mediatargetpath$uuid/$sku"montagetopn.jpg"
else
	echo "no montageur files to move"
fi

# concatenate markdown files
cat $TMPDIR$uuid/textfrontmatter.md $TMPDIR$uuid/body.md  > $TMPDIR$uuid/complete.md

# create metadata

if [[ -z "$customtitle" ]] ; then
	productname=`echo "$uploaded_tat_file" | colrm 30`
else
	productname="$customtitle"
fi
echo  "product name is "$productname
mkdir -p -m  755 "$metadatatargetpath$uuid"
cat includes/builder-metadata-header.csv > $metadatatargetpath$uuid/"current-import.csv"
. includes/builder-metadata-footer.sh
# take a number if you are planning to import

import="yes"
if [ "$import" = "yes" ] ; then 

	echo "adding import job to the manifest" 

	echo "$uuid" >> import_status/manifest.csv

	$scriptpath/bin/receiving_dock.sh


else

	echo "not importing this job" 

fi

echo "put docs on webserver where they are available" | tee --append $xform_log

# share

twitter_announcement="no"

if [ "$twitter_announcement" = "yes" ] ; then

        echo -n "t update " > $TMPDIR$uuid/tcommand
        echo -n  \" >> $TMPDIR$uuid/tcommand
        echo -n Just ran Text Analysis Tools job $uuid >> $TMPDIR$uuid/tcommand
        echo -n \" >> $TMPDIR$uuid/tcommand
        . $TMPDIR$uuid/tcommand

else
        echo "no twitter announcement" | tee --append $xform_log

fi

fb_announcement="no"

if [ "$fb_announcement" = "yes" ] ; then

        cloud_delivery_root="$WEB_HOST"
        cloud_delivery_path="magento/media/delivery/uuid/$uuid/"
        cloud_delivery_url=$cloud_delivery_root$cloud_delivery_path"wordcloud.jpg"

        fbcmd PPOST 472605809446163 "PageKicker Robot Igor just ran his Text Analysis Tools and created a wordcloud for $customer_name at $cloud_delivery_url"

else
        echo "no fb notification" | tee --append $xform_log
fi

 # deliver via e-mail

dat_catalog_url="http://www.pagekicker.com/index.php/catalog/document-analysis-results/"$prevsku".html" #prevsku is bug
echo $dat_catalog_url

echo "gmail id is" $GMAIL_ID
echo "gmail pw is " $GMAIL_PASSWORD

if [ "$montageur_success" = 0 ] ; then

sendemail -t "$customer_email" \
	-u "Document Analysis Tools Result" \
	-m "PageKicker's Document Analysis Robots living on "$MACHINE_NAME "and using version " $SFB_VERSION " of the PageKicker software have analyzed your file " $uploaded_tat_file " in job" $uuid \
       ".  A word cloud, an image montage, a list of proper nouns, and a list of possible acronyms have been placed in the PageKicker catalog at" $dat_catalog_url ". Additional files, including a programmatic summary, are attached here." \
	-f "$GMAIL_ID" \
	-cc "$GMAIL_ID" \
	-xu "$GMAIL_ID" \
	-xp "$GMAIL_PASSWORD" \
	-s smtp.gmail.com:587 \
	-o tls=yes \
	-a $TMPDIR$uuid/wordcloudbig.png \
	-a $TMPDIR$uuid/summary.txt \
	-a $TMPDIR$uuid/pp_summary.txt \
	-a $TMPDIR$uuid/all_nouns.txt \
	-a $TMPDIR$uuid/acronyms.txt \
	-a $logdir$uuid"/xform_log" \
	-a $TMPDIR$uuid/rr.md \
	-a $TMPDIR$uuid/research_report.docx \
	-a $TMPDIR$uuid/montage.jpg \
	-a $TMPDIR$uuid/montagetopn.jpg

else	

sendemail -t "$customer_email" \
	-u "Document Analysis Tools Result" \
	-m "PageKicker's Document Analysis Robots living on "$MACHINE_NAME "and using version " $SFB_VERSION " of the PageKicker software have analyzed your file " $uploaded_tat_file " in job" $uuid \
       ".  A word cloud, an image montage, a list of proper nouns, and a list of possible acronyms have been placed in the PageKicker catalog at" $dat_catalog_url ". Additional files, including a programmatic summary, are attached here."  \
	-f "$GMAIL_ID" \
	-cc "$GMAIL_ID" \
	-xu "$GMAIL_ID" \
	-xp "$GMAIL_PASSWORD" \
	-s smtp.gmail.com:587 \
	-o tls=yes \
	-a $TMPDIR$uuid/wordcloudbig.png \
	-a $TMPDIR$uuid/summary.txt \
	-a $TMPDIR$uuid/pp_summary.txt \
	-a $TMPDIR$uuid/all_nouns.txt \
	-a $TMPDIR$uuid/acronyms.txt \
	-a $logdir$uuid/xform_log \
	-a $TMPDIR$uuid/research_report.docx \
	-a $TMPDIR$uuid/rr.md 


fi

# not sending montageur_success correctly I think
