echo " " >> $TMPDIR$uuid/settings.md
echo " " >> $TMPDIR$uuid/settings.md
echo "# Settings" >> $TMPDIR$uuid/settings.md
echo "When I build a book there are many parameters that guide my authoring strategy.  A few of the key ones are listed below." >> $TMPDIR$uuid/settings.md
echo " "  >> $TMPDIR$uuid/settings.md
echo "**Search seeds I used after screening and deduplication:**" >> $TMPDIR$uuid/settings.md
echo " " >> $TMPDIR$uuid/settings.md
cat $TMPDIR$uuid/seeds/sorted.seedfile | sed G >> $TMPDIR$uuid/settings.md
echo " " >> $TMPDIR$uuid/settings.md
echo "**Expand seeds via page title strategy?**" $expand_seeds_to_pages >> $TMPDIR$uuid/settings.md
echo " " >> $TMPDIR$uuid/settings.md
echo " " >> $TMPDIR$uuid/settings.md
