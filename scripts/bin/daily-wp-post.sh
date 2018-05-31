#!/bin/bash

if shopt -q  login_shell ; then

	if [ ! -f "$HOME"/.pagekicker/config.txt ]; then
		echo "config file not found, creating /home/<user>/.pagekicker, you need to put config file there"
		mkdir -p -m 755 "$HOME"/.pagekicker
		echo "exiting"
		exit 1
	else
		. "$HOME"/.pagekicker/config.txt
		echo "read config file from login shell $HOME""/.pagekicker/config.txt"
	fi
else
	.  "$HOME"/.pagekicker/config.txt #hard-coding /home is a hack
	echo "read config file from nonlogin shell /home/$(whoami)/.pagekicker/config.txt"
fi

cd $scriptpath

. includes/set-variables.sh


my_twitter_handle="fredzannarbor"
name="Samuel Johnson"
postauthorid="2"
uuid=$("$PYTHON_BIN"  -c 'import uuid; print(uuid.uuid1())')

echo "creating daily wordpress post"
echo "$TMPDIR$uuid"

mkdir -m 775 -p "$TMPDIR$uuid/wordpress"


$FORTUNE_BIN johnson >> "$TMPDIR$uuid/wordpress/johnson_wotd.txt"
cat "$TMPDIR$uuid/wordpress/johnson_wotd.txt"
wotd_name=$(cat "$TMPDIR$uuid/wordpress/johnson_wotd.txt" | head -n 1 | cut -d" " -f1)
if [ "$wotd_name" = "To" ] ;
  then
		wotd_name=$(cat "$TMPDIR$uuid/wordpress/johnson_wotd.txt" | head -n 1 | cut -d" " -f2)
	else
		true
fi
# echo "$wotd_name"
# echo "$wotd_name" > "$TMPDIR$uuid/wordpress/johnson_wotd.md"

echo "## My Word of the Day" >> "$TMPDIR$uuid/wordpress/wotd_h2.txt"

cat "$TMPDIR$uuid/wordpress/wotd_h2.txt" "$TMPDIR$uuid/wordpress/johnson_wotd.txt" >>  "$TMPDIR$uuid/wordpress/johnson_wotd.md"


echo -e "\n" >> "$TMPDIR$uuid/wordpress/johnson_wotd.md"


echo "## Recent references to $wotd_name on Twitter" >> "$TMPDIR$uuid/wordpress/johnson_wotd.md"

t search all "$wotd_name lang:en -RT -$my_twitter_handle" >> "$TMPDIR$uuid/wordpress/johnson_wotd.md"

echo -e "\n" >> "$TMPDIR$uuid/wordpress/johnson_wotd.md"


echo "## Recent references to $name on Twitter" >> "$TMPDIR$uuid/wordpress/johnson_wotd.md"

t search all "Samuel Johnson lang:en -RT -$my_twitter_handle" >> "$TMPDIR$uuid/wordpress/johnson_wotd.md"

pandoc -f markdown -t html -o "$TMPDIR$uuid/wordpress/johnson_wotd.html" "$TMPDIR$uuid/wordpress/johnson_wotd.md"

"$WP_BIN" post create "$TMPDIR$uuid/wordpress/johnson_wotd.html"  --post_type=post --post_status="publish" --post_title="Daily Dose of Samuel Johnson: $wotd_name & more" --post_mime_type=html --post_category="words-language" --post_author="$postauthorid"
