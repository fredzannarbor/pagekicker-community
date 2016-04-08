#meta keywords below

echo -n  '"' | tee --append $metadatatargetpath$uuid/"current-import.csv"
while read keyword
do
	echo -n ''$keyword', ' | tee --append $metadatatargetpath"$uuid/current-import.csv"

done < "tmp/"$uuid/$sku"keywords.txt"
