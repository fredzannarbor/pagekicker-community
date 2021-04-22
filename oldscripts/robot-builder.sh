#!/bin/bash
# builds robot files on receipt of xml payload from webform

# requires directory name and xml file name
echo "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"

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

starttime=$(( `date +%s` ))

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
--storeids)
storeids=$2
shift 2
;;
--storeids=*)
storeids=${1#*=}
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
--format=*)
format=${1#*=}
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
--add_corpora)
add_corpora=$2
shift 2
;;
--add_corpora=*)
add_corporaa=${1#*=}
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
	uuid=$("$PYTHON_BIN"  -c 'import uuid; print uuid.uuid1()')
	echo "uuid is" $uuid | tee --append $xform_log

else
	uuid="$passuuid"
	echo "received uuid " $uuid

fi

# create directories I will need

mkdir -p -m 777 $TMPDIR
mkdir -p -m 777 $TMPDIR$uuid
mkdir -p -m 777 $TMPDIR$uuid/robot-builder



case "$format" in 
xml)
	echo "getting metadata from xml file"

	xmlbasepath="$WEBFORMSXML_HOME"

	echo "xmlbasepath is" $xmlbasepath
	echo "xmlfilename is" $xmlfilename
	xmlfilename=$xmlbasepath/$xmlfilename

	customer_email=$(xmlstarlet sel -t -v "/item/customer_email" "$xmlfilename")
	exemplar_file=$(xmlstarlet sel -t -v "/item/exemplar_file" "$xmlfilename")
	jobprofilename=$(xmlstarlet sel -t -v "/item/jobprofilename" "$xmlfilename")
	wikilang=$(xmlstarlet sel -t -v "/item/wikilang" "$xmlfilename")
	revenue_share=$(xmlstarlet sel -t -v "/item/revenue_share" "$xmlfilename")
	sources=$(xmlstarlet sel -t -v "/item/sources" "$xmlfilename")
	submissionid=$(xmlstarlet sel -t -v "/item/id" "$xmlfilename")
	coverfont=$(xmlstarlet sel -t -v "/item/coverfont" "$xmlfilename")
	covercolor=$(xmlstarlet sel -t -v "/item/covercolor" "$xmlfilename")
	customername=$(xmlstarlet sel -t -v "/item/customername" "$xmlfilename")
	customerid=$(xmlstarlet sel -t -v "/item/customer_id" "$xmlfilename")

	echo "environment is" $environment  | tee --append $xform_log
	echo "jobprofilename is" $jobprofilename  | tee --append $xform_log
	echo "exemplar_file is" $exemplar_file | tee --append $xform_log
	

	# cp $WEBFORMSHOME$submissionid/$exemplar_filedir_code/*/$exemplar_file $TMPDIR$uuid/$exemplar_file
;;
csv)
	echo "getting metadata from csv"
	cp $seedfile $TMPDIR$uuid/seeds/seedphrases
;;
*)
	echo "getting metadata from command line"
	cp $seedfile $TMPDIR$uuid/seeds/seedphrases
;;
esac
-
	robotname=$(xmlstarlet sel -t -v "/item/robotname" "$xmlfilename")
	robotresidence=$(xmlstarlet sel -t -v "/item/robotresidence" "$xmlfilename")
	robotbooktype=$(xmlstarlet sel -t -v "/item/robotbooktype" "$xmlfilename")
	robotcoverfont=$(xmlstarlet sel -t -v "/item/robotcoverfont" "$xmlfilename")
	robotcovercolor=$(xmlstarlet sel -t -v "/item/robotcovercolor" "$xmlfilename")
	robotbio=$(xmlstarlet sel -t -v "/item/robotbio" "$xmlfilename")
	robotrows=$(xmlstarlet sel -t -v "/item/robotrows" "$xmlfilename")
	robotlanguage=$(xmlstarlet sel -t -v "/item/robotlanguage" "$xmlfilename")
        
	echo "robotname was" $robotname | tee --append $xform_log
	echo "robotresidence was" $robotresidence | tee --append $xform_log
	echo "robotbooktype was" $robotbooktype | tee --append $xform_log
	echo "robotcoverfont was" $robotcoverfont | tee --append $xform_log
	echo "robotcovercolor was" $robotcovercolor | tee --append $xform_log
	echo "robotbio was" $robotbio | tee --append $xform_log
	echo "robotrows was" $robotrows | tee --append $xform_log


echo 'firstname=""' > $confdir"jobprofiles/$robotname".jobprofile
echo 'middlename=""' >> $confdir"jobprofiles/$robotname".jobprofile
echo 'lastname="'"$robotname"'"' >> $confdir"jobprofiles/$robotname".jobprofile
echo 'editedby="$firstname" "$middlename" "$lastname"' >> $confdir"jobprofiles/$robotname".jobprofile
echo "$robotbio" > $confdir"jobprofiles/authorbios/"$robotname".md"
echo 'authorbio="$SFB_HOME''/conf/jobprofiles/authorbios/'"$robotname".md'"' >> $confdir"jobprofiles/$robotname".jobprofile
cat $confdir"jobprofiles/defaults" >> $confdir"jobprofiles/$robotname".jobprofile

mkdir -p -m 755 "$LOCAL_DATA"bibliography/robots/$jobprofilename/$jobprofilename
touch "$LOCAL_DATA"bibliography/robots/"$jobprofilename"/"$jobprofilename"_titles.txt

# create robot webpage 

# create robot birth announcement


sendemail -t "$customer_email" \
	-u "PageKicker robot" $robotname " has been created." \
	-m "PageKicker robot " $robotname "has been created and is ready to go to work! \
	-a $confdir"jobprofiles/authorbios/"$robotname".md" \
	-a $confdir"jobprofiles/$robotname".jobprofile \
	-f "$GMAIL_ID" \
	-cc "$GMAIL_ID" \
	-xu "$GMAIL_ID" \
	-xp "$GMAIL_PASSWORD" \
	-s smtp.gmail.com:587 \
	-o tls=yes

echo "completed building robot $robotname, exiting"
echo "^^^^RRRR^^^^"
exit 0


