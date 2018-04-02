#!/bin/bash

# filters text file looking for acronyms

# input: text file as --txtinfile
# output: sorted uniq stdout
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

if [ "$verbose" = "y" ] ; then
	echo "text infile is "$txtinfile
else
	true
fi


# sed 's/[[:space:]]\+/\n/g' $txtinfile  | sort -u | egrep '[[:upper:]].*[[:upper:]]' | sed 's/[\(\),]//g' | uniq
sed 's/[[:space:]]\+/\n/g' $txtinfile  | sort -u | [A-Z][a-zA-Z0-9+\.\&]*[A-Z0-9] | sed 's/[\(\),]//g' | uniq
# more selective regex
