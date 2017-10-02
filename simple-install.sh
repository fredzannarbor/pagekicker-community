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


cp ~/pagekicker-community/conf/config_defaults.txt "$HOME"/.pagekicker/config.txt

# installs mac dependencies

install_dependencies_mac(){
    print_step "Installing 21 and its dependencies on your Mac..."
    if ! program_exists "brew"; then
        # from brew.sh
        print_step "Installing brew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    if ! program_exists "python3"; then
        print_and_run "brew install python3"
    fi

# current Mac default is 3.3.6.1 - needs 3.4 and above IIRC

    if ! program_exists "pip3"; then
        print_step "Installing Pip3 package manager..."
        curl -O https://bootstrap.pypa.io/get-pip.py
        sudo python3 get-pip.py
        rm get-pip.py
    fi

}

brew install calibre
brew install fdupes
brew install imagemagick
brew cask install java
brew install mysql-client
brew install pandoc
brew install pdfgrep
brew install pdftk
brew install poppler
brew install sendemail
brew cask install basictex
# brew install of pdftk is problematic
# see https://gist.github.com/jvenator/9672772a631c117da151
brew install https://raw.githubusercontent.com/turforlag/homebrew-cervezas/master/pdftk.rb
brew install wget # needed for Mac for install - replace with curl?
brew install xmlstarlet

brew tap caskroom/fonts
brew cask install font-dejavu-sans

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
pdfgrep \
pdftk \
perl \
php5-cli \
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
sudo pip install -r requirements.txt

# failing for Mac:
sudo pip3 install -r requirements.txt

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
wget https://nlp.stanford.edu/software/stanford-ner-2017-06-09.zip
unzip stanford-ner-2017-06-09.zip

# fix hard-coded IBMcloud configuration file

cd ~/pagekicker-community/scripts/lib/IBMcloud/examples
sed -i "s/fred/"$USER"/" configuration.txt

# set up imagemagick configuration

mkdir ~/.magick
cd ~/pagekicker-community
cp conf/colors.xml ~/.magick/colors.xml
conf/imagemagick-fonts.pl > ~/.magick/fonts.xml

echo "install script finished running"
