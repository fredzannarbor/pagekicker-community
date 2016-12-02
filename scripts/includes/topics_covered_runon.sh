echo '\pagenumbering{gobble}' > $TMPDIR$uuid/topics_covered.md
echo "  " >>  "$TMPDIR"$uuid/topics_covered.md
echo "# Topics Covered" >>  "$TMPDIR"$uuid/topics_covered.md
echo "  " >>  "$TMPDIR"$uuidtopics_covered.md
cat "$TMPDIR"$uuid/seeds/filtered.pagehits | awk '{printf("%s, ",$0)}' | sed 's/,\s*$//' >>  "$TMPDIR"$uuid/topics_covered.md
echo "  " >>  "$TMPDIR"$uuid/topics_covered.md
echo "  " >>  "$TMPDIR"$uuid/topics_covered.md
