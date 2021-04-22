sku=`tail -1 < $LOCAL_DATA"SKUs/sku_list"`
echo "sku" $sku

echo "starting to write metadata to " $metadatatargetpath | tee --append $sfb_log

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

# 2 is Nimble Combinatorial Publishing category

echo -n $categoryid"," >> $metadatatargetpath$uuid"/current-import.csv"

# has options

echo -n "1," >> $metadatatargetpath$uuid"/current-import.csv"

#name based on seed terms

productname=$covertitle

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n $productname >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# url key n/a

 echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# gift message available

echo -n "Use config," >> $metadatatargetpath$uuid"/current-import.csv"

# meta title

echo -n $covertitle "," >> $metadatatargetpath$uuid"/current-import.csv"

# meta description

echo -n "foo," >> $metadatatargetpath$uuid"/current-import.csv"
 
#image filename

echo -n $slash$uuid/$sku"cover.png," >> $metadatatargetpath"$uuid/current-import.csv"

# small image filename

echo -n $slash$uuid/$sku"cover.png," >> $metadatatargetpath$uuid"/current-import.csv"

#thumbnail filename

echo -n $slash$uuid/$sku$"cover.png," >> $metadatatargetpath$uuid"/current-import.csv" 

# options container

echo -n "Product Info Column," >> $metadatatargetpath$uuid"/current-import.csv"

#samples title 

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

# links title 

echo -n $escapeseed "," >> $metadatatargetpath$uuid"/current-import.csv"

#url path below

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv" 

# image label below

echo -n $escapeseed " cover," >> $metadatatargetpath$uuid"/current-import.csv"

echo -n $escapeseed " small cover," >> $metadatatargetpath$uuid"/current-import.csv"

echo -n $escapeseed "cover thumbnail," >> $metadatatargetpath$uuid"/current-import.csv" 

#custom design below

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "no layout updates," >> $metadatatargetpath$uuid"/current-import.csv"

. includes/pricing.sh

echo -n "$price" >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"
# description

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

cat tmp/$uuid/longdescription.html | sed -e 's/"/_/'g >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '",'>> $metadatatargetpath$uuid"/current-import.csv"

#short description below

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

cat tmp/$uuid/shortdescription.html | sed -e 's/"/_/'g | sed -e '/\<html/d' | sed -e '/\<body/d' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '",'>> $metadatatargetpath$uuid"/current-import.csv"

#meta keywords below

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

echo -n $escapeseed "," >> $metadatatargetpath$uuid"/current-import.csv"

# is there a special store id

echo -n "'$specialstoreid'," >> $metadatatargetpath$uuid"/current-import.csv"
 
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


if [ "$targetformats" = "epubonly" ] ; then
	
	echo "targetformats is" $targetformats

	echo $epublinkname 

	echo -n '"'$epublinkname,0,9,file,$uuid/$sku'plaintxt.epub,''"' >> $metadatatargetpath$uuid"/current-import.csv"

else

	echo -n '"'$epublinkrichname,0,9,file,$uuid/$sku'linkrich.epub'$pipe$docxname,0,9,file,$uuid/$sku'.docx'$pipe$epublinkname,0,9,file,$uuid/$sku'plaintxt.epub'$pipe$mobilinkname,0,9,file,$uuid/$sku'.mobi'$pipe$pdflinkname,0,9,file,$uuid/"$sku"print_color.pdf'"', >> $metadatatargetpath$uuid"/current-import.csv"

fi
 

# echo additional columns

#echo -n $special_price","  >> $metadatatargetpath$uuid"/current-import.csv"

#echo -n $special_from_date","  >> $metadatatargetpath$uuid"/current-import.csv"

#echo -n $special_to_date","  >> $metadatatargetpath$uuid"/current-import.csv"

echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

echo -n ","  >> $metadatatargetpath$uuid"/current-import.csv"

echo -n  '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n $editedby '",' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n  '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n $seedsource '",' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n $news_from_date >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

echo -n $news_to_date >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

echo -n $editorid >> $metadatatargetpath$uuid"/current-import.csv"

echo -n "," >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo -n $wordcount >> $metadatatargetpath$uuid"/current-import.csv"

echo -n '"' >> $metadatatargetpath$uuid"/current-import.csv"

echo ",," >> $metadatatargetpath$uuid"/current-import.csv"

#product tags were here

# . includes/keyword-reader


echo "finished writing metadata for this book "$booktype" on " $seed | tee --append $sfb_log

echo "SKU was "$sku | tee --append $sfb_log

echo "wrote metadata to "$metadatatargetpath$uuid"/current-import.csv" | tee --append $sfb_log


