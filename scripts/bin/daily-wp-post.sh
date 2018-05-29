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

uuid=$("$PYTHON_BIN"  -c 'import uuid; print(uuid.uuid1())')

echo "creating daily wordpress post"
echo "$TMPDIR$uuid"

mkdir -m 775 -p "$TMPDIR$uuid/wordpress"


echo "$(fortune johnson)" >> "$TMPDIR$uuid/wordpress/johnson_wotd.txt"
cat "$TMPDIR$uuid/wordpress/johnson_wotd.txt"
wotd_name=$(cat "$TMPDIR$uuid/wordpress/johnson_wotd.txt" | head -n 1 | cut -d" " -f1)
echo "$wotd_name"
# echo "$wotd_name" > "$TMPDIR$uuid/wordpress/johnson_wotd.md"

# cat "$TMPDIR$uuid/wordpress/johnson_wotd.txt" >>  "$TMPDIR$uuid/wordpress/johnson_wotd.md"

pandoc -s -o "$TMPDIR$uuid/wordpress/johnson_wotd.html" "$TMPDIR$uuid/wordpress/johnson_wotd.txt"

"$WP_BIN" post create "$TMPDIR$uuid/wordpress/johnson_wotd.html"  --post_type=post --post_status="publish" --post_title="Samuel Johnson WOTD $wotd_name" --post_mime_type=html --post_category="words-language"
