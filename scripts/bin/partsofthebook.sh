# assembling front matter
# assumes that all files exist but size 0 if not available for book
TMPDIR="/tmp/pagekicker/"
cat \
$TMPDIR$uuid/titlepage.md \
$TMPDIR$uuid/robo_ack.md \
$TMPDIR$uuid/rebuild.md \
$TMPDIR$uuid/tldr.md \
$TMPDIR$uuid/humansummary.md \
$TMPDIR$uuid/programmaticsummary.md \
$TMPDIR$uuid/add_this_content.md \
$TMPDIR$uuid/chapters.md \
$TMPDIR$uuid/sorted_uniqs.md \
$TMPDIR$uuid/analyzed_webpage.md \
$TMPDIR$uuid/twitter/sample_tweets.md \
$TMPDIR$uuid/allflickr.md \
$TMPDIR$uuid/builtby.md \
$TMPDIR$uuid/byimprint.md \
$TMPDIR$uuid/yaml-metadata.md \
> $TMPDIR$uuid/complete.md
