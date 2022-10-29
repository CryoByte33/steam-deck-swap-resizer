#!/bin/bash
# Author: CryoByte33
# I am in no way responsible to damage done to any device this
# is executed on, all liability lies with the runner.

hasPass=$(passwd -S "$USER" | awk -F " " '{print $2}')
if [[ ! $hasPass == "P" ]]; then
    zenity --error --title="Password Error" --text="Password is not set, please set one in the terminal with the <b>passwd</b> command, then run this again." --width=400 2> /dev/null
else
    PASSWD="$(zenity --password --title="Enter Password" --text="Enter Deck User Password (not Steam account!)" 2>/dev/null)"
    echo "$PASSWD" | sudo -v -S
    ans=$?
    if [[ $ans == 1 ]]; then
        zenity --error --title="Password Error" --text="Incorrect password provided, please run this command again and provide the correct password." --width=400 2> /dev/null
    else
        if zenity --question --title="Disclaimer" --text="This script was made by CryoByte33 to resize the swapfile on a Steam Deck.\n\n<b>Disclaimer: I am in no way responsible to damage done to any device this is executed on, all liability lies with the runner.</b>\n\nDo you accept these terms?" --width=600 2> /dev/null; then
            CURRENT_SWAP_SIZE=$(ls -l /home/swapfile | awk '{print $5}')
            CURRENT_VM_SWAPPINESS=$(sysctl vm.swappiness | awk '{print $3}')
            if zenity --question --title="Change Swap Size?" --text="Do you want to change the swap file size?" --width=300 2> /dev/null; then
                AVAILABLE=$(df --output="avail" -lh --sync /home | grep -v "Avail" | sed -e 's/^[ \t]*//')
                MACHINE_AVAILABLE=$(( $(df --output="avail" -l --sync /home | grep -v "Avail" | sed -e 's/^[ \t]*//') * 1024 ))
                SIZE=$(zenity --list --radiolist --text "You have $AVAILABLE space available, what size would you like the swap file (in GB)?" --hide-header --column "Selected" --column "Size" TRUE "1" FALSE "2" FALSE "4" FALSE "8" FALSE "12" FALSE "16" FALSE "32" --height=400 2> /dev/null)
                MACHINE_SIZE=$(( $SIZE * 1024 * 1024 ))
                TOTAL_AVAILABLE=$(( $MACHINE_AVAILABLE + $CURRENT_SWAP_SIZE ))
                echo "Debugging Information:"
                echo "----------------------"
                echo "Bytes Available: $MACHINE_AVAILABLE"
                echo "Chosen Size: $MACHINE_SIZE"
                echo "Current Swap Size in Bytes: $CURRENT_SWAP_SIZE"
                echo "Total Size Available: $TOTAL_AVAILABLE"

                if [ "$MACHINE_SIZE" -lt $TOTAL_AVAILABLE ]; then
                    (
                        echo 0
                        echo "# Disabling swap..."
                        sudo swapoff -a
                        echo 25
                        echo "# Creating new $SIZE GB swapfile (be patient, this can take between 10 seconds and 30 minutes)..."
                        sudo dd if=/dev/zero of=/home/swapfile bs=1G count=$SIZE status=none
                        echo 50
                        echo "# Setting permissions on swapfile..."
                        sudo chmod 0600 /home/swapfile
                        echo 75
                        echo "# Initializing new swapfile..."
                        sudo mkswap /home/swapfile 
                        sudo swapon /home/swapfile
                        echo 100
                        echo "# Process completed! You can verify the file is resized by doing 'ls /home' or using 'swapon -s'."
                    ) | zenity --title "Resizing Swap File" --progress --no-cancel --width=800 2> /dev/null
                else
                    zenity --error --title="Invalid Size" --text="You selected a size greater than the space you have available, cannot proceed." --width=500 2> /dev/null
                fi
            fi
            # Thank you to protosam for the idea and some of the code here.
            if zenity --question --title="Change Swappiness?" --text="Would you like to change swappiness?\n\nCurrent value: $CURRENT_VM_SWAPPINESS\nRecommended: 1" --width=300 2> /dev/null; then
                SWAPPINESS_ANSWER=$(zenity --list --title "Swappiness Value" --text "What value would you like to use for swappiness?" --column="vm.swappiness" "100" "50" "30" "1" --width=100 --height=300 2> /dev/null)
                sudo sysctl -w "vm.swappiness=$SWAPPINESS_ANSWER"
                if [ "$SWAPPINESS_ANSWER" -eq "100" ]; then
                    sudo rm /etc/sysctl.d/zzz-custom-swappiness.conf
                else
                    echo "vm.swappiness=$SWAPPINESS_ANSWER" | sudo tee /etc/sysctl.d/zzz-custom-swappiness.conf
                fi
            fi
        else
            zenity --error --title="Terms Denied" --text="Terms were denied, cannot proceed." --width=300 2> /dev/null
        fi
    fi
fi
