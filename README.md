# Arch Linux Installer
### Install.sh
Installs an UEFI and BIOS bootable USB Arch Linux

Installs the minimum number of packages :
| base                | base-devel     | ifplugd     |
|:-------             |:-------        |:------      |
| __grub__            | __efibootmgr__ | __iw__      |
| __wpa\_supplicant__ | __dialog__     | __wget__    |

### Usage
```bash
wget https://raw.githubusercontent.com/Nesci28/ArchInstaller/master/install.sh
or
wget https://bit.ly/2V3wF9q
chmod +x Install.sh
./Install.sh
```
### Packages.sh
Shows a dialog with a list of popular packages to get a working DE


| i3-gaps              | xorg         | nm-applet   |
|:-----                |:-----        |:-----       |
| __rxvt-unicode__     | __chromium__ | __vscode__  |
| __pasystray__        | __gedit__    | __vim__     |
| __cuda (Libraries)__ | __yay__      | __spotify__ |
| __libreoffice__      | __discord__  | __firefox__ |
| __gimp__             | __deluge__   | __gparted__ |  
| __vlc__              | 

# Dotfiles.sh
- .xinitrc
- .bashrc
- .config/i3/config
- /etc/i3status.conf
- __.config/vscode/plugins__
- .Xdefaults