echo "# Search Engine Snippets" > $TMPDIR$uuid/googler.md
echo "" >> $TMPDIR$uuid/googler.md
echo "search carried out at $(date -u)" >> $TMPDIR$uuid/googler.md
echo "" >> $TMPDIR$uuid/googler.md
while IFS= read -r seed; do
  echo "running googler on $seed"
  echo "**"$seed"**" >> $TMPDIR$uuid/googler.md
  echo "" >> $TMPDIR$uuid/googler.md
  "$scriptpath"lib/googler/googler -C --noprompt "$seed" >> $TMPDIR$uuid/googler.md
  echo "" >> $TMPDIR$uuid/googler.md
  echo "" >> $TMPDIR$uuid/googler.md
done < "$TMPDIR"$uuid"/seeds/filtered.pagehits"
