#!/bin/bash

# requires inotify to alert that xml file has been created by the Magento webforms plugin and deposited in the correct directory
# which is set by incrontab command for the bitnami user

starttime=$(( `date +%s` ))
datenow=$(date -R)

# parse the command-line very stupidly

xmldirectoryname=$1 # this is different when run from the command line v. from incrontab!
xmlbasefile=$2 # this is different when run from the command line!
echo "parameter 1 is" $1
echo  "parameter 2 is" $2
xmlfilename=$xmldirectoryname/$xmlbasefile

environment=$(xmlstarlet sel -t -v "/item/environment" "$xmlfilename")

. ../conf/"config.txt"
echo "loaded $environment config file at " $datenow 

uuid=$(python  -c 'import uuid; print uuid.uuid1()')
mkdir -p -m 755 $logdir$uuid 
xform_log=$logdir$uuid/"xform_log"
echo "XXXXXXXXXX" | tee --append $xform_log
echo "xmlfilename provided by webforms is" $xmlfilename | tee --append $xform_log
echo "xform_log is" $xform_log | tee --append $xform_log
echo "started xform at " $starttime " details in" $xform_log "at" $xform_log | tee --append $xform_log


sku=`tail -1 < "$LOCAL_DATA""SKUs/sku_list"`
echo "sku" $sku | tee --append $xform_log

echo "$0 version in $environment" "is" $SFB_VERSION | tee --append $xform_log

cd $scriptpath
echo "scriptpath is" $scriptpath 

export PATH=$PATH:/opt/bitnami/java/bin

echo "PATH is" $PATH | tee --append $xform_log


# use xmlstarlet to extract variable values that are common to all Magento forms
submissionid=$(xmlstarlet sel -t -v "/item/id" "$xmlfilename")
webform_id=$(xmlstarlet sel -t -v "/item/webform_id" "$xmlfilename")
customerid=$(xmlstarlet sel -t -v "/item/customer_id" "$xmlfilename")
customer_name=$(xmlstarlet sel -t -v "/item/customer_name" "$xmlfilename")
customer_email=$(xmlstarlet sel -t -v "/item/customer_email" "$xmlfilename")


# echo them back so I can see that they are the correct variable values

echo "webform_id was" $webform_id | tee --append $xform_log
echo "submissionid was" $submissionid | tee --append $xform_log
echo "customerid was " $customerid | tee --append $xform_log
echo "customername was" $customer_name | tee --append $xform_log
echo "customeremail was" $customer_email | tee --append $xform_log $sfb_log

# begin case loop that checks to see what form has been submitted and acts accordingly

case $webform_id in

4)

# echo "found Magento form submission id 4, executing ccc"

$scriptpath"bin/create-catalog-entry.sh" --xmlfilename "$xmlbasefile" --passuuid "$uuid" --format "xml" --builder "no"

echo "launched $0 from" $environment 
;;

21) 

	echo "running create your robot form 21" | tee --append $xform_log
	robotname=$(xmlstarlet sel -t -v "/item/robotname" "$xmlfilename")
	robotresidence=$(xmlstarlet sel -t -v "/item/robotresidence" "$xmlfilename")
	robotbooktype=$(xmlstarlet sel -t -v "/item/robotbooktype" "$xmlfilename")
	robotcoverfont=$(xmlstarlet sel -t -v "/item/robotcoverfont" "$xmlfilename")
	robotcovercolor=$(xmlstarlet sel -t -v "/item/robotcovercolor" "$xmlfilename")
	robotbio=$(xmlstarlet sel -t -v "/item/robotbio" "$xmlfilename")
	robotrows=$(xmlstarlet sel -t -v "/item/robotrows" "$xmlfilename")
	robotlanguage=$(xmlstarlet sel -t -v "/item/robotlanguage" "$xmlfilename")
        
        # summarizer flags

#        summarizer_on=$(xmlstarlet sel -t -v "/item/summarizer" "$xmlfilename")
#        robot_summary_length=$(xmlstarlet sel -t -v "/item/summary_length" "$xmlfilename")
#        positive_seeds=$(xmlstarlet sel -t -v "/item/positive_seeds" "$xmlfilename")
#        positive_seed_weight=$(xmlstarlet sel -t -v "/item/positive_seed_weight" "$xmlfilename")
#        negative_seeds=$(xmlstarlet sel -t -v "/item/negative_seeds" "$xmlfilename")
#        negative_seed_weight=$(xmlstarlet sel -t -v "/item/negative_seed_weight" "$xmlfilename")
#        summarizer_ngram_threshold=$(xmlstarlet sel -t -v "/item/summarizer_ngram_threshold" "$xmlfilename")

	echo "robotname was" $robotname | tee --append $xform_log
	echo "robotresidence was" $robotresidence | tee --append $xform_log
	echo "robotbooktype was" $robotbooktype | tee --append $xform_log
	echo "robotcoverfont was" $robotcoverfont | tee --append $xform_log
	echo "robotcovercolor was" $robotcovercolor | tee --append $xform_log
	echo "robotbio was" $robotbio | tee --append $xform_log
	echo "robotrows was" $robotrows | tee --append $xform_log
	echo "robotlanguage was" $robotlanguage | tee --append $xform_log
#        echo "robot_summary_length was "$robot_summary_length | tee --append $xform_log
#        echo "robot_summarizer_on was" $summarizer_on | tee --append $xform_log
#        echo "positive_seeds were" $positive_seeds| tee --append $xform_log
#        echo "positive_seed_weight was" $positive_seed_weight| tee --append $xform_log
#        echo "negative_seeds were" $negative_seeds| tee --append $xform_log
#        echo "negative_seed_weight was "$negative_seed_weight| tee --append $xform_log
#        echo "summarizer_ngram_threshold was" $summarizer_ngram_threshold| tee --append $xform_log

echo 'firstname=""' > $confdir"jobprofiles/$robotname".jobprofile
echo 'middlename=""' >> $confdir"jobprofiles/$robotname".jobprofile
echo 'lastname="'"$robotname"'"' >> $confdir"jobprofiles/$robotname".jobprofile
echo 'editedby="$firstname" "$middlename" "$lastname"' >> $confdir"jobprofiles/$robotname".jobprofile
echo "$robotbio" > $confdir"jobprofiles/authorbios/"$robotname".md"
echo 'authorbio="$SFB_HOME''/conf/jobprofiles/authorbios/'"$robotname".md'"' >> $confdir"jobprofiles/$robotname".jobprofile
cat $confdir"jobprofiles/defaults" >> $confdir"jobprofiles/$robotname".jobprofile

mkdir -p -m 755 $confdir"jobprofiles/bibliography/"$lastname

#$LOCAL_MYSQL_PATH --user $LOCAL_MYSQL_USER --password=$LOCAL_MYSQL_PASSWORD sfb-jobs << EOF
#insert into robots (robot_name, robot_bio, robot_summarizer_on, robot_positive_summary_seed, robot_positive_summary_seed_weight, robot_summary_length, robot_negative_seeds, robot_negative_seed_weight, robot_coverfont, robot_covercolor, robot_ngram_threshold,  robot_language, robot_rows, robot_experience_points_initial) values('$robotname', '$robotbio', '$summarizer_on', '$positive_seeds', '$positive_seed_weight', '$robot_summary_length', '$negative_seeds', '$negative_seed_weight','$robotcoverfont', '$robotcovercolor',  '$summarizer_ngram_threshold', '$robotlanguage', '$robotrows', '100');
#EOF

sendemail -t "$customer_email" \
	-u "PageKicker robot" $robotname " has been created." \
	-m "PageKicker robot " $robotname "has been created and is ready to go to work! The attached files are for debugging during development, you can ignore them." \
	-a $confdir"jobprofiles/authorbios/"$robotname".md" \
	-a $confdir"jobprofiles/$robotname".jobprofile \
	-f "$GMAIL_ID" \
	-cc "$GMAIL_ID" \
	-xu "$GMAIL_ID" \
	-xp "$GMAIL_PASSWORD" \
	-s smtp.gmail.com:587 \
	-o tls=yes

;;

23)

# echo "running dat.sh with xml file from webform"
$scriptpath"bin/dat.sh" --xmldirectoryname "$xmldirectoryname" --xmlbasefile "$xmlbasefile"  --passuuid "$uuid" --environment "$environment"
;;



24)

        echo "Automatically Build the Cover for Your Printed Book" | tee --append $xform_log
        covercolor=$(xmlstarlet sel -t -v "/item/covercolor" "$xmlfilename")
        coverfontcolor=$(xmlstarlet sel -t -v "/item/coverfontcolor" "$xmlfilename")
        coverfont=$(xmlstarlet sel -t -v "/item/coverfont" "$xmlfilename")
        customtitle=$(xmlstarlet sel -t -v "/item/customtitle" "$xmlfilename")
        environment=$(xmlstarlet sel -t -v "/item/environment" "$xmlfilename")
        imagebase=$(xmlstarlet sel -t -v "/item/imagebase" "$xmlfilename")
	imprintname=$(xmlstarlet sel -t -v "item/imprintname" "$xmlfilename")
        LANG=$(xmlstarlet sel -t -v "/item/lang" "$xmlfilename")
	pdffilename=$(xmlstarlet sel -t -v "item/pdffilename" "$xmlfilename")
	shorttitle=$(xmlstarlet sel -t -v "/item/shorttitle" "$xmlfilename")
        spineinches=$(xmlstarlet sel -t -v "item/spineinches" "$xmlfilename")
        trimsize=$(xmlstarlet sel -t -v "item/trimsize" "$xmlfilename")
        userdescription=$(xmlstarlet sel -t -v "item/userdescription" "$xmlfilename")
        userprovidedprintISBN=$(xmlstarlet sel -t -v "/item/userprovidedprintISBN" "$xmlfilename")
        yourlogo=$(xmlstarlet sel -t -v "/item/yourlogo" "$xmlfilename")
        editedby=$(xmlstarlet sel -t -v "/item/editedby" "$xmlfilename")
	pdfx1a=$(xmlstarlet sel -t -v "/item/pdfx1a" "$xmlfilename")
	echo "pdffilename is" $pdffilename
	pdfbase=$WEBFORMSHOME$submissionid	
	echo  "pdf base is" $WEBFORMSHOME$submissionid
	pdfsecuredir=`ls $pdfbase/*`
	pdffullpath=$pdfbase"/356/"$pdfsecuredir"/"
	echo "pdf full path is" $pdffullpath

	pdfpath=$pdffullpath$pdffilename

	mkdir -p images/$uuid images/$uuid/print
	backcovertext=$(xmlstarlet sel -t -v "/item/backcovertext" "$xmlfilename")
	echo $backcovertext > images/$uuid/print/backcover.txt

	echo "cover font properties are " $coverfont $covercolor $coverfontcolor

	echo "now running print cover builder with appropriate flags" | tee --append $xform_log

	echo "breakpoint" | tee --append $xform_log

	bin/standalone-print.sh \
	--ISBN "$userprovidedprintISBN" \
	--shorttitle "$shorttitle" \
	--imprintname "$imprintname" \
	--spineinches "$spineinches" \
	--pdfpath "$pdfpath" \
	--editedby "$editedby" \
	--covertitle "$customtitle" \
	--coverfontcolor "$coverfontcolor" \
	--coverfont "$coverfont" \
	--covercolor "$covercolor" \
	--covertype "wordcloud" \
        --trimsize "$trimsize" \
        --customer_email "$customer_email" \
	--pass_uuid "$uuid" \
	--pdfx1a "$pdfx1a"
       ;;


27) 

        echo "Feed the Robot" | tee --append $xform_log
        mkdir -p -m 755 tmp/$uuid
        filename=$(xmlstarlet sel -t -v "/item/food_for_thought" "$xmlfilename")
        key_380=$(xmlstarlet sel -t -v "/item/key_380" "$xmlfilename")
        echo "filename is" $filename | tee --append $xform_log
        cp $WEBFORMSHOME$submissionid"/380/$key_380/$filename" tmp/$uuid/$filename
        curl 'http://localhost:8983/solr/update/extract?literal.id=exid'$uuid"&commit=true" -F "myfile=@tmp/"$uuid"/"$filename
        echo "committed file "$filename "to Solr" | tee --append $xform_log

;;
*)
	echo "invalid webform id was " $webform_id | tee --append $xform_log
	exit 1
;;

esac
echo "exiting with LANG set to" $LANG | tee --append $xform_log
echo "ended logging xform activities" | tee --append $xform_log $sfb_log
