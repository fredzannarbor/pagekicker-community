# programmatically generated parser syntax from list of variable names
while :
do
case $1 in
--help | -\?)
# Call your help or usage function here
exit 0  # This is not an error, the user requested help, so do not exit status 1.
;;
--)
=$2
shift 2
;;
--=*)
=${1#*=}
shift
;;
--arxiv)
arxiv=$2
shift 2
;;
--arxiv=*)
arxiv=${1#*=}
shift
;;
--BISAC_code)
BISAC_code=$2
shift 2
;;
--BISAC_code=*)
BISAC_code=${1#*=}
shift
;;
--booktype)
booktype=$2
shift 2
;;
--booktype=*)
booktype=${1#*=}
shift
;;
--breaking)
breaking=$2
shift 2
;;
--breaking=*)
breaking=${1#*=}
shift
;;
--build_all_formats)
build_all_formats=$2
shift 2
;;
--build_all_formats=*)
build_all_formats=${1#*=}
shift
;;
--build_bw_pdf)
build_bw_pdf=$2
shift 2
;;
--build_bw_pdf=*)
build_bw_pdf=${1#*=}
shift
;;
--build_color_pdf)
build_color_pdf=$2
shift 2
;;
--build_color_pdf=*)
build_color_pdf=${1#*=}
shift
;;
--build_mobi)
build_mobi=$2
shift 2
;;
--build_mobi=*)
build_mobi=${1#*=}
shift
;;
--build_richlink_epub)
build_richlink_epub=$2
shift 2
;;
--build_richlink_epub=*)
build_richlink_epub=${1#*=}
shift
;;
--build_text_epub)
build_text_epub=$2
shift 2
;;
--build_text_epub=*)
build_text_epub=${1#*=}
shift
;;
--build_txt_html_only)
build_txt_html_only=$2
shift 2
;;
--build_txt_html_only=*)
build_txt_html_only=${1#*=}
shift
;;
--categoryid)
categoryid=$2
shift 2
;;
--categoryid=*)
categoryid=${1#*=}
shift
;;
--coverbase)
coverbase=$2
shift 2
;;
--coverbase=*)
coverbase=${1#*=}
shift
;;
--covercolor)
covercolor=$2
shift 2
;;
--covercolor=*)
covercolor=${1#*=}
shift
;;
--coverfile)
coverfile=$2
shift 2
;;
--coverfile=*)
coverfile=${1#*=}
shift
;;
--coverfont)
coverfont=$2
shift 2
;;
--coverfont=*)
coverfont=${1#*=}
shift
;;
--coverfontcolor)
coverfontcolor=$2
shift 2
;;
--coverfontcolor=*)
coverfontcolor=${1#*=}
shift
;;
--coverRGB)
coverRGB=$2
shift 2
;;
--coverRGB=*)
coverRGB=${1#*=}
shift
;;
--covertype_id)
covertype_id=$2
shift 2
;;
--covertype_id=*)
covertype_id=${1#*=}
shift
;;
--customer_email)
customer_email=$2
shift 2
;;
--customer_email=*)
customer_email=${1#*=}
shift
;;
--customtitle)
customtitle=$2
shift 2
;;
--customtitle=*)
customtitle=${1#*=}
shift
;;
--ebookformat)
ebookformat=$2
shift 2
;;
--ebookformat=*)
ebookformat=${1#*=}
shift
;;
--editedby)
editedby=$2
shift 2
;;
--editedby=*)
editedby=${1#*=}
shift
;;
--editorid)
editorid=$2
shift 2
;;
--editorid=*)
editorid=${1#*=}
shift
;;
--endurl)
endurl=$2
shift 2
;;
--endurl=*)
endurl=${1#*=}
shift
;;
--fetched_document_format)
fetched_document_format=$2
shift 2
;;
--fetched_document_format=*)
fetched_document_format=${1#*=}
shift
;;
--fetchfile)
fetchfile=$2
shift 2
;;
--fetchfile=*)
fetchfile=${1#*=}
shift
;;
--fleet)
fleet=$2
shift 2
;;
--fleet=*)
fleet=${1#*=}
shift
;;
--flickr)
flickr=$2
shift 2
;;
--flickr=*)
flickr=${1#*=}
shift
;;
--import)
import=$2
shift 2
;;
--import=*)
import=${1#*=}
shift
;;
--ISBN)
ISBN=$2
shift 2
;;
--ISBN=*)
ISBN=${1#*=}
shift
;;
--ISBN_owner)
ISBN_owner=$2
shift 2
;;
--ISBN_owner=*)
ISBN_owner=${1#*=}
shift
;;
--jobprofile)
jobprofile=$2
shift 2
;;
--jobprofile=*)
jobprofile=${1#*=}
shift
;;
--LSI_import)
LSI_import=$2
shift 2
;;
--LSI_import=*)
LSI_import=${1#*=}
shift
;;
--mylibrary)
mylibrary=$2
shift 2
;;
--mylibrary=*)
mylibrary=${1#*=}
shift
;;
--negative_seeds)
negative_seeds=$2
shift 2
;;
--negative_seeds=*)
negative_seeds=${1#*=}
shift
;;
--negative_seed_weight)
negative_seed_weight=$2
shift 2
;;
--negative_seed_weight=*)
negative_seed_weight=${1#*=}
shift
;;
--pass_uuid)
pass_uuid=$2
shift 2
;;
--pass_uuid=*)
pass_uuid=${1#*=}
shift
;;
--positive_seeds)
positive_seeds=$2
shift 2
;;
--positive_seeds=*)
positive_seeds=${1#*=}
shift
;;
--positive_seed_weight)
positive_seed_weight=$2
shift 2
;;
--positive_seed_weight=*)
positive_seed_weight=${1#*=}
shift
;;
--price)
price=$2
shift 2
;;
--price=*)
price=${1#*=}
shift
;;
--refresh)
refresh=$2
shift 2
;;
--refresh=*)
refresh=${1#*=}
shift
;;
--rows)
rows=$2
shift 2
;;
--rows=*)
rows=${1#*=}
shift
;;
--seedfile)
seedfile=$2
shift 2
;;
--seedfile=*)
seedfile=${1#*=}
shift
;;
--seedsource)
seedsource=$2
shift 2
;;
--seedsource=*)
seedsource=${1#*=}
shift
;;
--singleseed)
singleseed=$2
shift 2
;;
--singleseed=*)
singleseed=${1#*=}
shift
;;
--special_lasts_minutes)
special_lasts_minutes=$2
shift 2
;;
--special_lasts_minutes=*)
special_lasts_minutes=${1#*=}
shift
;;
--special_price)
special_price=$2
shift 2
;;
--special_price=*)
special_price=${1#*=}
shift
;;
--summarizer)
summarizer=$2
shift 2
;;
--summarizer=*)
summarizer=${1#*=}
shift
;;
--summarizer_ngram_threshold)
summarizer_ngram_threshold=$2
shift 2
;;
--summarizer_ngram_threshold=*)
summarizer_ngram_threshold=${1#*=}
shift
;;
--summary_length)
summary_length=$2
shift 2
;;
--summary_length=*)
summary_length=${1#*=}
shift
;;
--text_extraction_on)
text_extraction_on=$2
shift 2
;;
--text_extraction_on=*)
text_extraction_on=${1#*=}
shift
;;
--userdatadir)
userdatadir=$2
shift 2
;;
--userdatadir=*)
userdatadir=${1#*=}
shift
;;
--userdescription)
userdescription=$2
shift 2
;;
--userdescription=*)
userdescription=${1#*=}
shift
;;
--userid)
userid=$2
shift 2
;;
--userid=*)
userid=${1#*=}
shift
;;
--userlogo)
userlogo=$2
shift 2
;;
--userlogo=*)
userlogo=${1#*=}
shift
;;
--verbose)
verbose=$2
shift 2
;;
--verbose=*)
verbose=${1#*=}
shift
;;
        --) # End of all options
            shift
            break
            ;;
        -*)
            echo "WARN: Unknown option (ignored): $1" >&2
            shift
            ;;
        *)  # no more options. Stop while loop
            break
            ;;

esac
done

# Suppose some options are required. Check that we got them.

#if [ ! "$userprovidedprintISBN" ]; then
#   echo "ERROR: option '--ISBN [isbnvalue]' not given. See --help" >&2
#    exit 1
#fi


