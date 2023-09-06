## Notes
_This script will install android sdk and flutter sdk on ~/Android. If you select install with Android Studio, Android Studio will installed on /opt/android-studio_

# Flutter installer

## Requirements
Arch linux based OS (Pacman).

Debian 11 based OS, Ubuntu 20.04 LTS based OS or newer (APT).

<!--

Fendora based OS (DNF).

Opensuse based OS (DNF).

-->
bash, zsh or fish shell.

## To Install

1. Clone this repository and run install.sh

```
git clone https://github.com/wildan-pratama/flutter-install.git
cd flutter-install

./install.sh
```

2. Follow step installation on script

![image](https://user-images.githubusercontent.com/84622086/233557218-89b775bf-59c6-4f1f-9006-33fe9cf6dc0c.png)


## After installation

If you want change your shell, you must put your path manualy


```
# from fish to bash/zsh
## add this line to your .bashrc or .zshrc, if already exits you can skip
source $HOME/Android/flutterrc

# from bash/zsh to fish
## add this line to ~/.config/fish/config.fish, if already exits you can skip
source $HOME/Android/flutter.fish
```

You can set browser for flutter web on ~Android/flutterrc or ~/Android/flutter.fish


```
# fish to bash/zsh
## remove comment (#) and edit this line on ~/Android/flutter.fish
set -x CHROME_EXECUTABLE "/path/to/your/browser"

# bash/zsh
## remove comment (#) and edit this line on ~Android/flutterrc
export CHROME_EXECUTABLE="/path/to/your/browser"
```
