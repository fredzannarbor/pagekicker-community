# SEO module

seoseed=$(echo "$seed" | sed -e 's/"/_/g' -e 's/#/ /g'  -e 's/\&/ /g' -e 's/'\''/_/g'  -e 's/, /_/g' -e 's/,/_/g'  -e 's/\//_/g' -e 's/ /_/g' -e 's/\\/ /g' -e 's/|/_/g')
echo "seoseed is" $seoseed

cat assets/pk-html-adsense.js > tmp/$uuid/seo-cumulative.html
cat tmp/$uuid/cumulative.html >> tmp/$uuid/seo-cumulative.html
cp tmp/$uuid/seo-cumulative.html $APACHE_ROOT"pk-html/"$seoseed".html"

echo "ran SEO module and exported seo-cumulative.html to "$APACHE_ROOT"pk-html/"$seoseed".html"
