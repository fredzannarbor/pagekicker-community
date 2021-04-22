# xmlstarlet queries the searchresults.xml file and extracts all the title attributes 

# the title attributes are the only information brought back by the retrieve_all_links query, there are no abstracts or urls

xmlstarlet sel -t -m "/api/query/pages/page/links/pl" -v "@title" -n fetch/$uuid/searchresults.xml | grep -Ev 'Wikipedia|Template|Category|Portal|Help' | sed '/^$/d'  > fetch/$uuid"/titles.txt"

doccount=`wc -l < fetch/$uuid"/titles.txt"`

if [ "$doccount" = 0 ] ; then

	echo "skipping no relevant documents for seed" $seed | tee --append $sfb_log

	# exit 0

	pass

else

	echo "will be fetching " $doccount "documents on this seed " $seed | tee --append $sfb_log

fi


