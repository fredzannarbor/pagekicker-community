# pagekicker-community
Algorithmic book creation: push a button, build a unique new e-book using permissioned content.

PageKicker accepts explicit or implicit user specifications, searches permissioned content, fetches it, analyzes, designs, assembles, converts, and distributes the results in ebook, web, document, or mobile format.

# pagekicker-community
Algorithmic book creation toolkit: push a button, build a unique new e-book using permissioned content.

PageKicker accepts explicit or implicit user specifications, searches permissioned content, fetches it, analyzes, designs, assembles, converts, and distributes the results in ebook, web, document, or mobile format.

## Install on Ubuntu

```
cd ~

git clone https://github.com/fredzannarbor/pagekicker-community.git

cd pagekicker-community

./simple-install.sh_
```

## Quick Start

### Run your very first job
```
cd ~/pagekicker-community/scripts # all commands must be launched from this directory

bin/builder.sh --seedsviacli "Fancy Bear; Kaspersky" --booktitle "Cybersecurity Demo Book"
```
- runs verbosely by default, to make it run silently add 1> /dev/null to end of command
- searches wikipedia by default

```ls -lart /tmp/pagekicker```

- look in most recently created directory

- complete books begin with an SKU, e.g. 100*** and end with .docx, etc.


### Experiment by adding some useful command line options

```bin/builder.sh --seedsviacli "Fancy Bear; Kaspersky" --booktitle "Wapack Demo Book" --expand_seeds_to_pages "yes"```

- The system will spider out to all page hits for these key words

```--covercolor "Red"```

```--coverfont "Arial"```

```--editedby "Charles Dickens"```
