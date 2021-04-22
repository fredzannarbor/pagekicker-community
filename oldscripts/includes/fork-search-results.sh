	# fetch the documents for this seed

	while IFS='	' read url title description
	do	

	echo 'processing fetch lists' | tee --append $sfb_log

	echo "url is" $url
	wikiurl=$(echo $url | sed -e 's/.*wiki\///')
	echo "wikiurl is" $wikiurl
	echo "title is " $title
	echo "description is" $description

	fetchurlbase="http://"$wikilocale".wikipedia.org/w/api.php?action=parse&format=json&page="
	echo "fetchurlbase is" $fetchurlbase | tee --append $sfb_log
	endfetchurl="&mobileformat=html&noimages="
	fetchurl=$fetchurlbase$wikiurl$endfetchurl
	echo "url to be fetched is" $fetchurl | tee --append $sfb_log

	curl --silent --connect-timeout 15 --max-time 45 --max-redirs 1 --junk-session-cookies -o tmp/$uuid/$count.json $fetchurl  

	# xmlstarlet sel -t -v "/api/parse/@*" tmp/$uuid/$count.xml > tmp/$uuid/$count.html

	cat tmp/$uuid/$count.json | lib/jshon/jshon -e parse -e text -u |  sed 's|<a[^>]* href="[^"]*/|<a href="http://en.wikipedia.org/wiki/|g' > tmp/$uuid/$count.html

	ebook-convert tmp/$uuid/$count.html tmp/$uuid/$count.txt  --pretty-print 1> /dev/null

	echo "fetched document from" $fetchurl "and saved as tmp/"$uuid/$count".html and converted to txt using calibre" | tee --append sfb_log

	# reports on status of fetches

	echo "number of docs fetched so far on seed" $seed "is " $count "out of " $doccount | tee --append $sfb_log

	count=$((count+1))

	done <fetch/$uuid/safesearchresults.txt
