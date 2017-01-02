#!/bin/bash

# accepts book topic and book type definition, then builds book

echo "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"

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

 #ls -lart "$seedfile"

echo "shortform is $shortform"

echo "revision number is" $SFB_VERSION

echo "sfb_log is" $logdir"sfb_log"

echo "completed reading config file and  beginning logging at" `date +'%m/%d/%y%n %H:%M:%S'`

export PERL_SIGNALS="unsafe"
echo "PERL_SIGNALS" is $PERL_SIGNALS "UNSAFE is correct"

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
-s|--seedfile)
seedfile=$2
shift 2
;;
--seedfile=*)
seedfile=${1#*=}
shift
;;
-t|--booktype)
booktype=$2
shift 2
;;
--booktype=*)
booktype=${1#*=}
shift
;;
-T|--booktitle)
booktitle=$2
shift 2
;;
--booktitle=*)
booktitle=${1#*=}
shift
;;
-G|--buildtarget)
buildtarget=$2
shift 2
;;
--buildtarget=*)
buildtarget=${1#*=}
shift
;;
-S|--singleseed|s)
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
shift
truncate_seed=${1#*=}
;;
-w|--sample_tweets)
sample_tweets=$2
shift 2
;;
--sample_tweets=*)
shift
sample_tweets=${1#*=}
;;
-f|--ebook_format)
ebook_format=$2
shift 2
;;
--ebook_format=*)
shift
ebook_format=${1#*=}
;;
-J|--jobprofilename)
jobprofilename=$2
shift 2
;;
--jobprofilename=*)
jobprofilename=${1#*=}
shift
;;
--jobprofile)
jobprofile=$2
shift 2
;;
--jobprofile=*)
jobprofile=${1#*=}
shift
;;
-L|--wikilang)
wikilang=$2
shift 2
;;
--wikilang=*)
wikilang=${1#*=}
shift
;;
-M|--summary)
summary=$2
shift 2
;;
--summary=*)
summary=${1#*=}
shift
;;
-n|--safe_product_name)
safe_product_name=$2
shift 2
;;
--safe_product_name=*)
safe_product_name=${1#*=}
shift
;;
-F|--coverfont)
coverfont=$2
shift 2
;;
--coverfont=*)
coverfont=${1#*=}
shift
;;
-L|--covercolor)
covercolor=$2
shift 2
;;
--covercolor=*)
covercolor=${1#*=}
shift
;;
--fromccc)
fromccc=$2
shift 2
;;
--fromccc=*)
fromccc=${1#*=}
shift
;;
-b|--editedby)
editedby=$2
shift 2
;;
--editedby=*)
editedby=${1#*=}
shift
;;
-Y|--yourname)
yourname=$2
shift 2
;;
--yourname=*)
yourname=${1#*=}
shift
;;
-N|--customername)
customername=$2
shift 2
;;
--customername=*)
customername=${1#*=}
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
--environment)
environment=$2
shift 2
;;
--environment=*)
environment=${1#*=}
shift
;;
--shortform)
shortform=$2
shift 2
;;
--shortform=*)
shortform=${1#*=}
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
--dontcleanupseeds)
dontcleanupseeds=$2
shift 2
;;
--dontcleanupseeds=*)
dontcleanupseeds=${1#*=}
shift
;;
-u|--batch_uuid)
batch_uuid=$2
shift 2
;;
--batch_uuid=*)
batch_uuid=${1#*=}
shift
;;
-I|--imprint)
imprint=$2
shift 2
;;
--imprint=*)
imprint=${1#*=}
shift
;;
-l|--tldr)
tldr=$2
shift 2
;;
--tldr=*)
tldr=${1#*=}
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
--mailtoadmin)
mailtoadmin=$2
shift 2
;;
--mailtoadmin=*)
mailtoadmin=${1#*=}
shift
;;
--buildcover)
buildcover=$2
shift 2
;;
--buildcover=*)
buildcover=${1#*=}
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
--skyscraper)
skyscraper=$2
shift 2
;;
--skyscraper=*)
skyscraper=${1#*=}
shift
;;
--add_this_image)
add_this_image=$2
shift 2
;;
--add_this_image=*)
add_this_image=${1#*=}
shift
;;
--add_this_image_name)
add_this_image_name=$2
shift 2
;;
--add_this_image_name=*)
add_this_image_name=${1#*=}
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

echo "LOCAL_DATA is $LOCAL_DATA"

echo "add_this_content is $add_this_content"

echo "imprint is $imprint" #debug
echo "editedby is $editedby" #debug
echo "jobprofilename is $jobprofilename" #debug


human_author="$editedby"
# Suppose some options are required. Check that we got them.

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

if [ -z "$covercolor" ]; then
	covercolor="RosyBrown"
	echo "no cover color in command line so I set it to "$covercolor
else
	echo "cover color is $covercolor"
fi

if [ -z "$coverfont" ]; then
	coverfont="Minion"
	echo "no cover font in command line so I set it to "$coverfont
else
	echo "cover font is $coverfont"
fi

if [ -z "$wikilang" ]; then
	wikilang="en"
	echo "no wikilang in command line so I set it to "$wikilang
else
	echo "wiki search language is $wikilang"
fi

if [ -z "$imprint" ]; then
	imprint="default"
	. $confdir"jobprofiles/imprints/"$imprint"/"$imprint".imprint"
else
	. $confdir"jobprofiles/imprints/"$imprint"/"$imprint".imprint"
fi

if [ -z "$jobprofilename" ]; then
	jobprofilename="$jobprofile"
	. "$confdir"jobprofiles/robots/"$jobprofilename".jobprofile
else
	. "$confdir"jobprofiles/robots/"$jobprofilename".jobprofile
fi

TEXTDOMAIN=SFB
echo $"hello, world, I am speaking" $LANG

safe_product_name=$(echo "$booktitle"| sed -e 's/[^A-Za-z0-9._-]/_/g')
echo "safe product name is" $safe_product_name

sku=`tail -1 < "$LOCAL_DATA""SKUs/sku_list"`
echo "sku is" $sku


echo "test $covercolor" "$coverfont"

# resolving seedfile from command line

if [ -z "$seedfile" ] ; then
	if [ -z "$singleseed" ] ; then
			echo "no seed file or singleseed was provided, exiting"
			exit 0
		else
			seed="$singleseed"
			echo "seed is now singleseed" "$seed"
			echo "$singleseed" > "$TMPDIR"$uuid/seeds/seedphrases
	fi
else
	echo "path to seedfile was $seedfile"
	cp $seedfile "$TMPDIR"$uuid/seeds/seedphrases
fi

#echo "seedfile is " $seedfile
#ls -lart "seedfile is" $seedfile

. includes/api-manager.sh

echo "test $covercolor" "$coverfont"

# create directories I will need

mkdir -p -m 755  "$TMPDIR"$uuid/actual_builds
mkdir -p -m 755  "$TMPDIR"$uuid/cover
mkdir -p -m 755  "$TMPDIR"$uuid/twitter
mkdir -p -m 777  "$TMPDIR"$uuid/fetch
mkdir -p -m 777  "$TMPDIR"$uuid/flickr
mkdir -p -m 777  "$TMPDIR"$uuid/images
mkdir -p -m 777  "$TMPDIR"$uuid/mail
mkdir -p -m 777  "$TMPDIR"$uuid/seeds
mkdir -p -m 777  "$TMPDIR"$uuid/user
mkdir -p -m 777  "$TMPDIR"$uuid/wiki
mkdir -p -m 777  "$TMPDIR"$uuid/webseeds
mkdir -p -m 755 $LOCAL_DATA"jobprofile_builds/""$jobprofilename"

#move assets into position

#if [ "$truncate_seed" = "yes" ] ; then
#	echo "truncating path to seed file"
#	echo $seedfile
#	seedfile=$(dirname $seedfile)
#	seedfile=$seedfile"/seedlist"
#	echo "truncated seedfile" $seedfile " as kluge for var customer path"
#else
#	echo "not truncating seedfile"
#fi

#echo "seedfile is " $seedfile
#ls -lart "seedfile is" $seedfile


cp $scriptpath"assets/pk35pc.jpg"  "$TMPDIR"$uuid/pk35pc.jpg

if cmp -s "$seedfile" "$TMPDIR"$uuid"/seeds/seedphrases" ; then
	echo "seedfiles are identical, no action necessary"
else
	echo "Rotating new seedfile into tmpdir"
	cp "$seedfile"  "$TMPDIR"$uuid"/seeds/seedphrases"
fi

cp $confdir"jobprofiles"/imprints/"$imprint"/"$imprintlogo"  "$TMPDIR""$uuid"
cp $confdir"jobprofiles"/signatures/"$sigfile" "$TMPDIR""$uuid"
cp $confdir"jobprofiles"/imprints/"$imprint"/"$imprintlogo" "$TMPDIR"$uuid"/cover"

if [ -z  ${analyze_url+x} ] ; then
	echo "$analyze_url not set as analyze_url"
else
	if [[ $analyze_url =~ $httpvalidate ]] ; then
		echo "$analyze_url is valid URI"
		echo "analyze_url is set as $analyze_url"
		"$PANDOC_BIN" -s -r html "$analyze_url" -o  "$TMPDIR"$uuid"/webpage.md"
		"$PYTHON27_BIN" bin/nerv3.py  "$TMPDIR"$uuid"/webpage.md"  "$TMPDIR"$uuid"/webseeds" "$uuid"
		echo "seeds have been extracted from analyze_url"
		head -n "$top_q"  "$TMPDIR"$uuid"/webseeds" | sed '/^\s*$/d' >  "$TMPDIR"$uuid"/webseeds.top_q"
		cat  "$TMPDIR"$uuid"/webseeds.top_q" >  "$TMPDIR"$uuid"/webseeds"
		comm -2 -3 <(sort  "$TMPDIR"$uuid"/webseeds") <(sort "locale/stopwords/webstopwords.en") >>  "$TMPDIR"$uuid/seeds/seedphrases
	else
		echo "invalid URI, analyze_url not added"
	fi
fi

sort -f "$TMPDIR"$uuid"/seeds/seedphrases"
sort -u --ignore-case "$TMPDIR"$uuid"/seeds/seedphrases" | sed -e '/^$/d' -e '/^[0-9#@]/d' >  "$TMPDIR"$uuid/seeds/sorted.seedfile

echo "---"
echo "seeds are"
cat "$TMPDIR"$uuid"/seeds/sorted.seedfile"
echo "---"

#expand seeds to valid wiki pages

if [ "$expand_seeds_to_pages" = "yes" ] ; then
		echo "$expand_seeds_to_pages"
		"$PYTHON27_BIN" bin/wiki_seeds_2_pages.py --infile "$TMPDIR"$uuid"/seeds/sorted.seedfile" --pagehits "$TMPDIR"$uuid"/seeds/pagehits"
else
		echo "not expanding seeds to pages"
		cp "$TMPDIR"$uuid"/seeds/sorted.seedfile" "$TMPDIR"$uuid"/seeds/pagehits"
fi

# filter pagehits

cp  "$TMPDIR"$uuid/seeds/pagehits  "$TMPDIR"$uuid/seeds/filtered.pagehits

echo "--- filtered pagehits are ---"
cat  "$TMPDIR"$uuid/seeds/filtered.pagehits

echo "--- end of pagehits ---"

# fetch by pagehits


case "$summary" in
summaries_only)
	echo "fetching page summaries only"
	"$PYTHON_BIN"  $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR"$uuid"/seeds/filtered.pagehits" --outfile "$TMPDIR"$uuid/"wiki/wikisummariesraw.md" --lang "$wikilocale" --summary  1> /dev/null
	sed -e s/\=\=\=\=\=/JQJQJQJQJQ/g -e s/\=\=\=\=/JQJQJQJQ/g -e s/\=\=\=/JQJQJQ/g -e s/\=\=/JQJQ/g -e s/Edit\ /\ /g -e s/JQJQJQJQJQ/\#\#\#\#\#/g -e s/JQJQJQJQ/\#\#\#\#/g -e s/JQJQJQ/\#\#\#/g -e s/JQJQ/\#\#/g  "$TMPDIR"$uuid/wiki/wikisummariesraw.md | sed G >  "$TMPDIR"$uuid/wiki/wikisummaries.md
	cp  "$TMPDIR"$uuid/wiki/wikisummaries.md  "$TMPDIR"$uuid/wiki/wikiall.md
	wordcountsummaries=$(wc -w "$TMPDIR"$uuid/wiki/wikisummaries.md | cut -f1 -d' ')
	cp "$TMPDIR"$uuid"/wiki/wikisummaries.md" "$TMPDIR"$uuid"/wiki/wiki4cloud.md"
;;
complete_pages_only)
	echo "fetching complete pages only"
	"$PYTHON_BIN" $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR"$uuid"/seeds/filtered.pagehits" --outfile "$TMPDIR"$uuid"/wiki/wikipagesraw.md" --lang "$wikilocale"  1> /dev/null
	sed -e s/\=\=\=\=\=/JQJQJQJQJQ/g -e s/\=\=\=\=/JQJQJQJQ/g -e s/\=\=\=/JQJQJQ/g -e s/\=\=/JQJQ/g -e s/Edit\ /\ /g -e s/JQJQJQJQJQ/\#\#\#\#\#/g -e s/JQJQJQJQ/\#\#\#\#/g -e s/JQJQJQ/\#\#\#/g -e s/JQJQ/\#\#/g  "$TMPDIR"$uuid/wiki/wikipagesraw.md | sed G >  "$TMPDIR"$uuid"/wiki/wikipages.md"
	wordcountpages=$(wc -w "$TMPDIR"$uuid"/wiki/wikipages.md" | cut -f1 -d' ')
	cp "$TMPDIR"$uuid"/wiki/wikipages.md" "$TMPDIR"$uuid"/wiki/wiki4cloud.md"
	cp  "$TMPDIR"$uuid/wiki/wikipages.md  "$TMPDIR"$uuid/wiki/wikiall.md
;;
both)
	echo "fetching both summaries and complete pages"
	echo "fetching page summaries now"
	"$PYTHON_BIN"  $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR"$uuid"/seeds/filtered.pagehits" --outfile "$TMPDIR"$uuid"/wiki/wikisummaries1.md" --lang "$wikilocale" --summary  1> /dev/null
	echo "fetching complete pages now"
	"$PYTHON_BIN" $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR"$uuid"/seeds/filtered.pagehits" --outfile "$TMPDIR"$uuid"/wiki/wikipages1.md" --lang "$wikilocale"  1> /dev/null
	sed -e s/\=\=\=\=\=/JQJQJQJQJQ/g -e s/\=\=\=\=/JQJQJQJQ/g -e s/\=\=\=/JQJQJQ/g -e s/\=\=/JQJQ/g -e s/Edit\ /\ /g -e s/JQJQJQJQJQ/\#\#\#\#\#/g -e s/JQJQJQJQ/\#\#\#\#/g -e s/JQJQJQ/\#\#\#/g -e s/JQJQ/\#\#/g  "$TMPDIR"$uuid"/wiki/wikisummaries1.md" | sed G >  "$TMPDIR"$uuid/wiki/wikisummaries.md
	sed -e s/\=\=\=\=\=/JQJQJQJQJQ/g -e s/\=\=\=\=/JQJQJQJQ/g -e s/\=\=\=/JQJQJQ/g -e s/\=\=/JQJQ/g -e s/Edit\ /\ /g -e s/JQJQJQJQJQ/\#\#\#\#\#/g -e s/JQJQJQJQ/\#\#\#\#/g -e s/JQJQJQ/\#\#\#/g -e s/JQJQ/\#\#/g  "$TMPDIR"$uuid"/wiki/wikipages1.md" | sed G >  "$TMPDIR"$uuid/wiki/wikipages.md

	wordcountpages=$(wc -w "$TMPDIR"$uuid"/wiki/wikipages.md" | cut -f1 -d' ')
		if [ "$wordcountpages" -gt 100000 ] ; then
			cp  "$TMPDIR"$uuid/wiki/wikisummaries.md  "$TMPDIR"$uuid/wiki/wiki4cloud.md
			echo "body too big for wordcloud, using abstracts only"
		else
			cat  "$TMPDIR"$uuid/wiki/wikisummaries.md  "$TMPDIR"$uuid/wiki/wikipages.md >  "$TMPDIR"$uuid/wiki/wiki4cloud.md
			echo "building wordcloud from body + summaries"
		fi
;;
*)
	echo "unrecognized summary option"
;;
esac

if [ "$add_this_content" = "none" ] ; then
	echo "no added content"
	touch "$TMPDIR"$uuid/add_this_content.md
else
	echo "adding user content to cover cloud"
	cp "$add_this_content" "$TMPDIR"$uuid"/add_this_content_raw"
	echo "$add_this_content"
	"$PANDOC_BIN" -f docx -s -t markdown -o "$TMPDIR"$uuid"/add_this_content.md "$TMPDIR"$uuid/add_this_content_raw"
	cat "$TMPDIR"$uuid"/add_this_content.md >> "$TMPDIR"$uuid/wiki/wiki4cloud.md"
fi

echo "summary is" $summary #summary should be on for cover building
wikilocale="en" # hard code for testing
echo $wikilocale "is wikilocale"

if [ -n "$wordcountsummaries" ] ; then
	echo "summaries data has been returned, proceeding"
	wordcountsummaries=$(wc -w "$TMPDIR"$uuid"/wiki/wikisummaries.md" | cut -f1 -d' ')

elif [ "$wordcountpages" -gt "0" ] ; then
	echo "pages data has been returned, proceeding"
	wordcount=$(wc -w "$TMPDIR"$uuid"/wiki/wikipages.md" | cut -f1 -d' ')

else

	echo "zero data returned from wiki, exiting with error message"
	sendemail -t "$customer_email" \
		-u "Your submission [ $booktitle ] has not been added to the catalog" \
		-m "The system was not able to find any valid seed terms in your subcat $TMPDIR$uuid"/add_this_content.md" >> $TMPDIR$uuid/tmpbody.mdmission. Make sure that you have provided several keyphrases and that the words are spelled correctly.  Please let us know by replying to this message if you need assistance." \
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


	"$JAVA_BIN" -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -w "1800" -h "1800" <  "$TMPDIR"$uuid/wiki/wiki4cloud.md >  "$TMPDIR"$uuid/cover/wordcloudcover.png

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

echo "covercolor is" $covercolor | tee --append $sfb_log
echo "coverfont is" $coverfont  | tee --append $sfb_log

#create base canvases

convert -size 1800x2400 xc:$covercolor   "$TMPDIR"$uuid/cover/canvas.png
convert -size 1800x800 xc:$covercolor   "$TMPDIR"$uuid/cover/topcanvas.png
convert -size 1800x400 xc:$covercolor   "$TMPDIR"$uuid/cover/bottomcanvas.png
convert -size 1800x800 xc:$covercolor   "$TMPDIR"$uuid/cover/toplabel.png
convert -size 1800x200 xc:$covercolor   "$TMPDIR"$uuid/cover/bottomlabel.png

# underlay canvas

composite -gravity Center  "$TMPDIR"$uuid/cover/wordcloudcover.png   "$TMPDIR"$uuid/cover/canvas.png  "$TMPDIR"$uuid/cover/canvas.png

# build top label

convert -background "$covercolor" -fill "$coverfontcolor" -gravity center -size 1800x400 -font "$coverfont" caption:"$booktitle"  "$TMPDIR"$uuid/cover/topcanvas.png +swap -gravity center -composite  "$TMPDIR"$uuid/cover/toplabel.png

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

composite -geometry +0+0  "$TMPDIR"$uuid/cover/toplabel.png  "$TMPDIR"$uuid/cover/canvas.png  "$TMPDIR"$uuid/cover/step1.png
composite  -geometry +0+1800  "$TMPDIR"$uuid/cover/bottomlabel.png  "$TMPDIR"$uuid/cover/step1.png  "$TMPDIR"$uuid/cover/step2.png
composite  -gravity south -geometry +0+0  "$TMPDIR"$uuid/cover/"$imprintlogo"  "$TMPDIR"$uuid/cover/step2.png  "$TMPDIR"$uuid/cover/cover.png
convert  "$TMPDIR"$uuid/cover/cover.png -border 36 -bordercolor white  "$TMPDIR"$uuid/cover/bordercover.png
cp  "$TMPDIR"$uuid/cover/bordercover.png  "$TMPDIR"$uuid/cover/$sku"ebookcover.jpg"
cp  "$TMPDIR"$uuid/cover/bordercover.png  "$TMPDIR"$uuid/ebookcover.jpg

if [ "$shortform" = "no" ]; then

	# build front matter page by page

	echo "  " >>  "$TMPDIR"$uuid/titlepage.md
	echo "  " >>  "$TMPDIR"$uuid/titlepage.md
	echo "# About $editedby" >>  "$TMPDIR"$uuid/titlepage.md
	cat "$authorbio" >>  "$TMPDIR"$uuid/titlepage.md
	echo "  " >>  "$TMPDIR"$uuid/titlepage.md
	echo "  " >>  "$TMPDIR"$uuid/titlepage.md

#acknowledgments

. includes/acknowledgments.sh

	# describe the key settings used in book
	. includes/settings.sh

	# human-written abstracts

. includes/abstracts.sh

# parses list of chapters into simple ToC and runon sentence

. includes/listofpages.sh

. includes/topics_covered_runon.sh

# changelog

. includes/changelog.sh

# move cover files into position

	cat "$TMPDIR"$uuid"/wiki/wiki4cloud.md"  >> $TMPDIR$uuid/tmpbody.md

	# convert text so that I can add acronyms, programmatic summary, named entity recognition

pandoc -S -o "$TMPDIR"$uuid/targetfile.txt -t plain -f markdown "$TMPDIR"$uuid/tmpbody.md

#split into chunks that can be handled in memory

	split -C 50K  "$TMPDIR"$uuid/targetfile.txt "$TMPDIR"$uuid"/xtarget."

. includes/transect_summarize_ner.sh

# clean up both unprocessed and postprocessed summary text

	sed -i '1i # Programmatically Generated Summary \'  "$TMPDIR"$uuid/pp_summary.txt
	sed -i G  "$TMPDIR"$uuid/pp_summary.txt
	sed -i '1i # Programmatically Generated Summary \'  "$TMPDIR"$uuid/summary.txt
	sed -i G  "$TMPDIR"$uuid/summary.txt

	sed -n 3p $TMPDIR$uuid/pp_summary.txt > $TMPDIR$uuid/pp_summary_all.txt # for tldr
	echo '\pagenumbering{gobble}' > $TMPDIR$uuid/pp_summary_sky.txt
	#echo "  " >>
	#echo '\pagecolor{yellow!30}' >> $TMPDIR$uuid/pp_summary_sky.txt
	echo "  "  >> $TMPDIR$uuid/pp_summary_sky.txt
  sed -n 1,35p $TMPDIR$uuid/pp_summary.txt >> $TMPDIR$uuid/pp_summary_sky.txt # for skyscraper
  cp $TMPDIR$uuid/pp_summary_sky.txt $TMPDIR$uuid/pp_summary_sky.md

	# throw away unpreprocessed summary text if zero size

	if [ `wc -c <  "$TMPDIR"$uuid/pp_summary.txt` = "0" ] ; then
	  echo using "unpostprocessed summary bc wc pp summary = 0"
	  cat "$TMPDIR$uuid"/summary.txt >> $TMPDIR$uuid/programmaticsummary.md
	else
	  cp  "$TMPDIR"$uuid/pp_summary.txt  "$TMPDIR"$uuid/summary.md
		cat "$TMPDIR$uuid"/summary.md >> $TMPDIR$uuid/programmaticsummary.md
	fi


else
	echo "short form selected"
	echo '![cover image]'"(ebookcover.jpg)" >  "$TMPDIR"$uuid/titlepage.md
	echo '!['"$imprintname"']'"(""$imprintlogo"")" >>  "$TMPDIR"$uuid/titlepage.md

fi

#tldr

. includes/tldr_auto.sh #returns tldr.txt and tldr.md

# assemble body

## user provided content

## algorithmic content chapters

if [ "$summary" = "summaries_only" ] ; then
	echo "no body"
	touch $TMPDIR$uuid/chapters.md
else
	echo "  " >> $TMPDIR$uuid/chapters.md
	echo "  " >>  "$TMPDIR"$uuid/chapters.md
	echo "# Algorithmic Content" >>  "$TMPDIR"$uuid/chapters.md
	cat "$TMPDIR"$uuid"/wiki/wiki4cloud.md" | sed -e 's/#/##/' >>  "$TMPDIR"$uuid/chapters.md
	echo "  " >>  "$TMPDIR"$uuid/chapters.md
	echo "  " >>  "$TMPDIR"$uuid/chapters.md
fi

# acronyms

echo "# Acronyms" > $TMPDIR$uuid/tmpacronyms.md
echo " " >> $TMPDIR$uuid/tmpacronyms.md
echo " " >> $TMPDIR$uuid/tmpacronyms.md
$scriptpath/bin/acronym-filter.sh --txtinfile  "$TMPDIR"$uuid/targetfile.txt > "$TMPDIR"$uuid/acronyms.txt
sed G $TMPDIR$uuid/acronyms.txt >> $TMPDIR$uuid/acronyms.md
cat $TMPDIR$uuid/acronyms.md >> $TMPDIR$uuid/tmpacronyms.md
cp $TMPDIR$uuid/tmpacronyms.md $TMPDIR$uuid/acronyms.md

# Unique nouns

ls  "$TMPDIR"$uuid/xtarget.*nouns* >  "$TMPDIR"$uuid/testnouns
cat  "$TMPDIR"$uuid/xtarget.*nouns* >  "$TMPDIR"$uuid/all_nouns.txt

sort --ignore-case  "$TMPDIR"$uuid/all_nouns.txt | uniq >  "$TMPDIR"$uuid/sorted_uniqs.txt
sed -i '1i # Unique Proper Nouns and Key Terms'  "$TMPDIR"$uuid/sorted_uniqs.txt
sed -i '1i \'  "$TMPDIR"$uuid/sorted_uniqs.txt
sed -i G  "$TMPDIR"$uuid/sorted_uniqs.txt
echo '\pagenumbering{gobble}' > $TMPDIR$uuid/sorted_uniqs_sky.txt
echo "  " >> $TMPDIR$uuid/sorted_uniqs_sky.txt
sed -n 1,25p $TMPDIR$uuid/sorted_uniqs.txt >> $TMPDIR$uuid/sorted_uniqs_sky.txt
cp  "$TMPDIR"$uuid/sorted_uniqs.txt  "$TMPDIR"$uuid/sorted_uniqs.md
cp  "$TMPDIR"$uuid/sorted_uniqs_sky.txt  "$TMPDIR"$uuid/sorted_uniqs_sky.md

echo "" >> "$TMPDIR"$uuid/sorted_uniqs.md
echo "" >> "$TMPDIR"$uuid/sorted_uniqs.md

if [ "$sample_tweets" = "yes" ] ; then
			echo "adding Tweets to back matter"
			cat  "$TMPDIR"$uuid/twitter/sample_tweets.md >>  "$TMPDIR"$uuid/backmatter.md
else
			echo "no sample tweets"
			touch $TMPDIR$uuid/twitter/sample_tweets.md
fi

	if [ "$flickr" = "on" ] ; then

		cd  "$TMPDIR"$uuid/flickr
		for file in *.md
		do
		       cat $file >> allflickr.md
		       echo '\newpage' >> allflickr.md
		       echo "" >> allflickr.md
		done
		cat allflickr.md >>  "$TMPDIR"$uuid/backmatter.md
		#cp *.jpg ..
		# cp allflickr.md ..
		#cd ..
		# $PANDOC -o images.pdf allflickr.md
		# cd $scriptpath
		# echo "converted flickr md files to pdf pages with images" | tee --append $xform_log

	else
		echo "didn't  process flickr files"
		touch $TMPDIR$uuid/allflickr.md
	fi

	echo "# Sources" >>  "$TMPDIR"$uuid/sources.md
 	cat includes/wikilicense.md >> $TMPDIR/$uuid/sources.md
	echo "" >> "$TMPDIR"$uuid/sources.md
	echo "" >> "$TMPDIR"$uuid/sources.md

	echo "# Also built by PageKicker Robot $jobprofilename" >>   "$TMPDIR"$uuid/builtby.md
	sort -u --ignore-case "$LOCAL_DATA"bibliography/robots/"$jobprofilename"/$jobprofilename"_titles.txt" -o  "$LOCAL_DATA"/bibliography/robots/"$jobprofilename"/$jobprofilename"_titles.tmp" # currently sort by alphabetical
	cat "$LOCAL_DATA"/bibliography/robots/"$jobprofilename"/"$jobprofilename""_titles.tmp" >>  "$TMPDIR"$uuid/builtby.md
	echo " ">>  "$TMPDIR"$uuid/builtby.md
	echo " " >>  "$TMPDIR"$uuid/builtby.md


	if [ "add_imprint_biblio" = "yes" ] ; then
			echo "# Also from $imprintname" >>   "$TMPDIR"$uuid/byimprint.md
			uniq "$LOCAL_DATA"bibliography/imprints/"$imprint"/$imprint"_titles.txt" >>  "$TMPDIR"$uuid/byimprint.md # imprint pubs are not alpha
			echo "" >> "$TMPDIR"$uuid"/byimprint.md"
			echo "" >> "$TMPDIR"$uuid"/byimprint.md"
	else
		 	true
			touch $TMPDIR$uuid/byimprint.md
			# commenting out imprint bibliography because data is too messy right now
  fi

		if [ -z  ${url+x} ] ; then
			 touch "$TMPDIR"$uuid"/analyzed_webpage.md"
		else
			echo "" >> "$TMPDIR"$uuid"/analyzed_webpage.md"
			echo "" >> "$TMPDIR"$uuid"analyzed_webpage.md"
			"$PANDOC_BIN" -s -r html "$analyze_url" -o  "$TMPDIR"$uuid"/analyzed_webpage.md"
			"$PYTHON_BIN" bin/nerv3.py  "$TMPDIR"$uuid"/analyzed_webpage.md"  "$TMPDIR"$uuid"/analyzed_webseeds" "$uuid"
			echo "# Webpage Analysis" >>  "$TMPDIR"$uuid/analyzed_webpage.md
			echo "I analyzed this webpage $url. I found the following keywords on the page."  >> "$TMPDIR"$uuid/analyzed_webpage.md"
			comm -2 -3 <(sort  "$TMPDIR"$uuid"/analyzed_webseeds") <(sort $scriptpath"locale/stopwords/webstopwords."$wikilang) >>  "$TMPDIR"$uuid"/analyzed_webpage.md
			echo "" >> "$TMPDIR"$uuid"/analyzed_webpage.md"
			echo "" >> "$TMPDIR"$uuid"/analyzed_webpage.md"
		fi

	touch "$TMPDIR"$uuid/imprint_mission_statement.md
	cat $confdir"jobprofiles/imprints/$imprint/""$imprint_mission_statement" >> "$TMPDIR"$uuid"/imprint_mission_statement.md"
	echo '!['"$imprintname"']'"(""$imprintlogo"")" >>  "$TMPDIR"$uuid/imprint_mission_statement.md
	echo "built back matter"

my_year=`date +'%Y'`

echo "" >  "$TMPDIR"$uuid/yaml-metadata.md
echo "---" >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "title: $booktitle" >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "subtitle: $subtitle" >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "creator: " >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "- role: author "  >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "  text: "" $editedby"  >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "publisher: $imprintname"  >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "rights:  (c) $my_year $imprintname" >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "---" >>  "$TMPDIR"$uuid/yaml-metadata.md


# bin/partsofthebook.sh parallel construction of parts of the book

. bin/partsofthebook.sh

# build ebook in epub

safe_product_name=$(echo "$booktitle" | sed -e 's/[^A-Za-z0-9._-]/_/g')
bibliography_title="$booktitle"

cd  "$TMPDIR"$uuid
"$PANDOC_BIN" -o "$TMPDIR"$uuid/$sku"."$safe_product_name".epub" --epub-cover-image="$TMPDIR"$uuid/cover/$sku"ebookcover.jpg"  "$TMPDIR"$uuid/complete.md
"$PANDOC_BIN" -o "$TMPDIR"$uuid/$sku"."$safe_product_name".docx"   "$TMPDIR"$uuid/complete.md
"$PANDOC_BIN" -o "$TMPDIR"$uuid/$sku"."$safe_product_name".txt"   "$TMPDIR"$uuid/complete.md
"$PANDOC_BIN" -o "$TMPDIR"$uuid/$sku"."$safe_product_name".mw" -t mediawiki -s -S  "$TMPDIR"$uuid/complete.md
cp "$TMPDIR"$uuid/$sku"."$safe_product_name".txt" "$TMPDIR"$uuid/4stdout".txt"

cd $scriptpath
lib/KindleGen/kindlegen "$TMPDIR"$uuid/$sku."$safe_product_name"".epub" -o "$sku.$safe_product_name"".mobi" 1> /dev/null
#ls -lart  "$TMPDIR"$uuid
echo "built epub, mobi, and txt"

case $ebook_format in

epub)
if [ ! "$buildtarget" ] ; then
	buildtarget=" "$TMPDIR"$uuid/buildtarget.epub"
else
	echo "received buildtarget as $buildtarget"
fi
# deliver epub to build target
cp  "$TMPDIR"$uuid/$sku.$safe_product_name".epub" "$buildtarget"

chmod 755 "$buildtarget"
#echo "checking that buildtarget exists"
#ls -la $buildtarget
;;

mobi)
if [ ! "$buildtarget" ] ; then
	buildtarget="$TMPDIR"$uuid"/buildtarget.mobi"
else
	echo "received buildtarget as $buildtarget"
fi
cp  "$TMPDIR"$uuid/$sku.$safe_product_name".mobi" "$buildtarget"
#echo "checking that buildtarget exists"
#ls -la $buildtarget
;;
docx)
if [ ! "$buildtarget" ] ; then
	buildtarget="$TMPDIR"$uuid"/buildtarget.docx"
else
	echo "received buildtarget as $buildtarget"
fi
cp  "$TMPDIR"$uuid/$sku"."$safe_product_name".docx" "$buildtarget"
chmod 755 "$buildtarget"
echo "checking that buildtarget exists"
#ls -la $buildtarget
;;
*)

esac

if [ "$two1" = "yes" ] ; then
	echo "moving files so 21 script does not need to know uuid"
	cp "$TMPDIR"$uuid/$sku"."$safe_product_name".txt" "$TMPDIR"4stdout".txt"
	cp "$TMPDIR"$uuid/$sku.$safe_product_name".epub" /tmp/pagekicker/delivery.epub
	cp "$TMPDIR"$uuid/$sku.$safe_product_name".docx" /tmp/pagekicker/delivery.docx
else
	echo "files not requested from 21"
fi

# build skyscraper image

if [ -z "$skyscraper" ]; then
	echo "no skyscraper"
else

	. includes/1000x3000skyscraper.sh
	echo "built skyscraper"
fi

# housekeeping

unique_seed_string=$(sed -e 's/[^A-Za-z0-9._-]//g' <  "$TMPDIR"$uuid/seeds/sorted.seedfile | tr --delete '\n')

#checking if seedstring already in imprint corpus

if [ "$add_corpora" = "yes" ] ; then

	if grep -q "$unique_seed_string" "$SFB_HOME"shared-corpus/imprints/"$imprint"/unique_seed_strings.sorted ; then
		echo "seed string $unique_seed_string is already in corpus for imprint $imprint"
	else
		cp -u "$TMPDIR"$uuid"/"$sku.$safe_product_name".epub" "$SFB_HOME"shared-corpus/imprints"/"$imprint"/"$sku.$safe_product_name".epub"
		echo "added book associated with $unique_seed_string to corpus for imprint $imprint"
	fi
else
	:
fi

# checking if seed string is already in robot corpus
if [ "$add_corpora" = "yes" ] ; then

	if grep -q "$unique_seed_string" "$SFB_HOME"shared-corpus/robots/$jobprofilename/unique_seed_strings.sorted ; then
		echo "seed string $unique_seed_string is already in corpus for robot $jobprofilename "
	else
		cp "$TMPDIR"$uuid"/"$sku.$safe_product_name".epub" "$SFB_HOME"shared-corpus/robots/"$jobprofilename"/"$sku.$safe_product_name.epub"
		echo "added book associated with $unique_seed_string to corpus for robot $jobprofilename"
	fi
else
	:
fi

if [ "$add_corpora" = "yes" ] ; then
	echo "$unique_seed_string" >> "$SFB_HOME"shared-corpus/imprints/"$imprint"/unique_seed_strings
	echo "$unique_seed_string" >> "$SFB_HOME"shared-corpus/robots/"$jobprofilename"/unique_seed_strings
	sort -u $SFB_HOME"shared-corpus/robots/"$jobprofilename"/unique_seed_strings" > $SFB_HOME"shared-corpus/robots/"$jobprofilename"/unique_seed_strings.sorted"
	sort -u $SFB_HOME"shared-corpus/imprints/"$imprint"/unique_seed_strings" > $SFB_HOME"shared-corpus/imprints/"$imprint"/unique_seed_strings.sorted"

else
	echo "not requested to add builds and unique_seed_strings to corpus"
fi


if [ -z "$batch_uuid" ] ; then
	echo "not part of a batch"
else
	cp  "$TMPDIR"$uuid/$sku.$safe_product_name".epub"  "$TMPDIR"$batch_uuid/$sku.$safe_product_name".epub"
        cp  "$TMPDIR"$uuid/$sku.$safe_product_name".mobi"  "$TMPDIR"$batch_uuid/$sku.$safe_product_name".mobi"
        cp  "$TMPDIR"$uuid/$sku.$safe_product_name".docx"  "$TMPDIR"$batch_uuid/$sku.$safe_product_name".docx"
        cp  "$TMPDIR"$uuid/summary.txt   "$TMPDIR"$batch_uuid/$sku.$safe_product_name"_summary"
        cp  "$TMPDIR"$uuid/all_nouns.txt   "$TMPDIR"$batch_uuid/$sku.$safe_product_name"_all_nouns"
        cp  "$TMPDIR"$uuid/acronyms.txt   "$TMPDIR"$batch_uuid/$sku.$safe_product_name"_acronyms"
        cp  "$TMPDIR"$uuid/cover/wordcloudcover.png   "$TMPDIR"$batch_uuid/$sku.$safe_product_name"_wordcloudcover.png"
        cp  "$TMPDIR"$uuid/seeds/filtered.pagehits "$TMPDIR"$batch_uuid/$sku.$safe_product_name"_filtered.pagehits"
        #ls -l "$TMPDIR""$batch_uuid"/* # debug
fi


if [ "$dontcleanupseeds" = "yes" ]; then
	echo "leaving seed file in place $seedfile"
else
	echo "removing seedfile"
	rm "$seedfile"
  #	ls -la "$seedfile"
fi

echo "moving tmp biography to replace prior one"
cp "$LOCAL_DATA"/bibliography/robots/"$jobprofilename"/"$jobprofilename""_titles.tmp"  "$LOCAL_DATA"/bibliography/robots/"$jobprofilename"/"$jobprofilename""_titles.txt"
echo "appending & sorting new bibliography entries" # last item is out of alpha order, so must be sorted when read in future
echo "* $bibliography_title" >> "$LOCAL_DATA"bibliography/robots/"$jobprofilename"/"$jobprofilename"_titles.txt
echo "* $bibliography_title" >> "$LOCAL_DATA"bibliography/imprints/"$imprint"/"$imprint"_titles.txt
cat "$TMPDIR"$uuid"/yaml-metadata.md" >> "$LOCAL_DATA"bibliography/yaml/allbuilds.yaml

echo "exiting builder"
exit 0
