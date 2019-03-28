#!/bin/bash
categories() {
  OPTION=$(whiptail --title "Package Categories" --menu "Categories" 15 60 8 \
  "1" "DE / WM" \
  "2" "Drivers" \
  "3" "Multimedia" \
  "4" "Productivity"  \
  "5" "Internet" \
  "6" "Image" \
  "7" "Coding" \
  "8" "Other" 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    case $OPTION in
      1) dewm;;
      2) drivers;;
      3) multimedia;;
      4) productivity;;
      5) internet;;
      6) image;;
      7) coding;;
      8) other;;
     esac
  else
      echo "List of selected packages : ${packages}"
  fi 
}

dewm() {
  choices=$(whiptail --title "Desktop Environment / Window Manager" --checklist 15 60 8 \
  "i3" OFF \
  "i3-gaps" ON \
  "gnome" OFF \
  "kde" OFF  \
  "xfce4" OFF  \
  "cinnamon" OFF  \
  "xorg" ON  \
  "xorg-server" ON 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
   packages+="${choices}"
   categories
  else
   categories
  fi
}

drivers() {
  choices=$(whiptail --title "Drivers" --checklist \
  "Drivers" 15 60 8 \
  "nvidia" ON \
  "nvidia-lts" OFF \
  "opencl-amd" ON \
  "nouveau" OFF  \
  "mesa" OFF 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+="${choices}"
    categories
  else
    categories
  fi
}

multimedia() {
  choices=$(whiptail --title "Multimedia" --checklist \
  "Multimedia" 15 60 8 \
  "spotify" OFF \
  "discord" OFF \
  "vlc" OFF \
  "mpv" OFF  \
  "lazyman" OFF 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+="${choices}"
    categories
  else
    categories
  fi
}

productivity() {
  choices=$(whiptail --title "Productivity" --checklist \
  "Productivity" 15 60 8 \
  "libreoffice" OFF \
  "gedit" OFF \
  "rxvt-unicode" ON \
  "vim" OFF 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+="${choices}"
    categories
  else
    categories
  fi
}

internet() {
  choices=$(whiptail --title "Internet" --checklist \
  "Internet" 15 60 8 \
  "chromium" ON \
  "firefox" OFF \
  "vivaldi" OFF \
  "midori" OFF 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+="${choices}"
    categories
  else
    categories
  fi
}

image() {
  choices=$(whiptail --title "Image" --checklist \
  "Image" 15 60 8 \
  "gimp" OFF \
  "imagemagick" OFF 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+="${choices}"
    categories
  else
    categories
  fi
}

coding() {
  choices=$(whiptail --title "Coding" --checklist \
  "Coding" 15 60 8 \
  "vscode" ON \
  "atom" OFF \
  "npm" ON \
  "nodejs" ON 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+="${choices}"
    categories
  else
    categories
  fi
}

other() {
  choices=$(whiptail --title "Other" --checklist \
  "Other" 15 60 8 \
  "gparted" ON \
  "nm-applet" ON \
  "pasystray" ON 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+="${choices}"
    categories
  else
    categories
  fi
}

categories

