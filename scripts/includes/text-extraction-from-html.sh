# extract text 

$JAVA_BIN -jar $scriptpath"lib/tika-app.jar" -t tmp/$uuid/tmp.cumulative.html > tmp/$uuid/cumulative.txt

echo "completed text extraction from html to tmp/$uuid/cumulative.txt" | tee --append $sfb_log

