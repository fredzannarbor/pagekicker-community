
unformattedwordcount=`wc -w < tmp/$uuid/tmp.cumulative.txt`
wordcount=`wc -w < tmp/$uuid/tmp.cumulative.txt | sed -e :a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta' `
cp tmp/$uuid/tmp.cumulative.txt tmp/$uuid/test.cumulative.txt

echo "wordcount is" $wordcount | tee --append $sfb_log
echo "unformatted wordcount is" $unformattedwordcount | tee --append $sfb_log

# the html home page header and footer are already stored in includes/temptoc_*

cat includes/temptoc-header.html > tmp/$uuid/2.cumulative.html

# title page

# copyright page

# Dedication

cat ../conf/jobprofiles/dedications/$dedicationfilename >> tmp/$uuid/2.cumulative.html

# Epigraph

# List of Illustrations

# List of Tables

# Foreword

# Preface


# Author's signature (optional)


# Acknowledgments



# Introduction


# List of abbreviations


# Publisher's or translator's notes



# Body

# Parts

echo "$h1"Part I: User-Provided Content"$h1end" >> tmp/$uuid/2.cumulative.html

echo "userdata directory is" $userdatadir

if [ "$userdatadir" = "none" ] ; then

	echo "no user files provided" >> tmp/$uuid/temptoc.html

else
	# echo flat directories only for now -- in future, support directory userdata via find command

	# process docs in user-submitted folder 

	for file in tmp/$uuid/user/*
        do 
        echo $h2$openanchor"tmp/"$uuid/user/$file$dq$endbr"Chapter"$angbr$endanchor$h2end >> tmp/$uuid/2.cumulative.html
        cat $file >> tmp/$uuid/2.cumulative.html
	done
fi

# Chapters

echo "$h1"Part II: Permitted Content from the Web"$h1end" >> tmp/$uuid/temptoc.html

        for file in tmp/$uuid/wiki/*.html
        do 
        echo $h2$openanchor"tmp/"$uuid/wiki/$file$dq$endbr"Chapter"$angbr$endanchor$h2end >> tmp/$uuid/2.cumulative.html
        cat $file >> tmp/$uuid/2.cumulative.html
	done

echo "$h1"Part III: Permitted Images"$h1end" >> tmp/$uuid/temptoc.html

	for file in tmp/$uuid/flickr/*.jpg
        do 
        echo $imgsrc$dq$file$dq$endbr >> tmp/$uuid/2.cumulative.html
        done

# Epilogues, Afterwords, and Conclusions

# Appendixes

# Chronology

# Endnotes

# Glossary

# Bibliography

# Contributors

# Index

# Colophon

cat includes/temptoc-footer.html >> tmp/$uuid/temptoc.html

echo "built temporary Table of Contents page" | tee --append $sfb_log


