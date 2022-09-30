#!/bin/bash
# Author: CryoByte33
# I am in no way responsible to damage done to any device this
# is executed on, all liability lies with the runner.

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

TERM=xterm-256color
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
reset="$(tput sgr0)"

echo "This script was made by CryoByte33 to resize the swapfile on a Steam Deck."
echo
echo -e "${red}Disclaimer:${reset} I am in no way responsible to damage done to any device this\nis executed on, all liability lies with the runner.\n"

read -p "${yellow}Do you agree to these terms? (y/n)${reset} => " CONSENT

if [ "$CONSENT" = "y" ] || [ "$CONSENT" = "Y" ]; then
    echo "Consent granted, continuing..."
    AVAILABLE=$(df --output="avail" -hl --sync /home | grep -v "Avail" | sed -e 's/^[ \t]*//')
    echo "You have $AVAILABLE space available."
    read -p "${yellow}How large would you like the swapfile to be in GB? (1-32)${reset} => " SIZE
    if [ "$SIZE" -ge "1" ] && [ "$SIZE" -le "32" ] && [ "$SIZE" -lt $(echo $AVAILABLE | sed -e 's/[BKMGT]//') ]; then
        echo "Disabling read-only filesystem..."
        steamos-readonly disable
        echo "Disabling swap..."
        swapoff -a
        echo "Removing old swapfile..."
        rm -f /home/swapfile
        echo "Creating new $SIZE GB swapfile..."
        dd if=/dev/zero of=/home/swapfile bs=1G count=$SIZE
        echo "Setting permissions on swapfile..."
        chmod 0600 /home/swapfile
        echo "Initializing new swapfile..."
        mkswap /home/swapfile 
        swapon /home/swapfile
        echo "Re-enabling read-only filesystem..."
        steamos-readonly enable
        echo
        echo "${green}Process completed! You can verify the file is resized by doing 'ls /home' or using 'swapon -s'.${reset}"
        echo "${green}Enjoy your Deck!${reset}"
    else
        echo "${red}Invalid size given, exiting...${reset}"
        exit 2
    fi
else
    echo "${red}Consent not granted, exiting...${reset}"
    exit 1
fi
