
#!/bin/bash 

. ../conf/config.txt
. includes/set-variables.sh

if [ ! "$passuuid" ] ; then
	#echo "creating uuid"
	uuid=$("$PYTHON_BIN"  -c 'import uuid; print uuid.uuid1()')
	#echo "uuid is" $uuid | tee --append $xform_log
	mkdir -p -m 777 $TMPDIR$uuid
else
	uuid=$passuuid
	echo "received uuid " $uuid
	mkdir -p -m 777 $TMPDIR$uuid
fi

bin/create-catalog-entry.sh --builder "yes" --booktitle "Test" --yourname "Fred" --jobprofilename "Default" --import "no" --passuuid "$uuid" --seedfile "seeds/revolutionary_figures" 2>&1 > /dev/null | grep -v "IBM"

# tests begin here

if [ ! -f "$TMPDIR$uuid/ebookcover.jpg" ]; then
    echo "error: cover not found! " > "$TMPDIR$uuid/error.log"
fi

# if error log is empty then PASS

echo "PASS" "  $uuid"  | tee -a $LOCAL_DATA/logs/error.log

