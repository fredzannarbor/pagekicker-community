#!/bin/bash
editedby="Ching Na Ang"
covertitle="Designing a Laser for the Littoral Combat Ship" 
./bin/standalone-print.sh \
--ISBN "9781608889044" \
--shorttitle "Laser for the LCS" \
--imprintname "PageKicker" \
--spineinches "0.250" \
--pdfpath "/home/fred/Downloads/laser_lcs.pdf" \
--editedby "$editedby" \
--covertitle "$covertitle" \
--covertype "wordcloud"
