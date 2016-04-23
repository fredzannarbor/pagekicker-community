#!/bin/bash


# run this on first use but after configuring 

. ../conf/config.txt

# the builder and create-catalog-entry scripts expect these directories to exist


# subdirectories in Magento that do not exist in core Magento without plugins

mkdir -p -m 755 $SFB_MAGENTO_HOME"var/import" 
mkdir -p -m 755 $SFB_MAGENTO_HOME"var/export"
mkdir -p -m 755 $SFB_MAGENTO_HOME"media/webforms"
mkdir -p -m 755 $SFB_MAGENTO_HOME"media/webforms/xml"

# subdirectories in TMPDIR

mkdir -p -m 755 $TMPDIR"pagekicker"
mkdir -p -m 755 $TMPDIR"actual_builds"
mkdir -p -m 755 $TMPDIR"seeds"

