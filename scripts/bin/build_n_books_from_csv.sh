#!/bin/bash

# loops over csv metadata file with n data rows to build n books 

# initialize variables

. ../conf/config.txt
. includes/set-variables.sh
if [ ! "/tmp/pagekicker/buildresult" ] ; then
	rm /tmp/pagekicker/buildresult
else
	true
fi


#create batch uuid

echo "creating batch_uuid"
batch_uuid=$("$PYTHON_BIN"  -c 'import uuid; print uuid.uuid1()')
batch_uuid="batch_""$batch_uuid"
echo "batch_uuid is" $batch_uuid | tee --append $xform_log
mkdir -p -m 777 $TMPDIR$batch_uuid


echo "abt to enter main loop"

# main read & build loop

row_no=0

while [  $row_no -lt $2 ]; do

	uuid=$("$PYTHON_BIN"  -c 'import uuid; print uuid.uuid1()')
	mkdir -p -m 777 $TMPDIR$uuid
	mkdir -p -m 777 $TMPDIR$uuid/seeds
	mkdir -p -m 777 $TMPDIR$uuid/csv

	"$PYTHON_BIN"  $scriptpath"bin/csv_to_metadata.py" "$1" "$uuid" "$row_no"

	echo "getting ready to run catalog entry creation command for row $row_no"
	#catid=$(cat /tmp/pagekicker/$uuid/csv/row.catid)
	booktitle=$(cat /tmp/pagekicker/$uuid/csv/row.product_name)
	editedby=$(cat /tmp/pagekicker/$uuid/csv/row.editedby)
	#jobprofile=$(cat /tmp/pagekicker/$uuid/csv/row.jobprofile)
	seeds=$(cat /tmp/pagekicker/$uuid/csv/row.seeds)
	imprint=$(cat /tmp/pagekicker/$uuid/csv/row.imprint)
	#price=$(cat /tmp/pagekicker/$uuid/csv/row.price)
	echo "product name is $product_name and editedby is $editedby"
	echo "seeds are:"
	echo "$seeds"
	sed -e 's/\^/\n/g' /tmp/pagekicker/$uuid/csv/row.seeds > /tmp/pagekicker/$uuid/csv/seeds

	if [ "$2" = "ccc_off" ] ; then
		echo "not running ccc"
	else
		bin/create-catalog-entry.sh --format "csv"  --passuuid "$uuid" --categories "$catid" --booktitle "$booktitle" --booktype "Reader" --covercolor "Random" --coverfont "Minion" --environment "$environment" --jobprofilename "default" --seedfile "/tmp/pagekicker/$uuid/csv/seeds" --builder "yes"  --book_description "$description" --imprint "$imprint" --price "price" --batch_uuid "$batch_uuid" # jobprofilename hard coded
	fi
	echo "exit value is $?"
	if [ "$?" -eq 0 ] ; then 
		echo "$line" | tee --append /tmp/pagekicker/cat_adder_success
	else
		echo "$line" | tee --append /tmp/pagekicker/cat_adder_failure
	fi

	row_no=$(( row_no + 1 ))
	echo "row_no" is $row_no

done

zip "$TMPDIR$batch_uuid.zip" $TMPDIR$batch_uuid/*

echo "completed adding $row_no new entries with categories assigned"


exit 0



