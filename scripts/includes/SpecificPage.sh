	# select search API

			searchAPI="Wikipedia"

			#gets specific pages that match search term (only)


				wikiAPIendpoint="http://"$wikilocale".wikipedia.org/w/api.php?"

				wikiAPIaction="action=query&prop=revisions&rvprop=content&format=xml&titles="$safeseed
		
		
			# build the specific page request using the appropriate values for keyword search or link retrieval

			searchurl=$wikiAPIendpoint$wikiAPIaction
	
			echo $searchurl

			echo "submitting search now, searchurl is" $searchurl | tee --append $sfb_log

			# break point
		
			# submit the search

			curl --silent $searchurl > "fetch/"$uuid"/searchresults.xml"
