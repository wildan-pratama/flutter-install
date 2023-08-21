#!/bin/bash

# Dialog installer
dialog-install () {
    echo "This script will install package required by Flutter and will download required sdk to ~/Android"
    echo
    
    echo "1. Continue."
    echo "2. Abbort."
    echo

    # Read Input
    read -p "Continue? [1/2]: " confirm
    
    # Select OS
    echo "Please chose your os:"
    echo "1. Arch linux based OS (Pacman)."
    echo "2. Debian 11 based OS, Ubuntu 22.04 LTS based OS or newer (APT)."
    #echo "3. Fendora based OS (DNF)."
    #echo "4. Opensuse based OS (Zypper)."
    echo

    # Read Input
    read -p "Your OS? [1-2]: " OS
    
    if [ "$OS" == '1' ]; then
        os="pacman"
    elif [ "$OS" == '2' ]; then
        os="apt"
    #elif [ "$OS" == '3' ]; then
    #    os="dnf"
    #elif [ "$OS" == '4' ]; then
    #    os="zypper"
    else
		echo "Error"
		exit
    fi
    
    # Proccesing input
    if [ "$confirm" == '1' ]; then
        ex_path
        pkg_install
        flutter_install
    elif [ "$confirm" == '2' ]; then
        echo "Cancel"
        exit
    else
        echo "Error"
        exit
    fi
}

# Export path
ex_path () {
    flutter_path="source \$HOME/Android/flutterrc"
    if [[ "$current_shell" == 'zsh' ]]; then
        if ! [ -f "$HOME"/.zshrc ]; then
            touch "$HOME"/.zshrc
            echo 'source $HOME/Android/flutterrc' >> "$HOME"/.zshrc
        elif grep -q "$flutter_path" "$HOME"/.zshrc; then
            echo "Flutter is already on PATH"
        else
            echo 'source $HOME/Android/flutterrc' >> "$HOME"/.zshrc
        fi
    elif [[ "$current_shell" == 'bash' ]]; then
	    if ! [ -f "$HOME"/.bashrc ]; then
            touch "$HOME"/.bashrc
            echo 'source $HOME/Android/flutterrc' >> "$HOME"/.bashrc
        elif grep -q "$flutter_path" "$HOME"/.bashrc; then
            echo "Flutter is already on PATH"
        else
            echo 'source $HOME/Android/flutterrc' >> "$HOME"/.bashrc
        fi
    elif [[ "$current_shell" == 'fish' ]]; then
        flutter_path="source \$HOME/Android/flutter.fish"
	    if grep -q "$flutter_path" "$HOME"/.config/fish/config.fish; then
            echo "Flutter is already on PATH"
        else
            echo 'source $HOME/Android/flutter.fish' >> "$HOME"/.config/fish/config.fish
        fi
    fi
    
    # create dir
    if ! [ -d "$ANDROID_HOME" ]; then
        echo "Directory $ANDROID_HOME does not exist. Creating it now."
        mkdir -p $ANDROID_HOME
    fi
    if [[ "$current_shell" == 'zsh | bash' ]]; then
        cp -r flutterrc $ANDROID_HOME/
        source $ANDROID_HOME/flutterrc
    else
        cp -r flutter.fish $ANDROID_HOME/
        source $ANDROID_HOME/flutter.fish
    fi
}

# Required Package
pkg_install () {
	
	if [[ "$os" == 'apt' ]]; then
		sudo apt-get update
		sudo apt-get install git clang build-essential cmake ninja-build openjdk-11-jdk openjdk-11-jre libgtk-3-dev android-tools-adb which curl -y
	elif [[ "$os" == 'pacman' ]]; then
		sudo pacman -Syy git base-devel clang cmake ninja jre11-openjdk jdk11-openjdk gtk3 android-tools which curl
    #elif [[ "$os" == 'dnf' ]]; then
    #    sudo dnf update
    #    sudo dnf install git clang cmake ninja jre11-openjdk jdk11-openjdk gtk3-devel android-tools which curl
	fi
    
}

# Flutter install
flutter_install () {
    
    git clone https://github.com/flutter/flutter.git -b beta $ANDROID_HOME/flutter
    ./sdkmanager.sh
    if [[ "$current_shell" == 'zsh | bash' ]]; then
        source $ANDROID_HOME/flutterrc
    else
        source $ANDROID_HOME/flutter.fish
    fi
    sdkmanager "platform-tools" "build-tools;33.0.0" "platforms;android-33" "emulator"
    sdkmanager --licenses
    flutter precache
    flutter doctor --android-licenses
    flutter doctor -v
    
}


# Confirm
current_shell=$(basename "$SHELL")
if [[ "$current_shell" == 'zsh | bash' ]]; then
    source flutterrc
    dialog-install
elif [[ "$current_shell" == 'fish' ]]; then
    source flutter.fish
    dialog-install
else
    echo
    echo "only support bash/zsh/fish shell (your shell is: $current_shell)"
    echo
    echo "exit.."
    exit
fi
