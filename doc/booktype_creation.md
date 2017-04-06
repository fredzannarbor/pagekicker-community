## Adding a new **booktype**

In PageKicker the **booktype** is an explicit definition of the rules that are used for creating electronic codexes, i.e. content that is wrapped in "containers" like pages wrapped in a bound book. Booktypes include entities such as encyclopedias, dictionaries, chapbooks, and anthologies. Another way of describing such entities is as "chunk-ables" that can be published on their own. At the most practical level, booktypes exist and have evolved over the centuries because they _work._ Following a known format - or inventing a new one! - can make an enormous contribution to the success of author, publisher, and book, and to the happiness of readers, librarians and even critics.

In PageKicker, booktypes go beyond "chunk-ables" such as encyclopedia and include other, lower-level attributes that define structure, substance, and style.  Structure is defined in terms of "parts of the book" such as acknowledgement, foreword, epigraph, part, chapter, bibliography, and index.  Substance is defined by rules that govern the search, creation, and assembly strategy for each part of the book.  For example, the substance rule for "encyclopedia" might be "search for all content relevant to the seed phrases and assemble each document in alphabetical order". Similarly, a rule for style might be "use the order of parts specified by the Chicago Manual of the Style" (this is the default).

The **$booktype** variable is specified at runtime. Like most variables in PageKicker, the order of precedence is (in ascending order), the config file _~/.pagekicker,_ the default variable values file _scripts/includes/set-variables.sh_, and the command line as --booktype.  Note that the value of $booktype provided at the command line can be overridden by values specified in _jobprofiles_ for robots or imprints.  Thus, if an  imprint file explicitly defines the booktype as always "encyclopedia", PageKicker will always create all books for that imprint as encylopedias.  For this reason, it is recommended that booktypes should not be specified in imprints (unless the imprint always publishes one and only one type of book).

When the _builder_ script runs, it uses a case statement to look for the value of **$booktype** and run the corresponding script.   That booktypes are defined and created by scripts is probably not ideal--it might be better to have them defined strictly as data objects--but on the plus side it does largely isolate the changes.  The default booktype is "reader", which is a codex nonfiction with parts of the book in order as specified in the Chicago Manual of Style, i.e. front matter, body, back matter. One booktype has recently been added, _draft-report_. The purpose of _draft-report_ is to streamline the reader format to only those parts of the book that are helpful in jump-starting the writing of report, i.e. title, an executive summary, content, and bibliography -- much reduced front matter. PageKicker continues to make all its standard products in reader format using epub & mobi, but adds a Word format version of draft-report to its delivery to the user.

The procedure for adding a new booktype is relatively straightforward.  The first step is to add a new clause to the [booktype case construct](https://github.com/fredzannarbor/pagekicker-community/blob/bf0e752097451c8a137829388bfe7da06cd4fa5c/scripts/bin/builder.sh#L1090). The case construct for draft-report looks like this:

```
draft-report)
	echo "assembling parts needed for $booktype"
  . includes/draft-report.sh
	"$PANDOC_BIN" -o "$TMPDIR$uuid/draft-report-$safe_product_name.docx"   "$TMPDIR"$uuid/draft-report.md
	# note that draft-report does not get SKU because it is not a completed product
  ;;
```
So, to add a new case  clause for, let us say, a chapbook, the format would look like this:

```
chapbook)
 echo "assembling parts needed for $booktype"
  . includes/chapbook.sh
 "$PANDOC_BIN" -o "$TMPDIR$uuid/$sku-chapbook-$safe_product_name.epub" \ "$TMPDIR"$uuid/chapbook.md
  ;;
```
The chapbook script will reside in _pagekicker-community/scripts/includes_.  It need not be a shell script, it could be Python or any other language. The chapbook script has one major responsibility: to return the file chapbook.md to the assembly area at _$TMPDIR$uuid_, which will then use **pandoc** to convert it into an epub format document.  (Additional formats could be created by adding additional pandoc commands with different output extensions).  By convention, the book files are named with an SKU followed by a safe product name, which is the literal book title with special characters converted into underscores, e.g. 12345678-The_Plant.epub.  The ;; command concludes the case clause.

Since the _chapbook_ script runs as a sourced include (part of the main script), all defined PageKicker variables are available to it.  Since as mentioned above all parts of the book required for _reader_ are built by default, _chapbook_ is only responsible for creating any unique parts needed for a chapbook.  While chapbooks have a long history and were created for a wide variety of purposes, the most common modern usage is for small collections of poetry by a single author.  Thus, we will assume that the script needs to write a number of poems. Take a look at the [code for draft-report.sh](https://github.com/fredzannarbor/pagekicker-community/blob/master/scripts/includes/draft-report.sh), which includes three major parts: comments, part creation, and assembly.

The script begins by documenting our work.

```
#!/bin/bash
# --booktype="chapbook"
# A specified number of poems are created.
# There is a limit on word count.
# Other attributes may be implemented as desired.
# See http://www.baymoon.com/~ariadne/chapbooks.htm
# for a helpful guide to possible attributes.
# The script must return chapbook.md to $TMPDIR$uuid.
```
The script is then responsible for creating its specified parts of the book.  In this case, we will assume that the default number of poems is 20 and the default maximum word count is 10,000.  For the moment, this will be merely a mockup that uses a hypothetical poem generator.
```
poems="20"
poem_max_wordcount="10000"

echo "running poem script"
$PYTHON_BIN "poet.py" --poems "20" --maxwords "10000" -o "$TMPDIR$uuid/poems.md" --numbering "on"

```
Now the script must blend its unique content into the material already created by PageKicker, which is defined as follows for the _reader_ booktype.

```
"$TMPDIR$uuid/titlepage.md" \
"$TMPDIR$uuid/robo_ack.md" \
"$TMPDIR$uuid/settings.md" \
"$TMPDIR$uuid/rebuild.md" \
"$TMPDIR$uuid/tldr.md" \
"$TMPDIR$uuid/listofpages.md" \
"$TMPDIR$uuid/humansummary.md" \
"$TMPDIR$uuid/programmaticsummary.md" \
"$TMPDIR$uuid/add_this_content.md" \
"$TMPDIR$uuid/chapters.md" \
"$TMPDIR$uuid/content_collections/content_collections_results.md" \
"$TMPDIR$uuid/googler.md" \
"$TMPDIR$uuid/googler-news.md" \
"$TMPDIR$uuid/sorted_uniqs.md" \
"$TMPDIR$uuid/analyzed_webpage.md" \
"$TMPDIR$uuid/acronyms.md" \
"$TMPDIR$uuid/twitter/sample_tweets.md" \
"$TMPDIR$uuid/allflickr.md" \
"$TMPDIR$uuid/sources.md" \
"$TMPDIR$uuid/changelog.md" \
"$TMPDIR$uuid/builtby.md" \
"$TMPDIR$uuid/byimprint.md" \
"$TMPDIR$uuid/imprint_mission_statement.md" \
"$TMPDIR$uuid/yaml-metadata.md" \
> "$TMPDIR$uuid/complete.md"
```
The main point here is that for our _chapbook_ booktype we can get rid of many of these parts of the book.

```
"$TMPDIR$uuid/titlepage.md" \
"$TMPDIR$uuid/robo_ack.md" \
~~"$TMPDIR$uuid/settings.md" \
"$TMPDIR$uuid/rebuild.md" \
"$TMPDIR$uuid/tldr.md" \~~
"$TMPDIR$uuid/listofpages.md" \
~~"$TMPDIR$uuid/humansummary.md" \
"$TMPDIR$uuid/programmaticsummary.md" \
~~"$TMPDIR$uuid/add_this_content.md" \
~~"$TMPDIR$uuid/chapters.md" \
"$TMPDIR$uuid/content_collections/content_collections_results.md" \~~
~~"$TMPDIR$uuid/googler.md" \
"$TMPDIR$uuid/googler-news.md" \
"$TMPDIR$uuid/sorted_uniqs.md" \
"$TMPDIR$uuid/analyzed_webpage.md" \
"$TMPDIR$uuid/acronyms.md" \
"$TMPDIR$uuid/twitter/sample_tweets.md" \
"$TMPDIR$uuid/allflickr.md" \
"$TMPDIR$uuid/sources.md" \~~
"$TMPDIR$uuid/changelog.md" \
"$TMPDIR$uuid/builtby.md" \
"$TMPDIR$uuid/byimprint.md" \
"$TMPDIR$uuid/imprint_mission_statement.md" \
"$TMPDIR$uuid/yaml-metadata.md" \
> "$TMPDIR$uuid/complete.md"
```
and then add in poems.md and redirect the cumulative output to chapbook.md:

```
"$TMPDIR$uuid/titlepage.md" \
"$TMPDIR$uuid/robo_ack.md" \
"$TMPDIR$uuid/listofpages.md" \
"$TMPDIR$uuid/**poems.md" **\
"$TMPDIR$uuid/changelog.md" \
"$TMPDIR$uuid/builtby.md" \
"$TMPDIR$uuid/byimprint.md" \
"$TMPDIR$uuid/imprint_mission_statement.md" \
"$TMPDIR$uuid/yaml-metadata.md" \
> "$TMPDIR$uuid/**chapbook.md"**
```
