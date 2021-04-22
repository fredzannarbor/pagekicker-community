
unformattedwordcount=`wc -w < tmp/$uuid/tmp.cumulative.txt`
wordcount=`wc -w < tmp/$uuid/tmp.cumulative.txt | sed -e :a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta' `
cp tmp/$uuid/tmp.cumulative.txt tmp/$uuid/test.cumulative.txt

echo "wordcount is" $wordcount | tee --append $sfb_log
echo "unformatted wordcount is" $unformattedwordcount | tee --append $sfb_log

# the html home page header and footer are already stored in includes/temptoc_*

case $booktype in

Reader)

	echo $"Foreword" $p >> tmp/$uuid/shortdescription.html

	if [ $userdescription = "yes" ] ; then

		cat bin/xform-includes/userdescription.txt >> tmp/$uuid/shortdescription.html
		cat bin/xform-includes/userdescription.txt >> tmp/$uuid/lsi-shortdescription.txt

	else

		true

	fi

	echo $"This unique, differentiated, enhanced" $booktype $"in e-book format consists of" $doccount $"documents for a total of "$wordcount $"words." | tee --append tmp/$uuid/shortdescription.html tmp/$uuid/shortdescription.txt

	echo $p >> tmp/$uuid/shortdescription.html

	cat ../conf/jobprofiles/seriesdescriptions/$seriesdescriptionfilename >> tmp/$uuid/shortdescription.html

	echo $"About the Author"$p >> tmp/$uuid/shortdescription.html

	cat "$authorbio" >> tmp/$uuid/shortdescription.html

	cat "$authorbio" >> tmp/$uuid/book-description.txt


	echo $"Dedication" \n >> tmp/$uuid/dedication.txt

	echo $"Dedication" $p >> tmp/$uuid/dedication.html

        #echo "<center>" >> tmp/$uuid/shortdescription.html

	# echo $angbr"img src="$dq$dingbat$dq$endbr >> tmp/$uuid/shortdescription.html

	#echo "</center>" >> tmp/$uuid/shortdescription.html

	# cat includes/wordcloudpagefooter.html >> tmp/$uuid/shortdescription.html

	;;

	Explorer)

	
	;;

	*)

	;;

	esac

ebook-convert  tmp/$uuid/shortdescription.html tmp/$uuid/shortdescription.txt

# build ad section html for long description

cat tmp/$uuid/stored-descriptions.html >> tmp/$uuid/longdescription.html
cat tmp/$uuid/lsi-stored-descriptions.txt >> tmp/$uuid/lsi-longdescription.txt


# add front and back matter to cumulative.html and txt files



case $booktype in



Reader)

cat tmp/$uuid/html_header.html > tmp/$uuid/cumulative.html

cat tmp/$uuid/shortdescription.html >> tmp/$uuid/cumulative.html

cat ../conf/jobprofiles/dedications/$dedicationfilename >> tmp/$uuid/cumulative.html

cat tmp/$uuid/tmp.cumulative.html >> tmp/$uuid/cumulative.html

cat tmp/$uuid/shortdescription.txt >> tmp/$uuid/cumulative.txt

cat ../conf/jobprofiles/dedications/$dedicationfilename | html2text >> tmp/$uuid/cumulative.txt

# filter cumulative.txt for [Image]

cat tmp/$uuid/tmp.cumulative.txt | grep -v '\[Image\]$'  >> tmp/$uuid/filtered.cumulative.txt

cat tmp/$uuid/filtered.cumulative.txt >> tmp/$uuid/cumulative.txt

;;

Explorer) 
;;
*)

esac

echo $h1 $"Appendix" $h1end >> tmp/$uuid/cumulative.html

cat includes/wikilicense.html >> tmp/$uuid/cumulative.html

echo $"Appendix" >> tmp/$uuid/cumulative.txt

echo "" >> tmp/$uuid/cumulative.txt

cat includes/wikilicense.txt >> tmp/$uuid/cumulative.txt
