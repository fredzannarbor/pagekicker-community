#!/bin/bash

# version1.0 test suite
# runs test of all production-visible scripts

echo "------------------------version 1.0-------------------------------"

if shopt -q  login_shell ; then

	if [ ! -f "$HOME"/.pagekicker/config.txt ]; then
		echo "config file not found, creating /home/<user>/.pagekicker, put config file there"
		mkdir -p -m 755 "$HOME"/.pagekicker
		echo "exiting"
		exit 1
	else
		. "$HOME"/.pagekicker/config.txt
		echo "read config file from login shell $HOME""/.pagekicker/config.txt"
	fi
else
	. /home/$(whoami)/.pagekicker/config.txt #hard-coding /home is a hack
	echo "read config file from nonlogin shell /home/$(whoami)/.pagekicker/config.txt"
fi

cd $scriptpath

. includes/set-variables.sh

. ../test/paella.sh
. ../test/decimator-test.sh ../test/data/Zalasiewicz_Technosphere_2016.pdf "pioneering metrics and inventory"
. ../test/dat-mettan-test.sh
