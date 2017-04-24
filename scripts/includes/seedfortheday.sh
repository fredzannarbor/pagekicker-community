# gets encylopedia content related to the current date

today=$(date +%B" "%d)

if [ -n "$seedfortheday" ] ; then
  echo "seed for the day added to seedfile"
  date +%B" "%d >> "$TMPDIR$uuid/seeds/seedfortheday"
  "$PYTHON_BIN"  $scriptpath"bin/wikifetcher.py" \
  --infile "$TMPDIR$uuid/seeds/seedfortheday" \
  --outfile "$TMPDIR$uuid/wiki/seedfortheday-raw.md" \
  --lang "$wikilocale"

  sed -e s/\=\=\=\=\=/JQJQJQJQJQ/g -e s/\=\=\=\=/JQJQJQJQ/g -e s/\=\=\=/JQJQJQ/g -e s/\=\=/JQJQ/g -e s/Edit\ /\ /g -e s/JQJQJQJQJQ/\#\#\#\#\#/g -e s/JQJQJQJQ/\#\#\#\#/g -e s/JQJQJQ/\#\#\#/g -e s/JQJQ/\#\#/g  "$TMPDIR"$uuid/wiki/seedfortheday-raw.md | sed G > "$TMPDIR"$uuid/wiki/seedfortheday-postpend.md
  sed -i '2d' "$TMPDIR$uuid/wiki/seedfortheday-postpend.md"
  echo "  " >> "$TMPDIR$uuid/wiki/seedfortheday.md"
  echo "  " >> "$TMPDIR$uuid/wiki/seedfortheday.md"
  echo "# On This Day $today" >> "$TMPDIR$uuid/wiki/seedfortheday.md"
  cat "$TMPDIR$uuid/wiki/seedfortheday-postpend.md" >> "$TMPDIR$uuid/wiki/seedfortheday.md"
else
  echo "no seed for the day"
fi
