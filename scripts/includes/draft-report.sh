#!/bin/bash
# --booktype="draft-report"
# Front and back matter are minimized, candidate sentences for executive
# summary are provided."

# 1. create any unique parts of the book  that are needed
# 2. concatenates them and deliver complete.md to builder.

# tweak pp_summary to create Executive_summary


summary_length="5"
echo "creating executive summary"
"$PYTHON_BIN" bin/PKsum-clean.py -l "$summary_length" -o "$TMPDIR$uuid/exec_summary.txt" "$TMPDIR$uuid/clean_summary.txt"

echo By "$editedby" >> "$TMPDIR$uuid/titletop.md"
echo " " >> "$TMPDIR$uuid/titletop.md"

echo "# Candidate Sentences for Executive Summary" >> "$TMPDIR$uuid/executive_summary.md"
echo "  " >> "$TMPDIR$uuid/executive_summary.md"
cat "$TMPDIR$uuid/exec_summary.txt" >> "$TMPDIR$uuid/executive_summary.md"

cat \
"$TMPDIR$uuid/titletop.md" \
"$TMPDIR$uuid/executive_summary.md" \
"$TMPDIR$uuid/add_this_content.md" \
"$TMPDIR$uuid/chapters.md" \
"$TMPDIR$uuid/content_collections/content_collections_results.md" \
"$TMPDIR$uuid/googler.md" \
"$TMPDIR$uuid/googler-news.md" \
"$TMPDIR$uuid/sorted_uniqs.md" \
"$TMPDIR$uuid/analyzed_webpage.md" \
"$TMPDIR$uuid/acronyms.md" \
"$TMPDIR$uuid/sources.md" \
"$TMPDIR$uuid/yaml-metadata.md" \
"$TMPDIR$uuid/settings.md" \
> "$TMPDIR$uuid/draft-report.md"

# "$TMPDIR$uuid/conclusion.md"
# "$TMPDIR$uuid/appendices_front_page.md" \
