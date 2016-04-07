# programmatically generated parser syntax from list of variable names
while :
do
case '$'1 in
--help | -\?)
# Call your help or usage function here
exit 0  # This is not an error, the user requested help, so do not exit status 1.
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
--pass_uuid)
pass_uuid=$2
shift 2
;;
--pass_uuid=*)
pass_uuid=${1#*=}
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
--text_extraction_on)
text_extraction_on=$2
shift 2
;;
--text_extraction_on=*)
text_extraction_on=${1#*=}
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


