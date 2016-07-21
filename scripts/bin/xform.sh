 #!/bin/bash

# file path for file attachments must be hard coded 
# to match the magento file structure & specifically webform field #

# requires inotify to alert that xml file has been created by the Magento webforms plugin and deposited in the correct directory
# which is set by incrontab command for the bitnami user

if shopt -q  login_shell ; then
	
	if [ ! -f "$HOME"/.pagekicker/config.txt ]; then
		echo "config file not found, creating /home/<user>/.pagekicker, put config file there"
		mkdir -p -m 755 "$HOME"/.pagekicker
		echo "exiting"
		exit 1
	else
		. "$HOME"/.pagekicker/config.txt
		echo "read config file from $HOME""/.pagekicker/config.txt"
	fi
else
	. /home/$(whoami)/.pagekicker/config.txt #hard-coding /home is a hack 
	echo "read config file from /home/$(whoami)/.pagekicker/config.txt"
fi

starttime=$(( `date +%s` ))
datenow=$(date -R)

# parse the command-line very stupidly

xmldirectoryname=$1 
xmlbasefile=$2 
echo "parameter 1 is" $1
echo  "parameter 2 is" $2
xmlfilename=$xmldirectoryname/$xmlbasefile

echo "loaded" $environment "config file at " $datenow  

uuid=$(python  -c 'import uuid; print uuid.uuid1()')
mkdir -p -m 755 $logdir$uuid 
xform_log=$logdir$uuid/"xform_log"
echo "XXXXXXXXXX" | tee --append $xform_log
echo "xmlfilename provided by webforms is" $xmlfilename | tee --append $xform_log
echo "xform_log is" $xform_log | tee --append $xform_log
echo "started xform at " $starttime " details in $xform_log" | tee --append $xform_log

echo "WEBFORMSXML_HOME is $WEBFORMSXML_HOME"


sku=`tail -1 < "$LOCAL_DATA""SKUs/sku_list"`
echo "sku" $sku | tee --append $xform_log

echo "$0 version in $environment" "is" $SFB_VERSION | tee --append $xform_log

cd $scriptpath
echo "scriptpath is" $scriptpath 

# echo "PATH is" $PATH | tee --append $xform_log

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

$scriptpath"bin/create-catalog-entry.sh" --xmlfilename "$xmlbasefile" --passuuid "$uuid" --format "xml" --builder "yes" --summary "both"

echo "launched $0 from" $environment 
;;

21) 

echo "running create your robot form 21" | tee --append $xform_log
$scriptpath"bin/robot-builder.sh" --xmldirectoryname "$xmldirectoryname" --xmlbasefile "$xmlbasefile"  --passuuid "$uuid"

;;

23)

# echo "running dat.sh with xml file from webform"
$scriptpath"bin/dat.sh" --xmldirectoryname "$xmldirectoryname" --xmlbasefile "$xmlbasefile"  --passuuid "$uuid" 
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
	pdfbase=$WEBFORMSXML_HOME$submissionid	
	echo  "pdf base is" $WEBFORMSXML_HOME$submissionid
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
        mkdir -p -m 755 $TMPDIR$uuid
        filename=$(xmlstarlet sel -t -v "/item/food_for_thought" "$xmlfilename")
        key_380=$(xmlstarlet sel -t -v "/item/key_380" "$xmlfilename")
        echo "filename is" $filename | tee --append $xform_log
        cp $WEBFORMSXML_HOME$submissionid"/380/$key_380/$filename" $TMPDIR$uuid/$filename
        curl 'http://localhost:8983/solr/update/extract?literal.id=exid'$uuid"&commit=true" -F "myfile=@tmp/"$uuid"/"$filename
        echo "committed file "$filename "to Solr" | tee --append $xform_log
;;
34) 

echo "running create your imprint webform id 34" | tee --append $xform_log
$scriptpath"bin/imprint-builder.sh" --xmldirectoryname "$xmldirectoryname" --xmlbasefile "$xmlbasefile"  --passuuid "$uuid"

;;
*)
	echo "invalid webform id was " $webform_id | tee --append $xform_log
	exit 1
;;

esac
echo "exiting with LANG set to" $LANG | tee --append $xform_log
echo "ended logging xform activities" | tee --append $xform_log $sfb_log
