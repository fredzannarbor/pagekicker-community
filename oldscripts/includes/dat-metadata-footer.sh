sku=`tail -1 < "$LOCAL_DATA""SKUs/sku_list"`

echo "starting to write DAT metadata to " $metadatatargetpath$uuid/"current-import.csv" | tee --append $sfb_log
echo "current sku is "$sku | tee --append $xform_log

createtime=$(( `date +%s` ))

echo "createtime is " $createtime >> $sfb_log

special_from=$createtime

(( special_from = createtime - 86400 ))

news_from_date=$createtime

(( news_from_date = createtime - 86400 ))

news_from_date=`date -d @$news_from_date +'%m/%d/%y%n %H:%M:%S'`

(( news_to_date =  createtime + 7862400 ))

news_to_date=`date -d @$news_to_date +'%m/%d/%y%n %H:%M:%S'`

# Adjust the timestamp above by number of minutes given

minutes=$special_lasts_minutes

special_lasts_sec=$(( $minutes * 60))

echo "special lasts for this number of seconds" $special_lasts_sec >> $sfb_log

(( special_to =  createtime + special_lasts_sec ))

echo "special expires at " $special_to >> $sfb_log

echo "special expires at" `date -d @$special_to +'%m/%d/%y%n %H:%M:%S'` >> $sfb_log

echo "book is new from at " $news_from_date >> $sfb_log

echo "book is no longer new at " $news_to_date >> $sfb_log

special_from_date=`date -d @$special_from +'%m/%d/%y%n %H:%M:%S'`

special_to_date=`date -d @$special_to +'%m/%d/%y%n %H:%M:%S'`

special_price=0.00

#list of all metadata fields begins here

#store

echo -n "admin," >> $metadatatargetpath$uuid"/current-import.csv"

# websites

echo -n "base," >> $metadatatargetpath$uuid"/current-import.csv"

# attribute set

echo -n "Default," >> $metadatatargetpath$uuid"/current-import.csv"

# type

echo -n "downloadable,">> $metadatatargetpath$uuid"/current-import.csv"

#sku

echo -n "$sku," >> $metadatatargetpath$uuid"/current-import.csv" 

# 16 is Document Analysis Reports category

echo -n "16," >> $metadatatargetpath$uuid"/current-import.csv"

# has options

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

#name based on seed terms

productnamefull="$uploaded_tat_file"
productname=`echo "$productnamefull"|colrm 20`
productname=$productname"..."
echo "productname is" $productname

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "$productname" >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# url key n/a

echo -n "$sku," >> $metadatatargetpath$uuid"/current-import.csv"

# gift message available

echo -n "Use config," >> $metadatatargetpath$uuid"/current-import.csv"

# meta title

echo -n "Analysis of $productname" "," >> $metadatatargetpath$uuid"/current-import.csv"

# meta description

echo -n "Analysis of $productname," >> $metadatatargetpath$uuid"/current-import.csv"
 
#image filename

echo -n "/"$uuid/$sku"wordcloudbig.png," >> $metadatatargetpath"$uuid/current-import.csv"

# small image filename

echo -n "/"$uuid/$sku"wordcloudbig.png," >> $metadatatargetpath$uuid"/current-import.csv"

#thumbnail filename

echo -n "/"$uuid/$sku"wordcloudbig.png," >> $metadatatargetpath$uuid"/current-import.csv" 

# options container

echo -n "Product Info Column," >> $metadatatargetpath$uuid"/current-import.csv"

#samples title 

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# links title 

echo -n "Document Analysis Results," >> $metadatatargetpath$uuid"/current-import.csv"

#url below

echo -n "$sku," >> $metadatatargetpath$uuid"/current-import.csv" 

# image label below

echo -n  "Analysis of $productname cover," >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "Analysis of $productname small cover,">> $metadatatargetpath$uuid"/current-import.csv"

echo -n "Analysis of $productname  thumbnail," >> $metadatatargetpath$uuid"/current-import.csv" 

#custom design below

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "no layout updates," >> $metadatatargetpath$uuid"/current-import.csv"

#. includes/pricing.sh

echo -n "0.00" >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"
# description

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "Results of Document Analysis Tools on the file $productname" >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '",'>> $metadatatargetpath$uuid"/current-import.csv"

#short description below

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo "Results of Document Analysis Tools on the file $productname" >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '",'>> $metadatatargetpath$uuid"/current-import.csv"

#meta words below

echo -n '"'>> $metadatatargetpath$uuid"/current-import.csv"

# . includes/keyword-reader

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"
echo -n ',' >> $metadatatargetpath$uuid"/current-import.csv"

#custom layout update below

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# status below

echo -n "Enabled," >> $metadatatargetpath$uuid"/current-import.csv"

# taxable class
echo -n "None," >> $metadatatargetpath$uuid"/current-import.csv"

# catalog visibility

echo -n '"Catalog, Search",' >> $metadatatargetpath$uuid"/current-import.csv"

# enable google checkout

echo -n "Yes," >> $metadatatargetpath$uuid"/current-import.csv"

#links purchased separately

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

#quantity

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

#minimum quantity

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# use configured minimum quantity
echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

#is the quantity decimal?

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# will backorders be accepted

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# use configuration for backorders?

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

#what is the minimum sale quantity?
echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

#use configured value for min sale qty?
echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

#what is the maximum sale quantity?

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# use configured value for maximum sale quantity?

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# is the product in stock?

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# is there a low stock date?

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# should we notify on given stock quantity

echo -n "0," >> $metadatatargetpath$uuid/"current-import.csv"

# use configuration value on notifying stock quantity

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# manage the stock?

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# use configuration value for managing stock?

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# should the stock status be changed automatically

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

# what is the product name

echo -n "Document Analysis Results" "," >> $metadatatargetpath$uuid"/current-import.csv"

# is there a special store id

echo -n "'0'," >> $metadatatargetpath$uuid"/current-import.csv"
 
# what is the product type id?

echo -n "downloadable," >> $metadatatargetpath$uuid"/current-import.csv"
	
# has the product status changed?

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# what is the value of product_changed_websites

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# tier prices
echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

#associated products

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

#adwords grouped 

echo -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

# weight

echo  -n "0," >> $metadatatargetpath$uuid"/current-import.csv"

#downloadable options

# note that file path is relative to media/import because that's where Magento (not SFB) assumes the file will be

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

# echo additional columns

# "super_attribute_pricing"
echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

# "product_tags"

# . includes/keyword-reader
echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

# "custom_design"
echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

# "page_layout"
echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

# "gift_message_available"
echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

# "downloadplus_serialnr_inactive"
echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

# "downloadable_additional_clogin"
echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

# "downloadable_link_emaildeliver"
#echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

echo "finished writing metadata for this Document Analysis Report" | tee --append $sfb_log

# increment SKU by 1
prevsku=$sku
sku=$((sku+1)) 
echo $sku >> "$LOCAL_DATA""SKUs/sku_list"
echo "incremented SKU by 1 to" $sku " and updated SKUs/sku_list" 


echo "wrote metadata to "$metadatatargetpath$uuid"/current-import.csv" | tee --append $sfb_log


