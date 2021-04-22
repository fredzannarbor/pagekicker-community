                         
echo "values after command line processing are:" | tee --append $sfb_log
echo "mediatargetpath is" $mediatargetpath | tee --append $sfb_log
echo "deliverytargetpath is " $deliverytargetpath | tee --append $sfb_log
echo "metadatatargetpath is " $metadatatargetpath | tee --append $sfb_log
echo "scriptpath is" $scriptpath | tee --append $sfb_log
echo "price is " ${FLAGS_price} | tee --append $sfb_log
echo "category id is " ${FLAGS_categoryid} | tee --append $sfb_log
echo "value of rows is " ${FLAGS_rows} | tee --append $sfb_log
echo "seedfile is " ${FLAGS_seedfile} | tee --append $sfb_log
echo "escapecustomtitle is " $escapecustomtitle| tee --append $sfb_log
echo "userid is " ${FLAGS_userid} | tee --append $sfb_log
echo "coverfile is " ${FLAGS_coverfile} | tee --append $sfb_log
echo "fetchonly is " ${FLAGS_fetchonly} | tee --append $sfb_log
echo "fetchfile is " ${FLAGS_fetchfile} | tee --append $sfb_log
echo "special_lasts_minutes " ${FLAGS_special_lasts_minutes} | tee --append $sfb_log
echo "special price is " ${FLAGS_special_price} | tee --append $sfb_log
echo "covercolor is " ${FLAGS_covercolor} | tee --append $sfb_log
echo "text extraction is on " ${FLAGS_text_extractoin_on} | tee --append $sfb_log
echo "fresh is " ${FLAGS_fresh} | tee --append $sfb_log
echo "escapeedited_by is " $escapeedited_by | tee --append $sfb_log
echo "seedsource is " ${FLAGS_seedsource} | tee --append $sfb_log
echo "breaking is " ${FLAGS_breaking} | tee --append $sfb_log
echo 'covertype id is ' {$FLAGS}
echo "editorid is " ${FLAGS_editorid} | tee --append $sfb_log
echo "escapesingleseed is " $escapesingleseed | tee --append $sfb_log
echo "import is " ${FLAGS_import} | tee --append $sfb_log
echo "fleet is " ${FLAGS_fleet} | tee --append $sfb_log
echo "booktype is " ${FLAGS_booktype} | tee --append $sfb_log
echo "ebookformat is " ${FLAGS_ebookformat} | tee --append $sfb_log
echo "endurl is" ${FLAGS_endurl} | tee --append $sfb_log
echo "fetched_document_format is" ${FLAGS_fetched_document_format} | tee --append $sfb_log
