#!/bin/bash


# script that runs every time a new customer is added to the Magento database

# creates personal bookshelves

# stocks them using API (full contact)

echo "SIGNUP***SIGNUP***SIGNUP***SIGNUP"

TEXTDOMAIN=SFB
echo $"hello, world, I am speaking" $LANG

. ../conf/config.txt

# get bzr revision
bazaar_revision=`cat /home/bitnami/bzr_dev_rev`
echo "bazaar revision number is" $bazaar_revision

echo "sfb_log is" $sfb_log

echo "completed reading config file and  beginning logging at" `date +'%m/%d/%y%n %H:%M:%S'` 

starttime=$(( `date +%s` ))

. includes/set-variables.sh

while :
do
case $1 in
--help | -\?)

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
--customer_name)
customer_name=$2
shift 2
;;
--customer_name=*)
customer_name=${1#*=}
shift
;;
--customer_email)
customer_email=$2
shift 2
;;
--customer_email=*)
customer_email=${1#*=}
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
	uuid=$(python  -c 'import uuid; print uuid.uuid1()')
	echo "uuid is" $uuid | tee --append $xform_log

else
	uuid="$passuuid"
	echo "received uuid " $uuid

fi

# create directories I will need

mkdir -p -m 777 $TMPDIR$uuid
mkdir -p -m 777 $TMPDIR$uuid/categories
mkdir -p -m 755 $metadatatargetpath$uuid
 
echo "metadatatargetpath is "$tadatatargetpath
echo "uuid is" $uuid

# create category id(s)

catid=`tail -1 < "$LOCAL_DATA""categories/catid"`
echo "catid " $catid

# writing category import file 

cat includes/category_header.csv > $metadatatargetpath$uuid/"import_bulk_categories.csv"
. includes/bookshelf-footer.sh >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

cp $metadatatargetpath$uuid/"import_bulk_categories.csv" $TMPDIR$uuid # for testing

if [ "$import" = "yes" ] ; then 

	echo "adding import job to the manifest" 

	echo $uuid >> import_status/manifest.csv


	$scriptpath"bin/build_bookshelf.sh"


	# sendemail -t "$customer_email" \
		-u "Public Bookshelf for $customer_name has been added to the PageKicker catalog" \
		-m  "Your public bookshelf has been added to the PageKicker catalog. The URL is:"\ "$WEB_HOST".html "It has been prestocked with books created based on interests drawn from your public social media profile." \
		-f "$gmail_id" \
		-cc "$gmail_id"\
		-xu "$gmail_id"\
		-xp "$GMAIL_PASSWORD" \
		-s smtp.gmail.com:587 \
		-o tls=yes

	# increment catid by 1

	prevcatid=$catid
	catid=$((catid+1)) 
	echo $catid >> "$LOCAL_DATA""categories/catid"
	echo "incremented catid by 1 to" $catid" and updated categories/catid" 

	echo 'on_signup.sh job ' $uuid 'ran on' `date +'%m/%d/%y%n %H:%M:%S'` >> $sfb_log

else

	echo "not importing this category" 

fi

# get information about customer

FullContactAPIKey="8f1d60267f1b859f"
APIendpoint="https://api.fullcontact.com/v2/person.xml?email="
APItxt="&apiKey="
personurl=$APIendpoint$customer_email$APItxt$FullContactAPIKey
echo "personurl is" $personurl
curl --silent "$personurl" > $TMPDIR$uuid/person.xml

xmlstarlet sel -T -t -m  "/person/digitalFootprint/topics/topic/value" -c . -n  $TMPDIR$uuid"/person.xml" > $TMPDIR$uuid/topic-seeds
xmlstarlet sel -T -t -m  "/person/demographics/locationDeduced/normalizedLocation" -c . -n  "$TMPDIR$uuid"/person.xml >> $TMPDIR$uuid/topic-seeds
xmlstarlet sel -T -t -m  "/person/organizations/name" -c . -n  "$TMPDIR$uuid/person.xml" >> $TMPDIR$uuid/topic-seeds


#safe_product_name=$(echo "$booktitle" | sed -e 's/[^A-Za-z0-9._-]/_/g')
#echo "safe_product_name is" "$safe_product_name"
#google_form="http://goo.gl/forms/ur1Otr1G2q"




exit 0
