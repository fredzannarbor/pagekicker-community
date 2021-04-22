# process XML search results file when booktype is Reader -- ie relevancy search


xmlstarlet sel -N x="http://opensearch.org/searchsuggest2" -t -m "//x:Item" -v "x:Url"  -n fetch/$uuid/searchresults.xml | sed '/^$/d'  > fetch/$uuid/urls.txt

xmlstarlet sel -N x="http://opensearch.org/searchsuggest2" -t -m "//x:Item" -v "x:Text"  -n fetch/$uuid/searchresults.xml | sed '/^$/d' | grep -Ev 'Wikipedia|Template|Category|Portal|Help' > fetch/$uuid/titles.txt

 xmlstarlet sel -N x="http://opensearch.org/searchsuggest2" -t -m "//x:Item" -v "x:Description"  -n fetch/$uuid/searchresults.xml | sed '/^$/d'  > fetch/$uuid/descriptions.txt

cat fetch/$uuid/titles.txt | grep -Ev 'Wikipedia|Template|Category|Portal|Help'

cat fetch/$uuid/urls.txt | sed -e 's/;/_/g' > fetch/$uuid/safeurls.txt
cat fetch/$uuid/titles.txt | sed -e 's/;/_/g' > fetch/$uuid/safetitles.txt
cat fetch/$uuid/descriptions.txt | sed -e 's/;/_/g' > fetch/$uuid/safedescriptions.txt

paste fetch/$uuid/urls.txt fetch/$uuid/titles.txt fetch/$uuid/descriptions.txt > fetch/$uuid/safesearchresults.txt

# add this after "x:Text" to reinsert Description-o ", " -v "x:Description" -o ", " -v "x:Text"

count=1

doccount=`wc -l < fetch/$uuid/safeurls.txt`

if [ "$doccount" = 0 ] ; then

	echo "no relevant documents for seed" $seed | tee --append $sfb_log

	seedhasdocs="no"

	

else

	echo "will be fetching " $doccount "documents on this seed " $seed | tee --append $sfb_log

	seedhasdocs="yes"

fi




