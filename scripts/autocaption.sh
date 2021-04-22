#!/bin/bash
#
# Developed by Fred Weinhaus 2/3/2010 .......... revised 2/3/2010
# 
# USAGE: autocaption -s size -t text [-b buffer] [-f font] [-c color] [-u undercolor] infile outfile
# USAGE: autocaption [-h or -help]
# 
# OPTIONS:
# 
# -s      size              size of square textbox; integer>0
# -t      text              text to apply to image; enclose in quotes
# -b      buffer            buffer or padding around text box; integer>=0; 
#                           default=0
# -f      font              font name or path to font file; default=Helvetica
# -c      color             text color; any valid IM color specification;
#                           default will be either black or white, whichever 
#                           contrasts best with the color of the region that 
#                           was found by the search
# -u      undercolor        undercolor for text; any valid IM color 
#                           specification; default=none for transparent so that 
#                           image coloration shows behind text
# 
###
# 
# NAME: AUTOCAPTION 
# 
# PURPOSE: To place text automatically in a specified square size region that  
# has the least color variation throughout the image.
# 
# DESCRIPTION: AUTOCAPTION places text automatically in a specified square size 
# region that has the least color variation throughout the image. By default 
# the text will be placed on the image with no undercolor. But an undercolor 
# can be used which will cover the underlying image.
# 
# 
# ARGUMENTS: 
# 
# -s size ... SIZE of square textbox. Also used to find the location in the 
# image that has the least color variation. The text will be placed in multiple 
# rows as determined by the textbox size.
#
# -t text ... TEXT to apply to image. Be sure to enclose in quotes.
# 
# -b buffer ... BUFFER is the amount of padding around the textbox. Values are 
# integers greater than zero. The default=0.
# 
# -f font ... FONT is the text font or path to the font file. The default is 
# Helvetica.
# 
# -c color ... COLOR is the text color. Any valid IM color specification is 
# allowed. The default will be either black or white, whichever contrasts best 
# with the color of the region that was found by the search.
# 
# -u undercolor ... UNDERCOLOR is the color to use under the text within the 
# textbox. Any valid IM color specification is allowed. The default=none, which 
# means that the text will be placed over the image without any undercolor. If 
# an undercolor is specified, then it will cover the underlying image.
# 
# CAVEAT: No guarantee that this script will work on all platforms, 
# nor that trapping of inconsistent parameters is complete and 
# foolproof. Use At Your Own Risk. 
# 
######
# 

# set default values
size=""					# size of square match window
pad=0					# match window pad
color=""				# text color; default black or white depending upon grayscale
ucolor="none"			# text under color; default transparent
font="Helvetica"		# font name or path to font
text=""

# set directory for temporary files
dir="."    # suggestions are dir="." or dir="/tmp"

# set up functions to report Usage and Usage with Description
PROGNAME=`type $0 | awk '{print $3}'`  # search for executable on path
PROGDIR=`dirname $PROGNAME`            # extract directory of program
PROGNAME=`basename $PROGNAME`          # base name of program
usage1() 
	{
	echo >&2 ""
	echo >&2 "$PROGNAME:" "$@"
	sed >&2 -n '/^###/q;  /^#/!q;  s/^#//;  s/^ //;  4,$p' "$PROGDIR/$PROGNAME"
	}
usage2() 
	{
	echo >&2 ""
	echo >&2 "$PROGNAME:" "$@"
	sed >&2 -n '/^######/q;  /^#/!q;  s/^#*//;  s/^ //;  4,$p' "$PROGDIR/$PROGNAME"
	}


# function to report error messages
errMsg()
	{
	echo ""
	echo $1
	echo ""
	usage1
	exit 1
	}


# function to test for minus at start of value of second part of option 1 or 2
checkMinus()
	{
	test=`echo "$1" | grep -c '^-.*$'`   # returns 1 if match; 0 otherwise
    [ $test -eq 1 ] && errMsg "$errorMsg"
	}

# test for correct number of arguments and get values
if [ $# -eq 0 ]
	then
	# help information
   echo ""
   usage2
   exit 0
elif [ $# -gt 14 ]
	then
	errMsg "--- TOO MANY ARGUMENTS WERE PROVIDED ---"
else
	while [ $# -gt 0 ]
		do
			# get parameter values
			case "$1" in
		  -h|-help)    # help information
					   echo ""
					   usage2
					   exit 0
					   ;;
				-s)    # get size
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID SIZE SPECIFICATION ---"
					   checkMinus "$1"
					   size=`expr "$1" : '\([0-9]*\)'`
					   [ "$size" = "" ] && errMsg "--- SIZE=$size MUST BE A POSITIVE INTEGER VALUE (with no sign) ---"
					   ;;
				-t)    # get  text
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   #errorMsg="--- INVALID FONT SPECIFICATION ---"
					   #checkMinus "$1"
					   text="$1"
					   ;;
				-b)    # get  buffer
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID BUFFER SPECIFICATION ---"
					   checkMinus "$1"
					   buffer=`expr "$1" : '\([0-9]*\)'`
					   [ "$buffer" = "" ] && errMsg "--- BUFFER=$buffer MUST BE A NON-NEGATIVE INTEGER VALUE (with no sign) ---"
					   ;;
				-f)    # get  font
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID FONT SPECIFICATION ---"
					   checkMinus "$1"
					   font="$1"
					   ;;
				-c)    # get color
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID COLOR SPECIFICATION ---"
					   checkMinus "$1"
					   color="$1"
					   ;;
				-u)    # get ucolor
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID UCOLOR SPECIFICATION ---"
					   checkMinus "$1"
					   ucolor="$1"
					   ;;
				 -)    # STDIN and end of arguments
					   break
					   ;;
				-*)    # any other - argument
					   errMsg "--- UNKNOWN OPTION ---"
					   ;;
		     	 *)    # end of arguments
					   break
					   ;;
			esac
			shift   # next option
	done
	#
	# get infile and outfile
	infile=$1
	outfile=$2
fi

# test that infile provided
[ "$infile" = "" ] && errMsg "NO INPUT FILE SPECIFIED"

# test that outfile provided
[ "$outfile" = "" ] && errMsg "NO OUTPUT FILE SPECIFIED"

# test if no test or no size specified
[ "$text" = "" ] && errMsg "--- SOME TEXT MUST BE SPECIFIED ---"
[ "$size" = "" ] && errMsg "--- TEXTBOX SIZE MUST BE SPECIFIED ---"

# setup temp files
tmpA1="$dir/autocaption_1_$$.mpc"
tmpB1="$dir/autocaption_1_$$.cache"
tmpA2="$dir/autocaption_2_$$.mpc"
tmpB2="$dir/autocaption_2_$$.cache"
tmpA3="$dir/autocaption_3_$$.mpc"
tmpB3="$dir/autocaption_3_$$.cache"

trap "rm -f $tmpA1 $tmpB1 $tmpA2 $tmpB2 $tmpA3 $tmpB3; exit 0" 0
trap "rm -f $tmpA1 $tmpB1 $tmpA2 $tmpB2 $tmpA3 $tmpB3; exit 1" 1 2 3 15


# read the input image and filter image into the temp files and test validity.
convert -quiet -regard-warnings "$infile" +repage "$tmpA1" ||
	errMsg "--- FILE $infile DOES NOT EXIST OR IS NOT AN ORDINARY FILE, NOT READABLE OR HAS ZERO SIZE  ---"


# get image width and height
width=`convert $tmpA1 -ping -format "%w" info:`
height=`convert $tmpA1 -ping -format "%h" info:`


# get padded size of window
sizep=`convert xc: -format "%[fx:$size+2*$pad]" info:`


# get -blur radius from padded size
rad=`convert xc: -format "%[fx:floor($sizep/2)]" info:`


# get crop offsets to correct for window center to upper left corner
xoff=$rad
yoff=$rad
wwc=`convert xc: -format "%[fx:$width-2*$xoff]" info:`
hhc=`convert xc: -format "%[fx:$height-2*$yoff]" info:`

# get std = sqrt( ave(x^2) - ave(x)^2 )
# second line get average of squared image
# third line get average
# fourth line get square of average
# fifth line delete temps
# sixth line get std
# seventh line get equal average of 3 channels std, then negate 
# so best result is largest (white)
convert $tmpA1 \
	\( -clone 0 -clone 0 -compose multiply -composite -virtual-pixel black -blur ${rad}x65000 \) \
	\( -clone 0 -virtual-pixel black -blur ${rad}x65000 \) \
	\( -clone 2 -clone 2 -compose multiply -composite \) \
	-delete 0,2 +swap \
	-compose minus -composite -gamma 2 \
	-colorspace OHTA -channel R -separate +channel -negate -depth 8 \
	-crop ${wwc}x${hhc}+${xoff}+${yoff} +repage $tmpA2

# find location of max
max=`convert $tmpA2 -format "%[fx:round(255*maxima)]" info:`
data=`compare -metric rmse $tmpA2 \
	\( -size 1x1 xc:"gray($max)" \) null: 2>&1 |\
	tr -cs ".0-9\n" " "`

# get window score and location
score=`echo "$data" | cut -d\  -f2`
xxm=`echo "$data" | cut -d\  -f3`
yym=`echo "$data" | cut -d\  -f4`

# get black or white text color
	if [ "$color" = "" ]; then
		if [ "$ucolor" = "none" ]; then
			gray=`convert $tmpA2[${sizep}x${sizep}+${xxm}+${yym}] \
				-filter box -resize 1x1\! \
				-colorspace gray -format "%[fx:round(100*s.r)]" info:`
		else
			gray=`convert -size 1x1 xc:"$bcolor" \
				-colorspace gray -format "%[fx:round(100*s.r)]" info:`
		fi
		if [ $gray -lt 50 ]; then
			color="white"
		else
			color="black"
		fi
	fi

# write text into window
convert -background "$ucolor" -fill "$color" \
	-font $font -gravity center \
	-size ${size}x${size} caption:"$text" \
	$tmpA3


# compute text area offset including pad correction
xxmp=`convert xc: -format "%[fx:$xxm+$pad]" info:`
yymp=`convert xc: -format "%[fx:$yym+$pad]" info:`

# write text onto image at match location corrected for pad
convert $tmpA1 $tmpA3 -geometry +${xxmp}+${yymp} \
-composite $outfile

exit 0




