
#!bin/bash

# script that manages category imports into Magento

# get configuration variables

. ../conf/config.txt

echo "got config file from "$MACHINE_NAME

echo "config file imported"

while read bookshelf
do

	echo "building bookshelf" $bookshelf"onto the receiving dock"

	echo "metadatarget path is" $metadatatargetpath
	cp $metadatatargetpath$bookshelf/import_bulk_categories.csv $metadatatargetpath"import_bulk_categories.csv"

	echo "adding customer bookshelves to the category tree"

	cd $SFB_MAGENTO_HOME ; $SFB_PHP_BIN $scriptpath"bin/import_cat.php"

	cd $scriptpath

done<$scriptpath"import_status/category_manifest.csv"

rm $scriptpath"import_status/category_manifest.csv"

echo "done with that set of shelves" 

exit




