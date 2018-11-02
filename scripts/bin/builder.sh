#!/bin/bash

# accepts book topic and book type definition, then builds book

loguuid=$(python  -c 'import uuid; print(uuid.uuid1())')

mkdir /tmp/pagekicker/"$loguuid"

touch /tmp/pagekicker/"$loguuid"/log

# exec redirect below begins a rather convoluted process that is necessary to enable
# the operation of a --verbose flag

exec 3>&1 >> /tmp/pagekicker/"$loguuid"/startuplog


echo "builder begins"
echo ""
echo "received from command line: "
echo "$@"
echo ""

if shopt -q  login_shell ; then

	if [ ! -f "$HOME"/.pagekicker/config.txt ]; then
		echo "config file not found, creating /home/<user>/.pagekicker, you need to put config file there"
		mkdir -p -m 755 "$HOME"/.pagekicker
		echo "exiting"
		exit 1
	else
		. "$HOME"/.pagekicker/config.txt
		echo "read config file from login shell $HOME""/.pagekicker/config.txt"
	fi
else
	.  "$HOME"/.pagekicker/config.txt #hard-code here to have a nonlogin shell run the script
	echo "read config file from nonlogin shell /home/$(whoami)/.pagekicker/config.txt"
fi

cd $scriptpath

. includes/set-variables.sh

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
exec 1>&3
echo "version $SFB_VERSION"
cat assets/builder-help.txt | more
exit 0  # This is not an error, the user requested help, so do not exit status 1.
;;
--verbose|-v)
exec 1>&3
echo "verbose on"
cat /tmp/pagekicker/$loguuid/startuplog
shift
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
-b|--byline)
editedby=$2
shift 2
;;
--byline=*)
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
--content_collections)
content_collections=$2
shift 2
;;
--content_collections=*)
content_collections=${1#*=}
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
--seedsviacli)
seedsviacli=$2
shift 2
;;
--seedsviacli=*)
seedsviacli=${1#*=}
shift
;;
--googler_on)
googler_on=$2
shift 2
;;
--googler_on=*)
googler_on=${1#*=}
shift
;;
--googler_news_on)
googler_news_on=$2
shift 2
;;
--googler_news_on=*)
googler_news_on=${1#*=}
shift
;;
--kindlegen_on)
kindlegen_on=$2
shift 2
;;
--kindlegen_on=*)
kindlegen_on=${1#*=}
shift
;;
--screen_numbered_seeds)
screen_numbered_seeds=$2
shift 2
;;
--screen_numbered_seeds=*)
screen_numbered_seeds=${1#*=}
shift
;;
--seedfortheday)
seedfortheday=$2
shift 2
;;
--seedfortheday=*)
seedfortheday=${1#*=}
shift
;;
--daily_email_post_to_wp)
daily_email_post_to_wp=$2
shift 2
;;
--daily_email_post_to_wp=*)
daily_email_post_to_wp=${1#*=}
shift
;;
--daily_email_post_to_wp_status)
daily_email_post_to_wp_status=$2
shift 2
;;
--daily_email_post_to_wp_status=*)
daily_email_post_to_wp_status=${1#*=}
shift
;;
--search_engine_registry)
search_engine_registry=$2
shift 2
;;
--search_engine_registry=*)
search_engine_registry=${1#*=}
shift
;;
--mediawiki_api_url)
mediawiki_api_url$2
shift 2
;;
--mediawiki_api_url=*)
mediawiki_api_url=${1#*=}
shift
;;
--url_prefix)
url_prefix$2
shift 2
;;
--url_prefix=*)
url_prefix=${1#*=}
shift
;;
--wikipath)
wikipath$2
shift 2
;;
--wikipath=*)
wikipath=${1#*=}
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
echo "loaded options"


echo "LOCAL_DATA is $LOCAL_DATA"

echo "add_this_content is $add_this_content"

echo "imprint is $imprint"
echo "editedby is $editedby"
echo "jobprofilename is $jobprofilename"

human_author="$editedby"
# Suppose some options are required. Check that we got them.

if [ ! "$passuuid" ] ; then
	echo "using loguuid"
	#uuid=$("$PYTHON_BIN"  -c 'import uuid; print(uuid.uuid1())')
	uuid=$loguuid
	echo "uuid is" $uuid
	mkdir -p -m 777  "$TMPDIR"$uuid
else
	uuid=$passuuid
	echo "received uuid " $uuid
	mkdir -p -m 777  "$TMPDIR"$uuid
fi

# create directories I will need

mkdir -p -m 755  "$TMPDIR$uuid/actual_builds"
mkdir -p -m 755  "$TMPDIR$uuid/apis"
mkdir -p -m 755  "$TMPDIR$uuid/cover"
mkdir -p -m 755  "$TMPDIR$uuid/twitter"
mkdir -p -m 777  "$TMPDIR$uuid/fetch"
mkdir -p -m 777  "$TMPDIR$uuid/flickr"
mkdir -p -m 777  "$TMPDIR$uuid/images"
mkdir -p -m 777  "$TMPDIR$uuid/mail"
mkdir -p -m 777  "$TMPDIR$uuid/content_collections"
mkdir -p -m 777  "$TMPDIR$uuid/search_engine_results"
mkdir -p -m 777  "$TMPDIR$uuid/seeds"
mkdir -p -m 777  "$TMPDIR$uuid/user"
mkdir -p -m 777  "$TMPDIR$uuid/wiki"
mkdir -p -m 777  "$TMPDIR$uuid/webseeds"

mkdir -p -m 755 -p $LOCAL_DATA"jobprofile_builds/""$jobprofilename"

echo "search engine registry is" "$search_engine_registry"


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

echo "getting path to seedfile from command line"
if [ -z "$seedfile" ] ; then
	echo "no seedfile provided"
		if [ -z "$singleseed" ] ; then
			echo "no singleseed provided"
				if [ -z "$seedsviacli" ] ; then
					echo "no seedsviacli provided"
					echo "exiting because no seeds provided"
					exit 0
				else
					echo "semi-colon seeds provided via command line"
					echo "$seedsviacli" | sed -e 's/; /;/g' -e $'s/;/\\\n/g' > "$TMPDIR"$uuid/seeds/seedphrases
				fi
		else
			seed="$singleseed"
			echo "seed is now singleseed" "$seed"
			echo "$singleseed" > "$TMPDIR"$uuid/seeds/seedphrases
		fi
else
	  echo "path to seedfile was $seedfile"
		cp $seedfile "$TMPDIR$uuid/seeds/seedphrases"
fi
echo "seedfile is $seedfile"

if [ -z "$booktitle" ] ; then
	echo "no booktitle provided by operator"

  seedcount=`cat $TMPDIR$uuid/seeds/seedphrases | tr '\n' ' ' | wc -l | tr -d ' '`
	echo "seedcount is $seedcount"
	if [ "$seedcount" -gt "1" ] ; then
		booktitle=$(head -n 1 "$TMPDIR$uuid/seeds/seedphrases")" and more"
			echo "arbitrary booktitle is $booktitle"
	else
		booktitle=$(head -n 1 "$TMPDIR$uuid/seeds/seedphrases")
		echo "arbitrary booktitle is $booktitle"
	fi
else
	echo "booktitle provided via command line is $booktitle"
fi

. includes/api-manager.sh


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

#if cmp -s "$seedfile" "$TMPDIR"$uuid"/seeds/seedphrases" ; then
#	echo "seedfiles are identical, no action necessary"
#else
#	echo "Rotating new seedfile into tmpdir"
#	cp "$seedfile"  "$TMPDIR"$uuid"/seeds/seedphrases"
#fi

cp $confdir"jobprofiles"/imprints/"$imprint"/"$imprintlogo"  "$TMPDIR""$uuid"
cp $confdir"jobprofiles"/signatures/"$sigfile" "$TMPDIR""$uuid"
cp $confdir"jobprofiles"/imprints/"$imprint"/"$imprintlogo" "$TMPDIR"$uuid"/cover"

# create placeholder seedfortheday file

touch "$TMPDIR$uuid/wiki/seedfortheday.md"

# extracts seeds from analyzed webpage

if [ -z  ${analyze_url+x} ] ; then
	echo "$analyze_url not set as analyze_url"
else
	if [[ $analyze_url =~ $httpvalidate ]] ; then
		echo "$analyze_url is valid URI"
		echo "analyze_url is set as $analyze_url"
		"$PANDOC_BIN" -s -r html "$analyze_url" -o  "$TMPDIR"$uuid"/webpage.md"
		#"$PYTHON27_BIN" bin/nerv3.py  "$TMPDIR"$uuid"/webpage.md"  "$TMPDIR"$uuid"/webseeds" "$uuid"
		cd "$NER_BIN" && java -mx600m -cp "*:lib/*" edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier classifiers/english.all.3class.distsim.crf.ser.gz -textFile "$TMPDIR"$uuid"/webpage.md" -outputFormat tabbedEntities > "$TMPDIR"$uuid"/webseeds"
		cd $scriptpath && echo "seeds have been extracted from analyze_url"
		head -n "$top_q"  "$TMPDIR"$uuid"/webseeds" | sed '/^\s*$/d' >  "$TMPDIR"$uuid"/webseeds.top_q"
		cat  "$TMPDIR"$uuid"/webseeds.top_q" >  "$TMPDIR"$uuid"/webseeds"
		comm -2 -3 <(sort  "$TMPDIR"$uuid"/webseeds") <(sort "locale/stopwords/webstopwords.en") >>  "$TMPDIR"$uuid/seeds/seedphrases
	else
		echo "invalid URI, analyze_url not added"
	fi
fi

# creates sorted & screened list of seeds
if [ "$screen_numbered_seeds" = "yes" ] ; then
	sort -u --ignore-case "$TMPDIR$uuid/seeds/seedphrases" 	| sed -e '/^$/d' -e '/^[0-9#@]/d' >  "$TMPDIR"$uuid/seeds/sorted.seedfile
	echo "screened out seeds beginning with 0-9, #, @"
else
	sort -u --ignore-case "$TMPDIR$uuid/seeds/seedphrases"  >  "$TMPDIR"$uuid/seeds/sorted.seedfile
fi

echo "---"
echo "seeds are"
cat "$TMPDIR$uuid/seeds/sorted.seedfile"
echo "---"

# look at $search_engine_registry


# decides what additional search engines will be used

# loops over searches

while IFS=, read -r search_engine_on search_plugin_path search_credentials
do
    echo "I got:" "$search_engine_on" "$search_plugin_path" "$search_credentials"
		if [ "$search_engine_on" = "yes" ] ; then
		   echo "test $search_plugin_path"
			 "$search_plugin_path"
	  else
			"not running search plugin $search_plugin_path"
		fi
done < "$search_engine_registry"

# Wikipedia search is on by default
echo "PYTHON_BIN" is "$PYTHON_BIN"
. includes/mediawiki-fetch-loop.sh


# adds search results to wiki4cloud

# testing with dummy data

#cp ~/lorem "$TMPDIR$uuid/search_engine_results/cumulative.md"

# end test

if [ "$search_engine_results" = "none" ] ; then
	echo "no search engine results to add to cover cloud"
	touch "$TMPDIR"$uuid/search_engine_results/cumulative.md
else
	echo "adding search engine results to cover cloud"
	cat "$TMPDIR$uuid/search_engine_results/cumulative.md" >> "$TMPDIR"$uuid/wiki/wiki4cloud.md
fi

# adds user-provided content

if [ "$add_this_content" = "none" ] ; then
	echo "no added content"
	touch "$TMPDIR"$uuid/add_this_content.md
else
	echo "adding user content to cover cloud"
	cp "$add_this_content" "$TMPDIR"$uuid"/add_this_content_raw"
	echo "$add_this_content"
	"$PANDOC_BIN" -f docx -s -t markdown -o "$TMPDIR"$uuid"/add_this_content.md "$TMPDIR"$uuid/add_this_content_raw"
	cat "$TMPDIR$uuid/add_this_content.md" >> "$TMPDIR$uuid/wiki/wiki4cloud.md"
fi

# use googler to get search snippets

if [ "$googler_on" = "yes" ] ; then
	. includes/googler.sh

else
	echo "not fetching Search Engine Snippets"
	touch "$TMPDIR$uuid/googler.md"
fi

	cat "$TMPDIR$uuid/googler.md" >> "$TMPDIR$uuid/wiki/wiki4cloud.md"

if [ "$googler_news_on" = "yes" ] ; then
	. includes/googler-news.sh

else
	echo "not fetching News Snippets"
	touch "$TMPDIR$uuid/googler-news.md"
fi

cat "$TMPDIR$uuid/googler-news.md" >> "$TMPDIR$uuid/wiki/wiki4cloud.md"

if [ -n "$content_collections" ] ; then
	echo "content collections has value"
	. includes/search-content-collections.sh
	cat "$TMPDIR$uuid/content_collections/content_collections_results.md" >> "$TMPDIR$uuid/wiki/wiki4cloud.md"
  "$PYTHON_BIN" bin/PKsum-clean.py -l "$summary_length" -o "$TMPDIR$uuid/content_collections/summary.md" "$TMPDIR$uuid/content_collections/content_collections_results.md"
else
	echo "not searching content collections"
	touch "$TMPDIR"$uuid/content_collections/content_collections_results.md
	touch "$TMPDIR"$uuid/content_collections/content_sources.md
fi

echo "summary is" $summary  #summary should be on for cover building
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

. includes/listofpages.sh

. includes/topics_covered_runon.sh

# changelog

. includes/changelog.sh

	# run acronyms, programmatic summary, nerv3
	# against wiki4cloud content

cat "$TMPDIR$uuid/wiki/wiki4cloud.md" >> "$TMPDIR$uuid/tmpbody.md"

"$PANDOC_BIN" -o "$TMPDIR"$uuid/targetfile.txt -t plain -f markdown+smart "$TMPDIR"$uuid/tmpbody.md

#split into chunks that can be handled in memory

split -b 50000  "$TMPDIR"$uuid/targetfile.txt "$TMPDIR"$uuid"/xtarget."

. includes/transect_summarize_ner.sh

# clean up both unprocessed and postprocessed summary text

  cp "$TMPDIR$uuid/pp_summary.txt" "$TMPDIR$uuid/clean_summary.txt"

	sed -i G  "$TMPDIR"$uuid/pp_summary.txt

	sed -i G  "$TMPDIR"$uuid/summary.txt
  echo
	sed -n 3p "$TMPDIR"$uuid/pp_summary.txt > "$TMPDIR"$uuid/pp_summary_all.txt # for tldr
	echo '\pagenumbering{gobble}' > "$TMPDIR"$uuid/pp_summary_sky.txt

	echo "  "  >> "$TMPDIR"$uuid/pp_summary_sky.txt
  sed -n 1,35p "$TMPDIR"$uuid/pp_summary.txt >> "$TMPDIR"$uuid/pp_summary_sky.txt # for skyscraper
  cp "$TMPDIR"$uuid/pp_summary_sky.txt $TMPDIR$uuid/pp_summary_sky.md

	# throw away unpreprocessed summary text if zero size

	if [ `wc -c <  "$TMPDIR"$uuid/pp_summary.txt` = "0" ] ; then
	  echo using "unpostprocessed summary bc wc pp summary = 0"
	  cat "$TMPDIR$uuid"/summary.txt >> $TMPDIR$uuid/programmaticsummary.md
	else
	  cp  "$TMPDIR"$uuid/pp_summary.txt  "$TMPDIR"$uuid/summary.md
		cat "$TMPDIR$uuid"/summary.md >> $TMPDIR$uuid/programmaticsummary.md
	fi

#tldr

. includes/tldr_auto.sh #returns tldr.txt and tldr.md

# assemble body

## user provided content


## encyclopedia content

if [ "$summary" = "summaries_only" ] ; then
	echo "no body"
	touch $TMPDIR$uuid/chapters.md
else
	echo "  " >> $TMPDIR$uuid/chapters.md
	echo "  " >>  "$TMPDIR"$uuid/chapters.md
	echo "# Encyclopedia Content" >>  "$TMPDIR"$uuid/chapters.md
	cat "$TMPDIR"$uuid"/wiki/wiki4chapters.md" | sed -e 's/#/##/' >>  "$TMPDIR"$uuid/chapters.md
	echo "  " >>  "$TMPDIR"$uuid/chapters.md
	echo "  " >>  "$TMPDIR"$uuid/chapters.md
fi

# assemble section for search engine content
# placeholder for testing

cp ~/lorem "$TMPDIR"$uuid"/search_engine_results/cumulative.md"

# end test

echo "  " >> $TMPDIR$uuid/search_engine_content.md
echo "  " >>  "$TMPDIR"$uuid/search_engine_content.md
echo "# Search Engine Content" >>  "$TMPDIR"$uuid/search_engine_content.md
cat "$TMPDIR"$uuid"/search_engine_results/cumulative.md" >>  "$TMPDIR"$uuid/search_engine_content.md
echo "  " >>  "$TMPDIR"$uuid/search_engine_content.md
echo "  " >>  "$TMPDIR"$uuid/search_engine_content.md

# acronyms

echo "# Acronyms" > $TMPDIR$uuid/tmpacronyms.md
echo " " >> $TMPDIR$uuid/tmpacronyms.md
echo " " >> $TMPDIR$uuid/tmpacronyms.md
$scriptpath/bin/acronym-filter.sh --txtinfile  "$TMPDIR"$uuid/targetfile.txt > "$TMPDIR"$uuid/acronyms.txt
sed G $TMPDIR$uuid/acronyms.txt | sed 's/^#/[hashtag]/g' >> $TMPDIR$uuid/acronyms.md
cat $TMPDIR$uuid/acronyms.md >> $TMPDIR$uuid/tmpacronyms.md
cp $TMPDIR$uuid/tmpacronyms.md $TMPDIR$uuid/acronyms.md

# Unique nouns
cat "$TMPDIR"$uuid/Places "$TMPDIR"$uuid/People "$TMPDIR"$uuid/Other > "$TMPDIR"$uuid/all_nouns.txt
#ls  "$TMPDIR"$uuid/xtarget.*nouns* >  "$TMPDIR"$uuid/testnouns
# cat  "$TMPDIR"$uuid/xtarget.*nouns* >  "$TMPDIR"$uuid/all_nouns.txt
sort --ignore-case  "$TMPDIR"$uuid/all_nouns.txt | sed 's/^#/[hashtag]/g' | uniq >  "$TMPDIR"$uuid/sorted_uniqs.txt
sed '1s/^/# Unique Proper Nouns and Key terms\n/' "$TMPDIR"$uuid/sorted_uniqs.txt > $TMPDIR$uuid/tmpuniqs.txt
cp "$TMPDIR"$uuid/tmpuniqs.txt "$TMPDIR"$uuid/sorted_uniqs.txt
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

# Build sources page

	echo "# Sources" >>  "$TMPDIR$uuid/sources.md"
  echo "  "  >>  "$TMPDIR$uuid/sources.md"
	while IFS= read -r line; do

	safeline=$(echo $line | sed -e 's/[ ]/_/g')
	echo "Wikipedia contributors, $line, Wikipedia, The Free Encyclopedia, https://en.wikipedia.org/w/index.php?title=$safeline, accessed $(date +"%m-%d-%Y")."  >>  "$TMPDIR$uuid/wiki/wikisources.md"
  echo "  "  >>  "$TMPDIR"$uuid/wiki/wikisources.md
	echo "  "  >>  "$TMPDIR"$uuid/wiki/wikisources.md
	done < "$TMPDIR$uuid/seeds/filtered.pagehits"

# add search engine results to sources section

while IFS= read -r line; do
	safeline=$(echo $line | sed -e 's/[ ]/_/g')
	echo "$search_plugin_name", $line, Wikipedia, The Free Encyclopedia, https://en.wikipedia.org/w/index.php?title=$safeline, accessed $(date +"%m-%d-%Y").  >>  "$TMPDIR$uuid/wiki/wikisources.md"
	echo "  "  >>  "$TMPDIR"$uuid/wiki/wikisources.md
	echo "  "  >>  "$TMPDIR"$uuid/wiki/wikisources.md
done < "$TMPDIR$uuid/seeds/filtered.pagehits"

# pipe other sources in here, either apppend with ## second-level heading or sort -u

  cat "$TMPDIR"$uuid/content_collections/content_sources.md >> "$TMPDIR"$uuid/sources.md
  cat "$TMPDIR"$uuid/wiki/wikisources.md >> "$TMPDIR"$uuid/sources.md

 	cat includes/wikilicense.md >> "$TMPDIR/$uuid/sources.md"
	echo "" >> "$TMPDIR$uuid/sources.md"
	echo "" >> "$TMPDIR$uuid/sources.md"

	echo "# Also built by "$imprintname" Robot $jobprofilename" >>   "$TMPDIR"$uuid/builtby.md
	sort -u --ignore-case "$LOCAL_DATA"bibliography/robots/"$jobprofilename"/$jobprofilename"_titles.txt" -o  "$LOCAL_DATA"/bibliography/robots/"$jobprofilename"/$jobprofilename"_titles.tmp" # currently sort by alphabetical
	cat "$LOCAL_DATA"/bibliography/robots/"$jobprofilename"/"$jobprofilename""_titles.tmp" >>  "$TMPDIR"$uuid/builtby.md
	echo " ">>  "$TMPDIR"$uuid/builtby.md
	echo " " >>  "$TMPDIR"$uuid/builtby.md

echo "starting imprint biblio"

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

# builds analyzed webpage info for back matter"

echo "$analyze_url is analyze_url"
touch "$TMPDIR"$uuid"/analyzed_webpage.md"

# if [ -z  ${analyze_url+x} ] ; then
#
# 			 echo "no web page was analyzed"
# else
# 			echo "" >> "$TMPDIR"$uuid"/analyzed_webpage.md"
# 			echo "" >> "$TMPDIR"$uuid/"analyzed_webpage.md"
# 			"$PANDOC_BIN" -s -r html "$analyze_url" -o  "$TMPDIR"$uuid"/analyzed_webpage.md"
# 			#"$PYTHON_BIN" bin/nerv3.py  "$TMPDIR"$uuid"/analyzed_webpage.md"  "$TMPDIR"$uuid"/analyzed_webseeds" "$uuid"
# 			cd "$NER_BIN" && java -mx600m -cp "*:lib/*" edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier classifiers/english.all.3class.distsim.crf.ser.gz -textFile "$TMPDIR"$uuid"/webpage.md" -outputFormat tabbedEntities > "$TMPDIR"$uuid"/webseeds"
# 			cd ""$scriptpath"
# 			echo "# Webpage Analysis" >>  "$TMPDIR"$uuid/analyzed_webpage.md
# 			echo "I analyzed this webpage $analyze_url. I found the following keywords on the page."  >> "$TMPDIR"$uuid/analyzed_webpage.md"
# 			comm -2 -3 <(sort  "$TMPDIR"$uuid"/analyzed_webseeds") <(sort $scriptpath"locale/stopwords/webstopwords."$wikilang) >>  "$TMPDIR"$uuid"/analyzed_webpage.md
# 			echo "" >> "$TMPDIR"$uuid"/analyzed_webpage.md"
# 			echo "" >> "$TMPDIR"$uuid"/analyzed_webpage.md"
# fi

touch "$TMPDIR"$uuid/imprint_mission_statement.md
echo "imprint is $imprint"
cat $confdir"jobprofiles/imprints/$imprint/""$imprint_mission_statement" >> "$TMPDIR"$uuid"/imprint_mission_statement.md"
echo '!['"$imprintname"']'"(""$imprintlogo"")" >>  "$TMPDIR"$uuid/imprint_mission_statement.md
echo "built back matter"

my_year=`date +'%Y'`

echo "" >  "$TMPDIR"$uuid/yaml-metadata.md
echo "---" >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "title: \"$booktitle\"" >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "subtitle: \"$subtitle\"" >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "creator: " >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "- role: author "  >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "  text: "" \"$editedby\""  >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "publisher: \"$imprintname\""  >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "rights:  (c) \"$my_year $imprintname\"" >>  "$TMPDIR"$uuid/yaml-metadata.md
echo "---" >>  "$TMPDIR"$uuid/yaml-metadata.md

safe_product_name=$(echo "$booktitle" | sed -e 's/[^A-Za-z0-9._-]/_/g')
bibliography_title=$(echo "$booktitle" | sed -e 's/[^A-Za-z0-9 :;,.?]//g')

#always builds all partsofthebook
echo "starting parts of the book assembler"
. includes/partsofthebook.sh

# always builds cover
echo "starting cover builder"
. includes/builder-cover.sh

# sometimes build additional booktypes

case $booktype in
reader)
	# default
  echo "assembled all parts of the book by default"
  ;;
draft-report)
	echo "assembling parts needed for $booktype"
  . includes/draft-report.sh
	"$PANDOC_BIN" -o "$TMPDIR$uuid/draft-report-$safe_product_name.docx"   "$TMPDIR"$uuid/draft-report.md
	"$PANDOC_BIN" -t mediawiki -o "$TMPDIR$uuid/draft-report-$safe_product_name.mw"   "$TMPDIR"$uuid/draft-report.md
	cp "$TMPDIR$uuid/draft-report.md" "$TMPDIR$uuid/complete.md"
	# note that draft-report does not get SKU because it is not a completed product
  ;;
content-collections-first)
		echo "assembling parts needed for $booktype"
	  . includes/content-collections-first.sh
		"$PANDOC_BIN" -o "$TMPDIR$uuid/ccf-$safe_product_name.docx"   "$TMPDIR"$uuid/content-collections-first.md
		# note that content-collections-first does not get SKU because it is not a completed product
	  ;;
daily-email)
				echo "assembling parts needed for $booktype"
			  . includes/daily-email.sh
			  ;;
*)
  echo "assembled all parts of the book by default"
  ;;
esac

# build ebook in epub

cd  "$TMPDIR"$uuid
"$PANDOC_BIN" -o "$TMPDIR"$uuid/$sku"."$safe_product_name".epub" --epub-cover-image="$TMPDIR"$uuid/cover/$sku"ebookcover.jpg"  "$TMPDIR"$uuid/complete.md
"$PANDOC_BIN" -o "$TMPDIR"$uuid/$sku"."$safe_product_name".docx"   "$TMPDIR"$uuid/complete.md
"$PANDOC_BIN" -o "$TMPDIR"$uuid/$sku"."$safe_product_name".txt"   "$TMPDIR"$uuid/complete.md
"$PANDOC_BIN" -o "$TMPDIR"$uuid/$sku"."$safe_product_name".mw" -t mediawiki -s  "$TMPDIR"$uuid/complete.md
cp "$TMPDIR"$uuid/$sku"."$safe_product_name".txt" "$TMPDIR"$uuid/4stdout".txt"



cd $scriptpath

if [ "$kindlegen_on" = "yes" ] ; then

	lib/KindleGen/kindlegen "$TMPDIR"$uuid/$sku."$safe_product_name"".epub" -o "$sku.$safe_product_name"".mobi"
else
	ebook-convert "$TMPDIR"$uuid/$sku."$safe_product_name"".epub" "$TMPDIR"$uuid"/$sku.$safe_product_name"".mobi"
fi

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

unique_seed_string=$(sed -e 's/[^A-Za-z0-9._-]//g' <  "$TMPDIR"$uuid/seeds/sorted.seedfile | tr -d '\n')

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
	true
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
echo "seedfile is $seedfile"

if [ "$dontcleanupseeds" = "yes" ]; then
	echo "leaving seed file in place $seedfile"
	# default is "yes" in includes/set-variables
else
  echo "cleaning up seed file [deprecated, for use with Magento script tool]"
	rm "$seedfile"
fi

# increment sku

sku=$((sku+1))
echo $sku >> "$LOCAL_DATA""SKUs/sku_list"
echo "incremented SKU by 1 to" $sku " and updated SKUs/sku_list"

echo "moving tmp biography to replace prior one"
cp "$LOCAL_DATA"bibliography/robots/"$jobprofilename"/"$jobprofilename""_titles.tmp"  "$LOCAL_DATA"/bibliography/robots/"$jobprofilename"/"$jobprofilename""_titles.txt"
echo "appending & sorting new bibliography entries"   # last item is out of alpha order, so must be sorted when read in future
echo "adding markdown-safe bibliography title as $bibliography_title"
echo "* $bibliography_title" >> "$LOCAL_DATA"bibliography/robots/"$jobprofilename"/"$jobprofilename"_titles.txt
echo "* $bibliography_title" >> "$LOCAL_DATA"bibliography/imprints/"$imprint"/"$imprint"_titles.txt
cat "$TMPDIR"$uuid"/yaml-metadata.md" >> "$LOCAL_DATA"bibliography/yaml/allbuilds.yaml

# add some simple tests that builds worked ok

# always reports success, whether verbose is on or off

exec 1>&3
echo "builder run complete, files in $TMPDIR$uuid/"

exit 0
