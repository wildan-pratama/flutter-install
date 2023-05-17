#!/bin/bash

source .flutterrc

sdkmanager_path="$ANDROID_HOME/sdk/cmdline-tools/latest/bin/sdkmanager"

if [ ! -f "$sdkmanager_path" ]; then
    sdkmanager="sdkmanager"
else
    sdkmanager=""
fi


# Required Package

yay-cek () {
    if command -v yay &> /dev/null
    then
        yay -Syy git base-devel clang cmake ninja jre11-openjdk jdk11-openjdk gtk3 android-tools which $sdkmanager
    else
        sudo pacman -S base-devel
        git clone https://aur.archlinux.org/yay-bin
        cd yay-bin
        makepkg -si
        cd ..
        yay -Syy git clang cmake ninja jre11-openjdk jdk11-openjdk gtk3 android-tools which $sdkmanager
    fi
}
pkg_install () {
    if [[ "$os" == 'deb' ]]; then
	sudo apt-get update
        sudo apt-get install git clang build-essential cmake ninja-build openjdk-11-jdk openjdk-11-jre libgtk-3-dev android-tools-adb which $sdkmanager -y
    elif [[ "$os" == 'arch' ]]; then
        yay_cek
    else
        exit
    fi
}

# Flutter install
flutter_install () {
    
    git clone https://github.com/flutter/flutter.git -b stable $ANDROID_HOME/flutter
    
    uninstall_sdkmanager () {
    	if [[ "$os" == 'deb' ]]; then
	        sudo apt remove --purge sdkmanager -y
        elif [[ "$os" == 'arch' ]]; then
	        yay -Rs sdkmanager --noconfirm 
        else
            exit
        fi
    }

    if [ -f "$sdkmanager_path" ]; then
	uninstall_sdkmanager
    else
        sdkmanager "cmdline-tools;latest"
	uninstall_sdkmanager
    fi

    sdkmanager "platform-tools" "build-tools;33.0.0-rc4" "platforms;android-33"
    sdkmanager --licenses
    flutter doctor --android-licenses
    flutter doctor -v
}

# Export path
ex_path () {

    flutter_paths () {
    # export bash/zsh
        flutter_path="source \$HOME/Android/.flutterrc"
    
        if [ ! -f "$HOME"/.bashrc ]; then
            touch "$HOME"/.bashrc
            echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.bashrc
        elif grep -q "$flutter_path" "$HOME"/.bashrc; then
            echo ""
        else
            echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.bashrc
        fi
    
        if [ ! -f "$HOME"/.zshrc ]; then
            touch "$HOME"/.zshrc
            echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.zshrc
        elif grep -q "$flutter_path" "$HOME"/.zshrc; then
            echo ""
        else
            echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.zshrc
        fi
    }
    
    # create dir
    if [ ! -d "$ANDROID_SDK_ROOT" ]; then
        echo "Directory $ANDROID_SDK_ROOT does not exist. Creating it now."
        mkdir -p $ANDROID_SDK_ROOT
    elif [ ! -f "$ANDROID_HOME"/.flutterrc ]; then
        cp .flutterrc $ANDROID_HOME/
        flutter_paths
    elif cmp -s .flutterrc "$ANDROID_HOME"/.flutterrc; then
        flutter_paths
    else
         rm -rf "$ANDROID_HOME"/.flutterrc
         cp .flutterrc $ANDROID_HOME/
         flutter_paths
    fi
}

# Select OS and install Package
sel_os () {
    # Select OS
    echo "Please chose your os:"
    echo "1. Arch base like Artix, Manjaro, Garuda Linux, etc."
    echo "2. Debian base like Ubuntu, MX Linux, ZorinOS, etc."
    echo

    # Read Input
    read -p "Your OS? [1-2]: " OS

    # Proccesing input
    case $OS in
    1)
        echo "Installing Package for Arch"
        os="arch"
        ;;
    2)
        echo "Installing Package for Debian"
        os="deb"
        ;;
    *)
        echo "Error"
        ;;
    esac
}

install () {
    # Confirm
    echo "This script will install package required by Flutter and will download required sdk to $ANDROID_HOME"
    echo "and only support bash/zsh shell"
    echo "You are using '$SHELL' shell"
    
    echo "1. Continue."
    echo "2. Abbort."
    echo

    # Read Input
    read -p "Continue? [1/2]: " confirm

    # Proccesing input
    case $confirm in
    1)
        ex_path
        sel_os
        pkg_install
        flutter_install
        echo "if you want export manualy path you can run command:"
        echo "echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.zshrc (for zsh shell)"
        echo "echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.bashrc (for bash shell)"
        
        ;;
    2)
        echo "Cancel"
        exit
        ;;
    *)
        echo "Error"
        ;;
    esac
}

install
