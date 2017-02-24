#!/bin/bash
# --booktype="draft-report"
# shortens time to go from blank page to completed report
# by producing a draft report.  Front and back matter are minimized.

# 1. create any unique parts of the book  that are needed
# 2. concatenates them and deliver complete.md to builder.


cat \
"$TMPDIR$uuid/titlepage.md" \
"$TMPDIR$uuid/executive_summary" \
"$TMPDIR$uuid/add_this_content.md" \
"$TMPDIR$uuid/chapters.md" \
"$TMPDIR$uuid/googler.md" \
"$TMPDIR$uuid/googler-news.md" \
"$TMPDIR$uuid/conclusion.md" \
"$TMPDIR$uuid/appendices_front_page.md" \
"$TMPDIR$uuid/sorted_uniqs.md" \
"$TMPDIR$uuid/analyzed_webpage.md" \
"$TMPDIR$uuid/acronyms.md" \
"$TMPDIR$uuid/yaml-metadata.md" \
"$TMPDIR$uuid/settings.md" \
> "$TMPDIR$uuid/complete.md"
