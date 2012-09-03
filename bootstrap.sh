#!/bin/bash
cd "$(dirname "$0")"
git pull

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" --exclude "README.md" --exclude "hosts" -av . ~
}
if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset doIt

source ~/.bash_profile


function installHosts() {
    sudo cp -f hosts /private/etc/
}
if [ "$1" == "--force" -o "$1" == "-f" ]; then
    installHosts
else
    read -p "Do you wish to also copy the HOSTS file? This will require your password as it will be sudo'd into place (y/n) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        installHosts
    fi
fi
unset installHosts
