# Arch Linux Installer

## Install.sh
*Installs an UEFI and BIOS bootable USB Arch Linux.*

__Included packages :__
| base                | base-devel     | ifplugd     |
|:-------             |:-------        |:------      |
| __grub__            | __efibootmgr__ | __iw__      |
| __wpa_supplicant__  | __dialog__     | __wget__    |

__Partitions schema :__
1) `BIOS     1MB EF02`
2) `UEFI   100MB EF00`
3) `NTFS (Optionnal)`
4) `Linux 8300`

### Usage
```bash
wget https://raw.githubusercontent.com/Nesci28/ArchInstaller/master/install.sh
or a smaller link :
wget https://bit.ly/2V3wF9q

chmod +x Install.sh
./Install.sh
```
## Packages.sh
Shows a dialog, breaked down in categories, with a list of popular packages to get a working desktop a.s.a.p
It saves all the dialog informations and install the packages only once, for a maximum of productivity.

| De/Wm         | Drivers    | Multimedia | Productivity  | Internet | Image       | Coding | Other            |
| -----         | -----      | -----      | -----         | -----    | -----       | -----  | -----            |
| i3            | Nvidia     | Spotify    | LibreOffice   | Chromium | Gimp        | VsCode | OpenSSL          |
| i3-gaps       | Nvidia-Lts | Discord    | Gedit         | Firefox  | ImageMagick | Atom   | Gparted          |
| Gnome         | Opencl-Amd | Lazyman    | Vim           | Vivaldi  |             | Npm    | Yay              |
| Kde           | Nouveau    | Vlc        | Rxvt-Unicode  | Midori   |		         | Nodejs | Nm-applet        |
| Xfce4         | Mesa       | Mpv        |               | Deluge   |             | Git    | Pasystray        |
| Cinnamon      |            |            |               |          |             |        | OpenSSH          | 
| Xorg          |            |            |               |          |             |        | Libmicrohttpd    |
| Xorg-Server   |            |            |               |          |             |        | 

## Dotfiles.sh
- .xinitrc
- .bashrc
- .config/i3/config
- /etc/i3status.conf
- __.config/vscode/plugins__
- .Xdefaults