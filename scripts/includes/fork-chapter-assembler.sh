# process each chapter
#TEXTDOMAIN=chapter-assembler
ebook-convert tmp/$uuid/$count.html tmp/$uuid/$count.txt  --pretty-print 1> /dev/null
echo $"Chapter "$count $safetitle >> tmp/$uuid/tmp.cumulative.txt
cat tmp/$uuid/$count.txt >> tmp/$uuid/tmp.cumulative.txt

 echo "now building word cloud page" | tee --append $sfb_log

 $JAVA_BIN -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -w 1800 -h 2700 < tmp/$uuid/$count".txt" > tmp/$uuid/$count".cloudbase.png" 2>  /dev/null

echo "newcovercolor is" $newcovercolor
echo "coverfontcolor is" $coverfontcolor
echo "newcoverfont is " $newcoverfont

convert -size 1800x100 -density 300 -border 1 -bordercolor "white" -units pixelsperinch -background $newcovercolor -fill "$coverfontcolor" \
-font "$newcoverfont" -gravity center -pointsize 11 caption:"Visual Summary of $title" tmp/$uuid/cloudcaption$count.png 

convert tmp/$uuid/cloudcaption$count.png tmp/$uuid/$count".cloudbase.png" -append tmp/$uuid/$count.png

echo "built word cloud for chapter " $count "to tmp/"$uuid"/"$count".png" | tee --append $sfb_log

cat includes/wordcloudpageheader.html > tmp/$uuid/wordcloud.$count.html

echo $angbr"img src="$dq$count".png$dq" alt=$dq"Visual Summary"$dq$endbr >> tmp/$uuid/wordcloud.$count.html


echo "now building dingbat page" | tee --append $sfb_log


echo $"A favorite quote from" "$editedby" >> tmp/$uuid/dingbat.$count.html

/usr/games/fortune $fortunedb -s >> tmp/$uuid/dingbat.$count.html

echo "</quote><hr>" >> tmp/$uuid/dingbat.$count.html

echo "<center>" >> tmp/$uuid/dingbat.$count.html

echo $angbr"img src="$dq$dingbat$dq$slash$endbr >> tmp/$uuid/dingbat.$count.html

echo "</center>" >> tmp/$uuid/dingbat.$count.html

cat includes/wordcloudpagefooter.html >> tmp/$uuid/dingbat.$count.html
		
echo "now assembling pages and chapters into cumulative html" | tee --append $sfb_log


echo -n  "<li>"$description"</li>" >> tmp/$uuid/stored-descriptions.html
echo -n  "$description" | sed -e 's/"/_/g' -e 's/#/ /g'  -e 's/\&/ /g' -e 's/'\''/_/g'  -e 's/, /_/g' -e 's/,/_/g'  -e 's/\//_/g' -e 's// /g' -e 's/\\/ /g' -e 's/|/_/g' >> tmp/$uuid/lsi-stored-descriptions.txt

cat tmp/$uuid/wordcloud.$count.html >> tmp/$uuid/tmp.cumulative.html

cat tmp/$uuid/$count".html" >> tmp/$uuid/tmp.cumulative.html
# cat tmp/$uuid/dingbat.$count.html >> tmp/$uuid/tmp.cumulative.html

echo -n  "<li>"$description"</li>" >> tmp/$uuid/stored-descriptions.html
echo -n  "$description" | sed -e 's/"/_/g' -e 's/#/ /g'  -e 's/\&/ /g' -e 's/'\''/_/g'  -e 's/, /_/g' -e 's/,/_/g'  -e 's/\//_/g' -e 's// /g' -e 's/\\/ /g' -e 's/|/_/g' >> tmp/$uuid/lsi-stored-descriptions.txt

