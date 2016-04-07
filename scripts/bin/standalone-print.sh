#!/bin/bash

. ../conf/config.txt

uuid=$(python  -c 'import uuid; print uuid.uuid1()')
echo "stand-alone uuid for this instance is" $uuid | tee --append $sfb_log

# echo "launched standalone print" | tee --append /opt/bitnami/apache2/htdocs/pk-new/development/scripts/success # debugging command

# command line parser

# process command line

#!/bin/sh
# (POSIX shell syntax)

# Reset all variables that might be set

# this is for case bound only - most of these values would need to be conditional to support other bindings

	print_horizontal_trim=1538 # 2438 8.125 inches for 8.5 inch books 
	print_vertical_trim=2550 # 3300 for 11 inch
	print_top_height=$((print_vertical_trim / 4 - 50))
	print_bottom_height=$((print_vertical_trim / 10))
	print_label_text_width=$((print_horizontal_trim - 225))
	bottom_label_top_edge=$((print_vertical_trim - print_bottom_height - print_bottom_height))
	outsidebleed=187
	insidebleed=204
	topbleed=217
	bottombleed=225
	textsafety=150
	covercolor=`shuf -n 1 ../conf/print-cover-colors.txt`
	coverfontcolor="White"
	coverfont=`shuf -n 1 ../conf/print-cover-fonts.txt`
	covertype="wordcloud"
	imprintname="PageKicker"
	imprintlogo="assets/purplebird300.png"

while :
do
    case $1 in
        -h | --help | -\?)
            	#  Call your Help() or usage() function here.
           	 exit 0      # This is not an error, User asked help. Don't do "exit 1"
            	;;
        -I | --ISBN)
           	 userprovidedprintISBN=$2     # You might want to check if you really got FILE
           	 shift 2
           	 ;;
        --ISBN=*)
           	 userprovidedprintISBN=${1#*=}        # Delete everything up till "="
            	shift
           	 ;;
	-t | --covertitle)
		covertitle=$2
		shift 2
		;;
	--covertitle=*)
		covertitle=${1#*=}
		shift
		;;
	-T | --shorttitle)
		shorttitle=$2
		shift 2
		;;
	--shorttitle=*)
		shorttitle=${1#*=}
		shift
		;;
	-e | --editedby)
		editedby=$2
		shift 2
		;;
	--editedby=*)
		editedby=${1#*=}
		shift
		;;
	-s | --spinepixels)
		spinepixels=$2
		shift 2
		;;
	--spinepixels=*)
		spinepixels=${1#*=}
		echo $spinepixels
		spinepixels=$(( echo $spinepixels ))
		echo $spinepixels
		shift
		;;
	-p | --pdfpath)
		pdfpath=$2
		shift 2
		;;
	--pdfpath=*)
		pdfpath=${1#*=}
		shift
		;;
	--c | --covercolor)
		covercolor=$2
		shift 2
		;;
	--covercolor=*)
		covercolor=${1#*=}
		shift
		;;
	-f | --coverfont)
		coverfont=$2
		shift 2
		;;
	--coverfont=*)
		coverfont=${1#*=}
		shift
		;;	
	-T | --covertype)
		covertype=$2
		shift 2
		;;
	--covertype=*)
		covertype=${1#*=}
		shift
		;;
	--userimage)
		userimage=$2
		shift 2
		;;
	--userimage=*)
		userimage=${1#*=}
		shift
		;;
	--usercaption)
		usercaption=$2
		shift 2
		;;
	--usercaption=*)
		usercaption=${1#*=}
		shift
		;;
	--imprintname)
		imprintname=$2
		shift 2
		;;
	--imprintname=*)
		imprintname=${1#*=}
		shift
		;;
	--spineinches)
		spineinches=$2
		shift 2
		;;
	--spineinches=*)
		spineinches=$(1#*=}
		shift
		;;
	--print_vertical_trim)
		print_vertical_trim=$2
		shift 2
		;;
	--print_vertical_trim=*)
		print_vertical_trim=${1#*=}
		shift
		;;
	--print_horizontal_trim)
		print_horizontal_trim=$2
		shift 2
		;;
	--print_horizontal_trim)
		print_horizontal_trim=${1#*=}
		shift
		;;
	--coverfontcolor)
		coverfontcolor=$2
		shift 2
		;;
	--coverfontcolor)
		coverfontcolor=${1#*=}
		shift
		;;
	--pdfx1a)
		pdfx1a=$2
		shift 2
		;;
	--pdfx1a)
		pdfx1a=${1#*=}
		shift
		;;
        --trimsize)
		trimsize=$2
		shift 2
		;;
	--trimsize)
		trimsize=${1#*=}
		shift
		;;
        --customer_email)
                customer_email=$2
                shift 2
                ;;
        --customer_email)
                customer_email=${1#*=}
                shift
                ;;
	--pass_uuid)
		pass_uuid=$2
		shift 2
		;;
	--pass_uuid)
		pass_uuid=${1#*&=}
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

sku="sku"
# Suppose some options are required. Check that we got them.

if [ ! "$userprovidedprintISBN" ]; then
    echo "ERROR: option '--ISBN [isbnvalue]' not given. See --help" >&2
    exit 1
fi



echo "imprint name" $imprintname

if [ "$covercolor" = "Random" ] ; then

        covercolor=`shuf -n 1 ../conf/print-cover-colors.txt`
        coverfontcolor="White"
        echo "Random cover color is " $covercolor

else

        echo "covercolor is unchanged as" $covercolor

fi

if [ "$coverfont" = "Random" ] ; then

        coverfont=`shuf -n 1 ../conf/print-cover-fonts.txt`
        echo "Random cover font is " $coverfont
else
        echo  "coverfont is unchanged as" $coverfont

fi

spinefloat=$(echo "300*$spineinches" |bc); echo "spine width in floating point pixels is" $spinefloat; spinepixels=${spinefloat/.*}; echo "spine width in integer pixels is " $spinepixels


echo "accepted userprovidedprintISBN from command line and it is " $userprovidedprintISBN
echo "accepted covertitle from command line and it is " $covertitle
echo "accepted shorttitle from command line and it is " $shorttitle
echo "accepted editedby from command line and it is " $editedby
echo "accepted spine pixels or spineinches from command line and result is " $spinepixels
echo "accepted path to pdf of interior and it is " $pdfpath
echo "accepted covertype and it is" $covertype
echo "accepted user image path and it is" $userimage
echo "accepted user caption and it is" $usercaption
echo "accepted trim size and it is" $trimsize
echo "accepted customer email and it is" $customer_email
echo "accepted uuid from command line and it is" $pass_uuid
uuid=$pass_uuid
echo "accordingly uuid for this instance is now" $uuid


# echo making directories as needed

if [ ! $(ls -A images/$uuid) ] ; then
	mkdir images/$uuid ; mkdir images/$uuid/print
else
	echo "uuid directories were already made by xform"
fi

# need to protect SQL from apostrophes in 

#$LOCAL_MYSQL_PATH --user $LOCAL_MYSQL_USER --password=$LOCAL_MYSQL_PASSWORD sfb-jobs << EOF
#insert into standalone_print_cover_builds (ISBN, covertitle, shorttitle, editedby, spinepixels, covercolor, coverfontcolor, coverfont, uuid) values('$userprovidedprintISBN', '$covertitle', '$shorttitle', '$editedby', '$spinepixels', '$covercolor', '$coverfontcolor', '$coverfont', '$uuid');
#EOF


# calculate dimensions

case $trimsize in

5.5x8.5)

        print_horizontal_trim=1538 # 2438 8.125 inches for 8.5 inch books 
	print_vertical_trim=2550 # 3300 for 11 inch
        ;;

8.5x11)
        print_horizontal_trim=2438 # 8.125 inches for 8.5 inch books 
	print_vertical_trim=3300 # for 11 inch
        bottom_label_top_edge=$((print_vertical_trim - print_bottom_height - 175))
        ;;
*)
        echo "invalid trimsize" 
        exit 0
;;
esac

	# calculate spine dimensions (we must know the spine before we can do the canvas!)

		echo "checking sku is " $sku "and path to pdf is " $pdfpath

		pdfpagecount=`pdftk  "$pdfpath" dump_data output | grep -i NumberOfPages | cut -d":" -f2 | sed '/^$/d'`

		echo "pdf page count is" $pdfpagecount

		# get rid of space and save $spinepixels as variable

		# BUT THIS ASSUMES THAT OCR LAYER IS EMBEDDED IN PDR

	# calculate size of canvas

		canvaswidth=$(( $print_horizontal_trim * 2 + $spinepixels + $outsidebleed + $insidebleed + $insidebleed + $outsidebleed + 49 ))
		canvasheight=$((  $topbleed + $print_vertical_trim + $bottombleed + 10 ))

		echo "calculated canvaswidth as "$canvaswidth
		echo "calculated canvasheight as "$canvasheight

	# calculate safe areas on front and back page

		safepagewidth=$(( $print_horizontal_trim - $textsafety - $textsafety ))
		safepageheight=$(( $print_vertical_trim - $textsafety ))

		echo "calculated safepagewidth as" $safepagewidth
		echo "calculated safepageheight as" $safepageheight

	# calculate word cloud size

		wordcloudwidth=$(( $print_horizontal_trim - 150))
		wordcloudheight=$(( $safepageheight- $print_bottom_height - $print_top_height ))
		echo "calculated wordcloudwidth" as $wordcloudwidth "and wordcloudheight" as $wordcloudheight

	# calculate spine

		if [ "$spinepixels" -lt 106 ] ; then
			spinesafety=19
			echo "because spine width is less than 106 pixels, spinesafety is " $spinesafety "and we are using the short title for the spine"
			
		else
			spinesafety=37
			echo "because spine width is greater than 105 pixels, spinesafety is " $spinesafety
		fi

	

		safespinetitlewidth=$(( $spinepixels - $spinesafety - $spinesafety ))

		echo "safespinetitlewidth is" $safespinetitlewidth

		safespinetitleheight=$(( $safepageheight * 2 ))

		echo "calculated safespinetitleheight as " $safespinetitleheight

		spineleftmargin=$(( $outsidebleed + $insidebleed + $print_horizontal_trim -18 + $spinesafety * 2))

		echo "calculated spineleftmargin as bleed + page width + spinepixels for " $spineleftmargin
		
	

	# front page calculations

		frontpageflushleftmargin=$(( $outsidebleed + $print_horizontal_trim + $insidebleed + $spinepixels + insidebleed - 8 ))

		echo "calculated frontpageflushleftmargin as" $frontpageflushleftmargin

		# there's always a cushion around top and bottom text 

		frontpagetopcushion=150

		frontpagebottomcushion=0

		echo "frontpagetopcushion is " $frontpagetopcushion
		echo "frontpagebottomcushion is " $frontpagebottomcushion

	# back page calculations

		ISBNylocation=$(( $safepageheight - 300 - 25 ))
		ISBNxlocation=$(( $outsidebleed + 125 ))

		echo "calculated ISBNxlocation as" $ISBNxlocation
		echo "calculated ISBNylocation as" $ISBNylocation

		backpagetopcushion=$frontpagetopcushion
		backpagebottomcushion=$frontpagebottomcushion

		echo "backpage top and bottom cushions are" $backpagetopcushion "and" $backpagebottomcushion

		backpageleftbleedbegins=$(($outsidebleed))
		backpagelefttextbegins=$(($backpageleftbleedbegins + $textsafety))
	
		echo "backpage left bleed and left text margin are" $backpageleftbleedbegins "and" $backpagelefttextbegins


	# start by building the full canvas

		convert -size "$canvaswidth"x"$canvasheight" xc:$covercolor \
		-units "PixelsPerInch" -density 300  -resample 300x \
		images/$uuid/print/fullcanvas.png


	# then create the front cover
		convert -size "$print_horizontal_trim"x"$print_vertical_trim" -density 300 -units pixelsperinch xc:$covercolor  images/$uuid/print/canvas.png
		convert -size "$print_horizontal_trim"x"$print_top_height" -density 300 -units pixelsperinch xc:$covercolor  images/$uuid/print/topcanvas.png
		convert -size "$print_horizontal_trim"x"$print_bottom_height" -density 300 -units pixelsperinch xc:$covercolor  images/$uuid/print/bottomcanvas.png
		convert -size "$print_horizontal_trim"x"$print_top_height" -density 300 -units pixelsperinch xc:$covercolor  images/$uuid/print/toplabel.png
		convert -size "$print_horizontal_trim"x"$print_bottom_height" -density 300 -units pixelsperinch xc:$covercolor  images/$uuid/print/bottomlabel.png


	case $covertype in


	wordcloud)

		pdftotext "$pdfpath" images/$uuid/print/wordcloud.txt

		$JAVA_BIN -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -w $wordcloudwidth -h $wordcloudheight < images/$uuid/print/wordcloud.txt > images/$uuid/print/"printcloud.png" 2> /dev/null

		# building WordCloud "PK Peek" 

		peekthroughwidth=$(( wordcloudwidth / 3 + 25))

		convert -size "$peekthroughwidth"x100 -density 300 -border 1 -bordercolor "white" -units pixelsperinch -background  $covercolor -fill "$coverfontcolor" \
		-font "$coverfont" -gravity center -pointsize 11 caption:"Peekthrough by PageKicker" images/$uuid/print/peekthrough.png 
		convert images/$uuid/print/peekthrough.png images/$uuid/print/"printcloud.png"  -append images/$uuid/print/"peekprintcloud.png"

		# overlay the Word Cloud cover 

		composite -gravity Center  images/$uuid/print/"peekprintcloud.png" images/$uuid/print/canvas.png images/$uuid/print/canvastest.png

	;;

	imagefrontcenter) 
		
		convert "$userimage" -resize "$wordcloudwidth"x"$wordcloudheight" images/$uuid/print/resizedimage.tif
		convert -background "$covercolor" -fill "$coverfontcolor" -size "$wordcloudwidth"x200 -pointsize "14" caption:"$usercaption"  -gravity "north" images/$uuid/print/usercaption.png
		convert images/$uuid/print/resizedimage.tif images/$uuid/print/usercaption.png  -append images/$uuid/print/resizedimagewithcaption.tif
		composite -gravity Center images/$uuid/print/resizedimagewithcaption.tif images/$uuid/print/canvas.png images/$uuid/print/canvastest.png

	;;

	*)

	esac

	# build the labels for the front cover

	echo "covertitle is" $covertitle

	convert -background "$covercolor" -fill "$coverfontcolor" -gravity center -size "$print_label_text_width"x"$print_top_height" \
			-font "$coverfont" caption:"$covertitle" \
			-density 300 -units pixelsperinch\
				 images/$uuid/print/topcanvas.png +swap -gravity center -composite images/$uuid/print/toplabel.png

	echo "print_label_text_width is" $print_label_text_width "and height is" $print_top_height

	convert  -background $covercolor  -fill "$coverfontcolor" -gravity center -border 20x20 -bordercolor "$covercolor" -size "$print_label_text_width"x"$print_bottom_height" \
		 -font "$coverfont"  caption:"$editedby" \
		-density 300 -units pixelsperinch\
		 images/$uuid/print/bottomcanvas.png  +swap -gravity center -composite images/$uuid/print/bottomlabel.png

	# lay the labels on top of the front cover
		composite -geometry +0+150 images/$uuid/print/toplabel.png images/$uuid/print/canvastest.png images/$uuid/print/step1.png
		bottom_label_top_edge=$((bottom_label_top_edge - 150))
		composite  -geometry +0+$bottom_label_top_edge images/$uuid/print/bottomlabel.png images/$uuid/print/step1.png images/$uuid/print/step2.png

		case "$imprintname" in
		PageKicker)
		composite  -gravity south -geometry +0+0 assets/PageKicker_cmyk300dpi_300.png images/$uuid/print/step2.png images/$uuid/print/cover.png
		;;
		*)
		convert -background "$covercolor" -fill "$coverfontcolor" -size "$wordcloudwidth"x"300" -font "$coverfont" caption:"$imprintname" images/$uuid/print/imprintname.png
		composite -gravity south -geometry +0+0 images/$uuid/print/imprintname.png images/$uuid/print/step2.png images/$uuid/print/cover.png
		;;
		esac

	# make a working copy of the front cover

		cp images/$uuid/print/cover.png images/$uuid/print/$sku"printfrontcover.png"

	#  make PDF and EPS copies of the front cover
		convert images/$uuid/print/$sku"printfrontcover.png" -density 300 images/$uuid/print/$sku"printfrontcover.pdf"
		convert -density 300 images/$uuid/print/$sku"printfrontcover.pdf" images/$uuid/print/$sku"printfrontcover.eps"

	# build the ISBN
	
	python $scriptpath"lib/bookland-1.4/bookland-1.4.1b" -o images/$uuid/print/$userprovidedprintISBN.eps -f OCRB -b 1 -n -q --cmyk 0,0,0,1.0 "$userprovidedprintISBN" 90000

        # need to get rid of following sudo - it is ghostscript/imagemagick problem

	sudo convert -units "PixelsPerInch" -density 1200 -resize 25% -colorspace CMYK images/$uuid/print/$userprovidedprintISBN.eps -colorspace CMYK images/$uuid/print/$userprovidedprintISBN.png
	convert images/$uuid/print/$userprovidedprintISBN.png -colorspace CMYK -background white -flatten images/$uuid/print/$userprovidedprintISBN"box.png"

	# build the spine caption

	echo "building spine caption"

	convert -size "$safespinetitleheight"x"$safespinetitlewidth" -density 300 -units pixelsperinch -background $covercolor -pointsize "11" -fill "$coverfontcolor" -font "$coverfont"  \
	-rotate 90 -gravity west caption:"$shorttitle" images/$uuid/print/spinecaption.png

	# build the spine logotype

	logotypeheight=$(( safespinetitleheight / 6))
	echo "calculated logotypeheight as" $logotypeheight

	convert -size "$logotypeheight"x"$safespinetitlewidth" -density 300 -units pixelsperinch -background "$covercolor" -fill "$coverfontcolor" \
	-font "$coverfont" -rotate 90 -gravity East -pointsize "11" caption:"$imprintname" images/$uuid/print/spinelogotype.png


# lay the objects on the canvas
 

	# lay the front cover on the full canvas

		convert images/$uuid/print/fullcanvas.png \
		images/$uuid/print/$sku"printfrontcover.png" -geometry +$frontpageflushleftmargin+$topbleed -composite  \
		images/$uuid/print/fullcanvas2.png

# assemble and lay down the spine caption and logotype, unless it is too thin

	if [ "$pdfpagecount" -lt 48 ]; then

		echo "page count too low for spine"
		cp images/$uuid/print/fullcanvas2.png  images/$uuid/print/finalcanvas.png
                cp images/$uuid/print/fullcanvas2.png  images/$uuid/print/fullcanvas4.png

	else

		# lay the spine caption on the full canvas

		convert images/$uuid/print/fullcanvas2.png \
		images/$uuid/print/spinecaption.png -geometry +$spineleftmargin+375 -composite  \
		images/$uuid/print/fullcanvas3.png


		# resize the purple bird 
		purplebirdsize=75
		convert "$imprintlogo" -resize $purplebirdsizex$purplebirdsize\> images/$uuid/print/purple$safespinetitlewidth.png

		# surround the bird with a white box

		convert -units "PixelsPerInch" -density 300 -resample 300x -border 5x5 -bordercolor white images/$uuid/print/purple$safespinetitlewidth.png -colorspace CMYK images/$uuid/print/purplebirdwithbox.png

		# create spacer box

		convert -size "$safespinetitlewidth"x20 xc:none images/$uuid/print/spacer.png

		# append spine logotype, spacer, and purplebird box

		convert images/$uuid/print/spinelogotype.png images/$uuid/print/spacer.png -background none -gravity west -append images/$uuid/print/logowithspacer.png

			if [[ "$spinepixels" -gt 144 ]] ; then 

			convert images/$uuid/print/logowithspacer.png images/$uuid/print/purplebirdwithbox.png -background none -gravity center -append images/$uuid/print/logobar.png

			else 

			cp images/$uuid/print/logowithspacer.png images/$uuid/print/logobar.png

			fi

		# lay the spine logotype on the full canvas

		step1=$(( $safepageheight))
		echo "step1 is " $step1
		step2=$(( $step1 - 900 ))
		echo "step2 is "$step2
		spinelogotypebegin=$(( $step2  ))
		echo "calculated spinelogotype begin as " $spinelogotypebegin

		spinelogotypeleftmargin=$(( $spineleftmargin + 2 ))

		echo "about to lay down the missing logobar at " $spineleftmargin "," $spinelogotypebegin

		convert images/$uuid/print/fullcanvas3.png \
		images/$uuid/print/logobar.png -geometry +$spineleftmargin+$spinelogotypebegin -composite  \
		images/$uuid/print/fullcanvas4.png

		echo "finished laying the spine on the canvas"

        fi

		echo "determining what to lay on back cover"

	echo "covertype is "$covertype
		case "$covertype" in
		imagefrontcenter)

			

			pdf2txt "$pdfpath" > images/$uuid/print/wordcloud.txt

			$JAVA_BIN -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -w $wordcloudwidth -h $wordcloudheight < images/$uuid/print/wordcloud.txt > images/$uuid/print/"printcloud.png" 2> /dev/null

			# building WordCloud "PK Peek" 

			peekthroughwidth=$(( wordcloudwidth / 3 + 25))

			convert -size "$peekthroughwidth"x100 -density 300 -border 1 -bordercolor "white" -units pixelsperinch -background  $covercolor -fill "$coverfontcolor" \
			-font "$coverfont" -gravity center -pointsize 11 caption:"Peekthrough by PageKicker" images/$uuid/print/peekthrough.png 
			convert images/$uuid/print/"printcloud.png" images/$uuid/print/peekthrough.png -composite images/$uuid/print/"peekprintcloud.png"
		
			# overlay the Word Cloud on the back cover

			wordcloudylocation=$(($ISBNylocation - $wordcloudheight))
			echo "calculated wordcloudylocation as" $wordcloudylocation

			composite -geometry +$ISBNxlocation+$wordcloudylocation  images/$uuid/print/"peekprintcloud.png" images/$uuid/print/fullcanvas4.png images/$uuid/print/fullcanvas4.png

			echo "built word cloud and put it on back cover"
			;;
		wordcloud)
		
			#since wordcloud is on front caption is on back

			backcoverlocation=$(($ISBNylocation -300 ))
			echo "calculated backcoverylocaion as" $backcoverylocation
			convert -size  1200x1200 -density 300 -border 1 -bordercolor "$covercolor" -units pixelsperinch -background $covercolor -fill $coverfontcolor -font $coverfont -gravity center -pointsize 11 caption:@images/$uuid/print/backcover.txt images/$uuid/print/backcovertext.png

			composite -geometry +$ISBNxlocation+$backcoverylocation   images/$uuid/print/"backcovertext.png"  images/$uuid/print/fullcanvas4.png images/$uuid/print/fullcanvas5.png

			echo "built caption text and put it on back cover"
			;;

		*)
			echo "did not recognize cover type"
			;;
		esac

	
		# lay the ISBN box at the bottom left corner of the full canvas

		convert images/$uuid/print/fullcanvas4.png images/$uuid/print/fullcanvas4.tif

		sudo convert images/$uuid/print/fullcanvas4.tif  images/$uuid/print/$userprovidedprintISBN"box.png" -geometry +$ISBNxlocation+$ISBNylocation -composite  -colorspace "CMYK" images/$uuid/print/fullcanvas5.tif

		
		
		echo "laid the ISBN box down"

		cp images/$uuid/print/fullcanvas5.tif images/$uuid/print/finalcanvas.tif


	# lay the back text on the canvas
	
        # save the cover and prepare it for production

	# save as single large file (png)

	# convert RGB to CMYK

	sudo convert images/$uuid/print/finalcanvas.tif -colorspace CMYK images/$uuid/print/"$userprovidedprintISBN".pdf
	sudo convert images/$uuid/print/finalcanvas.tif -colorspace CMYK images/$uuid/print/"$userprovidedprintISBN"final.eps


# save the cover and prepare it for production

	# save as single large file (png)

	# convert RGB to CMYK


	echo "built print cover as file images/$uuid/print/$sku.cmyk.pdf" | tee --append $sfb_log

# building interior now that front cover has been built (some extra logic here ... need to tighten)

#xvfb-run --auto-servernum ebook-convert tmp/$uuid/cumulative.html $mediatargetpath$uuid/$sku".pdf" --cover "images/"$uuid"/print/"$sku"printfrontcover.png" --margin-left "54" --margin-right "54" --margin-top "54" --margin-bottom "54" --pdf-default-font-size "11" --pdf-page-numbers --insert-metadata --pdf-serif-family "AvantGarde" --title "$covertitle"

if [ "$pdfx1a" = "None" ] ; then 

echo "not saving interior as PDFx1a"

elif [ "$pdfx1a"  =  "PDFX1a color" ] ; then

echo "saving interior as PDFX1a color"

./lib/pstill_dist/pstill -M defaultall -m XimgAsCMYK -m Xspot -m Xoverprint -d 500 -m XPDFX=INTENTNAME -m XPDFXVERSION=1A -m XICCPROFILE=USWebCoatedSWOP.icc -o images/$uuid/print/interior.pdf $pdfpath

elif [ "$pdfx1a" = "PDFX1a black and white" ] ; then 

echo "saving interior as PDFx1a black and white"

./lib/pstill_dist/pstill -B -M defaultall -m XimgAsCMYK -m Xspot -m Xoverprint -d 500 -m XPDFX=INTENTNAME -m XPDFXVERSION=1A -m XICCPROFILE=USWebCoatedSWOP.icc -o images/$uuid/print/interior.pdf $pdfpath

else

echo "I'm confused about requested PDFx1a action"

fi

# now mailing results

if [ "$pdfx1a" = "None" ] ; then 

echo "sending cover only"

sendemail -t "$customer_email" \
	-u "Cover Builder Results" \
	-m "Cover attached" \
	-f "$GMAIL_ID" \
	-cc "$GMAIL_ID" \
	-xu "$GMAIL_ID" \
	-xp "$GMAIL_PASSWORD" \
        -a images/$uuid/print/$userprovidedprintISBN.pdf \
	-s smtp.gmail.com:587 \
	-o tls=yes 

elif [ "$pdfx1a"  =  "PDFX1a color" ] ; then

echo "sending cover and interior"

sendemail -t "$customer_email" \
	-u "Cover Builder Results" \
	-m "Cover attached" \
	-f "$GMAIL_ID" \
	-cc "$GMAIL_ID" \
	-xu "$GMAIL_ID" \
	-xp "$GMAIL_PASSWORD" \
        -a images/$uuid/print/$userprovidedprintISBN.pdf \
	-a images/$uuid/print/interior.pdf \
	-s smtp.gmail.com:587 \
	-o tls=yes 

elif [ "$pdfx1a" = "PDFX1a black and white" ] ; then 

echo "saving interior as PDFx1a black and white"

sendemail -t "$customer_email" \
	-u "Cover Builder Results" \
	-m "Cover attached" \
	-f "$GMAIL_ID" \
	-cc "$GMAIL_ID" \
	-xu "$GMAIL_ID" \
	-xp "$GMAIL_PASSWORD" \
        -a images/$uuid/print/$userprovidedprintISBN.pdf \
        -a images/$uuid/print/interior.pdf \
	-s smtp.gmail.com:587 \
	-o tls=yes 
else

	echo "didn't  mail anything"
fi

echo -n "t update " > images/$uuid/tcommand
echo -n  \" >> images/$uuid/tcommand
echo -n Automagically built a one-click cover for $customername >> images/$uuid/tcommand
echo -n \" >> images/$uuid/tcommand
. images/$uuid/tcommand

fb_announcement="yes"

if [ "$fb_announcement" = "yes" ] ; then

        fbcmd PPOST 472605809446163 "Automagically built a one-click cover for $customername"

else
        echo "no fb notification"
fi


