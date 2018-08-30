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
exit 0
mkdir -m 775 -p "$TMPDIR$uuid/"daily-wordpress-post"

echo "## Today's Dose of Samuel Johnson" >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo '<blockquote>' >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "$(fortune johnson)" >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo '</blockquote>' >> "$TMPDIR$uuid/daily-email/daily-email.md"
echo "  " >> "$TMPDIR$uuid/daily-email/daily-email.md"

wotd=$(fortune johnson | head -n 1 | cut -d" " -f1)

pandoc -s -o "$TMPDIR$uuid/daily-email/daily-email.html" "$TMPDIR$uuid/daily-email/daily-email.md"

"$WP_BIN" post create "$TMPDIR$uuid/daily-email/daily-email.html" --post_type=post --post_status="$daily_email_post_to_wp_status" --post_title="Samuel Johnson WOTD: $wotd" --post_mime_type=html
