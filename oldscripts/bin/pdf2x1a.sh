#!/bin/bash
# converts pdf in command line to pdfx1a

while :
do
	case $1 in
	--help | -\?)
	#
	exit 0  # This is not an error, the user requested help, so do not exit status 1.
	;;
	--filepath)
	filepath=$2
	shift 2
	;;
	--filepath=*)
	filepath=${1#*=}
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

echo "$filepath"

/home/fred/sfb/sfb-latest/trunk/scripts/lib/pstill_dist/pstill -M defaultall -m XimgAsCMYK -m Xspot -m Xoverprint -d 500 -m XPDFX=INTENTNAME -m XPDFXVERSION=1A -m XICCPROFILE=USWebCoatedSWOP.icc -o "$filepath".x1a "$filepath"
exit 0
