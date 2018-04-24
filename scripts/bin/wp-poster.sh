#!/bin/bash

# shares text or markdown file to wordpress

# input: text file as --txtinfile
# output: wordpress draft
# flags: --verbose "y" (stupidly requires y)


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
--title)
title=$2
shift 2
;;
--title=*)
title=${1#*=}
shift
;;
--WP_INSTALL)
WP_INSTALL=$2
shift 2
;;
--WP_INSTALL=*)
WP_INSTALL=${1#*=}
shift
;;
--WP_BIN)
WP_BIN=$2
shift 2
;;
--WP_BIN=*)
WP_BIN=${1#*=}
shift
;;
--verbose|v)
verbose=$2
shift 2
;;
--verbose|v=*)
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

if [ ! "$txtinfile" ]; then
  echo "ERROR: option '--txtinfile[txtinfile]' not given. See --help" >&2
   exit 1
fi
if [ ! "$title ]; then
  echo "ERROR: option '--title[title]' not given. See --help" >&2
   exit 1
fi

if [ "$verbose" = "y" ] ; then
	echo "text infile is "$txtinfile
else
	true
fi

"$WP_BIN" post "$WP_INSTALL" create "$txtinfile" --post_type=post --post_status=draft --post_title='title'
