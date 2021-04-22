if [ -z "$tldr" ]; then
  echo "  " >>  "$TMPDIR"$uuid/tldr.md
  echo "  " >>  "$TMPDIR"$uuid/tldr.md
  echo "# Programmatic TL;DR:" >>  "$TMPDIR"$uuid/tldr.md
  #cat $TMPDIR$uuid/shortest_summary.md >>  "$TMPDIR"$uuid/tldr.md
else
  echo "  " >>  "$TMPDIR"$uuid/tldr.md
  echo "  " >>  "$TMPDIR"$uuid/tldr.md
  echo "# TL;DR:" >>  "$TMPDIR"$uuid/tldr.md
  echo "$tldr" >>  "$TMPDIR"$uuid/tldr.md
fi
echo "  " >>  "$TMPDIR"$uuid/tldr.md
echo "  " >>  "$TMPDIR"$uuid/tldr.md
