YYYYMMDD=`date +'%Y%m%d'`

YYYYMMDDHHSS=`date +'%Y%m%d%k%M'`

YYYY=`date +'%Y'`

echo "<?xml version="$dq"1.0"$dq"?>" >> tmp/$uuid/onix-working.xml
echo "<!DOCTYPE ONIXMessage SYSTEM "$dq"http://www.editeur.org/onix/2.1/reference/onix-international.dtd"$dq">" >> tmp/$uuid/onix-working.xml
echo "<ONIXMessage>"  >> tmp/$uuid/onix-working.xml
echo "<Header>" >> tmp/$uuid/onix-working.xml
echo  "  <FromCompany>PageKicker</FromCompany>"  >> tmp/$uuid/onix-working.xml
echo   "  <FromPerson>fred@PageKicker.com</FromPerson>" >> tmp/$uuid/onix-working.xml
echo   "  <SentDate>$YYYYMMDD</SentDate>" >> tmp/$uuid/onix-working.xml
echo  "   <DefaultLanguageOfText>eng</DefaultLanguageOfText>" >> tmp/$uuid/onix-working.xml
echo  "</Header>" >> tmp/$uuid/onix-working.xml
 echo "<Product>" >> tmp/$uuid/onix-working.xml
 echo  " <RecordReference>"$sku"</RecordReference>" >> tmp/$uuid/onix-working.xml
 echo  " <NotificationType>03</NotificationType>" >> tmp/$uuid/onix-working.xml
echo " <ProductIdentifier>" >> tmp/$uuid/onix-working.xml
echo    " <ProductIDType>15</ProductIDType>" >> tmp/$uuid/onix-working.xml
 echo   " <IDValue>$ISBN</IDValue>" >> tmp/$uuid/onix-working.xml
echo "  </ProductIdentifier>" >> tmp/$uuid/onix-working.xml
echo "<ProductForm>DG</ProductForm>" >> tmp/$uuid/onix-working.xml
echo "<EpubType>029</EpubType>"  >> tmp/$uuid/onix-working.xml
echo "<EpubFormatDescription>Epub</EpubFormatDescription>" >> tmp/$uuid/onix-working.xml
echo "<Title>"  >> tmp/$uuid/onix-working.xml
echo "<TitleType>01</TitleType>" >> tmp/$uuid/onix-working.xml
echo "<TitleText>$covertitle</TitleText>"  >> tmp/$uuid/onix-working.xml
echo "</Title>"  >> tmp/$uuid/onix-working.xml
echo "<Contributor>" >> tmp/$uuid/onix-working.xml
echo "   <SequenceNumber>1</SequenceNumber>" >> tmp/$uuid/onix-working.xml
echo "   <ContributorRole>A01</ContributorRole>" >> tmp/$uuid/onix-working.xml
echo "    <NamesBeforeKey> "$firstname"</NamesBeforeKey>" >> tmp/$uuid/onix-working.xml
echo "   <KeyNames>$lastname</KeyNames>" >> tmp/$uuid/onix-working.xml
echo "<BiographicalNote>" >> tmp/$uuid/onix-working.xml
cat "$authorbio" | html2text >> tmp/$uuid/onix-working.xml
echo "</BiographicalNote>" >> tmp/$uuid/onix-working.xml
echo "</Contributor>" >> tmp/$uuid/onix-working.xml
echo "<Publisher>" >> tmp/$uuid/onix-working.xml
echo  "  <PublishingRole>01</PublishingRole>" >> tmp/$uuid/onix-working.xml
echo  "  <PublisherName>PageKicker</PublisherName>"   >> tmp/$uuid/onix-working.xml
echo "</Publisher>"  >> tmp/$uuid/onix-working.xml
echo "<SalesRights>"  >> tmp/$uuid/onix-working.xml
echo "   <SalesRightsType>01</SalesRightsType>"  >> tmp/$uuid/onix-working.xml
echo "   <RightsCountry>US GB </RightsCountry>" >> tmp/$uuid/onix-working.xml
echo "   <RightsTerritory>WORLD</RightsTerritory>" >> tmp/$uuid/onix-working.xml
echo "</SalesRights>" >> tmp/$uuid/onix-working.xml
echo "</Product>" >> tmp/$uuid/onix-working.xml
echo "</ONIXMessage>" >> tmp/$uuid/onix-working.xml
