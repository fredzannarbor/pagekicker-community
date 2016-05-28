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

#strips header line

mkdir -m 755 -p /tmp/pagekicker/


echo "abt to enter main loop"

# main read & build loop

row_no=0

while [  $row_no -lt $2 ]; do
	mkdir -p -m 777 /tmp/pagekicker/$uuid
	mkdir -p -m 777 /tmp/pagekicker/$uuid/seeds
	mkdir -p -m 777 /tmp/pagekicker/$uuid/csv
	
	"$PYTHON_BIN"  $scriptpath"bin/csv_to_metadata.py" "$1" "$uuid" "$row_no"

	echo "getting ready to run catalog entry creation command for row $row_no"
	catid=$(cat /tmp/pagekicker/$uuid/csv/row.catid)
	booktitle=$(cat /tmp/pagekicker/$uuid/csv/row.product_name)
	editedby=$(cat /tmp/pagekicker/$uuid/csv/row.editedby)
	jobprofile=$(cat /tmp/pagekicker/$uuid/csv/row.jobprofile)
	seeds=$(cat /tmp/pagekicker/$uuid/csv/row.seeds)
	imprint=$(cat /tmp/pagekicker/$uuid/csv/row.imprint)
	price=$(cat /tmp/pagekicker/$uuid/csv/row.price)
	echo "product name is $productname and editedby is $editedby"
	echo "seeds are:"
	echo "$seeds"
	sed -e 's/\^/\n/g' /tmp/pagekicker/$uuid/csv/row.seeds > /tmp/pagekicker/$uuid/csv/seeds

	if [ "$2" = "ccc_off" ] ; then
		echo "not running ccc"
	else
		bin/create-catalog-entry.sh --format "csv"  --passuuid "$uuid" --categories "$catid" --booktitle "$booktitle" --booktype "Reader" --covercolor "Random" --coverfont "Minion" --environment "$environment" --jobprofilename "$jobprofile" --seedfile "/tmp/pagekicker/$uuid/csv/seeds" --builder "yes"  --book_description "$description" --imprint "$imprint" --price "price"
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


echo "completed adding $row_no new entries with categories assigned"


exit 0



