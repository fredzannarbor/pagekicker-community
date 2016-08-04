#!/bin/bash
#  processes all txt files in a directory


# input: directory path that contains txt files with txt extension
# note - this would break on splitter output - fix
# output: directory with results

. includes/set-variables.sh
wordcloud="off"
configfile="lib/IBMcloud/examples/configuration.txt"
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
txtdir=${1#*=}
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
--summary_lines)
summary_lines=$2
shift 2
;;
--summary_lines=*)
summary_lines=${1#*=}
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

mkdir -p -m 755 $outdir

for file in "$txtdir"*.txt
do
	outfile=`basename $file`
	python "$scriptpath"bin/PKsum.py $file --output $outdir$outfile".sum" --length 1 
	"$PYTHON_BIN" "$scriptpath"bin/nerv3.py $file $outdir$outfile".ner" $outdir$outfile"."

	if [ "$wordcloud" = "on" ] ; then

		/opt/bitnami/apache2/htdocs/pk-new/development/scripts/bin/wordcloudwrapper.sh --txtinfile $file --outfile $outdir$outfile
		 echo "summarized and recognized proper nouns, and built wordcloud for" $file  

	else
		 echo "summarized and recognized proper nouns for" $file   
	fi
done
echo "done processing individual txt files in directory " $txtdir
cat $outdir*.ner > $outdir"all.ner.txt"
cat $outdir*.sum > $outdir"all.sum.txt"

echo "concatenated results into txt files containing all NER results, all summary results, and the union of both"

exit 0
