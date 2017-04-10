#!/bin/bash
# --booktype="daily-email"
# Front and back matter are minimized, candidate sentences for executive
# summary are provided."

# 1. create any unique parts of the book  that are needed
# 2. concatenates them and deliver complete.md to builder.

# tweak pp_summary to create Executive_summary


summary_length="5"

echo "creating daily-email"
mkdir -m 775 -p "$TMPDIR$uuid/daily-email"

N=1
while read -r line
do
    sed -n "$N"p "$TMPDIR$uuid/seeds/filtered.pagehits" > "$TMPDIR$uuid/daily-email/thisfile$N"
   "$PYTHON_BIN"  $scriptpath"bin/wikifetcher.py" \
  --infile "$TMPDIR$uuid/daily-email/thisfile$N" \
  --outfile "$TMPDIR$uuid/daily-email/wiki$N.md" \
  --lang "$wikilocale" \
  --summary
  cat "$TMPDIR$uuid/daily-email/wiki$N.md" >> "$TMPDIR$uuid/daily-email/postpend.md"
  ((N++))
done < "$TMPDIR$uuid/seeds/filtered.pagehits"

echo "# PageKicker Daily" >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "## Hi there!" >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "Welcome to PageKicker Daily." >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "A random image from your personal stash is attached below, followed by a random definition from Samuel Johnson's Dictionary of the English Language, then background on your recent reading." >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "## Today's Dose of Samuel Johnson" >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo '<blockquote>' >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "$(fortune)" >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo '</blockquote>' >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"

cat "$TMPDIR$uuid/daily-email/postpend.md" >> "$TMPDIR$uuid/daily-email/daily-email.md"
current_image=$(get_desktop_img | sed -e 's/file:\/\///'g -e "s/'//"g)
# echo "## Current Desktop Image" >> "$TMPDIR$uuid/daily-email/daily-email.md"
# echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"
# echo '!['"Current Desktop Image"']'"(""$current_image"")" >> "$TMPDIR$uuid/daily-email/daily-email.md"
# echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"

pandoc -s -o "$TMPDIR$uuid/daily-email/daily-email.html" "$TMPDIR$uuid/daily-email/daily-email.md"

#emailbody=$(<$TMPDIR$uuid/daily-email.md)
sendemail -t "wfzimmerman@gmail.com" \
  -u "PageKicker Daily" \
  -f "$GMAIL_ID" \
  -cc "$GMAIL_ID" \
  -xu "$GMAIL_ID" \
  -xp "$GMAIL_PASSWORD" \
  -s smtp.gmail.com:587 \
  -v \
  -o tls=yes \
  -o message-content-type=html \
  -o message-file="$TMPDIR$uuid/daily-email/daily-email.html" \
  -a "$current_image"
