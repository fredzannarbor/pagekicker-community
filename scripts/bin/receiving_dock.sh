
#!bin/bash

# script that manages imports into Magento

# get configuration variables

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

# runs when cron job is triggered every 30 minutes

# check if the importer is available

while read backofthetruck
do

	echo "wheeling job #" $backofthetruck "onto the receiving dock"| tee --append "$logdir"import_log.txt

	echo "metadatarget path is" $metadatatargetpath
	cp $metadatatargetpath$backofthetruck/current-import.csv $metadatatargetpath"current-import.csv"

	echo "lifting the boxes off the truck and putting them on the conveyor belt"

	# echo "opening the pod bay door"
	# echo $SFB_MAGENTO_HOME $SFB_PHP_BIN $scriptpath
	cd $SFB_MAGENTO_HOME ; $SFB_PHP_BIN $scriptpath"bin/import_cron.php"

	importrows=$(grep 'admin' var/import/current-import.csv | wc -l)

	cd $scriptpath

	echo "ran import script and submitted " $importrows "jobs (some may be dupes) for import to the Magento store"  | tee --append "$logdir"import_log.txt


done<$scriptpath"import_status/manifest.csv"

rm $scriptpath"import_status/manifest.csv"

echo "the empty truck has pulled away from the dock, we are waiting for the next truck to arrive"  | tee --append "$logdir"import_log.txt

exit




