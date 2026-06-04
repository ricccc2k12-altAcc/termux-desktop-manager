#!/bin/bash

# 1. Ask the user with a proper variable assignment
read -p "Install dialog, proot-distro, curl, and termux-x11? [Y/n]: " choice
choice=${choice:-Y}

if [[ "$choice" =~ ^[Yy]$ ]]; then
    pkg install -y dialog proot-distro x11-repo curl
    pkg install -y termux-x11-nightly
fi

dialog --title "Termux:X11 APK" --yesno "Install the termux-x11 Android APK?" 0 0
response=$?

if [ $response -eq 0 ]; then
    clear
    echo "Downloading APK..."

    curl -L "https://github.com/termux/termux-x11/releases/download/nightly/app-universal-debug.apk" -o "$HOME/app-universal-debug.apk"
    
    echo "Opening installer..."
    termux-open "$HOME/app-universal-debug.apk"
else
    clear
    echo "APK installation skipped."
fi
