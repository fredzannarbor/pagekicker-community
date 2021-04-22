echo " " > "$TMPDIR$uuid/settings.md"
echo " " >> "$TMPDIR$uuid/settings.md"
echo "# Settings" >> "$TMPDIR$uuid/settings.md"
echo "Key parameters are listed here." >> "$TMPDIR$uuid/settings.md"
echo " "  >> "$TMPDIR$uuid/settings.md"
echo "**Booktype:** " >> "$TMPDIR$uuid/settings.md"
echo "$booktype" >> "$TMPDIR$uuid/settings.md"
echo " "  >> "$TMPDIR$uuid/settings.md"
echo " "  >> "$TMPDIR$uuid/settings.md"
echo "**Search seeds after screening and deduplication:**" >> "$TMPDIR$uuid/settings.md"
echo " " >> "$TMPDIR$uuid/settings.md"
cat $TMPDIR$uuid/seeds/sorted.seedfile | sed G >> "$TMPDIR$uuid/settings.md"
echo " " >> "$TMPDIR$uuid/settings.md"
echo "**Expand seeds via page title strategy?**" $expand_seeds_to_pages >> "$TMPDIR$uuid/settings.md"
echo " " >> "$TMPDIR$uuid/settings.md"
echo " " >> "$TMPDIR$uuid/settings.md"