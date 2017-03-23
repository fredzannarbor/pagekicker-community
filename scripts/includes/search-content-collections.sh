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
    echo "searching $collection on $seed"
    echo "## **"$seed"**" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
    echo "" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"

    case $content_collection_filetype in
    pdf)
      echo "using pdfgrep against txt files in collection"
      afterKWIC=3
      beforeKWIC=1
      pdfgrep "$seed" -r -h -C 120  "$LOCAL_DATA"content_collections/"$content_collection_dirname" | uniq | sed G >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
    ;;
    txt)
      echo "using grep against txt files in collection"
      afterKWIC=3
      beforeKWIC=1
      grep -r -h -w --no-group-separator -A "$afterKWIC" -B "$beforeKWIC" "$seed" "$LOCAL_DATA"content_collections/"$content_collection_dirname" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
    ;;
    *)
    echo "assuming files in collection are txt and running grep"
      afterKWIC=3
      beforeKWIC=1
      grep -r -h -w --no-group-separator -A "$afterKWIC" -B "$beforeKWIC" "$seed" "$LOCAL_DATA"content_collections/"$content_collection_dirname" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
    ;;
    esac
    echo "" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
    echo "" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"

  done < "$TMPDIR"$uuid"/seeds/sorted.seedfile"

  echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
  echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
  sed -i 's/----//g' "$TMPDIR$uuid/content_collections/content_collections_results.md" #hack to remove confusing markdown from gutenberg
  sed -i 's/<<<//g' "$TMPDIR$uuid/content_collections/content_collections_results.md" #hack to remove confusing markdown from gutenberg
done < "$TMPDIR$uuid/content_collections/content_collections_list"
