#!/bin/bash
#  processes robot or user's corpus directory


# input: directory path that contains txt files with txt extension
# note - this would break on splitter output - fix
# output - unified wordcloud

wordcloud="off"
stopimagefolder="none"
outdir=""

while :
do
case $1 in
--help | -\?)
echo "requires user to provide path to directory containing one or more txt files"
exit 0  # This is not an error, the user requested help, so do not exit status 1.
;;
--txtdir)
txtdir=$2
shift 2
;;
--txtdir=*)
pdfinfile=${1#*=}
shift
;;
--stopimagefolder)
stopimagefolder=$2
shift 2
;;
--stopimagefolder=*)
stopimagefolder=${1#*=}
shift
;;
--outdir)
outdir=$2
shift 2
;;
--outdir=*)
outdir=${1#*=}
shift
;;
--wordcloud)
wordcloud=$2
shift 2
;;
--wordcloud=*)
wordcloud=${1#*=}
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

if [ ! "$txtdir" ]; then
  echo "ERROR: option '--txtdir[txtdir]' not given. See --help" >&2
   exit 1
fi

corpusname=`basename "$txtdir"`
echo corpusname is $corpusname
cat "$txtdir"*.txt > "$txtdir$corpusname"".txt"
bin/wordcloudwrapper.sh --txtinfile "$txtdir$corpusname"".txt" --outfile "$txtdir$corpusname.png"
echo "concatenated corpus of" $corpusname "and did wordcloud from it"

