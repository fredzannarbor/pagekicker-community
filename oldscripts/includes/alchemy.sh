echo "running alchemy module" | tee --append $sfb_log

echo "placing documents for analysis on public web server for access by Alchemy" | tee --append $sfb_log


rsync -av -e "ssh -i/home/fred/Documents/certificates/restorepk.pem" $scriptpath"tmp/"$uuid/cumulative.html "bitnami@www.pagekicker.com:/opt/bitnami/apache2/htdocs/alchemy-staging/"$sku"cumulative.html"
rsync -av -e "ssh -i/home/fred/Documents/certificates/restorepk.pem" $scriptpath"tmp/"$uuid/cumulative.txt "bitnami@www.pagekicker.com:/opt/bitnami/apache2/htdocs/alchemy-staging/"$sku"cumulative.txt"

curl  --connect-timeout 30 --max-redirs 1 --junk-session-cookies -o tmp/$uuid/$sku"tags.xml" http://access.alchemyapi.com/calls/url/URLGetRankedConcepts?apikey=50bc69376c77ff5ca754572ea483a77c037320d8&url="$WEB_HOST"alchemy-staging/$sku"cumulative.html" 

curl  --connect-timeout 30 --max-redirs 1 --junk-session-cookies -o  tmp/$uuid/$sku"namedentities.xml" http://access.alchemyapi.com/calls/url/URLGetRankedNamedEntities?apikey=50bc69376c77ff5ca754572ea483a77c037320d8&url="$WEB_HOST"alchemy-staging/$sku"cumulative.html"
	
xml2 < "tmp/$uuid/$sku"namedentities.xml" > "tmp/$uuid/$sku"namedentities.csv"

cat tmp/$uuid/$sku"namedentities.csv" | grep 'text' | cut -d= -f 2 > tmp/$uuid/$sku"nameentities.txt"
	
 curl   --connect-timeout 30 --max-redirs 1 --junk-session-cookies -o  tmp/$uuid/"keywords.xml" http://access.alchemyapi.com/calls/url/URLGetRankedKeywords?apikey=50bc69376c77ff5ca754572ea483a77c037320d8&url="$WEB_HOST"alchemy-staging/$sku"cumulative.txt"
			
if grep -q '<status>ERROR</status>' tmp/$uuid/$sku"keywords.xml" ; then
	echo "Alchemy API error, product tags could not be retrieved 4 seed" $seed | tee --append $sfb_log
	# save seeds so they tags can be added later when API is working
	echo $seed | tee --append logs/tags-not-retrieved.txt
	echo "tags were not available 4 this document" > tmp/$uuid/$sku"keywords.txt"
else
		
	xml2 < "tmp/"$uuid"/"$sku"keywords.xml" > "tmp/"$uuid"/"$sku"keywords.csv"

	cat "tmp/"$uuid/$sku"keywords.csv" | grep 'text' | cut -d= -f 2 > "tmp/"$uuid"/"$sku"keywords.txt"

fi

echo "fetched keywords from Alchemy and saved as$uuidkeywords.txt" | tee --append $sfb_log
