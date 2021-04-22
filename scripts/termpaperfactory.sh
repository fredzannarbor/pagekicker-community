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

$scriptpath"bin/builder.sh" --singleseed "$1" --ebook_format "docx" 

exit 0

# this script does not carry out testing because it is the production app not part of the test suite
