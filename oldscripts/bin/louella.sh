#!/bin/bash

# manages publicity for a book or robot

starttime=$(( `date +%s` ))

# parse the command-line very stupidly


. includes/set-variables

if [ "$environment" = "Production" ] ; then

        . /opt/bitnami/apache2/htdocs/pk-production/production/conf/config.txt
        echo "running prod config" > ~/which_xform

else

        . /opt/bitnami/apache2/htdocs/pk-new/development/conf/config.txt
        echo "running dev config"  > ~/which_xform

fi

echo "software id in" "$environment" "is" $SFB_VERSION

cd $scriptpath
echo "scriptpath is" $scriptpath

export PATH=$PATH:/opt/bitnami/java/bin

echo "PATH is" $PATH
# default values

fb_on="no"

# command line processing 


while :
do
case $1 in
--help | -\?)
echo "requires user to provide path to directory containing one or more txt files"
exit 0  # This is not an error, the user requested help, so do not exit status 1.
;;
--shorttitle)
shorttitle=$2
shift 2
;;
--shorttitle=*)
shorttitle=${1#*=}
shift
;;
--shortname)
shortname=$2
shift 2
;;
--shortname=*)
shortname=${1#*=}
shift
;;
--shorturl)
shorturl=$2
shift 2
;;
--shorturl=*)
shorturl=${1#*=}
shift
;;
--interval)
interval=$2
shift 2
;;
--interval=*)
interval=${1#*=}
shift 
;;
--shortmsg)
shortmsg=$2
shift 2
;;
--shortmsg=*)
shortmsg=${1#*=}
shift
;;
--shortmsg_after)
shortmsg_after=$2
shift 2
;;
--shortmsg_after=*)
shortmsg_after=${1#*=}
shift
;;
--longmsg)
longmsg=$2
shift 2
;;
--longmsg=*)
longmsg=${1#*=}
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
--fb_on)
fb_on=$2
shift 2
;;
--fb_on=*)
fb_on=${1#*=}
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

#if [ ! "$shorturl" ]; then
#  echo "ERROR: option '--shorturl' not given. See --help" >&2
#   exit 1
#fi

if [ ! "$passuuid" ] ; then
	echo "creating uuid"
	uuid=$(python  -c 'import uuid; print uuid.uuid1()')
	echo "uuid is" $uuid | tee --append $xform_log
	mkdir -p -m 755 tmp/$uuid
else
	uuid=$passuuid
	echo "received uuid " $uuid
fi

# file processing begins

# while csv file



t update "$shortmsg $shortname $shorttitle $shorturl $robot_credit $shortmsg_after $longmsg"

if [ "$fb_on" = "yes" ] ; then

	fbcmd status "$longmsg $shortmsg $shortname $shorttitle $shorturl $robot_credit $shortmsg_after"

else
	echo "no fb post"

fi

# mailchimp?


# done<../conf/publicity_bots/watch_files/watch_titles.csv
exit
0



