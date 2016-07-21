#!/bin/bash

# loops over csv metadata file with n data rows to build n books 

# initialize variables

# needs $1 = path to data file $2 number of rows

if [ ! -f "$HOME"/.pagekicker/config.txt ]; then
	echo "config file not found, creating /home/<user>/.pagekicker, put config file there"
	mkdir -p -m 755 "$HOME"/.pagekicker
	echo "exiting"
	exit 1
else
	. "$HOME"/.pagekicker/config.txt
	echo "read config file from $HOME""/.pagekicker/config.txt"
fi

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
row_no=$2
# main read & build loop
i=1
echo "number of rows to parse is $row_no"
while [[ "$i" -le $row_no ]]; do
	uuid=$("$PYTHON_BIN"  -c 'import uuid; print uuid.uuid1()')
	mkdir -p -m 777 $TMPDIR$uuid
	mkdir -p -m 777 $TMPDIR$uuid/seeds
	mkdir -p -m 777 $TMPDIR$uuid/csv

	"$PYTHON_BIN"  $scriptpath"bin/csv_row_reader.py" "$1" "$uuid" $i

	echo "getting ready to run catalog entry creation command for row $row_no"
	#catid=$(cat /tmp/pagekicker/$uuid/csv/row.catid)
	booktitle=$(cat /tmp/pagekicker/$uuid/csv/row.booktitle)
	editedby=$(cat /tmp/pagekicker/$uuid/csv/row.editedby)
	#jobprofile=$(cat /tmp/pagekicker/$uuid/csv/row.jobprofile)
	seeds=$(cat /tmp/pagekicker/$uuid/csv/row.seeds)
	imprint=$(cat /tmp/pagekicker/$uuid/csv/row.imprint)
	#price=$(cat /tmp/pagekicker/$uuid/csv/row.price)
	echo "booktitle is $booktitle and editedby is $editedby"
	echo "seeds are:"
	echo "$seeds"
	sed -e 's/\^/\n/g' /tmp/pagekicker/$uuid/csv/row.seeds > /tmp/pagekicker/$uuid/csv/seeds

	if [ "$2" = "ccc_off" ] ; then
		echo "not running ccc"
	else
		bin/create-catalog-entry.sh --format "csv"  --passuuid "$uuid" --booktitle "$booktitle" --booktype "Reader" --covercolor "Random" --coverfont "Minion" --environment "$environment" --jobprofilename "default" --seedfile "/tmp/pagekicker/$uuid/csv/seeds" --builder "yes"  --imprint "$imprint" --batch_uuid "$batch_uuid" --editedby "$editedby" --yourname "no" --summary "summaries_only"
 
#--categories "$catid" not implemented
# --book_description "$description" ditto
	fi
	echo "exit value is $?"
	if [ "$?" -eq 0 ] ; then 
		true
	else
		echo "exiting with error"
		exit 1
	fi

	i=$(( i + 1 ))
	echo "i is $i"

done

zip $TMPDIR$batch_uuid/batch $TMPDIR$batch_uuid/*.epub $TMPDIR$batch_uuid/*.mobi $TMPDIR$batch_uuid/*.docx
echo "zipped all deliverables in $TMPDIR$batch_uuid/batch.zip"
echo "completed building $row_no new titles"

exit 0



