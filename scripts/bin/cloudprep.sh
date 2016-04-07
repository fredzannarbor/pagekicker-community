#!/bin/bash
#  creates summaries and NER reports for all txt files in a directory in preparation for building a big wordcloud

for file in *.txt*
do
	outfile=`basename $file`
#         python /opt/bitnami/apache2/htdocs/pk-new/development/scripts/includes/PKsum.py $file --output $file.sum
#         python /opt/bitnami/apache2/htdocs/pk-new/development/scripts/includes/nerv3.py $file $file.ner
	 /opt/bitnami/apache2/htdocs/pk-new/development/scripts/bin/wordcloudwrapper.sh --txtinfile $file --outfile $outfile 
         echo "did " $file   
done
echo "done with directory"
cat *.ner > all.ner
cat *.sum > all.sum
cat all.ner all.sum > all.all
echo "concatenated results into files containing all NER results, all summary results, and the union of both"

