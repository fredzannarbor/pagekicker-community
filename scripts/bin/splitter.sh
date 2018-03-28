#!/bin/bash

# splits text files into chunks of arbitrary length

# input: text file txtinfile
# optional: size of chunks
# output: chunked files

# edit path to PageKicker config file here

. /opt/bitnami/apache2/htdocs/pk-new/development/conf/config.txt


#   configuraiton values for this program

chunksize="140K" #default

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
--chunksize)
chunksize=$2
shift 2
;;
--chunksize=*)
chunksize=${1#*=}
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

if [ ! "$txtinfile" ]; then
  echo "ERROR: option '--txtinfile[txtinfile]' not given. See --help" >&2
   exit 1
fi

echo "chunksize is" $chunksize

for file in *.txt
do
  split -b $chunksize $file "$file."
  echo "split " $file
done

