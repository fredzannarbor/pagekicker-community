echo "$content_collections" | sed -e 's/; /;/g' -e 's/;/\n/g' > "$TMPDIR$uuid/content_collections/content_collections_list"
echo -n "searching the following content collections: "
cat "$TMPDIR$uuid/content_collections/content_collections_list"

echo "# Local Content" > "$TMPDIR$uuid/content_collections/content_collections_results.md"
echo "" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
echo "searches carried out at $(date -u)" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
echo "" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"

while IFS= read -r collection; do
  mkdir "$TMPDIR$uuid/content_collections/$collection"
  . "$LOCAL_DATA/content_collections/$collection/$collection.cfg"

  while IFS= read -r seed; do
    echo "searching $collection on $seed"
    echo "## **"$seed"**" >> "$TMPDIR$uuid/content_collections/$collection/results.md"
    echo "" >> "$TMPDIR$uuid/content_collections/$collection/results.md"
    afterKWIC=3
    beforeKWIC=1
    grep -r -h -w --no-group-separator -A "$afterKWIC" -B "$beforeKWIC" "$seed" "$LOCAL_DATA"content_collections/"$content_collection_dirname" >> "$TMPDIR$uuid/content_collections/$collection/results.md"

    echo "" >> "$TMPDIR$uuid/content_collections/$collection/results.md"
    echo "" >> "$TMPDIR$uuid/content_collections/$collection/results.md"

  done < "$TMPDIR"$uuid"/seeds/sorted.seedfile"

  cat "$TMPDIR$uuid/content_collections/$collection/results.md" >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
  echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"s.
  echo "  " >> "$TMPDIR$uuid/content_collections/content_collections_results.md"
  sed -i 's/----//g' "$TMPDIR$uuid/content_collections/content_collections_results.md" #hack to remove confusing markdown from gutenberg
done < "$TMPDIR$uuid/content_collections/content_collections_list"
