#!/bin/sh

# This is the simple version of the install script for PageKicker.
#

# create outside repo directory structure

mkdir -m 755 ~/.pagekicker
mkdir -m 777 -p  /tmp/pagekicker
mkdir -m 755 ~/magento  # stub directory for optional import/export to catalog

# get master repository

#cd ~
#git clone https://github.com/fredzannarbor/pagekicker-community.git

# put default configuration file in place
# inspect it to make sure paths are correct

cp ~/pagekicker-community/conf/config_defaults.txt ~/.pagekicker/config.txt

# installs ubuntu dependencies

./apt-install.sh

# install python dependencies

cd ~/pagekicker-community
pip install -r requirements.txt
pip3 install -r requirements.txt

# create local-data hierarchy

mkdir -p local-data/bibliography local-data/imprints local-data/imprints/pagekicker
mkdir -p local-data/bibliography/robots local-data/bibliography/default
mkdir -p local-data/bibliography/yaml
mkdir -p local-data/jobprofile_builds/default
mkdir -p local-data/logs/uuids
mkdir -p local-data/seeds/history
echo "1000001" > local-data/SKUs/sku_list
touch local-data/bibliography/robots/default/default_titles.txt

# get lib programs

./get-lib.sh # fetches third party apps stored in PageKicker scripts/lib

# set up imagemagick configuration

./magick-setup.sh
