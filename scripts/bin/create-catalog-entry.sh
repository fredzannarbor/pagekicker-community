#!/bin/bash

echo "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"

TEXTDOMAIN=SFB # required for bash language awareness
echo $"hello, world, I am speaking" $LANG

if [ ! -f "$HOME"/.pagekicker/config.txt ]; then
	echo "config file not found, creating /home/<user>/.pagekicker, put config file there"
	mkdir -p -m 755 "$HOME"/.pagekicker
	echo "exiting"
	exit 1
else
	. "$HOME"/.pagekicker/config.txt
	echo "read config file from $HOME""/.pagekicker/config.txt"
fi


echo "software version number is" $SFB_VERSION

echo "sfb_log is" $sfb_log

echo "completed reading config file and  beginning logging at" `date +'%m/%d/%y%n %H:%M:%S'`
#echo $PATH
# echo "I am" $(whoami)
starttime=$(( `date +%s` ))

sku=`tail -1 < "$LOCAL_DATA""SKUs/sku_list"`
echo "sku" $sku

. includes/set-variables.sh

while :
do
case $1 in
--help | -\?)
echo "for help review source code for now"
exit 0  # This is not an error, the user requested help, so do not exit status 1.
;;
--xmlfilename)
xmlfilename=$2
shift 2
;;
--xmlfilename=*)
xmlfilename=${1#*=}
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
--seedfile)
seedfile=$2
shift 2
;;
--seedfile=*)
seedfile=${1#*=}
shift
;;
--pdfdir)
pdfdir=$2
shift 2
;;
--pdfdir*)
pdfdir=${1#*=}
shift
;;
--pdf_infile)
pdf_infile=$2
shift 2
;;
--pdf_infile*)
pdf_infile=${1#*=}
shift
;;
--txt_infile)
txt_infile=$2
shift 2
;;
--txt_infile*)
txt_infile=${1#*=}
shift
;;
--url_infile)
url_infile=$2
shift 2
;;
--url_infile*)
url_infile=${1#*=}
shift
;;
--csv_infile)
csv_infile=$2
shift 2
;;
--csv_infile=*)
csv_infile=${1#*=}
shift
;;
--booktype)
booktype=$2
shift 2
;;
--booktype=*)
booktype=${1#*=}
shift
;;
--booktitle)
booktitle=$2
shift 2
;;
--booktitle=*)
booktitle=${1#*=}
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
--singleseed)
singleseed=$2
shift 2
;;
--singleseed=*)
singleseed=${1#*=}
shift
;;
--truncate_seed)
truncate_seed=$2
shift 2
;;
--truncate_seed=*)
truncate_seed=${1#*=}
shift
;;
--builder)
builder=$2
shift 2
;;
--builder=*)
builder=${1#*=}
shift
;;
--yourname)
yourname=$2
shift 2
;;
--yourname=*)
yourname=${1#*=}
shift
;;
--mailtoadmin)
mailtoadmin=$2
shift 2
;;
--mailtoadmin=*)
mailtoadmin=${1#*=}
shift
;;
--storecode)
storecode=$2
shift 2
;;
--storecode=*)
storecode=${1#*=}
shift
;;
--websites)
websites=$2
shift 2
;;
--websites=*)
websites=${1#*=}
shift
;;
--attribute_set)
attribute_set=$2
shift 2
;;
--attribute_set=*)
attribute_set=${1#*=}
shift
;;
--type)
type=$2
shift 2
;;
--type=*)
type=${1#*=}
shift
;;
--categories)
categories=$2
shift 2
;;
--categories=*)
categories=${1#*=}
shift
;;
--customerid)
customerid=$2
shift 2
;;
--customerid=*)
customerid=${1#*=}
shift
;;
--status)
status=$2
shift 2
;;
--status=*)
status=${1#*=}
shift
;;
--visibility)
visibility=$2
shift 2
;;
--visibility=*)
visibility=${1#*=}
shift
;;
--featured)
featured=$2
shift 2
;;
--featured=*)
featured=${1#*=}
shift
;;
--special_to_buffer)
special_to_buffer=$2
shift 2
;;
--special_to_buffer=*)
special_to_buffer=${1#*=}
shift
;;
--storeids)
storeids=$2
shift 2
;;
--storeids=*)
storeids=${1#*=}
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
--booktitle)
booktitle=$2
shift 2
;;
--booktitle=*)
booktitle=${1#*=}
shift
;;
--exemplar_file)
exemplar_file=$2
shift 2
;;
--exemplar_file=*)
exemplar_file=${1#*=}
shift
;;
--jobprofilename)
jobprofilename=$2
shift 2
;;
--jobprofilename=*)
jobprofilename=${1#*=}
shift
;;
--wikilang)
wikilang=$2
shift 2
;;
--wikilang=*)
wikilang=${1#*=}
shift
;;
--covercolor)
covercolor=$2
shift 2
;;
--covercolor=*)
covercolor=${1#*=}
shift
;;
--coverfont)
coverfont=$2
shift 2
;;
--coverfont=*)
coverfont=${1#*=}
shift
;;
--revenue_share)
revenue_share=$2
shift 2
;;
--revenue_share=*)
revenue_share=${1#*=}
shift
;;
--tldr)
tldr=$2
shift 2
;;
--tldr=*)
tldr=${1#*=}
shift
;;
--format)
format=$2
shift 2
;;
--format=*)
format=${1#*=}
shift
;;
--yourname)
yourname=$2
shift 2
;;
--yourname=*)
yourname=${1#*=}
shift
;;
--book_description)
book_description=$2
shift 2
;;
--book_description=*)
book_description=${1#*=}
shift
;;
--seedphrases)
seedphrases=$2
shift 2
;;
--seedphrases=*)
seedphrases=${1#*=}
shift
;;
--import)
import=$2
shift 2
;;
--import=*)
import=${1#*=}
shift
;;
--batch_uuid)
batch_uuid=$2
shift 2
;;
--batch_uuid=*)
batch_uuid=${1#*=}
shift
;;
--editedby)
editedby=$2
shift 2
;;
--editedby=*)
editedby=${1#*=}
shift
;;
--subtitle)
subtitle=$2
shift 2
;;
--subtitle=*)
subtitle=${1#*=}
shift
;;
--add_corpora)
add_corpora=$2
shift 2
;;
--add_corpora=*)
add_corpora=${1#*=}
shift
;;
--analyze_url)
analyze_url=$2
shift 2
;;
--analyze_url=*)
analyze_url=${1#*=}
shift
;;
--dontcleanupseeds)
dontcleanupseeds=$2
shift 2
;;
--dontcleanupseeds=*)
dontcleanupseeds=${1#*=}
shift
;;
--top_q)
top_q=$2
shift 2
;;
--top_q=*)
top_q=${1#*=}
shift
;;
--summary)
summary=$2
shift 2
;;
--summary=*)
summary=${1#*=}
shift
;;
--imprint)
imprint=$2
shift 2
;;
--imprint=*)
imprint=${1#*=}
shift
;;
--pricing)
pricing=$2
shift 2
;;
--pricing=*)
pricing=${1#*=}
shift
;;
--add_this_content)
add_this_content=$2
shift 2
;;
--add_this_content=*)
add_this_content=${1#*=}
shift
;;
--add_this_content_part_name)
add_this_content_part_name=$2
shift 2
;;
--add_this_content_part_name=*)
add_this_content_part_name=${1#*=}
shift
;;
--add_dat_run)
add_dat_run=$2
shift 2
;;
--add_dat_run=*)
add_dat_run=${1#*=}
shift
;;
--two1)
two1=$2
shift 2
;;
--two1=*)
two1=${1#*=}
shift
;;
--expand_seeds_to_pages)
expand_seeds_to_pages=$2
shift 2
;;
--expand_seeds_to_pages=*)
expand_seeds_to_pages=${1#*=}
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

echo "PYTHON_BIN is $PYTHON_BIN"
"$PYTHON_BIN" --version

if [ ! "$passuuid" ] ; then
	echo "creating uuid"
	uuid=$("$PYTHON_BIN"  -c 'import uuid; print(uuid.uuid1())')
	echo "uuid is" $uuid | tee --append $xform_log

else
	uuid="$passuuid"
	echo "received uuid " $uuid

fi

# test values

# create directories I will need

mkdir -p -m 777 $TMPDIR
mkdir -p -m 777 "$TMPDIR"$uuid
mkdir -p -m 777 "$TMPDIR"$uuid/wiki
mkdir -p -m 777 "$TMPDIR"$uuid/user
mkdir -p -m 777 "$TMPDIR"$uuid/flickr
mkdir -p -m 777 "$TMPDIR"$uuid/fetch
mkdir -p -m 777 "$TMPDIR"$uuid/seeds
mkdir -p -m 777 "$TMPDIR"$uuid/images
mkdir -p -m 777 "$TMPDIR"$uuid/mail
mkdir -p -m 755 "$TMPDIR"$uuid/cover
mkdir -p -m 755 "$TMPDIR"$uuid/twitter
#mkdir -p -m 755 "$TMPDIR"$uuid/webseeds
mkdir -p -m 777 $metadatatargetpath$uuid
mkdir -p -m 777 $mediatargetpath$uuid

case "$format" in
xml)
	echo "getting metadata from xml file"

	xmlbasepath="$WEBFORMSXML_HOME"

	echo "xmlbasepath is" $xmlbasepath
	echo "xmlfilename is" $xmlfilename
	xmlfilename=$xmlbasepath/$xmlfilename

	booktitle=$(xmlstarlet sel -t -v "/item/booktitle" "$xmlfilename")
	booktype=$(xmlstarlet sel -t -v "/item/booktype" "$xmlfilename")
	BISAC_code=$(xmlstarlet sel -t -v "/item/BISAC_code" "$xmlfilename")
	customer_email=$(xmlstarlet sel -t -v "/item/customer_email" "$xmlfilename")
	environment=$(xmlstarlet sel -t -v "/item/environment" "$xmlfilename")
	exemplar_file=$(xmlstarlet sel -t -v "/item/exemplar_file" "$xmlfilename")
	jobprofilename=$(xmlstarlet sel -t -v "/item/jobprofilename" "$xmlfilename")
	wikilang=$(xmlstarlet sel -t -v "/item/wikilang" "$xmlfilename")
	revenue_share=$(xmlstarlet sel -t -v "/item/revenue_share" "$xmlfilename")
	sources=$(xmlstarlet sel -t -v "/item/sources" "$xmlfilename")
	submissionid=$(xmlstarlet sel -t -v "/item/id" "$xmlfilename")
	tldr=$(xmlstarlet sel -t -v "/item/tldr" "$xmlfilename")
	seedphrases=$(xmlstarlet sel -t -v "/item/seed-phrases" "$xmlfilename")
	book_description=$(xmlstarlet sel -t -v "/item/book-description" "$xmlfilename")
	coverfont=$(xmlstarlet sel -t -v "/item/coverfont" "$xmlfilename")
	covercolor=$(xmlstarlet sel -t -v "/item/covercolor" "$xmlfilename")
	yourname=$(xmlstarlet sel -t -v "/item/yourname" "$xmlfilename")
	customername=$(xmlstarlet sel -t -v "/item/customername" "$xmlfilename")
	customerid=$(xmlstarlet sel -t -v "/item/customer_id" "$xmlfilename")
	add_this_content=$(xmlstarlet sel -t -v "/item/add_this_content" "$xmlfilename")
	echo "environment is" $environment  | tee --append $xform_log
	echo "jobprofilename is" $jobprofilename  | tee --append $xform_log
	echo "exemplar_file is" $exemplar_file | tee --append $xform_log

	echo -n "$seedphrases" > "$TMPDIR"$uuid/seeds/seedphrases

	cp $WEBFORMSHOME$submissionid/$exemplar_filedir_code/*/$exemplar_file "$TMPDIR"$uuid/$exemplar_file
;;
csv)
	echo "getting metadata from csv"
	cp $seedfile "$TMPDIR"$uuid/seeds/seedphrases
;;
*)
	echo "getting metadata from command line"
	cp $seedfile "$TMPDIR"$uuid/seeds/seedphrases
;;
esac

# assign wikilocale & stopfile based on LANG

# deprecated assigning wikilocale via environment $LANG

# wikilocale=$(grep $LANG locale/wiki-lookup.csv |  cut -d, -f2)

# kluge for backwards compatibility
if [ "$wikilang" = "en_US.UTF-8" ] ; then
	wikilang="en"
else
	echo "wikilang in wikipedia domain format"
fi

wikilocale=$wikilang

if [ "$wikilang" = "en" ] ; then
	stopfile="$scriptpath""lib/IBMcloud/examples/pk-stopwords.txt"
elif [ "$wikilang" = "sv" ] ; then
	stopfile="$scriptpath""locale/stopwords/sv"
else
	stopfile="$scriptpath""lib/IBMcloud/examples/pk-stopwords.txt"
fi

echo "wikilocale now is "$wikilang

if [ -z "$imprint" ]; then
	imprint="default"
	. $confdir"jobprofiles/imprints/"$imprint"/"$fimpr".imprint"
else
	. $confdir"jobprofiles/imprints/"$imprint"/"$imprint".imprint"
        echo "imprint is $imprint"
fi

if [ -z "$jobprofilename" ]; then
	jobprofilename="default"
	. "$confdir"jobprofiles/robots/"$jobprofilename".jobprofile
else
	. "$confdir"jobprofiles/robots/"$jobprofilename".jobprofile
fi

human_author="$editedby"

# verbose logging

# APIs

. includes/api-manager.sh

# echo $scriptpath "is scriptpath"

echo "Assembling infiles and assets"

echo -n "$book_description" > "$TMPDIR"$uuid/book-description.txt
echo -n "$tldr" > "$TMPDIR"$uuid/tldr.txt
echo "analyze_url is $analyze_url"
if [ -z  ${analyze_url+x} ] ; then
	echo "$analyze_url not set as analyze_url"
else
	if [[ $analyze_url =~ $httpvalidate ]] ; then
		echo "$analyze_url is valid URI"
		echo "analyze_url is set as $analyze_url"
		"$PANDOC_BIN" -s -r html "$analyze_url" -o "$TMPDIR"$uuid"/webpage.md"
		"$PYTHON27_BIN" bin/nerv3.py "$TMPDIR"$uuid"/webpage.md" "$TMPDIR"$uuid"/webseeds" "$uuid"
		echo "seeds extracted from analyze_url"
		 head -n "$top_q" "$TMPDIR"$uuid"/webseeds" | sed '/^\s*$/d' > "$TMPDIR"$uuid"/webseeds.top_q"
		cat "$TMPDIR"$uuid"/webseeds.top_q" > "$TMPDIR"$uuid"/webseeds"
		comm -2 -3 <(sort "$TMPDIR"$uuid"/webseeds") <(sort "locale/stopwords/webstopwords.en") >> "$TMPDIR"$uuid/seeds/seedphrases
	else
		echo "invalid URI, analyze_url not added"
	fi
fi

# echo "checking for naughty words"

export uuid
"$scriptpath"bin/screen-naughty-seeds.sh "$TMPDIR$uuid/seeds/seedphrases" $uuid
naughtyresult=$?

if [ $naughtyresult -eq "0" ] ; then
	echo "naughty seeds checked"
else
	echo "Exited with problem in screen-naughty-seeds.sh"
  	exit 0
fi

# echo "checking for human error on form submission"

#if bin/screen-human-error.sh "$TMPDIR"$uuid/seeds/seedphrases  ; then
#   echo "Exited with zero value"
#else
#   echo "Exited with non zero"
#   exit 0
#fi

echo "seedfile is" $seedfile

# screen for zero value seed file


cat "$TMPDIR$uuid/seeds/seedphrases" | uniq | sort | sed -e '/^$/d' -e '/^[0-9#@]/d' > "$TMPDIR$uuid/seeds/sorted.seedfile"
cat "$TMPDIR$uuid/seeds/sorted.seedfile" > "$LOCAL_DATA"seeds/history/"$sku".seedphrases

#expand seeds to valid wiki pages

if [ "$expand_seeds_to_pages" = "yes" ] ; then
		echo "$expand_seeds_to_pages"
		"$PYTHON27_BIN" bin/wiki_seeds_2_pages.py --infile "$TMPDIR"$uuid"/seeds/sorted.seedfile" --pagehits "$TMPDIR"$uuid"/seeds/pagehits"
else
		echo "not expanding seeds to pages"
		cp "$TMPDIR"$uuid"/seeds/sorted.seedfile" "$TMPDIR"$uuid"/seeds/pagehits"
fi

# filter pagehits


cp "$TMPDIR"$uuid/seeds/pagehits "$TMPDIR"$uuid/seeds/filtered.pagehits

echo "--- filtered pagehits are ---"
cat "$TMPDIR"$uuid/seeds/filtered.pagehits

echo "--- end of pagehits ---"

# fetch data I will need based on seedfile

echo "summary is" $summary #summary should be on for cover building
wikilocale="en" # hard code for testing
echo $wikilocale "is wikilocale"

# fetch by pagehits

case $summary in
	summaries_only)
		echo "fetching page summaries only"
	"$PYTHON_BIN"  $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR$uuid/seeds/filtered.pagehits" --outfile "$TMPDIR$uuid/wiki/wikisummaries.md" --lang "$wikilocale" --summary  1> /dev/null
		wordcountsummaries=$(wc -w "$TMPDIR$uuid/wiki/wikisummaries.md" | cut -f1 -d' ')
		echo "wordcountsummaries is" $wordcountsummaries
		cp "$TMPDIR$uuid"/wiki/wikisummaries.md "$TMPDIR$uuid"/wiki/wiki4cloud.md
		;;
	complete_pages_only)
		echo "fetching complete pages only"
		"$PYTHON_BIN" $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR$uuid/seeds/filtered.pagehits" --outfile "$TMPDIR$uuid/wiki/wikipages.md" --lang "$wikilocale"  1> /dev/null
		wordcountpages=$(wc -w "$TMPDIR$uuid/wiki/wikipages.md" | cut -f1 -d' ')
		echo "wordcountpages is" $wordcountpages
		cp "$TMPDIR$uuid"/wiki/wikipages.md "$TMPDIR$uuid"/wiki/wiki4cloud.md
		;;
	both)
		echo "fetching both summaries and complete pages"
		echo "fetching page summaries now"
		"$PYTHON_BIN"  $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR$uuid/seeds/filtered.pagehits" --outfile "$TMPDIR$uuid/wiki/wikisummaries.md" --lang "$wikilocale" --summary  1> /dev/null
		wordcountsummaries=$(wc -w "$TMPDIR$uuid"/wiki/wikisummaries.md | cut -f1 -d' ')
		echo "fetching complete pages now"
		"$PYTHON_BIN" $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR$uuid/seeds/filtered.pagehits" --outfile "$TMPDIR$uuid/wiki/wikipages.md" --lang "$wikilocale"  1> /dev/null
		wordcountpages=$(wc -w "$TMPDIR$uuid"/wiki/wikipages.md | cut -f1 -d' ')
		if [ "$wordcountpages" -gt "100000" ] ; then
			cp "$TMPDIR"$uuid/wiki/wikisummaries.md "$TMPDIR"$uuid/wiki/wiki4cloud.md
			echo "body too big for wordcloud, using abstracts only"
		else
			cat "$TMPDIR"$uuid/wiki/wikisummaries.md "$TMPDIR"$uuid/wiki/wikipages.md > "$TMPDIR"$uuid/wiki/wiki4cloud.md
			echo "building wordcloud from body + summaries"
		fi
		;;
	*)
		echo "unrecognized summary option"
	;;
esac

wordcount=$(($wordcountsummaries + $wordcountpages))
echo "wordcount is $wordcount"

if [ "$wordcountsummaries" -gt "0" ] ; then

	echo "summaries data has been returned, proceeding"

elif [ "$wordcountpages" -gt "0" ] ; then

	echo "pages data has been returned, proceeding"

else

	echo "zero data returned from wiki, exiting with error message"
	sendemail -t "$customer_email" \
		-u "Your submission [ $booktitle ] has not been added to the catalog" \
		-m "The system was not able to find any valid seed terms in your submission. Make sure that you have provided several keyphrases and that the words are spelled correctly.  Please let us know by replying to this message if you need assistance." \
		-f "$GMAIL_ID" \
		-cc "$GMAIL_ID" \
		-xu "$GMAIL_ID" \
		-xp "$GMAIL_PASSWORD" \
		-s smtp.gmail.com:587 \
		-v \
		-o tls=yes
	exit 73
fi

# build cover

cp $scriptpath"assets/pk35pc.jpg" "$TMPDIR"$uuid/pk35pc.jpg
cp $confdir"jobprofiles"/imprints/"$imprint"/"$imprintlogo"  "$TMPDIR"$uuid/cover/"$imprintlogo"
cp $confdir"jobprofiles"/signatures/$sigfile "$TMPDIR"$uuid/$sigfile

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

	"$JAVA_BIN" -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -w "1800" -h "1800" < "$TMPDIR$uuid"/wiki/wiki4cloud.md > "$TMPDIR"$uuid/cover/wordcloudcover.png

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


#create base canvases

convert -size 1800x2400 xc:$covercolor  "$TMPDIR"$uuid/cover/canvas.png
convert -size 1800x800 xc:$covercolor  "$TMPDIR"$uuid/cover/topcanvas.png
convert -size 1800x400 xc:$covercolor  "$TMPDIR"$uuid/cover/bottomcanvas.png
convert -size 1800x800 xc:$covercolor  "$TMPDIR"$uuid/cover/toplabel.png
convert -size 1800x200 xc:$covercolor  "$TMPDIR"$uuid/cover/bottomlabel.png

# underlay canvas

composite -gravity Center "$TMPDIR"$uuid/cover/wordcloudcover.png  "$TMPDIR"$uuid/cover/canvas.png "$TMPDIR"$uuid/cover/canvas.png

# build top label

convert -background "$covercolor" -fill "$coverfontcolor" -gravity center -size 1800x400 -font "$coverfont" caption:"$booktitle" "$TMPDIR"$uuid/cover/topcanvas.png +swap -gravity center -composite "$TMPDIR"$uuid/cover/toplabel.png

#build bottom label

echo "yourname is" $yourname
if [ "$yourname" = "yes" ] ; then
	editedby="$human_author"
else
	echo "robot name on cover"
fi

echo "editedby is" $editedby

# editedby="PageKicker Robot "$editedby
convert  -background "$covercolor"  -fill "$coverfontcolor" -gravity south -size 1800x394 \
 -font "$coverfont"  caption:"$editedby" \
 "$TMPDIR"$uuid/cover/bottomcanvas.png  +swap -gravity center -composite "$TMPDIR"$uuid/cover/bottomlabel.png

# resize imprint logo

convert "$TMPDIR"$uuid/cover/"$imprintlogo" -resize x200 "$TMPDIR"$uuid/cover/"$imprintlogo"


# lay the labels on top of the target canvas

composite -geometry +0+0 "$TMPDIR"$uuid/cover/toplabel.png "$TMPDIR"$uuid/cover/canvas.png "$TMPDIR"$uuid/cover/step1.png
composite  -geometry +0+1800 "$TMPDIR"$uuid/cover/bottomlabel.png "$TMPDIR"$uuid/cover/step1.png "$TMPDIR"$uuid/cover/step2.png
composite  -gravity south -geometry +0+0 "$TMPDIR"$uuid/cover/"$imprintlogo" "$TMPDIR"$uuid/cover/step2.png "$TMPDIR"$uuid/cover/cover.png
convert "$TMPDIR"$uuid/cover/cover.png -border 36 -bordercolor white "$TMPDIR"$uuid/cover/bordercover.png
cp "$TMPDIR"$uuid/cover/bordercover.png "$TMPDIR"$uuid/cover/$sku"ebookcover.jpg"
convert "$TMPDIR"$uuid/cover/bordercover.png -resize 228x302 "$TMPDIR"$uuid/cover/$sku"ebookcover_thumb.jpg"


# move cover to import directory

cp "$TMPDIR"$uuid/cover/$sku"ebookcover.jpg" $mediatargetpath$uuid/$sku"ebookcover.jpg"
ls -l $mediatargetpath$uuid/$sku"ebookcover.jpg"
echo "* * * building Magento metadata header * * *"
echo "metadatatargetpath is "$metadatatargetpath
echo "uuid is" $uuid
echo "verifying uuid directory"
ls $metadatatargetpath$uuid
ls -la "$TMPDIR"$uuid/tldr.txt "$TMPDIR"$uuid/book-description.txt

cat includes/builder-metadata-header.csv > $metadatatargetpath$uuid/"current-import.csv"
echo "writing Magento metadata footer" to $metadatatargetpath$uuid/"current-import.csv"
. includes/builder-metadata-footer.sh >> $metadatatargetpath$uuid/"current-import.csv"

echo "writing Dublin Core metadata for use by pandoc"
#. includes/dc-metadata.txt

# increment SKU by 1
		prevsku=$sku
		sku=$((sku+1))
		echo $sku >> "$LOCAL_DATA""SKUs/sku_list"
		echo "incremented SKU by 1 to" $sku " and updated SKUs/sku_list"

#
if [ "$import" = "yes" ] ; then

	echo "adding import job to the manifest"

	echo $uuid >> import_status/manifest.csv

	$scriptpath"bin/receiving_dock.sh"

else

	echo "not importing this job"

fi


##verbose logging for sendemail
# cp "$TMPDIR"$uuid/seeds/seedphrases "$TMPDIR"$uuid/seeds/"$sku"seeds.txt

if [ "$builder" = "yes" ] ; then

	echo "seedfile was" "$TMPDIR"seeds/seedphrases

	$scriptpath"bin/builder.sh" --seedfile "$TMPDIR"$uuid"/seeds/sorted.seedfile" --booktype "$booktype" --jobprofilename "$jobprofilename" --booktitle "$booktitle" --ebook_format "epub" --sample_tweets "no" --wikilang "$wikilocale" --coverfont "$coverfont"  --covercolor "$covercolor" --passuuid "$uuid" --truncate_seed "no" --editedby "$editedby" --yourname "$yourname" --customername "$customername" --imprint "$imprint" --batch_uuid "$batch_uuid" --tldr "$tldr" --subtitle "$subtitle" --add_corpora "$add_corpora" --analyze_url "$analyze_url" --dontcleanupseeds "yes" --mailtoadmin "$mailtoadmin" --summary "$summary" --add_this_content "$add_this_content" --add_this_content_part_name "$add_this_content_part_name"

echo "test $@"

else

	echo "no builder"

fi

safe_product_name=$(echo "$booktitle" | sed -e 's/[^A-Za-z0-9._-]/_/g')
echo "safe_product_name is" "$safe_product_name"

	sendemail -t "$customer_email" \
		-u "test  build of [ SKU "$prevsku $booktitle " ] is attached" \
		-m "Hi! \n\nAttached you will find a free test version of the book that you asked us to add to the catalog.  It was created by PageKicker robots running software release $SFB_VERSION on branch" `git rev-parse --abbrev-ref HEAD` "on $MACHINE_NAME in $environment. To add this book to your personal account so that you can request free updates in future, you will need to order it via the PageKicker catalog at this URI:"\ "$WEB_HOST"index.php/"$prevsku.html. \n\n As an additional gesture of appreciation, here is a coupon code for 3 free books: THANKS54.  It is early days for us and we very much appreciate your feedback. Please take a moment to share your thoughts via this Google Form: "$google_form".  Finally, note that PageKicker is open source; we encourage you to contribute to the project, which is available at $MY_GITHUB_REPO ." \
		-f "$GMAIL_ID" \
		-cc "$GMAIL_ID" \
		-xu "$GMAIL_ID" \
		-xp "$GMAIL_PASSWORD" \
		-s smtp.gmail.com:587 \
		-o tls=yes \
		-a "$TMPDIR$uuid/$sku.$safe_product_name"".docx" \
		-a "$TMPDIR$uuid/$sku.$safe_product_name"".epub" \
		-a "$TMPDIR$uuid/$sku.$safe_product_name"".mobi"

if [ "$mailtoadmin" = "yes" ] ; then

	sendemail -t "$mailtoadmin_ids" \
		-u "test  build of [ "SKU $sku ""$booktitle" ] is attached" \
		-m "reference copy" \
		-f "$GMAIL_ID" \
		-xu "$GMAIL_ID" \
		-xp "$GMAIL_PASSWORD" \
		-s smtp.gmail.com:587 \
		-o tls=yes \
		-a "$TMPDIR$uuid/$sku.$safe_product_name"".mobi"

else
	echo "not mailing to $mailtoadmin_ids"

fi

echo 'job ' $uuid 'ending logging at' `date +'%m/%d/%y%n %H:%M:%S'` >> $sfb_log

cat "$sfb_log" >> $sfb_log_archive
echo -n "copied this job's log to the master archive and am now exiting"
exit 0
