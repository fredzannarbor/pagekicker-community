YYYYMMDD=`date +'%Y%m%d'`

YYYYMMDDHHSS=`date +'%Y%m%d%k%M'`

YYYY=`date +'%Y'`

ebookISBN="yes"


# echo $YYYY

# Title Group ID
 
echo -n '"'$ISBN'",' >> $metadatatargetpath"lsi-import-ready.csv"
 
# ISBN13
 echo -n '"'$ISBN'",'  >> $metadatatargetpath"lsi-import-ready.csv"

# Asset Type

 echo -n '"'EPUB'",'>> $metadatatargetpath"lsi-import-ready.csv"

# Asset Status

 echo -n '"'Active'",' >> $metadatatargetpath"lsi-import-ready.csv"

# Publishing Status

 echo -n '"'04 Active'",' >> $metadatatargetpath"lsi-import-ready.csv"

# Title
 
echo -n '"'$covertitle'",' >> $metadatatargetpath"lsi-import-ready.csv"
 
# Subtitle
 
echo -n '"'$subtitle'",' >> $metadatatargetpath"lsi-import-ready.csv"
 
# Publisher
 
echo -n '"'W. Frederick Zimmerman'",' >> $metadatatargetpath"lsi-import-ready.csv"
 
# Imprint
 
echo -n '"'PageKicker'",' >> $metadatatargetpath"lsi-import-ready.csv"
 
# Related Print Product ISBN
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 1 First Name
 
echo -n '"' $firstname  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 1 Middle Name
 
echo -n '"' $middlename  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 1 Last Name
 
echo -n '"' $lastname  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 1 Prefix

echo -n '"' $nameprefix  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 1 Suffix
 
echo -n '"' '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 1 Role
 
echo -n '"'Author'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 1 Bio
 
echo -n '"'   >> $metadatatargetpath"lsi-import-ready.csv"

cat "$authorbio"  >> $metadatatargetpath"lsi-import-ready.csv"

echo -n '",'   >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 2 First Name
 
echo -n '"' '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 2 Middle Name
 
echo -n '"'  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 2 Last Name
 
echo -n '"'  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 2 Prefix
 
echo -n '"'  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 2 Suffix
 
echo -n '"'  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 2 Role
  
echo -n '"'  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Contributor 2 Bio
 
echo -n '"'  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Price Business Model Flag
 
echo -n '"'Agency'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Currency Code
 
echo -n '"'USD'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Price 1
 
echo -n '"'$price'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Price Type Desc 1
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Price Effective From 1
 
echo -n '"'   '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Price Effective Until 1
 
echo -n '"'  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Sales Rights Type
 
echo -n '"'01 For unrestricted sale with exclusive rights in the specific countries or territories'",' >> $metadatatargetpath"lsi-import-ready.csv"
 
# Countries Included
 
echo -n '"'  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Countries Excluded
 
echo -n '"'  '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Regions Included
 
echo -n '"'WORLD'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Regions Excluded
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Publication Date
 
YYYYMMDD=`date +'%Y%m%d'`
echo -n '"'$YYYYMMDD'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Street Date
 
echo -n '"'$YYYYMMDD'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# BISAC Code(s)
 
# echo $BISAC_code
echo -n '"'$BISAC_code'",'  >> $metadatatargetpath"lsi-import-ready.csv"

# BIC Subject Code(s)
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Series Name
 
echo -n '"'$categoryname'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Series Number
 
echo -n '"' '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Edition Number
 
echo -n '"' '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Edition Type
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Edition Statement
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Volume Number
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Total Number of Volumes
 
echo -n '"'1'",' >> $metadatatargetpath"lsi-import-ready.csv"
 
# Language
 
echo -n '"'English'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Page Count
 
pagecount=$(( $unformattedwordcount / 250 )) 

echo -n '"'$pagecount'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# LC Classification
 
echo -n '"' '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# LC Subject Heading
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# LCCN
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Dewey Decimal Code
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Short Description
 
echo -n '"'  >> $metadatatargetpath"lsi-import-ready.csv"

cat tmp/$uuid/lsi-shortdescription.txt  >> $metadatatargetpath"lsi-import-ready.csv"

echo  -n '",'  >> $metadatatargetpath"lsi-import-ready.csv"

# Long Description

echo -n '"'  >> $metadatatargetpath"lsi-import-ready.csv"

# echo -n "foo" >> $metadatatargetpath"lsi-import-ready.csv"

cat tmp/$uuid/lsi-longdescription.txt  >> $metadatatargetpath"lsi-import-ready.csv"

echo -n '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Main Description
 
echo -n '"'  >> $metadatatargetpath"lsi-import-ready.csv"

echo -n "" >> $metadatatargetpath"lsi-import-ready.csv"

# cat tmp/$uuid/shortdescription.html  >> $metadatatargetpath"lsi-import-ready.csv"

echo -n '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Keywords
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Award
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Award Year
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Award Type
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Flag as adult content?
 
echo -n '"' No '",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Copyright Holder 
 
echo -n '"'PageKicker™'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Copyright Date
 
echo -n '"'$YYYY'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Audience/Readership
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# K-12 Grade Level
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Min Age
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Max Age
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# National Curriculum Key Stage
 
echo -n '"''",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Apple Publication Release Type
 
echo -n '"'Digital Only'",'  >> $metadatatargetpath"lsi-import-ready.csv"
 
# Apple Publication Book Type
 
echo '"'Book'"'  >> $metadatatargetpath"lsi-import-ready.csv"

echo "end of writing LSI metadata"
 
