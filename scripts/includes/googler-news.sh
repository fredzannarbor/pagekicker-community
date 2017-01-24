echo "#  News Snippets" > $TMPDIR$uuid/googler-news.md
echo "" >> $TMPDIR$uuid/googler-news.md
echo "search carried out at $(date -u)" >> $TMPDIR$uuid/googler-news.md
echo "" >> $TMPDIR$uuid/googler-news.md
while IFS= read -r seed; do
  echo "running googler -n on $seed"
  echo "**"$seed"**" >> $TMPDIR$uuid/googler-news.md
  echo "" >> $TMPDIR$uuid/googler-news.md
  "$scriptpath"lib/googler/googler -C --noprompt --news "$seed" >> $TMPDIR$uuid/googler-news.md
  echo "" >> $TMPDIR$uuid/googler-news.md
  echo "" >> $TMPDIR$uuid/googler-news.md
done < "$TMPDIR"$uuid"/seeds/filtered.pagehits"
