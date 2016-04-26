#!/bin/bash

# searches for permitted content in Wikipedia

# requires seed value

starttime=$(( `date +%s` ))

# parse the command-line very stupidly

echo "-NAUGHTY-NAUGHTY-DUPLICATE-DUPLICATE" | tee --append $xform_log
echo "starting to screen list of search terms for illegal ones"| tee --append $xform_log

while :
do
case $1 in
--help | -\?)
echo "requires PDF filename; example: montageur.sh filename"
exit 0  # This is not an error, the user requested help, so do not exit status 1.
;;
--infile)
infile=$2
shift 2
;;
--infile=*)
infile=${1#*=}
shift
;;
--outfile)
outfile=$2
shift 2
;;
--outfile=*)
outfile=${1#*=}
shift
;;
--environment)
environment=$2
shift 2
;;
--environment=*)
environment=${1#*=}
shift
;;
--passuuid)
passuuid=$2
shift 2
;;
--passuuid=*)
passuuid=${1#*=}
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

if [ ! "$infile" ]; then
  echo "ERROR: option '--in[infile]' not given. See --help" >&2
   exit 1
elif [ ! "$outfile" ] ; then
	echo "ERROR: option '--outfile[outfile]' not given. See --help" >&2
   	exit 1
fi

if [ ! "$passuuid" ] ; then
	echo "creating uuid"
	uuid=$(python  -c 'import uuid; print uuid.uuid1()')
	echo "uuid is" $uuid | tee --append $xform_log
	mkdir -p -m 755 tmp/$uuid
	mkdir -p -m 755 tmp/$uuid/montageur
else
	uuid=$passuuid
	echo "received uuid " $uuid
fi


. ../"conf/config.txt"
echo "running in $environment" | tee --append $xform_log

. $scriptpath"includes/set-variables"

echo "software id in" "$environment" "is" $SFB_VERSION | tee --append $sfb_log

cd $scriptpath
echo "scriptpath is" $scriptpath

export PATH=$PATH:/opt/bitnami/java/bin

# echo "PATH is" $PATH

echo "beginning to screen out naughty and duplicate seeds" >> $sfb_log

rm $outfile # clean up from last time overwrites previous outfile

while read -r line; do 

if grep -q "$line" "seeds/disallowed-seeds.txt"
then 
	echo "ncp_err_code:disallowed the seed "$line "was disallowed by policy" | tee --append $sfb_log
  # figure out how to send an error report to the user here
 

elif grep -q "$line" $LOCAL_DATA"seeds/history/seed-history.csv"
then 
	echo "ncp_err_code:duplicate the seed "$line " has previously been submitted to PageKicker"  | tee --append $sfb_log

  # figure out how to send an error report to the user here

else
	echo "ncp_err_code:ok" $line  | tee --append $LOCAL_DATA/seeds/"allowed/allowed-history.txt"
	echo "$line" >> "$outfile"
fi

done<"$infile" 

exit 0
