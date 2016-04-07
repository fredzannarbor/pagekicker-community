#!/bin/bash
editedby="Phil 73"
covertitle="A Serendipity Reader on Serendipity" 
./bin/standalone-print.sh \
--ISBN "9781608889068" \
--shorttitle "Serendipity" \
--imprintname "PageKicker" \
--spineinches "0.250" \
--pdfpath "/home/fred/sfb/sfb-latest/trunk/magento-output/media/import/ab98c5c0-b997-11e2-9e09-5891cf544016/614185413print.pdf" \
--editedby "$editedby" \
--covertitle "$covertitle" \
--covertype "wordcloud"
