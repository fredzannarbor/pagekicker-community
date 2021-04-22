#!/bin/bash
INGRAMSFTPSERVER="cs2ftp.ingramcontent.com"
# insert header in accumulated metadata import rows

# SERVER=
echo "building LSI import metadata" | tee --append $sfb_log

cat includes/lsi-metadata-header.txt > $SFB_MAGENTO_HOME"wfrederickzimmerman_"$YYYYMMDD".csv"
cat $metadatatargetpath"/lsi-import-ready.csv" >> $SFB_MAGENTO_HOME"wfrederickzimmerman_"$YYYYMMDD".csv"

# convert csv to xls with (grr...) sheet named "metadata"

(echo put $$SFB_MAGENTO_HOME"wfrederickzimmerman_"$YYYYMMDD".xls" echo put $SFB_MAGENTO_HOME"lsi-import"/*.EPUB; echo quit) | sftp -b - $INGRAMSFTPSERVER

exit 0
