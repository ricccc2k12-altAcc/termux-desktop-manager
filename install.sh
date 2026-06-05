#!/bin/bash

# 1. Chiedi all'utente l'installazione dei pacchetti base
read -p "Install dialog, proot-distro, curl, and termux-x11? [Y/n]: " choice
choice=${choice:-Y}

if [[ "$choice" =~ ^[Yy]$ ]]; then
    pkg update
    pkg install -y dialog proot-distro x11-repo curl
    pkg install -y termux-x11-nightly
fi

# Pulisce lo schermo prima di mostrare il primo elemento grafico di dialog
clear

dialog --title "Termux:X11 APK" --yesno "Install the termux-x11 Android APK?" 0 0
response=$?

if [ $response -eq 0 ]; then
    clear
    echo "Downloading APK..."
    echo "allow-external-apps = true" >> $HOME/.termux/termux.properties
    termux-reload-settings
    curl -L "https://github.com/termux/termux-x11/releases/download/nightly/app-universal-debug.apk" -o "$HOME/app-universal-debug.apk"
    echo "Opening installer..."
    termux-open "$HOME/app-universal-debug.apk"
    sed -i '$d' $HOME/.termux/termux.properties
    termux-reload-settings
    read -p "done? [press any button]"
else
    clear
    echo "APK installation skipped."
    sleep 1
fi

clear

SCELTA=$(dialog --output-fd 1 --title "Desktop Choice" --menu "First of all, we are going to choose your desktop environment! You can try searching for some images and info about them if you're curious (exit with the option at the end)" 0 0 0 \
    1 "Openbox" \
    2 "i3wm" \
    3 "bspwm(PRoot)" \
    4 "AwesomeWM" \
    5 "IceWM" \
    6 "XFCE" \
    7 "LXqt" \
    8 "MATE" \
    9 "KDE Plasma(PRoot)" \
    10 "LXDE" \
    11 "nevermind, exit the script")

if [ $? -ne 0 ]; then
    clear
    exit 0
fi

clear

case $SCELTA in
    1) echo "Installing Openbox" && export DEorWM="Openbox" ;;
    2) echo "Installing i3wm" && export DEorWM="i3wm" ;;
    3) echo "Installing bspwm" && export DEorWM="bspwm" ;;
    4) echo "Installing AwesomeWM" && export DEorWM="AwesomeWM" ;;
    5) echo "Installing IceWM" && export DEorWM="IceWM" ;;
    6) echo "Installing XFCE" && export DEorWM="XFCE" ;;
    7) echo "Installing LXqt" && export DEorWM="LXqt" ;;
    8) echo "Installing MATE" && export DEorWM="MATE" ;;
    9) echo "Installing KDE Plasma" && export DEorWM="KDE" ;;
    10) echo "Installing LXDE" && export DEorWM="LXDE" ;;
    11) echo "Exit. Bye!" ;;
esac
