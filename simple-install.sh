#!/bin/sh

# This is the simple version of the install script for PageKicker.
#
###########


# create directory structure

mkdir -m 755 ~/.pagekicker
mkdir -m 777 -p  /tmp/pagekicker
mkdir -m 755 ~/magento  # stub directory for optional import/export to catalog

# get master repository

cd ~
git clone https://github.com/fredzannarbor/pagekicker-community.git

# put default configuration file in place
# inspect it to make sure paths are correct

cp ~/pagekicker-community/conf/config_default.txt ~/.pagekicker/config.txt

# install python dependencies

cd ~/pagekicker-community
pip install -r requirements.txt

# installs ubuntu dependencies

. apt-install.sh 

# get lib programs

. get-lib.sh # fetches third party apps stored in PageKicker scripts/lib

# set up imagemagick configuration

. magick-setup.sh



