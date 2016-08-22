#!/bin/bash
#  creates summaries and NER reports for all txt files in a directory in preparation for building a big wordcloud

. includes/set-variables.sh
for file in *.txt*
do
	outfile=`basename $file`
        "$PYTHON_BIN" $scriptpath/bin/PKsum.py $file --output $file.sum
         "$PYTHON_BIN" $scriptpath/bin/nerv3.py $file $file.ner $file'.'
	 /opt/bitnami/apache2/htdocs/pk-new/development/scripts/bin/wordcloudwrapper.sh --txtinfile $file --outfile $outfile 
         echo "did " $file   
done
echo "done with directory"
cat *.ner > all.ner
cat *.sum > all.sum
cat all.ner all.sum > all.all
echo "concatenated results into files containing all NER results, all summary results, and the union of both"

