add_corpora="no"
analyze_url="no"
arxiv="no"
BISAC_code="None"
booktype="Reader"
breaking="no"
build_all_formats="yes"
build_bw_pdf="yes"
build_color_pdf="yes"
build_docx="no"
build_linkrich_epub="yes"
build_mobi="yes"
build_text_epub="yes"
build_txt_html_only="no"
categoryid=2
coverbase="images/bottomcanvas.png"
covercolor="RosyBrown"
coverfile="assets/NCP-cover.jpg"
coverfontcolor="white"
coverfont="Minion"
coverRGB="0,0,0"
covertype_id="1"
customer_email="store@pagekicker.com"
customtitle="none"
dedicationfilename="default.html"
dedicationfilename="default.html"
ebookformat="epub"
editedby="PageKicker"
editorid="1"
endurl="&prop=links&pllimit=500&format=xml"
fetched_document_format="html"
fetchfile="fetch/fetchlist.csv"
fleet="yes"
flickr="no"
import="yes"
imprint="pagekicker"
ISBN="012345679X"
ISBN_assign_automatically="no"
ISBN_owner="0"
jobprofile="default.jobprofile"
LSI_import="yes"
mylibrary="yes"
news_lasts_minutes="43200"
pass_uuid="no"
pdfserif="MinionWebPro"
price=0.99
refresh="yes"
rows=1
sample_tweets="yes"
seedfile="seeds/current-seeds"
seedsource="PageKicker"
SEOmodule_status="off"
seriesdescriptionfilename="default.html"
shortform="no"
singleseed="no"
special_lasts_minutes="43200"
special_price="0"
specialstoreid="0"
text_extraction_on="yes"
top_q="20" # number of nerv lines used divided by 2
userdatadir="none"
userdescription="no"
userid="1"
userlogo="assets/imprint.png"
verbose="no"
wikilocale="en"
yourname="no"

# summarizer

summarizer_on=Y
summary_length=10
robot_summary_length=10 
positive_seeds=""
positive_seed_weight=1
negative_seeds=""
negative_seed_weight=1
summarizer_ngram_threshold=2

#cccsetup

exemplar_filedir_code=400 # this is the field code value used in the directory structure where magento webforms stores uploaded exemplar files -- softcoded below
builder="yes"
mailtofred="yes"
storecode="admin"
websites="base"
attribute_set="Default"
type="downloadable"
categories="4"
status="Enabled"
visibility="Catalog,Search"
special_to_buffer="2592000"
storeids="0"
news_to_buffer="2592000"

#initializing some more variables

sku=`tail -1 < "$LOCAL_DATA""SKUs/sku_list"`

ebookintro="includes/ebook.intro.html"

nameprefix=""
middlename=""
firstname=""
lastname=""

wikilocale="en"

fetcharray=()



#workarounds & useful regexes

angbr="<"
body="<body>"
bold="<b>"
closeparen=")"
description="test"
docsandabstracts="'<b>Document titles and abstracts:</b><p>'"
docxlinkname="Microsoft_Word_docx"
docxname="Microsoft_Word_docx"
dq='"'
endanchor="/a>"
endbody="</body>"
endbold="</b>"
endbr=">"
endhead="</endhead>"
endhtml="</html>"
endp="</p>"
epublinkname="ePub"
epublinkrichname="Pub"
h1=$angbr"h1"$endbr
h1end=$angbr$slash"h1"$endbr
h2=$angbr"h2"$endbr
h2end=$angbr$slash"h2"$endr
h3=$angbr"h3"$endbr
h3end=$angbr$slash"h3"$endbr
head="<head>"
html="<html>"
httpvalidate='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
imgsrc="<IMG SRC="
mobilinkname="Kindle"
newline="/n"
on=" on "
openanchor="<a href="$dq
openparen="("
pdflinkname="PDF"
pipe="|"
p="<p>"
slash="/"
sq="'"
x="x" # for imagemagick scripts

#imagemagick setup

cover_image_extension=".png"
txtformatname=".txt"
txtwildcard="*.txt"
epub=".epub"xmlstarletwebformstart="xmlstarlet sel -t -v"
subtitle=""

# cover builder setup

printconfigfile="yes"

#xmlstarlet setup

xmlstarletwebformstart="xmlstarlet sel -t -v"
xpathwebformid='"/item/webform_id"'
booktypewebformid='"/item/booktype"'
singleseedwebformid='"/item/singleseed"'
customeridwebformid='"/item/customerid"'
