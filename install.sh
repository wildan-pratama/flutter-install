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
    echo "2. Debian 11 based OS or newer (APT)."
	echo "3. Ubuntu 20.04 LTS based OS or newer (APT)."
    echo

    # Read Input
    read -p "Your OS? [1-3]: " OS
    
    if [ "$OS" == '1' ]; then
        os="pacman"
    elif [ "$OS" == '2' ]; then
        os="apt"
    elif [ "$OS" == '3' ]; then
        os="aptub"
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
    fi
    
    # create dir
    if ! [ -d "$ANDROID_HOME" ]; then
        echo "Directory $ANDROID_HOME does not exist. Creating it now."
        mkdir -p $ANDROID_HOME
    fi
    
    cp -r flutterrc $ANDROID_HOME/
    source $ANDROID_HOME/flutterrc
}

# Required Package
pkg_install () {
	
	if [[ "$os" == "apt" || "$os" == "aptub" ]]; then
		sudo apt-get update
		sudo apt-get install git clang build-essential cmake ninja-build wget apt-transport-https libgtk-3-dev android-tools-adb which curl -y
		sudo mkdir -p /etc/apt/keyrings
		wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
		
		if [ "$os" = 'apt' ]; then
			echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
		elif [ "$os" = 'aptub' ]; then
			echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^UBUNTU_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
		fi
		
		sudo apt-get update
		sudo apt-get install temurin-11-jdk temurin-11-jre -y
	elif [[ "$os" == 'pacman' ]]; then
		sudo pacman -Syy git base-devel clang cmake ninja jdk11-openjdk jre11-openjdk gtk3 android-tools which curl
	fi
    
}

# Flutter install
flutter_install () {
    
    git clone https://github.com/flutter/flutter.git -b beta $ANDROID_HOME/flutter
    ./sdkmanager.sh
    source $ANDROID_HOME/flutterrc
    source $ANDROID_HOME/flutter.fish
    sdkmanager "platform-tools" "build-tools;33.0.0" "platforms;android-33" "emulator"
    sdkmanager --licenses
    flutter precache
    flutter doctor --android-licenses
    flutter doctor -v
    
}


# Confirm
current_shell=$(basename "$SHELL")
if [[ "$current_shell" == "bash" || "$current_shell" == "zsh" ]]; then
    source flutterrc
    dialog-install
elif [[ "$current_shell" == 'fish' ]]; then
    ./.install.fish
else
    echo
    echo "only support bash/zsh/fish shell (your shell is: $current_shell)"
    echo
    echo "exit.."
    exit
fi
