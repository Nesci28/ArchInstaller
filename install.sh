#!/bin/bash

# Check for Connection
checkConnection() {
  if [[ $(ping -q -w1 -c1 google.com &>/dev/null && echo online || echo offline) == "online" ]]; then
    connection
  fi
}

connection() {
  read -p "Ethernet or Wifi [E/w] ? " connection
  if [[ $connection == "E" || $connection == "e" ]]; then
    interface=$(ifconfig -a | grep "Link encap:Ethernet" | sed 's/  */ /g' | cut -d ' ' -f1)
    if [[ -z $interface ]]; then
      fatalError
    fi
    ip link set ${interface} up
    dhcpcd ${interface}
    checkConnection
  elif [[ $connection == "W" || $connection == "w" ]]; then
    interface=$(lspci -k | grep -A3 'Network controller')
    if [[ $interface == *"cannot"* ]]; then
      fatalError
    fi
    interface=$(iw dev)
    ip link set ${interface} up
    read -p "SSID" ssid
    read -p "Password" pass
    wpa_supplicant -i ${interface} -c <(wpa_passphrase \'${ssid}\' \'${pass}\') 
    dhcpcd ${interface}
    checkConnection
  else
    errorMessage
    connection
  fi
}

# Get disk
getdisk() {
  lsblk
  read -p "Which device /dev/sdX ? " disk
  if ! [[ ${disk} =~ ^[a-zA-Z]{1}$ ]]; then
    errorMessage
    getDisk
  fi
  disk="/dev/sd${disk}"
}

# Partition the disk
partition() {
  sudo gdisk ${disk} <<EOF
o
Y
n
1

+1MB
EF02
n
2

+100MB
EF00
n
3

+10MB
0700
n
4


8300
w
EOF
}

# Format the partitions
format() {
  mkfs.fat -F32 ${disk}2
  mkfs.ext4 ${disk}3
}

# Mount the partitions
mount() {
  mkdir -p /mnt/usb
  mount /dev/sdX3 /mnt/usb
  mkdir /mnt/usb/boot
  mount /dev/sdX2 /mnt/usb/boot
}

# Download and install the minimum packages
pacstrap() {
  pacstrap /mnt/usb base base-devel --noconfirm
}

# Generate fstab
fstab() {
  genfstab -U /mnt/usb >> /mnt/usb/etc/fstab
}

# Chroot to the new /
chroot() {
  arch-chroot /mnt/usb
}

# Set the time and the language
timeAndLanguage() {
  ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime
  hwclock --systohc
  sed "s/#en_US.UTF-8/en_US.UTF-8/" </etc/locale.gen
  locale-gen
  echo "LANG=en_US.UTF-8" > /etc/locale.conf
}

hostname() {
  read "Type in you wanted hostname" host
  echo ${host} > /etc/hostname
  echo "127.0.1.1    ${host}.localdomain    ${host}" >> /etc/hosts
}

extra() {
  ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
  sed "s/#Storage=*/Storage=volatile/" </etc/systemd/journald.conf
  sed "s/#SystemMaxUse=*/SystemMaxUse=16M/" </etc/systemd/journald.conf
  sed "s/relatime/noatime/2" </etc/fstab
}

bootloaders() {
  pacman -S grub efibootmgr
  msg=$(grub-install --target=i386-pc --boot-directory /boot ${disk})
  if [[ ${msg} == *"error"* ]]; then
    fatalError
  fi
  grub-install --target=x86_64-efi --efi-directory /boot --boot-directory /boot --removable ${disk}
  if [[ ${msg} == *"error"* ]]; then
    fatalError
  fi
  grub-mkconfig -o /boot/grub/grub.cfg
}

pacman() {
  pacman -S ifplugd iw wpa_supplicant dialog --noconfirm
}

user() {
  pass=$(passwd)
  if [[ ${pass} !== *"Succesfully"* ]]; then
    errorMessage
    user
  fi
  read -p "Username for the new user" user
  useradd -m ${user}
  pass=$(passwd ${user})
  if [[ ${pass} !== *"Sucessfully"* ]]; then
    errorMessage
    user
  fi
  echo "${user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers
}

quit() {
  if [[ $connection == "E" || $connection == "e" ]]; then
    cp /etc/netctl/examples/ethernet-dhcp /etc/netctl/eth0-arch_usb
    systemctl start netctl-ifplugd@eth0.service
    systemctl enable netctl-ifplugd@eth0.service
  fi
  timedatectl set-ntp true
  exit
  umount /mnt/usb/boot /mnt/usb
}

# Error messages
errorMessage() {
  echo -e "Input error, try again"
}

fatalError() {
  echo -e "Fatal Error.  No solution found."
  read -p "Press any key to continue..."
  exit
}


read -p "Checking for internet connection" var
checkConnection
clear
read -p "Getting the disk Label" var
getDisk
clear
read -p "Setting up the partitions" var
partition
clear
read -p "Formatting the partitions" var
format
clear
read -p "Mounting the partitions" var
mount
clear
read -p "Downloading base and base-devel" var
pacstrap
clear
read -p "Generating fstab" var
fstab
clear
read -p "Chrooting in the new system" var
chroot
clear
read -p "Setting up time and Language" var
timeAndLanguage
clear
read -p "Setting up the hostname" var
hostname
clear
read -p "Setting up uncategorized stuff (network interface, journal, mount option)" var
extra
clear
read -p "Installing EFI and BIOS bootloaders" var
bootloaders
clear
read -p "Downlading stuff to make sure internet will work" var
pacman
clear
read -p "Setting up the passwords, an account and sudo rights" var
user
clear
read -p "Unmounting and quitting" var
quit
clear
read -p "All done, thanks" var
poweroff
