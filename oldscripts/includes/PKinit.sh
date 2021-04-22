#!/bin/bash

echo '------------------------------'
TEXTDOMAIN=SFB
echo $"hello, world"

. ../conf/config.txt

echo "software id in $environment is " $SFB_VERSION

echo "completed reading config file and  beginning logging at" `date +'%m/%d/%y%n %H:%M:%S'` | tee --append $sfb_log

echo "SFB version is SFB"$SFB_VERSION | tee --append $sfb_log

starttime=$(( `date +%s` ))

echo "starttime for performance monitoring is ..." $starttime | tee --append $sfb_log

. includes/initialize-default-normal-values-of-flag-variables.sh

. flags.sh 

# parse the command-line
FLAGS "$@" || exit 1
eval set -- "${FLAGS_argv}"

# command line options trump jobprofiles

. includes/set-variables-via-flags.sh

# jobprofiles trump command line

jobprofile=${FLAGS_jobprofile}

. ../conf/jobprofiles/$jobprofile

echo "read jobprofile" $jobprofile | tee --append $sfb_log


if [ "$verbose" = "yes" ] ; then

	. includes/echo-variables.sh

else

	echo "not echoing variable values, you must think you know what you're doing"

fi

. includes/api-manager.sh


if [ "$pass_uuid" = "no" ] ; then

	uuid=$(python  -c 'import uuid; print uuid.uuid1()')
	echo "new uuid for this instance is" $uuid | tee --append $sfb_log

else
	
	uuid=$pass_uuid
	echo "received uuid from parent instance, uuid is" $uuid | tee --append $sfb_log

fi

# add to jobs file

#passwordflag="--password"
#passwordvalue=$LOCAL_MYSQL_PASSWORD
#passwordtext=$passwordflag$passwordvalue
#echo $passwordtext



$LOCAL_MYSQL_PATH --user $LOCAL_MYSQL_USER --password=$LOCAL_MYSQL_PASSWORD sfb-jobs << EOF
insert into jobs (uuid, SFB_revision_no) values('$uuid', '$bazaar_revision');
EOF

echo "added job row to SFB database" | tee --append $sfb_log


mkdir -m 755 tmp/$uuid
mkdir -m 755 fetch/$uuid
mkdir -m 755 $metadatatargetpath$uuid
mkdir -m 755 $mediatargetpath$uuid
mkdir -m 755 seeds/uuids/$uuid
mkdir -m 755 $logdir$uuid
mkdir -m 755 images/$uuid
mkdir -m 755 mail/$uuid

#initial values of command line options

#writing initial values of program paths to log

if [ $verbose = "yes" ] ; then

	echo 'default values are' | tee --append $sfb_log
	echo "metadatatargetpath is " $metadatatargetpath | tee --append $sfb_log
	echo "mediatargetpath is" $mediatargetpath | tee --append $sfb_log
	echo "media archive txt target path is " $mediaarchivetxt | tee --append $sfb_log
	echo "deliverytargetpath is " $deliverytargetpath | tee --append $sfb_log
	echo "scriptpath is " $scriptpath | tee --append $sfb_log
	echo "imagedir" is $imagedir | tee --append $sfb_log
	echo  "cover_image_extension" is $cover_image_extension | tee --append $sfb_log
	echo "ebook introductory boilerplate is " $ebookintro | tee --append $sfb_log

fi	

sfb_log=$logdir/$uuid/sfb_log.$uuid".txt"


if [ "$verbose" = "yes" ] ; then

	cat ../conf/config.txt | tee --append $sfb_log

fi	

if [ "$verbose" = "yes" ] ; then

	. includes/echo-variables.sh

fi

