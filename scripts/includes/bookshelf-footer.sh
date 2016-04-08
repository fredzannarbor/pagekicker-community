 # builds metadata footer for public bookshelf categories

createtime=$(( `date +%s` ))

echo "createtime is " $createtime >> $sfb_log

special_price=0.00

#list of all metadata fields begins here

# rootid
rootid=2 # for PageKicker main

echo -n "$rootid," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# store

storecode="default" # for PageKicker main
echo -n "$storecode,"  >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# category_id

echo -n "$catid," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# name

echo -n "Public Bookshelf for $customer_name," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# description

echo -n "Public Bookshelf for $customer_name," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

#categories

echo -n "Customer Bookshelf/$customer_name," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# url_key

safe_url_key=$(echo "$customer_name" | sed -e 's/[^A-Za-z0-9._-]/-/g')

echo -n $"$safe_url_key," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# is_active

echo -n "1," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# meta_title

echo -n "Public Bookshelf for $customer_name," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# url_path

echo -n $"$safe_url_key.html," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"


# is_anchor

echo -n "1," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# meta_keywords

echo -n "TBD," >>  $metadatatargetpath$uuid/"import_bulk_categories.csv"

# meta_description

echo -n "Publicly shared ebooks from PageKicker customer $customer_name," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# display_mode

echo -n "PRODUCTS_AND_PAGE," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# page_layout

echo -n "," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# cms_block

echo -n "," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# custom_layout_update

echo -n "," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# custom_design

echo -n "," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# category_image

echo -n "," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# category_thumb_image

echo -n "," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# include_in_menu

echo -n "0," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# custom_apply_to_products

echo -n "0," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"

# custom_use_parent_settings

echo -n "0," >> $metadatatargetpath$uuid/"import_bulk_categories.csv"
# position

# last column has no -n flag and no terminal comma

echo "1" >> $metadatatargetpath$uuid/"import_bulk_categories.csv"






