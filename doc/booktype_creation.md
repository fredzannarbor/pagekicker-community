# Adding a new booktype to PageKicker

In the PageKicker algorithmic publishing platform the **booktype** is an explicit definition of the rules that are used for creating electronic codexes, i.e. content that is wrapped in "containers" like pages wrapped in a bound book. **Booktypes** include entities such as anthologies, chapbooks, dictionaries, encyclopedias, epic poems, and novels. Another way of describing such entities is as "chunk-ables" that can be published on their own, sufficiently valuable that they can be thrust into the stream of commerce (without a paddle?). At the most practical level, booktypes exist and have evolved over the centuries because they _work._ Following a known format - or inventing a new one! - can make an enormous contribution to the success of author, publisher, and book, and to the happiness of readers, librarians and even critics.

In PageKicker, booktypes go beyond "chunk-ables" such as encyclopedia and include other, lower-level attributes that define structure, substance, and style.  Structure is defined in terms of "parts of the book" such as acknowledgement, foreword, epigraph, part, chapter, bibliography, and index.  Substance is defined by rules that govern the search, creation, and assembly strategy for each part of the book.  For example, the substance rule for "encyclopedia" might be "search for all content relevant to the seed phrases and assemble each document in alphabetical order". Similarly, a rule for style might be "use the order of parts specified by the Chicago Manual of the Style".  

PageKicker's approach to booktypes is an algorithmic abstraction of an important aspect of traditional publishing.  Early in the acquisition and development stage an author or publisher who is contemplating a book on a particular topic for a particular audience must consider what is the best format for the job.  The default is usually the standard codex book, i.e. front matter, sequential chapters, back matter, but as noted above there are scores of options that have been developed over 500+ years of publishing. The algorithmic approach enables the publisher to define and continually improve consistent rules for creating books in a particular format.  The publisher can also switch from one booktype to another instantly and painlessly experiment with different approaches to the same work.

## Technical Details

The default booktype is _reader_, which is a codex nonfiction with parts of the book in order as specified in the Chicago Manual of Style, i.e. front matter, body, back matter. One _booktype_ has recently been added, _draft-report_. The purpose of _draft-report_ is to streamline the reader format to only those parts of the book that are helpful in jump-starting the writing of report, i.e. title, an executive summary, content, and bibliography--much reduced front matter.

**Booktype** is one of several hundred variables that the PageKicker system accesses during book creation.
The **$booktype** variable is specified at runtime. Like most variables in PageKicker, the order of precedence is (in ascending order), the config file _~/.pagekicker,_ the default variable values file _scripts/includes/set-variables.sh_, and the command line as _--booktype._  Note that the value of **$booktype** provided at the command line can be overridden by values specified in _jobprofiles_ for robots or imprints.  Thus, if an  imprint file explicitly defines the booktype as always "encyclopedia", PageKicker will always create all books for that imprint as encylopedias.  For this reason, it is recommended that booktypes should not be specified in imprint files (unless the imprint always publishes one and only one type of book).

When the _builder_ script runs, it uses a case statement to look for the value of **$booktype** and run the corresponding script.   That booktypes are defined and created by scripts is probably not ideal--it might be better to have them defined strictly as data objects--but on the plus side it does largely isolate the changes.   

## Example: Adding a Chapbook

The procedure for adding a new booktype is relatively straightforward.

The first step is to add a new clause to the [booktype case construct](https://github.com/fredzannarbor/pagekicker-community/blob/bf0e752097451c8a137829388bfe7da06cd4fa5c/scripts/bin/builder.sh#L1090) in the _builder_ script. The case construct for draft-report looks like this:

```
draft-report)
	echo "assembling parts needed for $booktype"

  . includes/draft-report.sh
	"$PANDOC_BIN" \
  -o "$TMPDIR$uuid/draft-report-$safe_product_name.docx" \
  "$TMPDIR"$uuid/draft-report.md

	# note that draft-report does not get SKU because it is not
  # acompleted product
  ;;
```
So, to add a new case  clause for, let us say, a chapbook, the format would look like this:

```
chapbook)
 echo "assembling parts needed for $booktype"
  . includes/chapbook.sh
 "$PANDOC_BIN" -o \
  "$TMPDIR$uuid/$sku-chapbook-$safe_product_name.epub" \
 "$TMPDIR"$uuid/chapbook.md
  ;;
```
From inspecting the above code sample, we see that the _chapbook_ script will reside in _pagekicker-community/scripts/includes_.  It need not be a shell script, it could be Python or any other language. The chapbook script has one major responsibility: to return the markdown format file _chapbook.md_ to the assembly area at _$TMPDIR$uuid_, which will then use **pandoc** to convert it into an epub format document.  (Additional formats could be created by adding additional pandoc commands with different output extensions).  By convention, the book files are named with an SKU followed by a safe product name, which is the literal book title with special characters converted into underscores, e.g. _12345678-The_Plant.epub_.  The ;; command concludes the case clause.

Since the _chapbook_ script runs as a sourced include (part of the main script), all defined PageKicker variables are available to it.  Since as mentioned above all parts of the book required for _reader_ are built by default, _chapbook_ is only responsible for creating any unique parts needed for a chapbook.  

While chapbooks have a long history and were created for a wide variety of purposes, the most common modern usage is for small collections of poetry by a single author.  Thus, we will assume that the script needs to write a number of poems. Take a look at the [code for _draft-report.sh_](https://github.com/fredzannarbor/pagekicker-community/blob/master/scripts/includes/draft-report.sh), which includes three major parts: comments, part creation, and assembly.

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
The script is then responsible for creating its specified parts of the book.  In this case, we will assume that the default number of poems is 20 and the default maximum word count is 10,000.  For the moment, this will be merely a mockup that uses a hypothetical poem generator.  So the second major section of chapbook is responsible for creating the unique substance.
```
poems="20"
poem_max_wordcount="10000"

echo "running poem script"

$PYTHON_BIN "poet.py" --poems "20" \
--maxwords "10000" -o "$TMPDIR$uuid/poems.md" \
--numbering "on"

```
Now the script must blend its unique content into the material already created by PageKicker, which is defined as follows for the _reader_ booktype.

```
cat \
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
For the _chapbook_ booktype we can delete many of these sections as either pedantic or irrelevant to the art of poetry. We then add the poems.md part to the list of items that are assembled to make up chapbook.md:

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

echo "chapbook content"
```

There is no need for an exit status, we simply report completion in the echo statement and control reverts to the appropriate place in bin/builder, i.e. the next step in the case clause, which is the **pandoc** command that builds the chapbook itself.

```
"$PANDOC_BIN" -o  \
"$TMPDIR$uuid/$sku-chapbook-$safe_product_name.epub" \
"$TMPDIR"$uuid/chapbook.md
```

The chapbook file, $sku-chapbook-$safe_product_name.epub, is delivered to the results directory, where the user can access it and additional actions such as delivery and distribution can be carried out.

This is the basic procedure for adding booktypes.  We highly encourage innovation: by all mean, write a script and plug it in!  Note that if a booktype script introduces dependencies (as in the hypothetical _poet.py_ program mentioned in the example), the install program _pagekicker-community/simple-install.sh_ should be updated to install those dependencies and the requirements should be documented in _install_notes.md_.  Similarly, a test script for the booktype should be added to _test/._
