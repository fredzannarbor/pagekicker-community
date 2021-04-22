#initialize print variables

# this is for case bound only - most of these values would need to be conditional to support other bindings

	print_horizontal_trim=2438 # 8.125 inches for 8.5 inch books
	print_vertical_trim=3300
	print_top_height=$((print_vertical_trim / 4))
	print_bottom_height=$((print_vertical_trim / 10))
	print_label_text_width=$((print_horizontal_trim - 225))
	outsidebleed=187
	insidebleed=204
	topbleed=217
	bottombleed=225
	textsafety=150
	userprovidedprintISBN=9781608880416 # dev only
	spinepixels=131 #dev only

# create directory for print images

	cd images/$uuid ; mkdir print ; echo "created directory images/$uuid/print" ; cd $scriptpath ; echo "changed directory back to " $scriptpath | tee --append $sfb_log

# calculate dimensions

	# calculate spine dimensions (we must know the spine before we can do the canvas!)

		echo "checking sku is " $sku "and path to pdf is " $mediatargetpath$uuid"/"$sku"print.pdf" 

		pdfpagecount=`pdftk $mediatargetpath$uuid/$sku"print.pdf" dump_data output | grep -i NumberOfPages | cut -d":" -f2 | sed '/^$/d'`

		echo "pdf page count is" $pdfpagecount

		# get rid of space and save $spinepixels as variable

	# calculate size of canvas

		canvaswidth=$(( $print_horizontal_trim * 2 + $spinepixels + $outsidebleed + $insidebleed + $insidebleed + $outsidebleed + 10 ))
		canvasheight=$((  $topbleed + $print_vertical_trim + $bottombleed + 10 ))

		echo "calculated canvaswidth as "$canvaswidth
		echo "calculated canvasheight as "$canvasheight

	# calculate safe areas on front and back page

		safepagewidth=$(( $print_horizontal_trim - $textsafety - $textsafety ))
		safepageheight=$(( $print_vertical_trim - $textsafety ))

		echo "calculated safepagewidth as" $safepagewidth
		echo "calculated safepageheight as" $safepageheight

	# calculate spine

		if [ "$spinepixels" -lt 106 ] ; then
			spinesafety=10
		else
			spinesafety=18
		fi

		echo "because spine width is less than 105 pixels, spinesafety is " $spinesafety

		safespinetitlewidth=$(( $spinepixels - $spinesafety - $spinesafety ))

		echo "safespinetitlewidth is" $safespinetitlewidth

		safespinetitleheight=$(( $safepageheight / 2 ))

		echo "calculated safespinetitleheight as " $safespinetitleheight

		spineleftmargin=$(( $outsidebleed + $insidebleed + $print_horizontal_trim + $spinesafety * 2 ))

		echo "calculated spineleftmargin as bleed + page width +spinepixels for " $spineleftmargin
		
		spinelogotypebegin=$(( $print_horizontal_trim - 600 ))

	# front page calculations

		frontpageflushleftmargin=$(( $outsidebleed + $print_horizontal_trim + $insidebleed + $spinepixels + insidebleed ))

		echo "calculated frontpageflushleftmargin as" $frontpageflushleftmargin

		# there's always a cushion around top and bottom text t

		frontpagetopcushion=150

		frontpagebottomcushion=0

		echo "frontpagetopcushion is " $frontpagetopcushion
		echo "frontpagebottomcushion is " $frontpagebottomcushion

	# back page calculations

		ISBNylocation=$(( $safepageheight - 300 - 25 ))
		ISBNxlocation=$(( $outsidebleed + 125 ))

		echo "calculated ISBNxlocation as" $ISBNxlocation
		echo "calculated ISBNylocation as" $ISBNylocation


	# start by building the full canvas

		convert -size "$canvaswidth"x"$canvasheight" xc:$newcovercolor \
		-units "PixelsPerInch" -density 300  -resample 300x \
		images/$uuid/print/fullcanvas.png


	# then create the front cover
		convert -size "$print_horizontal_trim"x"$print_vertical_trim" -density 300 -units pixelsperinch xc:$newcovercolor  images/$uuid/print/canvas.png
		convert -size "$print_horizontal_trim"x"$print_top_height" -density 300 -units pixelsperinch xc:$newcovercolor  images/$uuid/print/topcanvas.png
		convert -size "$print_horizontal_trim"x"$print_bottom_height" -density 300 -units pixelsperinch xc:$newcovercolor  images/$uuid/print/bottomcanvas.png
		convert -size "$print_horizontal_trim"x"$print_top_height" -density 300 -units pixelsperinch xc:$newcovercolor  images/$uuid/print/toplabel.png
		convert -size "$print_horizontal_trim"x"$print_bottom_height" -density 300 -units pixelsperinch xc:$newcovercolor  images/$uuid/print/bottomlabel.png


	# underlay the Word Cloud cover (which was created during the ebookcover build)

	composite -gravity Center images/$uuid/ebookcover/$sku"printcloud.png"  images/$uuid/print/canvas.png images/$uuid/print/canvas.png

	# build the labels for the front cover

		echo "covertitle is" $covertitle


		convert -background $newcovercolor -fill "$coverfontcolor" -gravity center -size "$print_label_text_width"x"$print_top_height" \
			-font $newcoverfont caption:"$covertitle" \
			-density 300 -units pixelsperinch\
				 images/$uuid/print/topcanvas.png +swap -gravity center -composite images/$uuid/print/toplabel.png\

		convert  -background $newcovercolor  -fill "$coverfontcolor" -gravity center -size "$print_label_text_width"x"$print_bottom_height" \
		 -font $newcoverfont  caption:"$editedby" \
		-density 300 -units pixelsperinch\
		 images/$uuid/print/bottomcanvas.png  +swap -gravity center -composite images/$uuid/print/bottomlabel.png

	# lay the labels on top of the front cover
		composite -geometry +0+0 images/$uuid/print/toplabel.png images/$uuid/print/canvas.png images/$uuid/print/step1.png
		composite  -geometry +0+$print_horizontal_trim images/$uuid/print/bottomlabel.png images/$uuid/print/step1.png images/$uuid/print/step2.png
		composite  -gravity south -geometry +0+0 assets/PageKicker_cmyk300dpi_300.png images/$uuid/print/step2.png images/$uuid/print/cover.png

	# make a working copy of the front cover

		cp images/$uuid/print/cover.png images/$uuid/print/$sku"printfrontcover.png"

	#  make PDF and EPS copies of the front cover
		convert images/$uuid/print/$sku"printfrontcover.png" -density 300 images/$uuid/print/$sku"printfrontcover.pdf"
		convert -density 300 images/$uuid/print/$sku"printfrontcover.pdf" images/$uuid/print/$sku"printfrontcover.eps"

	# replace first page of interior with print cover page

		pdftk A=$mediatargetpath$uuid/$sku"print.pdf" B="images/"$uuid/print/$sku"printfrontcover.pdf" cat B1 A2-end output $mediatargetpath$uuid/$sku"finalprint.pdf"

	# build the ISBN

	python $scriptpath"lib/bookland-1.4/bookland-1.4.1b" -o images/$uuid/print/$userprovidedprintISBN.eps -f OCRB -b 1 -q --cmyk 0,0,0,1.0 "$userprovidedprintISBN" 90000
	
	convert -units "PixelsPerInch" -density 300 -resample 300x -border 25x25 -bordercolor white images/$uuid/print/$userprovidedprintISBN.eps -colorspace CMYK images/$uuid/print/$userprovidedprintISBN.png

	# build the spine caption

	echo "building spine caption"

	convert -size $safespinetitleheight$x$safespinetitlewidth -density 300 -units pixelsperinch -background  $newcovercolor -fill "$coverfontcolor" -font $coverfont -rotate 90 -gravity West caption:"$covertitle" images/$uuid/print/spinecaption.png

	# build the spine logotype

	echo "building spine logotype"

	convert -size $safespinetitleheight$x$safespinetitlewidth -density 300 -units pixelsperinch -background  $newcovercolor -fill "$coverfontcolor" -font $coverfont -rotate 90 -gravity East caption:"PageKicker" images/$uuid/print/spinelogotype.png


# lay the objects on the canvas


	
	# lay the ISBN box at the bottom left corner of the full canvas

		convert images/$uuid/print/fullcanvas.png \
		images/$uuid/print/$userprovidedprintISBN.png -geometry +$ISBNxlocation+$ISBNylocation  -composite  \
		images/$uuid/print/fullcanvas1.png 

	# lay the front cover on the full canvas

		convert images/$uuid/print/fullcanvas1.png \
		images/$uuid/print/$sku"printfrontcover.png" -geometry +$frontpageflushleftmargin+$topbleed -composite  \
		images/$uuid/print/fullcanvas2.png

# assemble and lay down the spine caption and logotype, unless it is too thin

	if [ "$pdfpagecount" -lt 48 ]; then

		echo "page count too low for spine"
		cp images/$uuid/print/fullcanvas2.png images/$uuid/print/finalcanvas.png

	else

		# lay the spine caption on the full canvas

			convert images/$uuid/print/fullcanvas2.png \
			images/$uuid/print/spinecaption.png -geometry +$spineleftmargin+375 -composite  \
			images/$uuid/print/fullcanvas3.png


		# resize the purple bird 
			purplebirdsize=$(( $safespinetitlewidth - 20 ))
			convert assets/purplebird300.png -resize $purplebirdsizex$purplebirdsize\> images/$uuid/print/purple$safespinetitlewidth.png

		# surround the bird with a white box

			convert -units "PixelsPerInch" -density 300 -resample 300x -border 5x5 -bordercolor white images/$uuid/print/purple$safespinetitlewidth.png -colorspace CMYK images/$uuid/print/purplebirdwithbox.png

		# create spacer box

		convert -size "$safespinetitlewidth"x20 xc:none images/$uuid/print/spacer.png

		# append spine logotype, spacer, and purplebird box

		convert images/$uuid/print/spinelogotype.png images/$uuid/print/spacer.png -background none -gravity west -append images/$uuid/print/logowithspacer.png
		convert images/$uuid/print/logowithspacer.png images/$uuid/print/purplebirdwithbox.png -background none -gravity west -append images/$uuid/print/logobar.png

		# lay the spine logotype on the full canvas

		convert images/$uuid/print/fullcanvas3.png \
		images/$uuid/print/logobar.png -geometry +$spineleftmargin+$spinelogotypebegin -composite  \
		images/$uuid/print/fullcanvas4.png

		cp images/$uuid/print/fullcanvas2.png images/$uuid/print/finalcanvas.png


	fi

	
# save the cover and prepare it for production

	# save as single large file (png)

	# convert RGB to CMYK

	convert images/$uuid/print/finalcanvas.png -colorspace CMYK images/$uuid/print/$userprovidedISBN.pdf

	echo "built print cover as file images/$uuid/print/$sku.cmyk.pdf" | tee --append $sfb_log

xvfb-run --auto-servernum ebook-convert tmp/$uuid/cumulative.html $mediatargetpath$uuid/$sku".pdf" --cover "images/"$uuid"/print/"$sku"printfrontcover.png" --margin-left "54" --margin-right "54" --margin-top "54" --margin-bottom "54" --pdf-default-font-size "11" --pdf-page-numbers --insert-metadata --pdf-serif-family "AvantGarde" --title "$covertitle"

echo "saving interior as PDFx1a"

# -B flag makes it b&w

./lib/pstill_dist/pstill -M defaultall -m XimgAsCMYK -m Xspot -m Xoverprint -d 500 -m XPDFX=INTENTNAME -m XPDFXVERSION=1A -m XICCPROFILE=USWebCoatedSWOP.icc -o $mediatargetpath$uuid/$userprovidedprintISBN.pdf $mediatargetpath$uuid/$sku.pdf
