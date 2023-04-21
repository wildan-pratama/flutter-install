#!/bin/bash

source .flutterrc

# Arch Package
arch_pkg () {
    sudo pacman -U ./*.tar.gz --noconfirm 
    yay -Syy sdkmanager git base-devel clang cmake ninja jre11-openjdk jdk11-openjdk gtk3 android-tools
}

# Debian Package
deb_pkg () {
    sudo apt-get update
    sudo apt-get install sdkmanager git clang build-essential cmake ninja-build openjdk-11-jdk openjdk-11-jre libgtk-3-dev android-tools-adb -y
}

# Flutter install
flutter_install () {
    
    if [ -d "$ANDROID_HOME"/flutter ]; then
        rm -rf $ANDROID_HOME/flutter
        git clone https://github.com/flutter/flutter.git $ANDROID_HOME/flutter
    else
        git clone https://github.com/flutter/flutter.git $ANDROID_HOME/flutter
    fi
    
    sdkmanager "cmdline-tools;latest"
    
    if [[ "$os" == 'deb' ]]; then
	    sudo apt remove --purge sdkmanager -y
    elif [[ "$os" == 'arch' ]]; then
	    yay -Rs sdkmanager --noconfirm 
    else
        exit
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
install_pkg () {
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
        arch_pkg
        os="arch"
        ;;
    2)
        echo "Installing Package for Debian"
        deb_pkg
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
        install_pkg
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
