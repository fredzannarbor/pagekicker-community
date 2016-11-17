if [ "$add_this_content" = "none" ] ; then
	echo "no added content"
	touch $TMPDIR$uuid/add_this_content.
else
	echo "adding user content to front matter"
	cp "$add_this_content" "$TMPDIR"$uuid"/add_this_content_raw"
	echo "$add_this_content"
	"$PANDOC_BIN" -f docx -s -t markdown -o "$TMPDIR"$uuid"/add_this_content.md "$TMPDIR"$uuid/add_this_content_raw"
	cat $TMPDIR$uuid"/add_this_content.md" >> $TMPDIR$uuid/tmpbody.md
fi
