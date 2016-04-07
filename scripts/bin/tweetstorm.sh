#!/bin/bash

# sends out a tweetstorm

# requires t cli client

# accepts either text file or directory of decimator files

echo "running $0"

starttime=$(( `date +%s` ))

# parse the command-line very stupidly


. includes/set-variables

if [ "$environment" = "Production" ] ; then

        . /opt/bitnami/apache2/htdocs/pk-production/production/conf/config.txt
        echo "running prod config" > ~/which_xform

else

        . /opt/bitnami/apache2/htdocs/pk-new/development/conf/config.txt
        echo "running dev config"  > ~/which_xform

fi

# get bzr revision
bazaar_revision=`bzr revno`
echo "bazaar revision number in" "$environment" "is" $bazaar_revision

cd $scriptpath
echo "scriptpath is" $scriptpath

export PATH=$PATH:/opt/bitnami/java/bin

echo "PATH is" $PATH
# default values

sleep_interval=60

# command line processing 


while :
do
case $1 in
--help | -\?)
echo "requires user to provide path to directory containing one or more txt files"
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
--txtinfile)
txtinfile=$2
shift 2
;;
--txtinfile=*)
txtinfile=${1#*=}
shift
;;
--decimator_dir)
decimator_dir=$2
shift 2
;;
--decimator_dir=*)
decimator_dir=${1#*=}
shift
;;
--stormtype)
stormtype=$2
shift 2
;;
--stormtype=*)
stormtype=$1{#*=}
shift
;;
--sleep_interval)
sleep_interval=$2
shift 2
;;
--sleep_interval=*)
sleep_interval=$1{#*=}
shift
;;
--docname)
docname=$2
shift 2
;;
--docname=*)
docname=$1{#*=}
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

echo  "stormtype is" $stormtype

if [ ! "$stormtype" ] ; then
  echo "ERROR: option '--stormtype' not given. See --help" >&2
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

# processing begins

case "$stormtype" in

txtinput)

if [ ! "$txtinfile" ] ; then
  echo "ERROR: option '--txtinfile' not given. See --help" >&2
  exit 1
else
	echo "going on to read txtinfile"
fi

echo "txtinfile is "$txtinfile
while read -r line;
do
	number=$((number + 1))
	message="$number"" ... ""$line"
	echo "message is" $message
	t update "$message"
	sleep "$sleep_interval"
done < "$txtinfile"

;;

decimator)

if [ ! "$decimator_dir" ] ; then
  echo "ERROR: option '--decimator_dir' not given. See --help" >&2
  exit 1
else
	echo "going on to post decimator files"
fi

mkdir -m 755 $scriptpath"../pk-html/"$uuid
cp tmp/$uuid/home.png $scriptpath/../pk-html/$uuid/home.png
cp tmp/$uuid/wordcloudslide.png $scriptpath/../pk-html/$uuid/wordcloudslide.png
cp tmp/$uuid/montage.png $scriptpath/../pk-html/$uuid/montage.png
cp tmp/$uuid/sum1.png $scriptpath/../pk-html/$uuid/sum1.png
cp tmp/$uuid/sum2.png $scriptpath/../pk-html/$uuid/sum2.png
cp tmp/$uuid/sum3.png $scriptpath/../pk-html/$uuid/sum3.png
cp tmp/$uuid/pageburst.png $scriptpath/../pk-html/$uuid/pageburst.png
cp tmp/$uuid/samplepages.png $scriptpath/../pk-html/$uuid/samplepages.png
cp tmp/$uuid/keywords.png $scriptpath/../pk-html/$uuid/keywords.png
cp tmp/$uuid/rrslide.png $scriptpath/../pk-html/$uuid/rrslide.png

mogrify -resize 1650x1275  $scriptpath"../pk-html/"$uuid"/*.png"

msg_before="Decimating ""$docname"" Home "
urlwc="http://pagekicker.com/"pk-new/development/pk-html/$uuid/home.png
message="$msg_before""$urlwc"
t update "$message"
sleep "$sleep_interval"

msg_before="Decimating ""$docname"" Wordcloud "
urlwc="http://pagekicker.com/"pk-new/development/pk-html/$uuid/wordcloudslide.png
message="$msg_before""$urlwc"
t update "$message"
sleep "$sleep_interval"

msg_before="Decimating ""$docname"" Image Montage"
urlwc="http://pagekicker.com/"pk-new/development/pk-html/$uuid/montage.png
message="$msg_before""$urlwc"
t update "$message"
sleep "$sleep_interval"

msg_before="Decimating ""$docname"" Sentence 1 "
urlwc="http://pagekicker.com/"pk-new/development/pk-html/$uuid/sum1.png
message="$msg_before""$urlwc"
t update "$message"
sleep "$sleep_interval"

msg_before="Decimating ""$docname"" Sentence 2 "
urlwc="http://pagekicker.com/"pk-new/development/pk-html/$uuid/sum2.png
message="$msg_before""$urlwc"
t update "$message"
sleep "$sleep_interval"

msg_before="Decimating ""$docname"" Sentence 3 "
urlwc="http://pagekicker.com/"pk-new/development/pk-html/$uuid/sum3.png
message="$msg_before""$urlwc"
t update "$message"
sleep "$sleep_interval"

msg_before="Decimating ""$docname"" Page Burst "
urlwc="http://pagekicker.com/"pk-new/development/pk-html/$uuid/pageburst.png
message="$msg_before""$urlwc"
t update "$message"
sleep "$sleep_interval"

msg_before="Decimating ""$docname"" Sample Pages"
urlwc="http://pagekicker.com/"pk-new/development/pk-html/$uuid/samplepages.png
message="$msg_before""$urlwc"
t update "$message"
sleep "$sleep_interval"

msg_before="Decimating ""$docname"" Keywords"
urlwc="http://pagekicker.com/"pk-new/development/pk-html/$uuid/keywords.png
message="$msg_before""$urlwc"
t update "$message"
sleep "$sleep_interval"

msg_before="Decimating ""$docname " " Readability Report "
urlwc="http://pagekicker.com/"pk-new/development/pk-html/$uuid/rrslide.png
message="$msg_before""$urlwc"
t update "$message"
sleep "$sleep_interval"
;;
*)
	echo "no storm type given"
;;
esac

exit
0



