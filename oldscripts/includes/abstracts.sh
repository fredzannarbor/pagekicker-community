case $summary in
summaries_only)
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  echo "# Abstracts" >>  "$TMPDIR"$uuid/humansummary.md
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  cat "$TMPDIR"$uuid"/wiki/wikisummaries.md" | sed -e 's/#/##/' >>  "$TMPDIR"$uuid/humansummary.md
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  ;;
complete_pages_only)
  echo "using complete pages only for main body"
  ;;
both)
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  echo "# Abstracts" >>  "$TMPDIR"$uuid/humansummary.md
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  cat "$TMPDIR"$uuid"/wiki/wikisummaries.md" | sed -e 's/#/##/' >>  "$TMPDIR"$uuid/humansummary.md
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
  echo "  " >>  "$TMPDIR"$uuid/humansummary.md
;;
*)
  echo "unrecognized summary option"
;;
esac
