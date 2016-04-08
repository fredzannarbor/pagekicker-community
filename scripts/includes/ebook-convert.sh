if [ "$build_all_formats" = "yes" ] ; then

	echo "building all available ebook formats"
	build_bw_pdf="yes"
	build_color_pdf="yes"
	build_mobi="yes"
	build_linkrich_epub="yes"
	build_text_epub="yes"
	build_txt_html_only="yes"
	build_docx="yes"

else

	echo "building only specified formats"

fi

# converting cumulative txt file to outputs dependent on it

echo "converting txt to strictly compliant epub" 

xvfb-run --auto-servernum ebook-convert tmp/$uuid/"cumulative.txt" $mediatargetpath$uuid/$sku"plaintxt.epub"  --smarten-punctuation --language $"English" --publisher "PageKicker" --title "$covertitle" --cover $mediatargetpath$uuid/cover.png --authors "$editedby" --enable-heuristics --chapter-mark "pagebreak"  --formatting-type "heuristic" --dont-split-on-page-breaks --pretty-print --remove-first-image --formatting-type "heuristic" 1> /dev/null


# checking that epub is compliant

echo "running epubcheck"

$JAVA_BIN -jar $epubcheckjarpath $mediatargetpath$uuid/$sku"plaintxt.epub" 

epubchecksuccess=$?

echo "epubchecksuccess on book "$sku"plaintxt.epub is" $epubchecksuccess 

# converting cumulative html files

if [ "$build_linkrich_epub" = "yes" ] ; then

	echo "converting cumulative html to linkrich epub using calibre" 

	xvfb-run --auto-servernum ebook-convert tmp/$uuid/cumulative.html $mediatargetpath$uuid/$sku"linkrich.epub" --smarten-punctuation --language $LANG --publisher "PageKicker" --title "$covertitle" --cover $mediatargetpath$uuid/cover.png --authors "$editedby" --enable-heuristics --chapter-mark "pagebreak" --dont-split-on-page-breaks --pretty-print --remove-first-image 1> /dev/null

	cp  $mediatargetpath$uuid/$sku"linkrich.epub"  $mediatargetpath$uuid/$safecovertitle".epub"

	echo "converting temptoc.html to linkrich epub using calibre"
	

	xvfb-run --auto-servernum ebook-convert tmp/$uuid/temptoc.html $mediatargetpath$uuid/$sku"multipart.epub" --smarten-punctuation --language $LANG --publisher "PageKicker" --title "$covertitle" --cover $mediatargetpath$uuid/cover.png --authors "$editedby" --enable-heuristics --chapter-mark "pagebreak" --dont-split-on-page-breaks --pretty-print --remove-first-image --max-levels "1"  1> /dev/null
else

	echo "not building linkrich epub"

fi

if [ "$build_mobi" = "yes" ] ; then

	echo "converting  html to mobi using calibre" 

	xvfb-run --auto-servernum ebook-convert tmp/$uuid/cumulative.html $mediatargetpath$uuid/$sku".mobi" --smarten-punctuation --insert-metadata --language $"English" --publisher "PageKicker" --title "$covertitle" --cover $mediatargetpath/$uuid/cover.png --authors "$editedby" --enable-heuristics 1> /dev/null

else

	echo "not building mobi"

fi


if [ "$build_docx" = "yes" ] ; then

	echo "converting html to docx using pandoc"

	pandoc -s -S --toc tmp/$uuid/"cumulative.html" -o $mediatargetpath$uuid/$sku".docx"

else

	echo "not building docx"

fi


if [ "$build_color_pdf" = "yes" ] ; then


	echo "converting cumulative html to pdf using calibre and default ebook cover" 

	if [ "$booktype" = "Reader" ] ; then

		size="5x8"

	else

		size="8.5x11"
	fi	
	echo "size is" $size

	echo "deciding on pdfserif font"
	pdfserif=$(shuf ../conf/pdfserif_fonts.txt)
	echo "pdfserif is" $pdfserif

	xvfb-run --auto-servernum ebook-convert tmp/$uuid/cumulative.html $mediatargetpath$uuid/$sku"print_color.pdf" --cover "images/"$uuid/ebookcover/$sku"cover.png" --pdf-serif-family "$pdfserif" --margin-left "54"  \--margin-right "54" --margin-top "54" --margin-bottom "54" --pdf-default-font-size "14" --pretty-print --language $LANG --publisher "PageKicker" --title "$covertitle" --cover $mediatargetpath$uuid/cover.png --authors "$editedby" --chapter-mark "pagebreak" --custom-size "$size" 1> /dev/null


#echo removing page 1

#pdftk $mediatargetpath$uuid/$sku"print_tmp.pdf" cat 2-end output $mediatargetpath$uuid$sku"print.pdf"

#echo "saving interior as PDFx1a"

	if [ "$build_bw_pdf" = "yes" ] ; then


	# -B flag makes it b&w

	./lib/pstill_dist/pstill  -M defaultall -m XimgAsCMYK -m Xspot -m Xoverprint -d 500 -m XPDFX=INTENTNAME -m XPDFXVERSION=1A -m XICCPROFILE=USWebCoatedSWOP.icc -B -o $mediatargetpath$uuid/$sku"bw.pdf" $mediatargetpath$uuid/$sku"print_color.pdf"

	# cp $mediatargetpath$uuid/$sku"print_nocover.pdf" $mediatargetpath/$sku"print.pdf"

	else

		echo "not building b&w pdf"

	fi

else

	echo "not building color or bw pdfs"

fi


if [ $userdescription = "yes" ] ; then

	echo "appending user description to book metadata"
	cat bin/xform-includes/userdescription.txt >> tmp/$uuid/shortdescription.html
	cat bin/xform-includes/userdescription.txt >> tmp/$uuid/lsi-shortdescription.txt

else

	echo "no user description was provided"

fi


if [ "$mylibrary" = "yes" ] ; then
	
	cp $mediatargetpath/$uuid/$sku"plaintxt.epub" $mediatargetpath"../calibre-import/"
	echo "copied "$sku"plaintxt.epub to my calibre library" 

else

	echo "calibre import flag was off" 

fi
