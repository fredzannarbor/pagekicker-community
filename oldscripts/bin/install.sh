#!/bin/bash

# installs bitnami magento stack without plugins

echo "installing bitnami downloadable $1"
./$1 # first parameter is path to bitnami stack download, this runs it

# creates additional plugin directories that are needed for a full pagekicker store installation to operate
# book builder and create a catalog entry scripts expect these directories as destinations for file builds

. ../conf/config.txt

mkdir -p  -m 755 $SFB_MAGENTO_HOME"var/import" 
mkdir -p -m 755 $SFB_MAGENTO_HOME"var/export"
mkdir -p -m 755 $SFB_MAGENTO_HOME"media/webforms"
mkdir -p -m 755 $SFB_MAGENTO_HOME"media/webforms/xml"
