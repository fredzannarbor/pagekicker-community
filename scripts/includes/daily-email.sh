#!/bin/bash
# --booktype="daily-email"
# Front and back matter are minimized, candidate sentences for executive
# summary are provided."

# 1. create any unique parts of the book  that are needed
# 2. concatenates them and deliver complete.md to builder.

# tweak pp_summary to create Executive_summary


summary_length="5"

# optionally add seed for the day section of the book

. includes/seedfortheday.sh

echo "creating daily-email"
mkdir -m 775 -p "$TMPDIR$uuid/daily-email"

N=1
while read -r line
do
   #echo  "$PYTHON_BIN"  $scriptpath"bin/wikifetcher.py" | tee --append "$TMPDIR$uuid/daily-email/test"
    sed -n "$N"p "$TMPDIR$uuid/seeds/filtered.pagehits" > "$TMPDIR$uuid/daily-email/thisfile$N"
   "$PYTHON_BIN"  $scriptpath"bin/wikifetcher.py" \
  --infile "$TMPDIR$uuid/daily-email/thisfile$N" \
  --outfile "$TMPDIR$uuid/daily-email/wiki$N.md" \
  --lang "$wikilocale" \
  --summary
  cat "$TMPDIR$uuid/daily-email/wiki$N.md" >> "$TMPDIR$uuid/daily-email/postpend.md"
  ((N++))
done < "$TMPDIR$uuid/seeds/filtered.pagehits"

#echo "# $booktitle" >> "$TMPDIR$uuid/daily-email/daily-email.md"
#echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"
#echo "## Hi there!" >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"
#echo "Welcome to my daily algorithmic publishing results." >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"
#echo "A random image from your personal stash is attached below, followed by a random definition from Samuel Johnson's Dictionary of the English Language, then background on your recent reading." >> "$TMPDIR$uuid/daily-email/daily-email.md"
#echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "## Today's Dose of Samuel Johnson" >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo '<blockquote>' >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "$(/usr/games/fortune johnson)" >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo '</blockquote>' >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"

cat "$TMPDIR$uuid/daily-email/postpend.md"  "$TMPDIR$uuid/wiki/seedfortheday.md" >> "$TMPDIR$uuid/daily-email/daily-email.md"

# need to make imagepicker platform-independent
# need image management approach - symbolic linking

# current_image=$(get_desktop_img | sed -e 's/file:\/\///'g -e "s/'//"g)


pandoc -s -o "$TMPDIR$uuid/daily-email/daily-email.html" "$TMPDIR$uuid/daily-email/daily-email.md"

#emailbody=$(<$TMPDIR$uuid/daily-email.md)
sendemail -t "wfzimmerman@gmail.com" \
  -u "Algorithmic Publishing Daily Results" \
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

if [ "$daily_email_post_to_wp" = "yes" ] ; then
  "$WP_BIN" post create "$TMPDIR$uuid/daily-email/daily-email.html" --post_type=post --post_status="$daily_email_post_to_wp_status" --post_title="$booktitle" --post_mime_type=html
else
  echo "not posting to wp"
fi
