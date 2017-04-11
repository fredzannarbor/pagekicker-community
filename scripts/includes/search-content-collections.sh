echo "$content_collections" | sed -e 's/; /;/g' -e 's/;/\n/g' > "$TMPDIR$uuid/content_collections/content_collections_list"
echo -n "searching the following content collections: "
cat "$TMPDIR$uuid/content_collections/content_collections_list"
echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"

echo "# Local Data" > "$TMPDIR$uuid/content_collections/content_collections_results.md"
echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
echo "searches carried out at $(date -u)" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"

while IFS= read -r collection; do
  mkdir "$TMPDIR$uuid/content_collections/$collection"
    . "$LOCAL_DATA"content_collections/"$collection/$collection.cfg"

    echo "# $content_collection_name" > "$TMPDIR$uuid/content_collections/content_collections_results.md"
    echo "" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
    echo "" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"

  while IFS= read -r seed; do
    echo "now searching $collection on $seed"
    echo "## **"$seed"**" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
    echo "" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"

    case $content_collection_filetype in
    pdf)
      echo "ccf filetype is pdf"
      grep -h -r -l -w "$seed" "$LOCAL_DATA"content_collections/"$content_collection_dirname"   | while read fn
      do
        #echo "**$fn**" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
        #echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
        #pdfgrep "$seed" -r -h -C 120  "$fn" | uniq | sed G >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
        #echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
        echo "pdfgrep search not implemented in search-content-collections"
      done
    ;;
    txt)
      echo "using grep against txt files in collection"
      echo $content_collection_dirname
      grep -h -r -l -w "$seed" "$LOCAL_DATA"content_collections/"$content_collection_dirname" >> "$TMPDIR$uuid/content_collections/files"
      grep -r -l "$seed" "$LOCAL_DATA"content_collections/"$content_collection_dirname" | while read fn
      do
        echo "*$fn*" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
        echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
        grep "$seed" --no-group-separator -h -w -A 2 -B 2  "$fn" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
        echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
      done
    ;;
    *)
    echo "assuming files in collection are txt and running grep"
      grep -h -r -l -w "$seed" "$fn" "$LOCAL_DATA"content_collections/"$content_collection_dirname"   | while read fn
      do
        echo "**$fn**" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
        echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
        grep "$seed" --no-group-separator -hw -A 2 -B 2 "$fn" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
        echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
      done
    ;;
    esac
    echo "" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
    echo "" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"

  done < "$TMPDIR"$uuid"/seeds/sorted.seedfile"

  echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
  echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
  sed -i 's/----//g' "$TMPDIR$uuid/content_collections/content_collections_results.md" #hack to remove confusing markdown from gutenberg
  sed -i 's/<<<//g' "$TMPDIR$uuid/content_collections/content_collections_results.md" #hack to remove confusing markdown from gutenberg
  echo "$content_collection_citation" >> "$TMPDIR$uuid/content_collections/content_sources.md"
  echo "  " >> "$TMPDIR$uuid/content_collections/content_sources.md"
done < "$TMPDIR$uuid/content_collections/content_collections_list"
