	# fetch the documents for this seed
	while IFS='	' read url title description
	do	

	echo 'processing fetch lists' 

	echo "url is" $url
	wikiurl=$(echo $url | sed -e 's/.*wiki\///')
	echo "wikiurl is" $wikiurl
	echo "title is " $title
	echo "description is" $description

	fetchurlbase="http://"$wikilocale".wikipedia.org/w/api.php?action=parse&format=json&page="
	echo "fetchurlbase is" $fetchurlbase 
	endfetchurl="&mobileformat=html&noimages="
	fetchurl=$fetchurlbase$wikiurl$endfetchurl
	echo "url to be fetched is" $fetchurl

	curl --silent --connect-timeout 15 --max-time 45 --max-redirs 1 --junk-session-cookies -o tmp/$uuid/wiki/$count.json $fetchurl  1> /dev/null

	echo "fetched document from" $fetchurl "using curl and saved as tmp/"$uuid/wiki/$count".html" 

	echo "number of docs fetched so far on seed" $seed "is " $count "out of " $doccount 
	count=$((count+1))

	done <fetch/$uuid/safesearchresults.txt
