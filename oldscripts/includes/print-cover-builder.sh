#!/bin/bash

# run from $SFB_HOME"scripts"

. ./flags.sh

. ../conf/config.txt

# . bin/float_fx.sh

echo "printconfigfile is "$printconfigfile

if [ $printconfigfile = "yes" ] ; then

	 . ../conf/printconfig.txt

	echo "using print configuration from file" | tee --append $sfb_log

	uuid=$(python  -c 'import uuid; print uuid.uuid1()')
	echo "new uuid for this instance is" $uuid | tee --append $sfb_log


	mkdir images/$uuid
	echo "created directory images/"$uuid

else

	echo "using print configuration passed along from parent process" | tee --append $sfb_log
	echo "uuid passed along from parent is" $uuid | tee --append $sfb_log

fi



# print cover builder

echo "starting print cover builder" | tee --append $sfb_log

# cleanup previous images

# rm -rf images/
# echo "removed previous images" | tee --append $sfb_log


cd images/$uuid ; mkdir print ; echo "created directory images/$uuid/print" ; cd $scriptpath ; echo "changed directory back to " $scriptpath | tee --append $sfb_log

# print cover builder is inserted into cases in cover-build.sh depending on values received from xform

# now echoing values of variables that will be needed to build the print cover


echo "booktype was " $booktype | tee --append $xform_log
echo "simpleseed was " $simpleseed | tee --append $xform_log
echo "coverfont was" $coverfont | tee --append $xform_log
echo "covercolor was" $coverfont | tee --append $xform_log
echo "covercolorfont was" $covercolorfont | tee --append $xform_log
echo "coverRGB was" $coverRGB | tee --append $xform_log
echo "userdescription was " $userdescription > $scriptpath"bin/xform-includes/userdescription.txt" | tee --append $xform_log
echo "imagebase was " $imagefilename| tee --append $xform_log
echo "printcreate was " $printcreate| tee --append $xform_log
echo "pagecount was " $pagecount | tee --append $xform_log
echo "trimsize was" "$trimsize" | tee --append $xform_log
echo "spinewidth was" "$spinewidth" | tee --append $xform_log
echo "printbookprice was" $printbookprice | tee --append $xform_log
echo "aliastobackendcopy was" $aliastobackendcopy | tee --append $xform_log
echo "copyinbackend was" $copyinbackend | tee --append $xform_log
echo "userprovidedprintISBN was "$userprovidedprintISBN | tee --append $xform_log

# convert spine width to pixels
asterisk="*"
dpi="300"

spinepixelsfloat=`python -c "from math import ceil ;print ceil($spinewidth*300)"`
echo "spinepixelsfloat is " $spinepixelsfloat
for rounded in $(printf %.0f $spinepixelsfloat); do spinepixels=$rounded ; done
# convert trim size to pixel height and width of full canvas

case $trimsize in

	5x8pb)
		pagewidth=1500
		pageheight=2400 

	;;

	55x85pb)
		pagewidth=1650
		pageheight=2550

	;;
	6x9pb)
		pagewidth=1800
		pageheight=2700
	;;
	6x9laminate)
		pagewidth=1800
		pageheight=2700
	;;
	6x9case)
		pagewidth=1800
		pageheight=2700
	;;
	8x10pb)
		pagewidth=2400
		pageheight=3000
	;;
	8x10laminate)
		pagewidth=2400
		pageheight=3000
	;;
	8.5x11pb)
		pagewidth=2550
		pageheight=3300
	;;
	8.5x11laminate)
		pagewidth=2550
		pageheight=3300
	;;

	*)
	canvaswidth="n/a"
	height="n/a"
		echo "no trim size was available, exiting" | tee --append $sfb_log
	exit
	;;

esac

echo "assigned pagewidth as " $pagewidth "and height as" $height "pixels" 

# canvas calculations
	bleed=38

	canvaswidth=$(( $pagewidth * 2 + $spinepixels + $bleed + $bleed ))
	canvasheight=$((  $bleed + $pageheight + $bleed ))

	echo "calculated canvaswidth as "$canvaswidth
	echo "calculated canvasheight as "$canvasheight

	#calculate text safety areas

	textsafety=150

	safepagewidth=$(( $pagewidth - $textsafety - $textsafety ))
	safepageheight=$(( $pageheight - $textsafety ))

	echo "calculated safepagewidth as" $safepagewidth
	echo "calculated safepageheight as" $safepageheight

# spine calculations

	if [ $spinepixels -lt 105 ] ; then
		spinesafety=12
	else
		spinesafety=22
	fi

	echo "because spine width is less than 105 pixels, spinesafety is " $spinesafety

	safespinetitlewidth=$(( $spinepixels - $spinesafety - $spinesafety ))

	echo "safespinetitlewidth is" $safespinetitlewidth

	safespinetitleheight=$(( $safepageheight / 2 ))

	echo "calculated safespinetitleheight as " $safespinetitleheight

	spineleftmargin=$(( $bleed + $pagewidth + $spinesafety ))

	echo "calculated spineleftmargin as bleed + page width +spinepixels for " $spineleftmargin

# front page calculations

	frontpageflushleftmargin=$(( $bleed + $pagewidth + $spinepixels + $textsafety ))

	echo "calculated frontpageflushleftmargin as" $frontpageflushleftmargin\

	# there's always a cushion around top and bottom text t

	frontpagetopcushion=150

	frontpagebottomcushion=0

	echo "frontpagetopcushion is " $frontpagetopcushion
	echo "frontpagebottomcushion is " $frontpagebottomcushion


# back page calculations

	ISBNylocation=$(( $safepageheight - 372 - 25 ))
	ISBNxlocation=$(( 150 + 25 ))


# build objects that are always the same

	# build the bottom canvas

	x="x"

	convert -size $canvaswidth$x$canvasheight xc:$newcovercolor \
	-units "PixelsPerInch" -density 300 -resample 300x \
	images/$uuid/print/bottomcanvas.png

#	# build the front page canvas

#	convert -size $pagewidth$x$height xc:$newcovercolor images/$uuid/print/frontpagecanvas.png

#	# build the back page canvas

#	convert -size $pagewidth$x$height  xc:$newcovercolor  images/$uuid/print/backpagecanvas.png

	# build the ISBN

	python $scriptpath/lib/bookland-1.4/bookland -o images/$uuid/print/$sku.eps -f OCRB -b 1 -q --rgb 0,0,0 --cmyk 0,0,0,1.0 "$userprovidedprintISBN" 90000

	convert -units "PixelsPerInch" -density 300 -resample 300x -border 25x25 -bordercolor white images/$uuid/print/$sku.eps -colorspace CMYK images/$uuid/print/ISBN$sku.png

# now decide which cover to use

case $coverlayout in


2) 

# build objects that are always the same except sometimes they are translucent

	echo "using cover layout id=2, front window, simple image in center of front cover, text on back"


		# build the spine caption

		convert -size $safespinetitleheight$x$safespinetitlewidth -background $newcovercolor -fill "$coverfontcolor" -font $coverfont -rotate 90 -gravity West caption:"$escapeseed" images/$uuid/print/spinecaption.png

		# build the spine Nimble Books LLC caption

		convert -size $safespinetitleheight$x$safespinetitlewidth -background $newcovercolor -fill "$coverfontcolor" -font $coverfont -rotate 90 -gravity West caption:"Nimble Books LLC" images/$uuid/print/spinenimblecaption.png

	# use the golden ratio to define the vertical size of the page elements: title/subtitle block = 0.31 (1/2 golden ratio), image = 0.382 , byline/logotype = 0.31

		# top section = safepageheight * .31

		topsectionpixelsfloat=`python -c "from math import ceil ;print ceil($safepageheight*0.31)"`
		for rounded in $(printf %.0f $topsectionpixelsfloat); do topsectionpixels=$rounded ; done
		echo "topsectionpixels is " $topsectionpixels


		titleheight_step1=$(( $topsectionpixels - $frontpagetopcushion ))
		titleheight=$(( $titleheight_step1 / 2 ))
		subtitleheight_step1=$(( $topsectionpixels - $frontpagetopcushion ))
		subtitleheight=$(( $subtitleheight_step1 / 2 ))

#		if [ $subtitle = "none" ] ; then
#			titleheight=$(( $titleheight * 2 ))
#			subtitleheight=0
#			echo "no subtitle, so big title"
#		else
#			echo "creating both title and subtitle blocks"
#		fi

		echo "title block is " $titleheight "pixels high"
		echo "subtitle block is " $subtitleheight "pixels high"

		imageheightfloat=`python -c "print($safepageheight*0.382)"`
		for rounded in $(printf %.0f $imageheightfloat); do imageheight=$rounded ; done
		echo "imageheight is calculated as" $imageheight

		# adjust imageheight to provide a 20-px buffer around the image so that it does not bump into the title or byline boxes
		imagebuffer=20

		imageheight=$(( $imageheight - $imagebuffer -$imagebuffer ))

		bottomsectionpixelsfloat=`python -c "from math import ceil ;print ceil($safepageheight*0.31)"`
				for rounded in $(printf %.0f $bottomsectionpixelsfloat); do bottomsectionpixels=$rounded ; done
		echo "bottomsectionpixels is " $bottomsectionpixels

		bylinevertical_step1=$(( $bottomsectionpixels - $frontpagebottomcushion ))
		bylinevertical=$(( $bylinevertical_step1 / 2 ))
		logotypevertical_step1=$(( $bottomsectionpixels - $frontpagebottomcushion ))
		logotypevertical=$(( $logotypevertical_step1 / 4 ))

		echo "bylinevertical is " $bylinevertical
		echo "logotypevertical is " $logotypevertical


		bylinetopheight=$(( $safepageheight - $bylinevertical ))
		logotypetopheight=$(( $safepageheight - $logotypevertical ))

		echo "calculated bylinetopheight as " $bylinetopheight
		echo "calculated logotypetopheight as " $logotypetopheight

		# build the title caption



		convert  -background $newcovercolor -fill "$coverfontcolor" -gravity center -font $coverfont -size $safepagewidth$x$titleheight caption:"$escapeseed"  images/$uuid/print/titlecaption.png

		# build the subtitle caption


		convert  -background $newcovercolor -fill "$coverfontcolor" -gravity center -font $coverfont -size $safepagewidth$x$subtitleheight caption:"$subtitle"  images/$uuid/print/subtitlecaption.png

		# build the byline caption

		bylineheight=$(( $safepageheight / 10 ))

		convert  -background $newcovercolor -fill "$coverfontcolor" -gravity center -font $coverfont -size $safepagewidth$x$bylineheight caption:"$author" images/$uuid/print/bylinecaption.png

		# build the Nimble Books logotype caption

		# calculate the space available for logotype

		safelogotype=$(( $safepagewidth ))
		logotypeheight=$(( $safepageheight / 20 ))

		echo "calculated safe area for logotype as " $safelogotype

		convert -size $safelogotype$x$logotypeheight -background $newcovercolor -fill "$coverfontcolor" -gravity center -font $coverfont caption:"Nimble Books LLC" images/$uuid/print/logotypecaption.png

# import the image and get it into right format and size

		echo "imagefilename is " $imagefilename

		# how big is the initial image and how many dpi

		initialheight=`identify -format "%h" images/$imagefilename`
		initialwidth=`identify -format "%w" images/$imagefilename`
		initialxdensity=`identify -format "%x" images/$imagefilename`
		initialydensity=`identify -format "%y" images/$imagefilename`
		echo "initialheight and initialwidth were "$initialheight "and " $initialwidth
		echo "initialxdensity and initialydensity were "$initialxdensity "and " $initialydensity
		initialxdensity_num=`echo $initialxdensity | sed 's/\([0-9]*\).*/\1/'
`
		initialydensity_num=`echo $initialydensity | sed 's/\([0-9]*\).*/\1/'
`
		if [ "$initialxdensity_num" -lt "72" ] ; then
			echo "xdensity is less than 72; image must be 72 dpi; exiting ..."
			exit 1
		else
			echo "x dpi ok"
		fi
		
		if [ $initialydensity_num -lt 72 ] ; then
			echo  "ydensity is less than 72; image must be 72 dpi; exiting ..."
			exit 1
		else
			echo "y dpi ok"
		fi

		convert images/$imagefilename -resize $imageheight$x$pagewidth\> images/$uuid/print/$sku"frontimage".png

		resizedwidth=`identify -format "%w" images/$uuid/print/$sku"frontimage".png`
		resizedheight=`identify -format "%h" images/$uuid/print/$sku"frontimage".png`
		echo "resized image width is " $resizedwidth
		echo "resized image height is " $resizedheight

	# begin laying down the objects on the front page

	# lay the spine on top of the canvas

		convert images/$uuid/print/bottomcanvas.png \
		images/$uuid/print/spinecaption.png -geometry +$spineleftmargin+150 -composite  \
		images/$uuid/print/$sku.png

	## lay the ISBN box at the bottom left corner of the back page

	
		convert images/$uuid/print/$sku.png \
		images/$uuid/print/ISBN$sku.png -geometry +$ISBNxlocation+$ISBNylocation -composite \
		images/$uuid/print/$sku.png

	## lay the title on top of the front page

		frontpagetitletop=$(( $bleed + $frontpagetopcushion ))
		convert images/$uuid/print/$sku.png \
		images/$uuid/print/titlecaption.png -geometry +$frontpageflushleftmargin+$frontpagetitletop -composite \
		images/$uuid/print/$sku.png

	## lay the subtitle on top of the front page

		frontpagesubtitletop=$(( $bleed + $frontpagetopcushion + $titleheight ))
		convert images/$uuid/print/$sku.png \
		images/$uuid/print/subtitlecaption.png -geometry +$frontpageflushleftmargin+$frontpagesubtitletop -composite \
		images/$uuid/print/$sku.png

	## lay the front image in the center of the front page

		frontpageimagetop=$(( 300 + $titleheight ))

		echo "calculated frontpageimagetop as" $frontpageimagetop

		frontpageimagetop=$(( $frontpageimagetop - $imagebuffer  ))
		echo "adjusted frontpageimagetop with image buffer"

		frontpageimage_whitespace=$(( $pagewidth - $resizedwidth ))
		echo "calculated frontpageimage_whitespace as " $frontpageimage_whitespace
		frontpageimage_offset=$(( $frontpageimage_whitespace / 2 ))
		frontpageimageleftmargin=$(( $pagewidth + $spinepixels + $frontpageimage_offset ))
		echo "calculated frontpageimageleftmargin as" $frontpageimageleftmargin

		convert images/$uuid/print/$sku.png \
		images/$uuid/print/$sku"frontimage.png" -geometry +"$frontpageimageleftmargin"+$frontpageimagetop  -composite \
		images/$uuid/print/$sku.png

	## lay down the byline


		convert images/$uuid/print/$sku.png \
		images/$uuid/print/bylinecaption.png -geometry +"$frontpageflushleftmargin"+$bylinetopheight -composite images/$uuid/print/$sku.png

	## lay down the Nimble logotype on the front cover

		logotypetopheight=$(( $safepageheight - $bylineheight + 75 ))

		convert images/$uuid/print/$sku.png \
		images/$uuid/print/logotypecaption.png -geometry +"$frontpageflushleftmargin"+$logotypetopheight -composite images/$uuid/print/$sku.png

	## lay down the Nimble Books LLC on the spine

		spinecaptiontop=$(( $safepageheight - 600 ))
		echo "calculated spinecaptiontop as " $spinecaptiontop
		convert images/$uuid/print/$sku.png \
		images/$uuid/print/spinenimblecaption.png -geometry +$spineleftmargin+$spinecaptiontop -composite  \
		images/$uuid/print/$sku.png

	;;


3) 

	echo "design using single hi res image for entire cover"

	;;

4) 

	echo "design using simple image for top half of front cover"

	;;

5) 

	echo "design using carousel of images for front cover"

	;;

*) 
	echo "no cover design chosen, exiting"
	exit 3
	;;

esac

# convert RGB to CMYK

convert images/$uuid/print/$sku.png -colorspace CMYK images/$uuid/print/$sku.cmyk.pdf

# build front cover for e-books and metadata

frontpageleftmarginwithsafety=$(( $spineleftmargin + $spinepixels ))

convert images/$uuid/print/$sku.png  -crop  $pagewidth$x$pageheight+$frontpageleftmarginwithsafety+$bleed images/$uuid/print/$sku"_front_cover.jpg"

echo "built front cover at images/"$uuid"/print/"$sku"_front_cover.jpg"


## housekeeping
#cp $scriptpath$imagedir$uuid/print/$sku".png" $mediatargetpath$uuid/print/$sku".png"

#echo "wrote print cover "$scriptpath$imagedir$uuid/print$sku".png"  >> $sfb_log
