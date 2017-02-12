#!/bin/sh

# This is the simple version of the install script for PageKicker.
#
# get master repository via git clone

#cd ~
#git clone https://github.com/fredzannarbor/pagekicker-community.git

# cd into the repo and run this script
# cd pagekicker-community
# ./simple-install.sh
# it will do the following

# create outside repo directory structure

mkdir -m 755 ~/.pagekicker
mkdir -m 777 -p  /tmp/pagekicker
mkdir -m 755 ~/magento  # stub directory for optional import/export to catalog

# put default configuration file in place
# inspect it to make sure paths are correct

cp ~/pagekicker-community/conf/config_defaults.txt ~/.pagekicker/config.txt

# installs ubuntu dependencies
# takes 20-30 min on 12 MB download

sudo apt-get install -y \
apache2 \
build-essential \
calibre \
default-jre \
fdupes \
git \
imagemagick \
mysql-client \
pandoc \
pdftk \
perl \
php \
poppler-utils \
python2.7 \
python3-dev \
python-pip \
python3-pip \
sendemail \
texlive-xetex \
ttf-dejavu \
xmlstarlet


# install python dependencies

cd ~/pagekicker-community
pip install -r requirements.txt
pip3 install -r requirements.txt

# create local-data hierarchy

mkdir -p local-data/bibliography local-data/bibliography/imprints local-data/bibliography/imprints/pagekicker
mkdir -p local-data/bibliography/robots local-data/bibliography/robots/default
mkdir -p local-data/bibliography/yaml
mkdir -p local-data/jobprofile_builds/default
mkdir -p local-data/logs/uuids
mkdir -p local-data/seeds/history
mkdir -p local-data/seeds/SKUs
echo "1000001" > local-data/SKUs/sku_list
touch local-data/bibliography/robots/default/default_titles.txt

# fetches & deploys third party apps stored in PageKicker scripts/lib

cd ~/pagekicker-community/scripts/lib
git clone https://github.com/jarun/googler.git
mkdir KindleGen
cd KindleGen
wget http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz
tar -xvf kindlegen_linux_2.6_i386_v2_9.tar.gz

# set up imagemagick configuration

mkdir ~/.magick
cd ~/pagekicker-community
cp conf/colors.xml ~/.magick/colors.xml
conf/imagemagick-fonts.pl > ~/.magick/fonts.xml

echo "install script finished running"
