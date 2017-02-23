# api manager

# apis registered

# currently registered APIs

AlchemyAPI=1
WikipediaAPI=1
FacebookAPI=1
MendeleyAPI=1
TwitterAPI=1
PLOSAPI=1
arxivAPI=1
FullContactAPI=1

# apis currently in use

AlchemyAPIinUse=0
WikipediaAPIinUse=1
MendeleyAPIinUse=0
FacebookAPIinUse=0
TwitterAPIinUse=0
PLOSAPIinUse=0
arxivAPIinUse=0


# api registration information

WikipediaAPIuserID="nimblecombinatorial"
WikipediaAPIuserPW="Balssa41"

FullContactAPIKey="8f1d60267f1b859f"
# mendeley key/secret pair is MendeleyClient('13a47f20711f5d5ffe8e8f4db1df1daa04f8bd9b6', '394d64a2907f23c7f6ea5d94fb386865')

# Mendeley client is activated by running lib/wikiradar.py

plos_API_key="XMIciRBsScpd2NT"

# api login behavior

# AlchemyAPI does not require login

# Wikipedia login per http://www.mediawiki.org/wiki/API:Login

# BASH script per http://stackoverflow.com/questions/6370357/login-to-mediawiki-using-rcurl

# needs to check if already logged in elsewise it will be throttled

curl --silent -c cookies.txt -d "lgname="$WikipediaAPIuserID"&lgpassword="$WikipediaAPIuserPW"&action=login&format=xml" https://en.wikipedia.org/w/api.php -o $TMPDIR$uuid/output.xml

TOKEN=$(xmlstarlet sel -t -m '//login' -v '//@token' $TMPDIR$uuid/output.xml)

if [ $WikipediaAPIinUse = "1" ] ; then

	echo "running API manager for logging into Wikipedia API"

	curl --silent -b cookies.txt -d "action=login&lgname="$WikipediaAPIuserID"&lgpassword="$WikipediaAPIuserPW"&format=xml&lgtoken="$TOKEN https://en.wikipedia.org/w/api.php >> $TMPDIR$uuid/output.xml
	echo " "
else

	echo "Wikipedia API not in use" 

fi

if [ $MendeleyAPIinUse = "1" ] ; then

	echo "append customer key to URL requests for access to public Mendeley resources (only)"

	consumer_key="13a47f20711f5d5ffe8e8f4db1df1daa04f8bd9b6"

	else

	true

fi
