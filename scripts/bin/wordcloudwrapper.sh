#!/bin/bash

# runs wordcloud program with text file input

# requires java, IBMcloud

# input: text file
# optional: wordcloud_height, wordcloud_width, configfile, outfile
# output: wordcloud.png

# edit path to PageKicker config file here

. /home/$USER/.pagekicker/config.txt


#   configuration values for this program

configfile="$scriptpath"lib/IBMcloud/examples/configuration.txt
wordcloud_height=5100
wordcloud_width=6600
outfile="wordcloud" # if multiple wordclouds are run this is the basename


while :
do
case $1 in
--help | -\?)
echo "requires input text file name"
exit 0  # This is not an error, the user requested help, so do not exit status 1.
;;
--txtinfile)
txtinfile=$2
shift 2
;;
--txtinfile=*)
txtinfile=${1#*=}
shift
;;
--wordcloud_width)
wordcloud_width=$2
shift 2
;;
--wordcloud_width=*)
wordcloud_width=${1#*=}
shift
;;
--wordcloud_height)
wordcloud_height=$2
shift 2
;;
--wordcloud_height=*)
wordcloud_height=${1#*=}
shift
;;
--configfile)
configfile=$2
shift 2
;;
--configfile=*)
configfile=${1#*=}
shift
;;
--outfile|o)
outfile=$2
shift 2
;;
--outfile|o=*)
outfile=${1#*=}
shift
;;
--stopfile)
stopwordfile=$2
shift 2
;;
--stopfile=*)
stopwordfile=${1#*=}
shift 2
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

if [ ! "$txtinfile" ]; then
  echo "ERROR: option '--txtinfile[txtinfile]' not given. See --help" >&2
   exit 1
fi
echo "JAVA_BIN is" $JAVA_BIN
echo "jar file is" $scriptpath"lib/IBMcloud/ibm-word-cloud.jar"
echo "configfile is" $configfile

# rotate stopwordfile in and out

cp "$stopfile" $scriptpath"lib/IBMcloud/examples/pk-stopwords.txt"
echo "running stopfile $stopfile"

$JAVA_BIN -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $configfile -h "$wordcloud_height" -w "$wordcloud_width" < $txtinfile > $outfile".png"

cp $scriptpath"lib/IBMcloud/examples/restore-pk-stopwords.txt"  $scriptpath"lib/IBMcloud/examples/pk-stopwords.txt" 

exit 0
