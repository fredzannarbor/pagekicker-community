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
ls -lart "$seedfile"

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
shift
truncate_seed=${1#*=}
;;
--sample_tweets)
sample_tweets=$2
shift 2
;;
--sample_tweets=*)
shift
sample_tweets=${1#*=}
;;
--ebook_format)
ebook_format=$2
shift 2
;;
--ebook_format=*)
shift
ebook_format=${1#*=}
;;
--jobprofilename)
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
--wikilang)
wikilang=$2
shift 2
;;
--wikilang=*)
wikilang=${1#*=}
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
--safe_product_name)
safe_product_name=$2
shift 2
;;
--safe_product_name=*)
safe_product_name=${1#*=}
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
--covercolor)
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
--editedby)
editedby=$2
shift 2
;;
--editedby=*)
editedby=${1#*=}
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
--customername)
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
--batch_uuid)
batch_uuid=$2
shift 2
;;
--batch_uuid=*)
batch_uuid=${1#*=}
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
--tldr)
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
ls -lart $seedfile

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

#echo "seedfile is " $seedfile
#ls -lart "seedfile is" $seedfile
if [ "$singleseed" = "no" ] ; then
	echo "no singleseed"
else
	seed="$singleseed"
	echo "seed is now singleseed" "$seed"
	echo "$seed" > "$seedfile"
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

"$PYTHON27_BIN" bin/wiki_seeds_2_pages.py --infile "$TMPDIR"$uuid"/seeds/sorted.seedfile" --pagehits "$TMPDIR"$uuid"/seeds/pagehits"

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

	# building front matter
	# removed title page b/c Pandoc already builds it
	echo "  " >>  "$TMPDIR"$uuid/titlepage.md
	echo "  " >>  "$TMPDIR"$uuid/titlepage.md
	echo "# About $editedby" >>  "$TMPDIR"$uuid/titlepage.md
	cat "$authorbio" >>  "$TMPDIR"$uuid/titlepage.md
	echo "  " >>  "$TMPDIR"$uuid/titlepage.md
	echo "  " >>  "$TMPDIR"$uuid/titlepage.md

	cp $scriptpath"assets/rebuild.md"  "$TMPDIR"$uuid/rebuild.md
	cp $confdir"jobprofiles/signatures/"$sigfile  "$TMPDIR"$uuid/$sigfile
	echo "# Acknowledgements from the PageKicker Robot Author" >>  "$TMPDIR"$uuid/robo_ack.md
	echo "I would like to thank "$editedby" for the opportunity to participate in writing this book." >>  "$TMPDIR"$uuid/robo_ack.md
	echo "  " >>  "$TMPDIR"$uuid/robo_ack.md
	echo "  " >>  "$TMPDIR"$uuid/robo_ack.md
	cat $scriptpath/assets/robo_ack.md >>  "$TMPDIR"$uuid/robo_ack.md
	echo "This book was created with revision "$SFB_VERSION "of the PageKicker software running on the "$environment "server." >>  "$TMPDIR"$uuid/robo_ack.md
	echo "  " >>  "$TMPDIR"$uuid/robo_ack.md
	echo "  " >>  "$TMPDIR"$uuid/robo_ack.md
	echo '<i>'"Ann Arbor, Michigan, USA"'</i>' >>  "$TMPDIR"$uuid/robo_ack.md
	echo "  " >>  "$TMPDIR"$uuid/robo_ack.md
	echo "  " >>  "$TMPDIR"$uuid/robo_ack.md
	echo '![Robot author photo]'"($sigfile)" >>  "$TMPDIR"$uuid/robo_ack.md


	# assemble front matter

	cat  "$TMPDIR"$uuid/titlepage.md  "$TMPDIR"$uuid/robo_ack.md  "$TMPDIR"$uuid/rebuild.md >  "$TMPDIR"$uuid/tmpfrontmatter.md

	if [ -z "$tldr" ]; then
		echo "no tl;dr"
	else
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "# TL;DR:" >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "$tldr" >>  "$TMPDIR"$uuid/tmpfrontmatter.md
	fi

	# assemble summary section (wiki human written)

	case $summary in
	summaries_only)
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "# Abstracts" >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		cat "$TMPDIR"$uuid"/wiki/wikisummaries.md" | sed -e 's/#/##/' >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		;;
	complete_pages_only)
		echo "using complete pages only for main body"
		;;
	both)
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "# Abstracts" >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "  " >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		cat "$TMPDIR"$uuid"/wiki/wikisummaries.md" | sed -e 's/#/##/' >>  "$TMPDIR"$uuid/tmpfrontmatter.md
		echo "  " >  "$TMPDIR"$uuid/tmpbody.md
		echo "  " >>  "$TMPDIR"$uuid/tmpbody.md
		echo "# Chapters" >>  "$TMPDIR"$uuid/tmpbody.md
		cat "$TMPDIR"$uuid"/wiki/wikipages.md" | sed -e 's/#/##/' >>  "$TMPDIR"$uuid/wiki/tmpbody.md
		echo "  " >  "$TMPDIR"$uuid/tmpbody.md
		echo "  " >>  "$TMPDIR"$uuid/tmpbody.md
;;
	*)
		echo "unrecognized summary option"
	;;
	esac


	echo "assembled front matter"

else
	echo "short form selected"
	echo '![cover image]'"(ebookcover.jpg)" >  "$TMPDIR"$uuid/tmpfrontmatter.md
	echo '!['"$imprintname"']'"(""$imprintlogo"")" >>  "$TMPDIR"$uuid/tmpfrontmatter.md

fi



	# assemble body

	if [ "$add_this_content" = "none" ] ; then
		echo "not adding user content"
	else
		echo "adding user-provided content file $add_this_content"

		echo "  " >>  "$TMPDIR"$uuid/add_this_content.md
		echo "  " >>  "$TMPDIR"$uuid/echo "  " >>  "$TMPDIR"$uuid/add_this_content.md
		echo "# $add_this_content_part_name" >> "$TMPDIR"$uuid"/tmpbody.md"
		cat "$TMPDIR"$uuid"/add_this_content.md" >> "$TMPDIR"$uuid"/tmpbody.md"
		echo "  " >> "$TMPDIR"$uuid"/tmpbody.md"
		echo "  " >> "$TMPDIR"$uuid"/tmpbody.md"
	fi

	if [ "$summary" = "summaries_only" ] ; then
		echo "no body"
	else
		echo "  " >>  "$TMPDIR"$uuid/tmpbody.md
		echo "  " >>  "$TMPDIR"$uuid/tmpbody.md
		echo "# Algorithmic Content" >>  "$TMPDIR"$uuid/tmpbody.md
		cat "$TMPDIR"$uuid"/wiki/wikipages.md" | sed -e 's/#/##/' >>  "$TMPDIR"$uuid/tmpbody.md
		echo "  " >>  "$TMPDIR"$uuid/tmpbody.md
		echo "  " >>  "$TMPDIR"$uuid/tmpbody.md


        # convert text so that I can add acronyms, programmatic summary, named entity recognition

        pandoc -S -o "$TMPDIR"$uuid/targetfile.txt -f markdown "$TMPDIR"$uuid/tmpbody.md



        # run acronym filter

        $scriptpath/bin/acronym-filter.sh --txtinfile  "$TMPDIR"$uuid/targetfile.txt >  "$TMPDIR"$uuid/acronyms.txt

        # external loop to run NER and summarizer on split file

        split -C 50K  "$TMPDIR"$uuid/targetfile.txt "$TMPDIR"$uuid"/xtarget."

        for file in "$TMPDIR"$uuid"/xtarget."*
        do

        "$PYTHON27_BIN" $scriptpath"bin/nerv3.py" $file $file"_nouns.txt" "$uuid"
        echo "ran nerv3 on $file" | tee --append $sfb_log
        cat "$TMPDIR$uuid"/Places >> "$TMPDIR"$batch_uuid"/"$sku"."$safe_product_name"_Places"
        cat "$TMPDIR$uuid"/People >>  "$TMPDIR"$batch_uuid"/"$sku"."$safe_product_name"_People"
        cat "$TMPDIR$uuid"/Other >>  "$TMPDIR"$batch_uuid"/"$sku"."$safe_product_name"_Other"
	echo "python_bin is" $PYTHON_BIN # debug
	"$PYTHON_BIN" --version
	#pip freeze # debug

        "$PYTHON_BIN" bin/PKsum.py -l "$summary_length" -o $file"_summary.txt" $file
        sed -i 's/ \+ / /g' $file"_summary.txt"
        cp $file"_summary.txt" $file"_pp_summary.txt"
        echo "ran summarizer on $file" | tee --append $sfb_log
        awk 'length>=50' $file"_pp_summary.txt" >  "$TMPDIR"$uuid/awk.tmp && mv  "$TMPDIR"$uuid/awk.tmp $file"_pp_summary.txt"
        #echo "postprocessor threw away summary lines shorter than 50 characters" | tee --append $sfb_log
        awk 'length<=4000' $file"_pp_summary.txt" >  "$TMPDIR"$uuid/awk.tmp && mv  "$TMPDIR"$uuid/awk.tmp $file"_pp_summary.txt"
        #echo "postprocessor threw away summary lines longer than 4000 characters" | tee --append $sfb_log
        #echo "---end of summary section of 140K bytes---" >> $file"_pp_summary.txt"
        #echo "---end of summary section of 140K bytes---" >> $file"_summary.txt"
        cat $file"_pp_summary.txt" >>  "$TMPDIR"$uuid/pp_summary.txt
        cat $file"_summary.txt" >>  "$TMPDIR"$uuid/summary.txt
        #sleep 3
        done
        ls  "$TMPDIR"$uuid/xtarget.*nouns* >  "$TMPDIR"$uuid/testnouns
        cat  "$TMPDIR"$uuid/xtarget.*nouns* >  "$TMPDIR"$uuid/all_nouns.txt
        sort --ignore-case  "$TMPDIR"$uuid/all_nouns.txt | uniq >  "$TMPDIR"$uuid/sorted_uniqs.txt
        sed -i '1i # Unique Proper Nouns and Key Terms \n'  "$TMPDIR"$uuid/sorted_uniqs.txt
        sed -i '2i \'  "$TMPDIR"$uuid/sorted_uniqs.txt
        sed -i G  "$TMPDIR"$uuid/sorted_uniqs.txt
        cp  "$TMPDIR"$uuid/sorted_uniqs.txt  "$TMPDIR"$uuid/sorted_uniqs.md
        sed -i '1i # Programmatically Generated Summary \'  "$TMPDIR"$uuid/pp_summary.txt
        sed -i G  "$TMPDIR"$uuid/pp_summary.txt
        sed -i '1i # Programmatically Generated Summary \'  "$TMPDIR"$uuid/summary.txt
        sed -i G  "$TMPDIR"$uuid/summary.txt

        if [ `wc -c <  "$TMPDIR"$uuid/pp_summary.txt` = "0" ] ; then
	        echo using "unpostprocessed summary bc wc pp summary = 0"
        else
	        cp  "$TMPDIR"$uuid/pp_summary.txt  "$TMPDIR"$uuid/summary.md
        fi
fi
	# assemble back matter
	echo "" >>   "$TMPDIR"$uuid/backmatter.md
	echo "" >>   "$TMPDIR"$uuid/backmatter.md


	if [ "$sample_tweets" = "yes" ] ; then
		echo "adding Tweets to back matter"
		cat  "$TMPDIR"$uuid/twitter/sample_tweets.md >>  "$TMPDIR"$uuid/backmatter.md
	else
		echo "no sample tweets"
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
	fi

if [ "$shortform" = "no" ] ;then

	echo "# Sources" >>  "$TMPDIR"$uuid/backmatter.md
 	cat includes/wikilicense.md >> $TMPDIR/$uuid/backmatter.md

	echo "# Also built by PageKicker Robot $jobprofilename" >>   "$TMPDIR"$uuid/backmatter.md
	sort -u --ignore-case "$LOCAL_DATA"bibliography/robots/"$jobprofilename"/$jobprofilename"_titles.txt" -o  "$LOCAL_DATA"bibliography/robots/"$jobprofilename"/$jobprofilename"_titles.txt" # currently sort by alphabetical
	cat "$LOCAL_DATA"/bibliography/robots/"$jobprofilename"/"$jobprofilename""_titles.txt" >>  "$TMPDIR"$uuid/backmatter.md
	echo " ">>  "$TMPDIR"$uuid/backmatter.md
	echo " " >>  "$TMPDIR"$uuid/backmatter.md

	echo "# Also from $imprintname" >>   "$TMPDIR"$uuid/backmatter.md
	uniq "$LOCAL_DATA"bibliography/imprints/"$imprint"/$imprint"_titles.txt" >>  "$TMPDIR"$uuid/backmatter.md # imprint pubs are not alpha

	echo "" >> "$TMPDIR"$uuid"/backmatter.md"
	echo "" >> "$TMPDIR"$uuid"/backmatter.md"

		if [ -z  ${url+x} ] ; then
			:
		else
			"$PANDOC_BIN" -s -r html "$analyze_url" -o  "$TMPDIR"$uuid"/analyzed_webpage.md"
			"$PYTHON_BIN" bin/nerv3.py  "$TMPDIR"$uuid"/analyzed_webpage.md"  "$TMPDIR"$uuid"/analyzed_webseeds" "$uuid"
			echo "# Webpage Analysis" >>  "$TMPDIR"$uuid/backmatter.md
			echo "I analyzed this webpage $url. I found the following keywords on the page."
			comm -2 -3 <(sort  "$TMPDIR"$uuid"/analyzed_webseeds") <(sort $scriptpath"locale/stopwords/webstopwords."$wikilang) >>  "$TMPDIR"$uuid"/backmatter.md
			echo "" >> "$TMPDIR"$uuid"/backmatter.md"
			echo "" >> "$TMPDIR"$uuid"/backmatter.md
		fi

	cat $confdir"jobprofiles/imprints/$imprint/""$imprint_mission_statement" >> "$TMPDIR"$uuid"/backmatter.md"
	echo '!['"$imprintname"']'"(""$imprintlogo"")" >>  "$TMPDIR"$uuid/backmatter.md
	echo "assembled back matter"

else
	echo "no back matter"

fi



# concatenate front matter, body & back matter

	if [ -s "$TMPDIR"$uuid"/tmpbody.md" ] ; then
		cat  "$TMPDIR"$uuid"/tmpbody.md" >>  "$TMPDIR"$uuid/tmpfrontmatter.md
	else
		echo "no body"
	fi
	cat  "$TMPDIR"$uuid/backmatter.md >>  "$TMPDIR"$uuid/tmpfrontmatter.md
	cp  "$TMPDIR"$uuid/tmpfrontmatter.md  "$TMPDIR"$uuid/complete.md

# create epub metadata

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

cat "$TMPDIR"$uuid/yaml-metadata.md >>  "$TMPDIR"$uuid/complete.md

# build ebook in epub


bibliography_title="$booktitle"
#echo "bibliography title is $bibliography_title"
safe_product_name=$(echo "$booktitle" | sed -e 's/[^A-Za-z0-9._-]/_/g')
cd  "$TMPDIR"$uuid
"$PANDOC_BIN" -o "$TMPDIR"$uuid/$sku"."$safe_product_name".epub" --epub-cover-image="$TMPDIR"$uuid/cover/$sku"ebookcover.jpg"  "$TMPDIR"$uuid/complete.md
"$PANDOC_BIN" -o "$TMPDIR"$uuid/$sku"."$safe_product_name".docx"   "$TMPDIR"$uuid/complete.md
cd $scriptpath
lib/KindleGen/kindlegen "$TMPDIR"$uuid/$sku."$safe_product_name"".epub" -o "$sku.$safe_product_name"".mobi" 1> /dev/null
#ls -lart  "$TMPDIR"$uuid
echo "built epub and mobi"

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
	ls -la "$seedfile"
fi

echo "appending & sorting new bibliography entries"
echo "* ""$bibliography_title" >> "$LOCAL_DATA"bibliography/robots/"$jobprofilename"/"$jobprofilename"_titles.txt
echo "* ""$bibliography_title" >> "$LOCAL_DATA"bibliography/imprints/"$imprint"/"$imprint"_titles.txt
cat "$TMPDIR"$uuid"/yaml-metadata.md" >> "$LOCAL_DATA"bibliography/yaml/allbuilds.yaml


echo "exiting builder"
exit 0
