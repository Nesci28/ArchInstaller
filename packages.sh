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
  "8" "Other" \
  "9" "Default packages" 3>&1 1>&2 2>&3)
  
  exitstatus=$?
  if [ $exitstatus == 0 ]; then
    case $OPTION in
      1) dewm;;
      2) drivers;;
      3) multimedia;;
      4) productivity;;
      5) internet;;
      6) image;;
      7) coding;;
      8) other;;
      9) default;;
     esac
  else
    if [[ ! -z ${packages} ]]; then
      echo "${packages}"
      read -p "Confirm [Y/n] ? " var
      if [[ ${var,,} == "y" ]]; then
        installation      
      else
        categories
      fi
    else
      echo "Operation cancelled..."
    fi
  fi 
}

dewm() {
  choices=$(whiptail --title "Desktop Environment Window Manager" --checklist "Choose:" 15 60 8 \
  "i3" "" OFF \
  "i3-gaps" "" ON \
  "gnome" "" OFF \
  "kde" "" OFF  \
  "xfce4" "" OFF  \
  "cinnamon" "" OFF  \
  "xorg" "" ON  \
  "xorg-server" "" ON  \
  3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
   packages+=" ${choices}"
   categories
  else
   categories
  fi
}

drivers() {
  choices=$(whiptail --title "Drivers" --checklist "Choose:" 15 60 8 \
  "nvidia" "" ON \
  "nvidia-lts" "" OFF \
  "opencl-amd" "" ON \
  "nouveau" "" OFF  \
  "mesa" "" OFF  \
  3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+=" ${choices}"
    categories
  else
    categories
  fi
}

multimedia() {
  choices=$(whiptail --title "Multimedia" --checklist "Choose:" 15 60 8 \
  "spotify" "" OFF \
  "discord" "" OFF \
  "vlc" "" OFF \
  "mpv" "" OFF  \
  "lazyman" "" OFF  \
  3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+=" ${choices}"
    categories
  else
    categories
  fi
}

productivity() {
  choices=$(whiptail --title "Productivity" --checklist "Choose:" 15 60 8 \
  "libreoffice" "" OFF \
  "gedit" "" OFF \
  "rxvt-unicode" "" ON \
  "vim" "" OFF  \
  3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+=" ${choices}"
    categories
  else
    categories
  fi
}

internet() {
  choices=$(whiptail --title "Internet" --checklist "Choose:" 15 60 8\
  "chromium" "" ON \
  "firefox" "" OFF \
  "vivaldi" "" OFF \
  "midori" "" OFF  \
  "deluge" "" OFF  \
  3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+=" ${choices}"
    categories
  else
    categories
  fi
}

image() {
  choices=$(whiptail --title "Image" --checklist "Choose:" 15 60 8 \
  "gimp" "" OFF \
  "imagemagick" "" OFF  \
  3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+=" ${choices}"
    categories
  else
    categories
  fi
}

coding() {
  choices=$(whiptail --title "Coding" --checklist "Choose:" 15 60 8 \
  "vscode" "" ON \
  "atom" "" OFF \
  "npm" "" ON \
  "nodejs" "" ON  \
  "git" "" ON  \
  3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+=" ${choices}"
    categories
  else
    categories
  fi
}

other() {
  choices=$(whiptail --title "Other" --checklist "Choose:" 15 60 8 \
  "gparted" "" ON \
  "nm-applet" "" ON \
  "pasystray" "" ON  \
  "yay" "" ON  \
  "openSSL" "" ON  \
  "openSSH" "" ON  \
  "libmicrohhtpd" "" ON  \
  3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    packages+=" ${choices}"
    categories
  else
    categories
  fi
}

default() {
  text="List of default packages :
i3-gaps, xorg, xorg-server, nvidia, opencl-amd, rxvt-unicode, chromium, vscode, npm, nodejs
  
Confirm [Y/n] ? "
  read -p "${text}" var
  
  if [[ $var == "Y" || $var == "y" ]]; then
    packages="i3-gaps xorg xorg-server nvidia opencl-amd rxvt-unicode chromium code npm nodejs git gparted nm-applet pasystray yay openssl openssh"
    installation
  elif [[ ${var,,} == "n" ]]; then
    categories
  fi
}

installation() {
  if [[ "${packages}" == *"opencl-amd"* ]]; then
    packages=$(echo "${packages}" | sed 's/ opencl-amd//g')
    aurman+='opencl-amd '
  fi
  if [[ "${packages}" == *"libmicrohttpd"* ]]; then
    packages=$(echo "${packages}" | sed 's/ libmicrohttpd//g')
    aurman+='libmicrohttpd '
  fi
  if [[ "${aurman}" == *"libmicrohttpd"* || "${aurman}" == *"opencl-amd"* ]]; then
    packages+=" git"
  fi
  
  if [[ "${packages}" == *"vscode"* ]]; then
    packages=$(echo "${packages}" | sed 's/ vscode/ code/g')
  fi
  if [[ "${packages}" == *"nvidia-lts"* ]]; then
    packages=$(echo "${packages}" | sed 's/ nvidia-lts/ nvidia-390xx-lts/g')
  fi
  
  sudo pacman -Syy
  sudo pacman -S "${packages}" --noconfirm
  sudo pacman -Scc --noconfirm
  yay -S "${aurman}"
  yay -Scc
}

categories

