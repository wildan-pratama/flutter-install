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

    # Proccesing input
    case $confirm in
    1)
        sel_os
        ex_path
        pkg_install
        flutter_install
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

# Export path
ex_path () {

    flutter-path () {

        current_shell=$(basename "$SHELL")
        flutter_path="source \$HOME/Android/.flutterrc"

        if [[ "$current_shell" == 'zsh' ]]; then
	        if [ ! -f "$HOME"/.zshrc ]; then
                touch "$HOME"/.zshrc
                echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.zshrc
            elif grep -q "$flutter_path" "$HOME"/.zshrc; then
                echo "Flutter is already on PATH"
            else
                echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.zshrc
            fi
        elif [[ "$current_shell" == 'bash' ]]; then
	        if [ ! -f "$HOME"/.bashrc ]; then
                touch "$HOME"/.bashrc
                echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.bashrc
            elif grep -q "$flutter_path" "$HOME"/.bashrc; then
                echo "Flutter is already on PATH"
            else
                echo 'source $HOME/Android/.flutterrc' >> "$HOME"/.bashrc
            fi
        else
            exit
        fi
    }
    
    # create dir
    if [ ! -d "$ANDROID_SDK_ROOT" ]; then
        echo "Directory $ANDROID_SDK_ROOT does not exist. Creating it now."
        mkdir -p $ANDROID_SDK_ROOT
    elif [ ! -f "$ANDROID_HOME"/.flutterrc ]; then
        cp .flutterrc $ANDROID_HOME/
        flutter-path
    elif cmp -s .flutterrc "$ANDROID_HOME"/.flutterrc; then
        flutter-path
    else
         rm -rf "$ANDROID_HOME"/.flutterrc
         cp .flutterrc $ANDROID_HOME/
         flutter-path
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
        echo "Setup path, directory and installing Package for Arch"
        os="arch"
        ;;
    2)
        echo "Setup path, directory and installing Package for Debian"
        os="deb"
        ;;
    *)
        echo "Error"
        ;;
    esac
}

# Required Package
pkg_install () {

    sdkmanager_path="$ANDROID_HOME/sdk/cmdline-tools/latest/bin/sdkmanager"

    if [ ! -f "$sdkmanager_path" ]; then
        sdkmanager="sdkmanager"
    else
        sdkmanager=""
    fi

    if [[ "$os" == 'deb' ]]; then
	    sudo apt-get update
        sudo apt-get install git clang build-essential cmake ninja-build openjdk-11-jdk openjdk-11-jre libgtk-3-dev android-tools-adb which $sdkmanager -y
    elif [[ "$os" == 'arch' ]]; then
        sudo pacman -Syy git base-devel clang cmake ninja jre11-openjdk jdk11-openjdk gtk3 android-tools which $sdkmanager
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
	        sudo pacman -Rs sdkmanager --noconfirm 
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
    #if [ -d $ANDROID_HOME/cmdline-tools ]; then
    #    ln -sf $ANDROID_HOME/cmdline-tools $ANDROID_SDK_ROOT/
    #else
    #    echo
    #fi

    source $HOME/Android/.flutterrc

    sdkmanager "platform-tools" "build-tools;33.0.0-rc4" "platforms;android-33"
    sdkmanager --licenses
    flutter doctor --android-licenses
    flutter doctor -v
}


install () {
    # Confirm
    current_shell=$(basename "$SHELL")
    if [[ "$current_shell" == 'zsh' ]]; then
        source .flutterrc
        dialog-install
    elif [[ "$current_shell" == 'bash' ]]; then
        source .flutterrc
        dialog-install
    else
        echo
        echo "only support bash/zsh shell (your shell is: $current_shell)"
        echo
        echo "exit.."
        exit
    fi
    
}

install

