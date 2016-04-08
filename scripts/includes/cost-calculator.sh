
#AWS cost variables

# $0.165 per High-CPU Medium Instance (c1.medium) instance-hour (or partial hour)

cpuhour= 0.165

# 0.10 per GB-month of provisioned storage

gbmonth = 0.10

epubbytes=`stat -c %s $mediatargetpath$uuid"/"$sku.epub`
mobibytes=`stat -c %s $mediatargetpath$uuid"/"$sku.mobi`
pdfbytes=`stat -c %s $mediatargetpath$uuid"/"$sku.pdf`

echo "epub file size is" $epubbytes | tee --append $sfb_log
echo "mobi file size is" $mobibytes | tee --append $sfb_log
echo "pdf file size is" $pdfbytes | tee --append $sfb_log

epubstoragecost=(( %$epubbytes / 1000000000 * $gbmonth ))
mobistoragecost=(( $mobibytes / 1000000000 * $gbmonth ))
pdfstoragecost=(( $pdfbytes / 1000000000 * $gbmonth ))
allformatstoragecost=(( $epubstorage + $mobistoragecost + $pdfstoragecost ))

echo "epub storage cost per month is " $epubstoragecost | tee --append $sfb_log
echo "mobi storage cost per month is " $mobistoragecost | tee --append $sfb_log
echo "pdf storage cost per month is " $pdfstoragecost | tee --append $sfb_log
echo "total storage cost per month is " $allformatstoragecost | tee --append $sfb_log

#  $0.10 per 1 million I/O requests

millionIOrequests = 0.10 

# buildcost = min x cpuhour/60

# gbmonth = bytesize/1000 * gbmonth





