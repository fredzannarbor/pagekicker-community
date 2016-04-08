  # build title page

	echo "# "$customtitle > tmp/$uuid/titlepage.md
	echo "# "$byline >> tmp/$uuid/titlepage.md
        echo "# Enhanced with Text Analytics by PageKicker Robot" $jobprofilename >> tmp/$uuid/titlepage.md
	echo '![pk logo](assets/PageKicker_cmyk300dpi.png)\' >> tmp/$uuid/titlepage.md
	echo '\pagenumbering{roman}' >> tmp/$uuid/titlepage.md

        pandoc tmp/$uuid/titlepage.md -o tmp/$uuid/titlepage.pdf --variable fontsize=12pt --latex-engine=xelatex

        # build "About the Robot Author"

        echo "# About the Robot Author" > tmp/$uuid/robot_author.md
        echo "# $lastname" >> tmp/$uuid/robot_author.md
        cat "$authorbio" >> tmp/$uuid/robot_author.md

        # build "also by this Robot Author"
        
        # build "Acknowledgements"

        cp assets/acknowledgements.md tmp/$uuid/acknowledgements.md
	echo "  " >> tmp/$uuid/acknowledgements.md
	echo "  " >> tmp/$uuid/acknowledgements.md
	echo '![author-sig](../conf/jobprofiles/signatures/'"$sigfile"')' >> tmp/$uuid/acknowledgements.md

        # assemble front matter

	cat tmp/$uuid/titlepage.md assets/newpage.md assets/copyright_page.md assets/newpage.md tmp/$uuid/robot_author.md assets/newpage.md tmp/$uuid/acknowledgements.md assets/newpage.md tmp/$uuid/summary.md assets/newpage.md tmp/$uuid/rr.md assets/newpage.md tmp/$uuid/sorted_uniqs.md > tmp/$uuid/textfrontmatter.md
	pandoc tmp/$uuid/textfrontmatter.md --latex-engine=xelatex -o tmp/$uuid/textfrontmatter.pdf

        # add wordcloud page to front matter

	pdftk tmp/$uuid/textfrontmatter.pdf tmp/$uuid/wordcloud.pdf  output tmp/$uuid/$uuid"_frontmatter.pdf"
