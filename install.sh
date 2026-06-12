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
    mkdir $HOME/termux-desktop-manager
    curl -L "https://github.com/termux/termux-x11/releases/download/nightly/app-universal-debug.apk" -o "$HOME/termux-desktop-manager/app-universal-debug.apk"
    echo "Opening installer..."
    termux-open "$HOME/app-universal-debug.apk"
    sed -i '$d' $HOME/.termux/termux.properties
    rm $HOME/termux-desktop-manager/app-universal-debug.apk
    termux-reload-settings
    read -p "done? [press any button]"
else
    clear
    echo "APK installation skipped."
    sleep 1
fi

clear

SCELTA=$( dialog --output-fd 1 --title "Desktop Choice" \
    --checklist "First of all, we are going to choose your desktop environment(s)! You can try searching for some images and info about them if you're curious (exit by selecting nothing)." 0 0 0 \
    1 "Openbox" off \
    2 "i3wm" off \
    3 "bspwm" off \
    4 "AwesomeWM" off \
    5 "IceWM" off \
    6 "dwm" off \
    7 "XFCE" off \
    8 "LXqt" off \
    9 "MATE" off \
    10 "KDE Plasma" off \
    11 "LXDE" off )

if [[ $? != 0 ]]; then
    exit 0
fi

clear

#case $SCELTA in
#    *" 1 "*) echo "Installing Openbox"     ; DEorWM="${DEorWM} 1" ;;
#    *" 2 "*) echo "Installing i3wm"        ; DEorWM="${DEorWM} 2" ;;
#    *" 3 "*) echo "Installing bspwm"       ; DEorWM="${DEorWM} 3" ;;
#    *" 4 "*) echo "Installing AwesomeWM"   ; DEorWM="${DEorWM} 4" ;;
#    *" 5 "*) echo "Installing IceWM"       ; DEorWM="${DEorWM} 5" ;;
#    *" 6 "*) echo "Installing dwm"         ; DEorWM="${DEorWM} 6" ;;
#    *" 7 "*) echo "Installing XFCE"        ; DEorWM="${DEorWM} 7" ;;
#    *" 8 "*) echo "Installing LXqt"        ; DEorWM="${DEorWM} 8" ;;
#    *" 9 "*) echo "Installing MATE"        ; DEorWM="${DEorWM} 9" ;;
#    *" 10 "*) echo "Installing KDE Plasma" ; DEorWM="${DEorWM} 10" ;;
#    *" 11 "*) echo "Installing LXDE"       ; DEorWM="${DEorWM} 11" ;;
#esac

echo "$SCELTA"

#10 if statements... yeah I have to do it because
#of the differences between installation processes.
#I could use the case operator here but its gonna be messy

if [[ " $SCELTA " == *" 1 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: obconf, tint2, feh, any terminal)" 0 0)
  pkg install openbox $pkgs
  echo "openbox installed" >> $HOME/termux-desktop-manager/.installed
fi

if [[ " $SCELTA " == *" 2 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: i3-status OR i3-blocks OR polybar, dmenu OR rofi, any terminal)" 0 0)
  #its evident I have more experience with i3
  pkg install i3 $pkgs
  echo "i3 installed" >> $HOME/termux-desktop-manager/.installed
fi

if [[ " $SCELTA " == *" 3 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: polybar, rofi, feh, any terminal)" 0 0)
  pkg install bspwm sxhkd $pkgs
  echo "bspwm installed" >> $HOME/termux-desktop-manager/.installed
fi

if [[ " $SCELTA " == *" 4 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: picom, rofi, any terminal)" 0 0)
  pkg install awesome $pkgs
  echo "awesomewm installed" >> $HOME/termux-desktop-manager/.installed
fi

if [[ " $SCELTA " == *" 5 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: pcmanfm, feh, any terminal)" 0 0)
  pkg install icewm $pkgs
  echo "ice installed" >> $HOME/termux-desktop-manager/.installed
fi

if [[ " $SCELTA " == *" 6 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: dmenu, st-term)" 0 0)
  pkg install dwm $pkgs
  echo " installed" >> $HOME/termux-desktop-manager/.installed
fi

if [[ " $SCELTA " == *" 7 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: [none, choose for yourself])" 0 0)
  pkg install xfce4-goodies xfce4 $pkgs
  echo "xfce installed" >> $HOME/termux-desktop-manager/.installed
fi

if [[ " $SCELTA " == *" 8 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: qterminal, screengrab, lxqt-policykit)" 0 0)
  pkg install lxqt-core $pkgs
  echo "lxqt installed" >> $HOME/termux-desktop-manager/.installed
fi

if [[ " $SCELTA " == *" 9 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: mate-terminal, mate-applets)" 0 0)
  pkg install mate-desktop-environment-core $pkgs
  echo "mate installed" >> $HOME/termux-desktop-manager/.installed
fi

if [[ " $SCELTA " == *" 10 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: dolphin, konsole, plasma-nm, kscreen)" 0 0)
  pkg install kde-plasma-desktop $pkgs
  echo "kde installed" >> $HOME/termux-desktop-manager/.installed
fi

if [[ " $SCELTA " == *" 11 "* ]]; then
  pkgs=$( dialog --output-fd 1 --inputbox "extra packages to install (divide with a space) (suggested: lxappearance, any terminal)" 0 0)
  pkg install lxde-core
  echo "lxde installed" >> $HOME/termux-desktop-manager/.installed
fi
