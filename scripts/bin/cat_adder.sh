#!/bin/bash

# assumes one catid row per file

# create $uuid



# initialize variables

. ../conf/config.txt
. includes/set-variables.sh
rm /tmp/pagekicker/buildresult

# adds books to specified categories with seed terms 

# uuid for csv file

row_no=1

while read -r line ;
do
	uuid=$(python  -c 'import uuid; print uuid.uuid1()')
	mkdir -p -m 777 /tmp/pagekicker/$uuid
	mkdir -p -m 777 /tmp/pagekicker/$uuid/seeds
	mkdir -p -m 777 /tmp/pagekicker/$uuid/csv
	current_row_location="/tmp/pagekicker/$uuid/csv/current_row"
	tail -n$row_no "$1" | head -n1 > "$current_row_location"

	# echo "$line" > "/tmp/pagekicker/$uuid/csv/row_no."$row_no
	/opt/bitnami/python/bin/python  $scriptpath"bin/csv_to_ccc.py" "$current_row_location" "$uuid"
	
	echo "running catalog entry creation command"
	catid=$(cat /tmp/pagekicker/$uuid/csv/row.catid)
	booktitle=$(cat /tmp/pagekicker/$uuid/csv/row.booktitle)
	echo catid is "$catid" and booktitle is" $booktitle"
	sed -e 's/\^/\n/g' /tmp/pagekicker/$uuid/csv/row.seeds > /tmp/pagekicker/$uuid/csv/seeds

	if [ "$2" = "ccc_off" ] ; then
		echo "not running ccc"
	else
		bin/ccc.sh --format "csv"  --passuuid "$uuid" --categories "$catid" --booktitle "$booktitle" --booktype "Reader" --covercolor "Random" --coverfont "Minion" --environment "development"  --jobprofilename "default" --wikilang "en" --yourname "DHS Social Monitoring" --seedfile "/tmp/pagekicker/$uuid/csv/seeds" --builder "no"  --book_description "PageKicker robots will use the latest version of their software to search, analyze, and assemble real-time permissioned content relating to this topic when you download the book, so it is always improving and always current." --tldr "This is one of the topics that DHS analysts monitor in social media."
	fi
	echo "exit value is $?"
	if [ "$?" -eq 0 ] ; then 
		echo "$line" | tee --append /tmp/pagekicker/cat_adder_success
	else
		echo "$line" | tee --append /tmp/pagekicker/cat_adder_failure
	fi

	row_no=$(( row_no + 1 ))
echo "line is" $line
done<$1

rows_done=$(( $row_no - 1 ))
echo "completed adding $rows_done new entries with categories assigned"


exit 0



