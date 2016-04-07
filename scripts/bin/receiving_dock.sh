
#!bin/bash

# script that manages imports into Magento

# get configuration variables

. ../conf/config.txt

echo "got config file from "$MACHINE_NAME

echo "config file imported" |  tee --append $SFB_HOME"local-data/logs/import_log.txt"

# runs when cron job is triggered every 30 minutes

# check if the importer is available

while read backofthetruck
do

	echo "wheeling job #" $backofthetruck "onto the receiving dock"| tee --append $SFB_HOME"local-data/logs/import_log.txt"

	echo "metadatarget path is" $metadatatargetpath
	cp $metadatatargetpath$backofthetruck/current-import.csv $metadatatargetpath"current-import.csv"

	echo "lifting the boxes off the truck and putting them on the conveyor belt"

	# echo "opening the pod bay door"
	# echo $SFB_MAGENTO_HOME $SFB_PHP_BIN $scriptpath
	cd $SFB_MAGENTO_HOME ; $SFB_PHP_BIN $scriptpath"bin/import_cron.php"

	importrows=$(grep 'admin' var/import/current-import.csv | wc -l)

	cd $scriptpath

	echo "ran import script and submitted " $importrows "jobs (some may be dupes) for import to the Magento store"  | tee --append $SFB_HOME"local-data/logs/import_log.txt"


done<$scriptpath"import_status/manifest.csv"

rm $scriptpath"import_status/manifest.csv"

echo "the empty truck has pulled away from the dock, we are waiting for the next truck to arrive"  | tee --append $SFB_HOME"local-data/logs/import_log.txt"

exit




