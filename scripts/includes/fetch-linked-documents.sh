	# fetch the documents for this seed

	# start with seed document 
	
	count=1

	seedfetchurlbase="http://"$wikilocale".wikipedia.org/w/index.php?action=render&title="
	seedfetchurl=$seedfetchurlbase$safeseed

	curl --verbose --connect-timeout 60 --max-time 600 --max-redirs 1 --junk-session-cookies -o tmp/seed_document.html $seedfetchurl

if [ $fetched_document_format= "txt" ] ; then


	html2text -style pretty -nobs tmp/$uuid/seed_document.html > tmp/$uuid/seed_document.txt

else

	echo "no need to convert seed doc to txt"  | tee --append $sfb_log

fi

	echo 'processing fetch list' | tee --append $sfb_log

	while IFS='	' read title 
		do	
			
		echo "title is " $title

		safetitle=$(echo $title | sed -e 's/%/%25/g' -e 's/ /%20/g' -e 's/!/%21/g' -e 's/"/%22/g' -e 's/#/%23/g' -e 's/\$/%24/g' -e 's/\&/%26/g' -e 's/'\''/%27/g' -e 's/(/%28/g' -e 's/)/%29/g' -e 's/\*/%2a/g' -e 's/+/%2b/g' -e 's/,/%2c/g' -e 's/-/%2d/g' -e 's/\./%2e/g' -e 's/\//%2f/g' -e 's/:/%3a/g' -e 's/;/%3b/g' -e 's//%3e/g' -e 's/?/%3f/g' -e 's/@/%40/g' -e 's/\[/%5b/g' -e 's/\\/%5c/g' -e 's/\]/%5d/g' -e 's/\^/%5e/g' -e 's/_/%5f/g' -e 's/`/%60/g' -e 's/{/%7b/g' -e 's/|/%7c/g' -e 's/}/%7d/g' -e 's/~/%7e/g' -e 's/;/_/g')

		echo "safetitle is " $safetitle


		fetchurlbase="http://en.wikipedia.org/w/index.php?action=render&title="
		echo "fetchurlbase is" $fetchurlbase | tee --append $sfb_log
		fetchurl=$fetchurlbase$safetitle
		echo "url to be fetched is" $fetchurl | tee --append $sfb_log

		# shall we be polite?

		# sleep 1

		# implement curl persistent connection
		# implement curl connection tracking

		curl --silent --compressed --retry 2 --retry-delay 5 --retry-max 15 --connect-timeout 30 --max-time 60 --max-redirs 2 --junk-session-cookies -o tmp/$uuid/$count.tmp $fetchurl		

		echo "fetched document on " $title " and saved it to tmp/"$uuid/$count".tmp" | tee --append $sfb_log

		# remove img links from count.tmp



		if [ $fetched_document_format= "txt" ] ; then

			echo "fetched document format is " $fetched_document_format| tee --append $sfb_log

		 mv tmp/$uuid/$count.tmp tmp/$uuid/$count.html

		sed -e "s/<img[^>]*[^>]*>/images deleted/g" -e "s/'[edit]'//g" | sed '/table id="toc" class="toc"/,/table>/d'

			html2text -style pretty -nobs tmp/$uuid/$count".html" > tmp/$uuid/$count.txt
			echo "ran html2text on tmp/" $uuid/$count".html" | tee --append $sfb_log


			echo "#" "Chapter " $count". "$title  >> tmp/tmp.cumulative.txt
			echo "#" $h1 "Chapter " $count". "$title $h1end >> tmp/stored-toc-entries.html
			cat tmp/$uuid"/"$count".txt" >> tmp/$uuid/tmp.cumulative.txt


		else
		
			echo "fetched document format is " $fetched_document_format | tee --append $sfb_log

		 cat tmp/$uuid/$count.tmp | sed -e "s/<img[^>]*[^>]*>/images deleted/g" -e "s/'[edit]'//g" | sed '/table id="toc" class="toc"/,/table>/d' > tmp/$uuid/$count".html"

			echo $h1  "Chapter " $count". "$title $h1end >> tmp/$uuid/tmp.cumulative.html
			echo $h1 "Chapter " $count". "$title $h1end >> tmp/$uuid/stored-toc-entries.html
			cat tmp/$uuid"/"$count".html" >> tmp/$uuid/tmp.cumulative.html

			html2text -style pretty -nobs tmp/$uuid/tmp.cumulative.html > tmp/$uuid/tmp.cumulative.txt

		fi

		# writes titles to descriptions temp file

		echo $title $p >> tmp/$uuid"/stored-descriptions.html"
		# echo "added" $title "to temporary html and txt files that hold all descriptions" | tee --append tmp/stored-descriptions.html	
		
		# reports on status of fetches

		echo "number of docs fetched so far on seed" $seed "is " $count "out of " $doccount | tee --append $sfb_log

		count=$((count+1))

	
	done <fetch/$uuid/titles.txt
