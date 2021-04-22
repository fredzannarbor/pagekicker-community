
# this is an updated metadata builder to accommodate new product columns
# created by downloadable builder software

# now need to also incorporate dat-builder metadata settings

if [ "$dat" = "yes" ] ; then
	categories="16"
	productnamefull="$uploaded_tat_file"
	productname=`echo "$productnamefull"|colrm 20`
	productname=$productname"..."
	booktitle="Analysis of "$productname
	links_title="Document Analysis Results"
else
	links_title="Formats"
fi

createtime=$(( `date +%s` ))

echo "createtime is " $createtime >> $sfb_log

special_price=0.00

#list of all metadata fields begins here

#store

echo -n "$storecode," >> $metadatatargetpath$uuid"/current-import.csv"

# websites

echo -n "$websites," >> $metadatatargetpath$uuid"/current-import.csv"

# attribute set

echo -n "$attribute_set," >> $metadatatargetpath$uuid"/current-import.csv"

# type

echo -n "$type,">> $metadatatargetpath$uuid"/current-import.csv"

# 16 is Document Analysis Reports category, 4 is catalog
 program &> /dev/null
echo -n '"'$categories'"'"," >> $metadatatargetpath$uuid"/current-import.csv"

# sku

#case "$storecode" in
# set sku root
#;;
# esac

echo -n "$sku," >> $metadatatargetpath$uuid"/current-import.csv"

# has options

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# name

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "$booktitle" >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# meta title
echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "$booktitle" >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# meta_description

# see https://yoast.com/meta-descriptions/ for info about how to compose

echo -n '"'  >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '"'  >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# image

# [ ! -f $TMPDIR$uuid/$sku"wordcloudbig.png" ] && cp $TMPDIR$uuid/$sku"wordcloudbig.png" $TMPDIR$uuid$sku"ebookcover.jpg"

echo -n "/"$uuid/$sku"ebookcover.jpg," >> $metadatatargetpath"$uuid/current-import.csv"

# small_image

echo -n "/"$uuid/$sku"ebookcover.jpg," >> $metadatatargetpath$uuid"/current-import.csv"

# thumbnail
 program &> /dev/null
echo -n "/"$uuid/$sku"ebookcover.jpg," >> $metadatatargetpath$uuid"/current-import.csv"

# url_key

echo -n "$sku," >> $metadatatargetpath$uuid"/current-import.csv"

# url_path

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# config_attributes

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# custom design

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# page_layout

echo -n "No layout updates," >> $metadatatargetpath$uuid"/current-import.csv"

# options_container
 program &> /dev/null
echo -n "Block after Info Column," >> $metadatatargetpath$uuid"/current-import.csv"

# msrp_enabled

echo -n "Use config," >> $metadatatargetpath$uuid"/current-import.csv"

# msrp_display_actual_price_type
echo -n "Use config," >> $metadatatargetpath$uuid"/current-import.csv"

# gift_message_available

echo -n "Use config," >> $metadatatargetpath$uuid"/current-import.csv"

# samples_title

echo -n "Samples," >> $metadatatargetpath$uuid"/current-import.csv"
# links_title

 program &> /dev/null
echo -n "$links_title," >> $metadatatargetpath$uuid"/current-import.csv"

# editorid

echo -n "$customerid," >> $metadatatargetpath$uuid"/current-import.csv"

# wordcount

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# seedsource

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# editedby

echo -n "$customername," >> $metadatatargetpath$uuid"/current-import.csv"

# external_uniqid

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# xml_file

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# price

if [ "$pricing" = "yes" ] ; then
	./includes/pricing.sh
else
	true
fi

echo -n "$price," >> $metadatatargetpath$uuid"/current-import.csv"

# special_price

if [ "$special_pricing" = "yes" ] ; then
	echo -n "$special_price," >> $metadatatargetpath$uuid"/current-import.csv"
else
	echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"
fi

# cost

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# msrp

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# status

echo -n "$status," >> $metadatatargetpath$uuid"/current-import.csv" 

# visibility

echo -n '"'Catalog, Search'"', >> $metadatatargetpath$uuid"/current-import.csv"

# tax_class_id

echo -n "None," >> $metadatatargetpath$uuid"/current-import.csv"

# links_purchased_separately

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# links_exist

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# ebizmarts_mark_visited

echo -n "Yes," >> $metadatatargetpath$uuid"/current-import.csv"

# (is) featured

echo -n "Yes," >> $metadatatargetpath$uuid"/current-import.csv"

# description

echo -n '"'  >> $metadatatargetpath$uuid"/current-import.csv"

cat includes/wikilicense.txt >> $TMPDIR$uuid/book-description.txt
cat $TMPDIR$uuid/book-description.txt | sed -e 's/"/_/'g >> $metadatatargetpath$uuid"/current-import.csv"
# add process.md
echo -n '"'  >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# short_description

echo -n '"'  >> $metadatatargetpath$uuid"/current-import.csv"
cat $TMPDIR$uuid/tldr.txt | sed -e 's/"/_/'g >> $metadatatargetpath$uuid"/current-import.csv"
# cat $TMPDIR$uuid/book-description.txt | sed -e 's/"/_/'g >> $metadatatargetpath$uuid"/current-import.csv"
echo -n '"'  >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# meta_keyword

# printf "%s" "$(cat $TMPDIR$uuid/seeds/sorted.seedfile)" | sed -e 's/"/_/'g -e 's/\n/, /'g >> $metadatatargetpath$uuid"/current-import.csv"
echo  -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# custom_layout_update

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# downloadable_link_emaildeliver
echo  -n "1," >> $metadatatargetpath$uuid"/current-import.csv"


# special_from_date

special_from=$createtime

(( special_from = createtime - 86400 ))

special_from_date=`date -d @$special_from +'%m/%d/%Y%n %H:%M:%S'`

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"
echo -n "$special_from_date"  >> $metadatatargetpath$uuid"/current-import.csv"
echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"
echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# special_to_date

minutes=$special_lasts_minutes # read from config or command line default 43,200 = 1 hour

special_lasts_sec=$(( $minutes * 60))

(( special_to =  createtime + special_lasts_sec ))


special_to_date=`date -d @$special_to +'%m/%d/%Y%n %H:%M:%S'`

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"
echo -n "$special_to_date"  >> $metadatatargetpath$uuid"/current-import.csv"
echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"
echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"


# new(s)_from_date

news_from=$createtime

(( news_from = createtime - 86400 ))

news_from_date=`date -d @$news_from +'%m/%d/%Y%n %H:%M:%S'`

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"
echo -n "$news_from_date"  >> $metadatatargetpath$uuid"/current-import.csv"
echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"
echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# new(s) to_date

news_minutes=$news_lasts_minutes # read from config or command line default 43,200 = 1 hour

news_lasts_sec=$(( $news_lasts_minutes * 60))


(( news_to =  createtime + news_lasts_sec ))

news_to_date=`date -d @$news_to +'%m/%d/%Y%n %H:%M:%S'`

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"
echo -n "$news_to_date"  >> $metadatatargetpath$uuid"/current-import.csv"
echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"
echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# custom_design_from

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# custom_design_to

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# qty

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# min_qty

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# use_config_min_qty

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# is_qty_decimal

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# backorders

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# use_config_backorders

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# min_sale_qty

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# use_config_min_sale_qty

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# max_sale_qty

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# use_config_max_sale_qty

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# is_in_stock

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# low_stock_date

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# notify_stock_qty

echo -n "0," >> $metadatatargetpath$uuid/"current-import.csv"

# use_config_notify_stock_qty

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# manage_stock

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# use_config_manage_stock

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# stock_status_changed_auto

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# use_config_qty_increments

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# qty_increments

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# use_config_enable_qty_inc

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# enable_qty_increments

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# is_decimal_divided

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# stock_status_changed_automatically

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# use_config_enable_qty_increments

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# product_name
bashsafe_product_name=$(echo "$booktitle"  | sed -e '/[|,&<>]/g')

echo -n "$bashsafe_product_name," >> $metadatatargetpath$uuid"/current-import.csv"

# store_id

echo -n "$storeids," >> $metadatatargetpath$uuid"/current-import.csv"

# product_type_id

echo -n "downloadable," >> $metadatatargetpath$uuid"/current-import.csv"

# product_status_changed

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# product_changed_websites

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# gallery

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# gallery_label

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# related

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# upsell

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# crosssell

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# tier_prices

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# associated

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# bundle_options

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# grouped

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# group_price

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"


# downloadable_options

if [ "$dat" = "yes" ] ; then

	link1name="Poster_Sized_Word_Cloud"
	link2name="Candidate_Acronyms"
	link3name="Readability_Report"
	link4name="Keywords"
	link5name="Automatic_Summary"
	link6name="All_Images_Montage"
	link7name="Top_N_Images_Montage"
	filename1="$sku"wordcloudbig.png
	filename2="$sku"acronyms.txt
	filename3="$sku"rr.pdf
	filename4="$sku"all_nouns.txt
	filename5="$sku"summary.txt
	filename6="$sku"montage.jpg
	filename7="$sku"montagetopn.jpg

	pipe="|"

	if [ "$montageur_success" = 0 ] ; then

		echo "montageur ran successfully so adding links for montages to metadata" | tee --append $xform_log

		echo -n '"'$link1name,0,9,file,$uuid/$filename1$pipe$link2name,0,9,file,$uuid/$filename2$pipe$link3name,0,9,file,$uuid/$filename3$pipe$link4name,0,9,file,$uuid/$filename4$pipe$link5name,0,9,file,$uuid/$filename5$pipe$link6name,0,9,file,$uuid/$filename6$pipe$link7name,0,9,file,$uuid/$filename7'"'"," >> $metadatatargetpath$uuid"/current-import.csv"


	else

		echo "montageur did not run successfully so not adding links for montages" | tee --append $xform_log

		echo -n '"'$link1name,0,9,file,$uuid/$filename1$pipe$link2name,0,9,file,$uuid/$filename2$pipe$link3name,0,9,file,$uuid/$filename3$pipe$link4name,0,9,file,$uuid/$filename4$pipe$link5name,0,9,file,$uuid/$filename5'"'"," >> $metadatatargetpath$uuid"/current-import.csv"

	fi

else
# note that file path is relative to media/import because that's where Magento (not SFB) assumes the file will be

	# echo -n '"'$epublinkrichname,0,9,file,$uuid/$sku'linkrich.epub'$pipe$docxname,0,9,file,$uuid/$sku'.docx'$pipe$epublinkname,0,9,file,$uuid/$sku'plaintxt.epub'$pipe$mobilinkname,0,9,file,$uuid/$sku'.mobi'$pipe$pdflinkname,0,9,file,$uuid/"$sku"print_color.pdf'"', >> $metadatatargetpath$uuid"/current-import.csv"

	if [ "$environment" = "Production" ] ; then

		echo -n '"'$mobilinkname,0,9,builder,12$pipe$epublinkname,0,9,builder,9$pipe$docxlinkname,0,9,builder,10'"', >> $metadatatargetpath$uuid"/current-import.csv"

	elif [ "$environment" = "Staging" ] ; then

		echo -n '"'$mobilinkname,0,9,builder,15$pipe$epublinkname,0,9,builder,13$pipe$docxlinkname,0,9,builder,14'"', >> $metadatatargetpath$uuid"/current-import.csv"

	else

	echo -n '"'$mobilinkname,0,9,builder,12$pipe$epublinkname,0,9,builder,9$pipe$docxlinkname,0,9,builder,10'"', >> $metadatatargetpath$uuid"/current-import.csv"

	fi

fi

# downloadable_sample_options

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# super_attribute_pricing

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# product_tags

# . includes/keyword-reader
echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# is_recurring

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"
# image_label

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "$booktitle cover" >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# small_image_label

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "$booktitle small cover" >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# thumbnail_label
echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "$booktitle thumbnail" >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# job profile name
echo -n "$jobprofilename," >> $metadatatargetpath$uuid"/current-import.csv"

# downloadable_additional_clogin
echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# country of manufacture
echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# weight

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# book types such as Reader, NodeHome, Spider, etc.

echo -n "$booktype," >> $metadatatargetpath$uuid"/current-import.csv"

# seeds to catalog

echo -n '"'  >> $metadatatargetpath$uuid"/current-import.csv"
printf "%s" "$(cat $TMPDIR$uuid/seeds/sorted.seedfile)" | sed -e 's/"/_/'g >> $metadatatargetpath$uuid"/current-import.csv"
echo -n '"'  >> $metadatatargetpath$uuid"/current-import.csv"
echo  -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# imprint

echo -n "$imprint," >> $metadatatargetpath$uuid"/current-import.csv"

# customer id for revenue sharing

echo -n "$customerid," >> $metadatatargetpath$uuid"/current-import.csv"

# safe product name

safe_product_name=$(echo "$booktitle" | sed -e 's/[^A-Za-z0-9._-]/_/g' | sed -e 's/,/_/g')
echo -n "$safe_product_name," >> $metadatatargetpath$uuid"/current-import.csv"

# wikilang
echo  -n "$wikilang," >> $metadatatargetpath$uuid"/current-import.csv"

#coverfont

echo -n "$coverfont," >> $metadatatargetpath$uuid"/current-import.csv"

#covercolor

echo -n "$covercolor," >> $metadatatargetpath$uuid"/current-import.csv"

 #final line has different echo format

echo "0" >> $metadatatargetpath$uuid"/current-import.csv"
