# PageKicker Algorithmic Publishing Toolkit

PageKicker accepts explicit or implicit user specifications, searches permissioned content, fetches it, analyzes, designs, assembles, converts, and distributes the results in ebook, web, document, or mobile format.

### Install on Debian-Ubuntu Linux

`cd ~

git clone https://github.com/fredzannarbor/pagekicker-community.git

cd pagekicker-community

./simple-install.sh`

### Quick Start

#### Run your very first job

cd ~/pagekicker-community/scripts # all commands must be launched from this directory

bin/builder.sh --seedsviacli "Fancy Bear; Kaspersky" --booktitle "Cybersecurity Demo Book" --covercolor "red"
