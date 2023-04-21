#!/bin/bash

source .flutterrc

# Arch Package
arch_pkg () {
    sudo yay -Syy sdkmanager git base-devel clang cmake ninja jre11-openjdk jdk11-openjdk gtk3 android-tools --noconfirm 
}

# Debian Package
deb_pkg () {
    sudo apt-get update
    sudo apt-get install sdkmanager git clang build-essential cmake ninja-build openjdk-11-jdk openjdk-11-jre libgtk-3-dev android-tools-adb -y
}

# Flutter install
flutter_install () {
    git clone https://github.com/flutter/flutter.git $ANDROID_HOME/flutter
    sdkmanager "platform-tools" "build-tools;33.0.0-rc4" "platforms;android-33" "cmdline-tools;latest"
    sdkmanager --licenses
    flutter doctor --android-licenses
    flutter doctor -v
}

# Export path
ex_path () {
    # create dir
    if [ -d "$ANDROID_SDK_ROOT" ]; then
        echo "Directory $ANDROID_SDK_ROOT exists. Skip create dir"
    else
        echo "Directory $ANDROID_SDK_ROOT does not exist. Creating it now."
        mkdir -p $ANDROID_SDK_ROOT
    fi
    
    # copy .flutterrc
    if [ ! -f "$ANDROID_HOME"/.flutterrc ]; then
        cp .flutterrc $ANDROID_HOME/
    elif cmp -s .flutterrc "$ANDROID_HOME"/.flutterrc; then
        exit
    else
        rm -rf "$ANDROID_HOME"/.flutterrc
        cp .flutterrc $ANDROID_HOME/
    fi

    # export bash/zsh
    flutter_path="source $HOME/Android/.flutterrc"
    
    if [ ! -f "$HOME"/.bashrc ]; then
        touch "$HOME"/.bashrc
        echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.bashrc
    elif grep -q "$flutter_path" "$HOME"/.bashrc; then
        exit
    else
        echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.bashrc
    fi
    
    if [ ! -f "$HOME"/.zshrc ]; then
        touch "$HOME"/.zshrc
        echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.zshrc
    elif grep -q "$flutter_path" "$HOME"/.zshrc; then
        exit
    else
        echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.zshrc
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
        ;;
    2)
        echo "Installing Package for Debian"
        deb_pkg
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
    echo "You are using '$0' shell"
    
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
        echo "if you want export manualy path you can run command"
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