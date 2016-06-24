#!/bin/bash

# test imprint form processor which is part of xform.shh

if [ ! -f "$HOME"/.pagekicker/config.txt ]; then
	echo "config file not found, creating /home/<user>/.pagekicker, put config file there"
	mkdir -p -m 755 "$HOME"/.pagekicker
	echo "exiting"
	exit 1
else
	. "$HOME"/.pagekicker/config.txt
	echo "read config file from $HOME""/.pagekicker/config.txt"
fi

bin/xform.sh /home/fred/bin/magento-1.9.2.4-1/apps/magento/htdocs/media/webforms/xml 3383.xml
