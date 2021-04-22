echo "<?xml version="1.0"?>" >> tmp/$uuid/onix-working.xml
echo "<!DOCTYPE ONIXMessage SYSTEM "http://www.editeur.org/onix/2.1/reference/onix-international.dtd">" >> tmp/$uuid/onix-working.xml
echo "<ONIXMessage>"  >> tmp/$uuid/onix-working.xml
 echo "<Header>" >> tmp/$uuid/onix-working.xml
 echo  "<FromCompany>PageKicker</FromCompany>"  >> tmp/$uuid/onix-working.xml
 echo   "<FromPerson>fred@PageKicker.com</FromPerson>" >> tmp/$uuid/onix-working.xml
 echo   "<SentDate>$YYYYMMDDHHMM</SentDate>" >> tmp/$uuid/onix-working.xml
 echo  " <DefaultLanguageOfText>eng</DefaultLanguageOfText>" >> tmp/$uuid/onix-working.xml
echo  "</Header>" >> tmp/$uuid/onix-working.xml
 echo "<Product>" >> tmp/$uuid/onix-working.xml
 echo  "<RecordReference>$uuid"/"$SKU$filetype</RecordReference>" >> tmp/$uuid/onix-working.xml
 echo  " <NotificationType>03</NotificationType>" >> tmp/$uuid/onix-working.xml
echo "<ProductIdentifier>" >> tmp/$uuid/onix-working.xml
echo    "<ProductIDType>15</ProductIDType>" >> tmp/$uuid/onix-working.xml
 echo   "<IDValue>$ISBN</IDValue>" >> tmp/$uuid/onix-working.xml
echo "</ProductIdentifier>" >> tmp/$uuid/onix-working.xml
echo "<ProductForm>DG</ProductForm>" >> tmp/$uuid/onix-working.xml
echo "<EpubType>029</EpubType>"  >> tmp/$uuid/onix-working.xml
echo "<EpubFormatDescription>Epub</EpubFormatDescription>" >> tmp/$uuid/onix-working.xml
echo "<Title>"  >> tmp/$uuid/onix-working.xml

