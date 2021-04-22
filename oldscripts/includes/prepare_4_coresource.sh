
ISBNowner="8"

if [ "$ebookISBN" = "no" ]  ; then

	echo "ISBN not assigned automatically, looking for one that is manually entered" | tee --append $sfb_log


else
	echo "user has asked for ISBN to be assigned automatically" | tee --append $sfb_log

fi

echo "ISBNowner is " $ISBNowner

case "$ISBNowner" in


0)
	echo "no ISBN assigned" | tee --append $sfb_log

;;

8) 

	ISBN=`head -1 ISBNs/customer_id_8/nimble-ISBNs-available.txt`
	echo "ISBN "$ISBN" was assigned to SKU "$sku "with covertitle "$covertitle | tee --append $sfb_log $ISBN_log
	echo -n $ISBN >> $sfb_log ISBNs/customer_id_8/nimble-ISBNs-used.csv
	echo -n "," >>  ISBNs/customer_id_8/nimble-ISBNs-used.csv
	echo -n "$title" >>  ISBNs/customer_id_8/nimble-ISBNs-used.csv
	echo -n ",">>  ISBNs/customer_id_8/nimble-ISBNs-used.csv
	echo -n "$author"| tee --append ISBNs/customer_id_8/nimble-ISBNs-used.csv
	ISBNs_remaining=`wc -l "ISBNs/customer_id_8/nimble-ISBNs-available.txt"`
	echo "there are "$ISBNs_remaining" in nimble-ISBNs-available.txt" | tee --append $sfb_log
	sed -i '1,1d' ISBNs/customer_id_8/nimble-ISBNs-available.txt

	# fix up epub for submission to CoreSource

	cp $mediatargetpath$uuid/$sku".epub" $mediatargetpath$uuid"/"$ISBN"_working.epub"
	# epub-fix --epubcheck $mediatargetpath$uuid"/"$ISBN"_working.epub"
	cp $mediatargetpath$uuid"/"$ISBN"_working.epub" $SFB_MAGENTO_HOME"media/lsi-import/"$ISBN"_EPUB.epub"

	# echo "created epubfixed version of" $sku."epub" at $mediatargetpath$uuid"/"$ISBN"_EPUB.epub" | tee --append $sfb_log

	convert images/$uuid/$sku".png" $SFB_MAGENTO_HOME"media/lsi-import/"$ISBN"_FC.jpg"

	echo "converted cover png to jpg for CoreSource" | tee --append $sfb_log

;;

*)

	echo "no ISBNs associated with this value of ISBN_owner" $ISBN_owner | tee --append $sfb_log
	
;;

esac

