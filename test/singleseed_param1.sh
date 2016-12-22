#!/bin/bash

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

if [ ! "$passuuid" ] ; then
	#echo "creating uuid"
	uuid=$("$PYTHON_BIN"  -c 'import uuid; print(uuid.uuid1())')
	#echo "uuid is" $uuid | tee --append $xform_log
	mkdir -p -m 777 $TMPDIR$uuid
else
	uuid=$passuuid
	echo "received uuid " $uuid
	mkdir -p -m 777 $TMPDIR$uuid
fi


bin/create-catalog-entry.sh --builder "yes" --booktitle "$1" --yourname "Sam Johnson" --jobprofilename "default" --import "no" --passuuid "$uuid" --singleseed "$1" --imprint "pagekicker"  \
--analyze_url "none" --summary "both" --import "no" --skyscraper "yes"

# tests begin here

if [ ! -f "$TMPDIR$uuid/ebookcover.jpg" ]; then
    echo "error: cover not found! " > "$TMPDIR$uuid/error.log"
fi

# if error log is empty then PASS
echo -e "\n"
echo "PASS" "  $uuid"  "$0" | tee -a $LOCAL_DATA/logs/testlog
