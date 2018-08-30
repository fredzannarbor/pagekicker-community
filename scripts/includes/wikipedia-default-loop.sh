#expand seeds to valid wiki pages

if [ "$expand_seeds_to_pages" = "yes" ] ; then
		echo "$expand_seeds_to_pages"
		"$PYTHON27_BIN" bin/wiki_seeds_2_pages.py --infile "$TMPDIR"$uuid"/seeds/sorted.seedfile" --pagehits "$TMPDIR"$uuid"/seeds/pagehits"
else
		echo "not expanding seeds to pages"
		cp "$TMPDIR"$uuid"/seeds/sorted.seedfile" "$TMPDIR"$uuid"/seeds/pagehits"
fi

# filter pagehits

sort -u  "$TMPDIR"$uuid/seeds/pagehits >  "$TMPDIR"$uuid/seeds/filtered.pagehits

echo "--- filtered pagehits are ---"
cat  "$TMPDIR"$uuid/seeds/filtered.pagehits

echo "--- end of pagehits ---"

# fetch by pagehits

case "$summary" in
summaries_only)
	echo "fetching page summaries only"
	"$PYTHON_BIN"  $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR$uuid /seeds/filtered.pagehits" --outfile "$TMPDIR"$uuid/"wiki/wikisummariesraw.md" --lang "$wikilocale" --summary  1> /dev/null
	sed -e s/\=\=\=\=\=/JQJQJQJQJQ/g -e s/\=\=\=\=/JQJQJQJQ/g -e s/\=\=\=/JQJQJQ/g -e s/\=\=/JQJQ/g -e s/Edit\ /\ /g -e s/JQJQJQJQJQ/\#\#\#\#\#/g -e s/JQJQJQJQ/\#\#\#\#/g -e s/JQJQJQ/\#\#\#/g -e s/JQJQ/\#\#/g  "$TMPDIR"$uuid/wiki/wikisummariesraw.md | sed G >  "$TMPDIR"$uuid/wiki/wikisummaries.md
	cp  "$TMPDIR"$uuid/wiki/wikisummaries.md  "$TMPDIR"$uuid/wiki/wikiall.md
	wordcountsummaries=$(wc -w "$TMPDIR"$uuid/wiki/wikisummaries.md | cut -f1 -d' ')
	cp "$TMPDIR"$uuid"/wiki/wikisummaries.md" "$TMPDIR"$uuid"/wiki/wiki4cloud.md"
;;
complete_pages_only)
	echo "fetching complete pages only"
	"$PYTHON_BIN" $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR"$uuid"/seeds/filtered.pagehits" --outfile "$TMPDIR"$uuid"/wiki/wikipagesraw.md" --lang "$wikilocale"  1> /dev/null
	sed -e s/\=\=\=\=\=/JQJQJQJQJQ/g -e s/\=\=\=\=/JQJQJQJQ/g -e s/\=\=\=/JQJQJQ/g -e s/\=\=/JQJQ/g -e s/Edit\ /\ /g -e s/JQJQJQJQJQ/\#\#\#\#\#/g -e s/JQJQJQJQ/\#\#\#\#/g -e s/JQJQJQ/\#\#\#/g -e s/JQJQ/\#\#/g  "$TMPDIR"$uuid/wiki/wikipagesraw.md | sed G >  "$TMPDIR"$uuid"/wiki/wikipages.md"
	wordcountpages=$(wc -w "$TMPDIR"$uuid"/wiki/wikipages.md" | cut -f1 -d' ')
	cp "$TMPDIR"$uuid"/wiki/wikipages.md" "$TMPDIR"$uuid"/wiki/wiki4cloud.md"
	cp  "$TMPDIR"$uuid/wiki/wikipages.md  "$TMPDIR"$uuid/wiki/wikiall.md
;;
both)
	echo "fetching both summaries and complete pages"
	echo "fetching page summaries now"
	"$PYTHON_BIN"  $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR"$uuid"/seeds/filtered.pagehits" --outfile "$TMPDIR"$uuid"/wiki/wikisummaries1.md" --lang "$wikilocale" --summary
	echo "fetching complete pages now"
	"$PYTHON_BIN" $scriptpath"bin/wikifetcher.py" --infile "$TMPDIR"$uuid"/seeds/filtered.pagehits" --outfile "$TMPDIR"$uuid"/wiki/wikipages1.md" --lang "$wikilocale"
	sed -e s/\=\=\=\=\=/JQJQJQJQJQ/g -e s/\=\=\=\=/JQJQJQJQ/g -e s/\=\=\=/JQJQJQ/g -e s/\=\=/JQJQ/g -e s/Edit\ /\ /g -e s/JQJQJQJQJQ/\#\#\#\#\#/g -e s/JQJQJQJQ/\#\#\#\#/g -e s/JQJQJQ/\#\#\#/g -e s/JQJQ/\#\#/g  "$TMPDIR"$uuid"/wiki/wikisummaries1.md" | sed G >  "$TMPDIR"$uuid/wiki/wikisummaries.md
	sed -e s/\=\=\=\=\=/JQJQJQJQJQ/g -e s/\=\=\=\=/JQJQJQJQ/g -e s/\=\=\=/JQJQJQ/g -e s/\=\=/JQJQ/g -e s/Edit\ /\ /g -e s/JQJQJQJQJQ/\#\#\#\#\#/g -e s/JQJQJQJQ/\#\#\#\#/g -e s/JQJQJQ/\#\#\#/g -e s/JQJQ/\#\#/g  "$TMPDIR"$uuid"/wiki/wikipages1.md" | sed G >  "$TMPDIR"$uuid/wiki/wikipages.md

wordcountpages=1
	#wordcountpages=$(wc -w "$TMPDIR"$uuid"/wiki/wikipages.md" | cut -f1 -d' ')
  wordcountpages=$(cat "$TMPDIR"$uuid"/wiki/wikipages.md" | tr '\n' ' ' | wc -w | tr -d ' ')
	echo "Wordcount pages is" $wordcountpages
		if [ "$wordcountpages" -gt 100000 ] ; then
			cp  "$TMPDIR"$uuid/wiki/wikisummaries.md  "$TMPDIR"$uuid/wiki/wiki4cloud.md
			cp  "$TMPDIR"$uuid/wiki/wikisummaries.md  "$TMPDIR"$uuid/wiki/wiki4chapters.md
			echo "body too big for wordcloud, using abstracts only"
		else
			 cp "$TMPDIR$uuid/wiki/wikipages.md"  "$TMPDIR$uuid/wiki/wiki4cloud.md"
			 cp  "$TMPDIR"$uuid/wiki/wikipages.md  "$TMPDIR"$uuid/wiki/wiki4chapters.md
			echo "building wordcloud from body"
		fi
;;
*)
	echo "unrecognized summary option"
;;
esac
