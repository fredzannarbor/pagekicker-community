#!/bin/sh

# This is the install script for PageKicker.
#
###########

BLACK='\033[30;1m'
RED='\033[91;1m'
GREEN='\033[32;1m'
CYAN='\033[36;1m'
RESET='\033[0m'

print_step() {
    printf "$BLACK$1$RESET\n"
}

print_error() {
    printf "$RED$1$RESET\n"
}

print_warning() {
    printf "$CYAN$1$RESET\n"
}

print_good() {
    printf "$GREEN$1$RESET\n"
}

program_exists() {
    if ! type "$1" > /dev/null 2>&1; then
        return 1
    else
        return 0
    fi
}

pip3_package_exists() {
    python3 -c "import $1" 2> /dev/null && return 0 || return 1
}

spinner() {
    while true; do
        printf '\\\b'
        sleep 0.1
        printf 'l\b'
        sleep 0.1
        printf '/\b'
        sleep 0.1
        printf -- '-\b'
        sleep 0.1
    done
}

print_and_run(){
    case "$1" in
        *sudo*) sudo -l > /dev/null ;;
    esac
    print_step "$1"
    spinner &
    spinner_pid=$!
    $1
    kill $spinner_pid
    wait $spinner_pid 2> /dev/null
    printf ' '  # clear spinner
    printf '\n'
}

systemctl_or_service(){
    if program_exists "systemctl"; then
        print_and_run "sudo systemctl ${1} ${2}.service"
    else
        print_and_run "sudo service ${2} ${1}"
    fi
}

install_dependencies_debian_linux(){
    print_step "Installing PageKicker and its dependencies on your Debian/Ubuntu Linux..."
    APT_FLAG=0
    arch=$(uname -m)

    if ! program_exists "sudo"; then
	apt-get install -q -y sudo
    fi

    # check for /usr/bin/pip3
    if [ "$(which pip3)" = "" ]; then
        # pip3 incompleteread fix
        sudo apt-get remove -y python3-requests python3-pip
        wget https://bootstrap.pypa.io/get-pip.py
        sudo python3 get-pip.py
        sudo rm get-pip.py
    fi

    if [ "$(which pip3)" = "/usr/bin/pip3" ]; then
        # pip3 incompleteread fix
        sudo apt-get remove -y python3-requests python3-pip
        wget https://bootstrap.pypa.io/get-pip.py
        sudo python3 get-pip.py
        sudo rm get-pip.py
    fi

    if pip3_package_exists "setuptools"; then
        sudo pip3 uninstall -y setuptools
    fi

    if [ "$APT_FLAG" = "0" ]; then
        print_and_run "sudo apt-get -q update"
    fi

  

    # install fonts

    # need  /usr/share/fonts/truetype/ttf-dejavu

    # create directory structure

    mkdir -m 755 ~/.pagekicker
    mkdir -m -p  /tmp/pagekicker

    # create local-data directory structure

    # get master repository

    cd ~
    git clone https://github.com/fredzannarbor/pagekicker-community.git

    # install python dependencies

    cd ~/pagekicker-community
    pip install -r requirements.txt

    # installs ubuntu dependencies

    . apt-install.sh 

    # get lib programs

    . get-lib.sh # fetches third party apps stored in PageKicker scripts/lib

    # set up imagemagick configuration

    . magick-setup.sh

  
}

install_optional_dependencies(){

# Magento if needed

# wget bitnami magento stack
# sudo apt-get install xmlstarlet
# Social media connectivity

    sudo apt-get install ruby-dev
    sudo gem install t
    sudo gem install facebook-cli
    # see  https://github.com/specious/facebook-cli for info on how to authorize
# mysql-client & mysql-server needed in future but not right now
  }

verify_installation(){
    printf "Verifying $1..."
    if ! program_exists $1; then
        print_error "[FAIL]"
        fail="y"
    else
        print_good "[PASS]"
    fi
}

verify_installation_all(){
    print_step "Verifying installation"
    fail=
    verify_installation "python3"
    verify_installation "pip3"

    if [ -z $fail ]; then
        print_good "You have successfully installed PageKicker!"
        print_step ""
        print_step ""
        exit 0
    else
        print_error "Installation failed. Please contact support at support@pagekicker.com"
        exit 1
    fi
}

suggest_locale(){
    print_warning "Warning: If your computer's locale is not US based"
    print_warning "Please set the following environment variables:"
    print_step "\texport LC_ALL=C.UTF-8"
    print_step "\texport LANG=C.UTF-8"
}

API_warning(){
  print_warning "To test the default system, you will need a Wikipedia API key."
  print_step "Go to https://www.mediawiki.org/wiki/API:Login."
}

main() {
    trap 'kill $spinner_pid; printf "\n"; verify_installation_all; exit 1' 2
    # checks the system type and calls system specific install functions
    UNAME=$(uname)
    case "${UNAME:-nil}" in
        Linux)
            if program_exists "apt-get"; then
                install_dependencies_debian_linux
            else
                print_error "Sorry, your system does not have either apt-get or yum package manager."
                exit 1
            fi
        *)
            print_error "Sorry, $UNAME is currently not supported via this installer."
            exit 1
        ;;
    esac

    # test whether to install optional dependencies for Magento & social networking
    # install_optional_dependencies

    suggest_locale
    verify_installation_all
    api_warning
}

main
