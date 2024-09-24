#!/usr/bin/env bash

current_shell=$(basename "$SHELL")
case $current_shell in
	bash | zsh)
	
    source flutterrc
    echo
    echo "This script will install package required by Flutter and will download required sdk to $ANDROID_HOME"
    echo
    
    # Read Input
    read -p "Continue? [Yes/yes/Y/y/No/no/N/n]: " confirm
    
    # Proccesing input
    case $confirm in
		Yes | yes | Y | y)
		# Select channel
		channel="stable"
        echo
        echo "Please slect flutter channel you want install:"
        echo "1. Stabel (default, updated quarterly, for new users and for production app releases)."
        echo "2. Beta (updated monthly, recommended for experienced users)."
	    echo "3. Main (latest development branch, follows master channel)."
		echo "4. Master (latest development branch, for contributors)."
        echo

		# Read Input
		read -p "Channel? [1-4]: " channel
    
        if [ "$channel" == '1' ]; then
            channel="stable"
        elif [ "$channel" == '2' ]; then
            channel="beta"
        elif [ "$channel" == '3' ]; then
            channel="main"
		elif [ "$channel" == '4' ]; then
            channel="master"
        else
		    echo
		    echo "Please select channel"
		    exit
        fi

		echo
		echo "installing Fluter $channel"
		echo

        # Select OS
        echo
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
		    echo
		    echo "Please select your os (1, 2 or 3)"
		    exit
        fi
        
        # Android studio
        echo
        echo "Do you want Install with Android Studio?"
		echo 

		# Read Input
		read -p "[Yes/yes/y/No/no/n]: " astudio
		
		case $astudio in
			Yes | yes | y)
				echo
				echo "Installing with Android Studio"
				echo 
				;;
				
			No | no | n)
				echo
				echo "Please chose Java version: "
				echo
				echo "1. Java 11 LTS"
				echo "2. Java 17 LTS"
				echo "3. Java 21 LTS"
				echo
				
				read -p "[1-3]?: " javaver
				
				if [ "$javaver" == '1' ]; then
					echo
					echo "selecting Java 11 LTS"
					echo
				elif [ "$javaver" == '2' ]; then
					echo
					echo "selecting Java 17 LTS"
					echo
				elif [ "$javaver" == '3' ]; then
					echo
					echo "selecting Java 21 LTS"
					echo
				else
					echo
					echo "Error, Please select correct java version (1, 2 or 3)."
					echo
					exit
				fi
				;;
				
			*)
				echo
				echo "Error, Please repeat from the beginning and choose install with or without android."
				echo
				exit
				;;
		esac
        
        # Intalling PKGS
        if [[ "$os" == "apt" || "$os" == "aptub" ]]; then
		    sudo apt-get update
		    sudo apt-get install git clang build-essential cmake ninja-build wget apt-transport-https libgtk-3-dev android-tools-adb which curl unzip -y
		    case $astudio in
				Yes | yes | y)
					echo
					echo "Skip installing java, beacuse included with Android studio"
					echo
					;;
					
				No | no | n)	
					sudo mkdir -p /etc/apt/keyrings
					wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
		    
					if [ "$os" = 'apt' ]; then
						echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
					elif [ "$os" = 'aptub' ]; then
						echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^UBUNTU_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
					fi
					
					sudo apt-get update
					
					if [ "$javaver" = '1' ]; then
						sudo apt-get install temurin-11-jdk -y
					elif [ "$javaver" = '2' ]; then
						sudo apt-get install temurin-17-jdk -y
					elif [ "$javaver" = '3' ]; then
						sudo apt-get install temurin-21-jdk -y
					fi
					;;
			esac

	    elif [[ "$os" == 'pacman' ]]; then
			sudo pacman -Syy --noconfirm git base-devel clang cmake ninja gtk3 android-tools which curl unzip
			case $astudio in
				Yes | yes | y)
					echo
					echo "Skip installing java, beacuse included with Android studio"
					echo
					;;
				
				No | no | n)
					if [ "$javaver" = '1' ]; then
						sudo pacman -Syy --noconfirm jdk11-openjdk
					elif [ "$javaver" = '2' ]; then
						sudo pacman -Syy --noconfirm jdk17-openjdk
					elif [ "$javaver" = '3' ]; then
						sudo pacman -Syy --noconfirm jdk21-openjdk 
					fi
					;;
			esac
	    fi
		
		
		# Exporting PATH
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
    
        # Create DIR
        if ! [ -d "$ANDROID_SDK_ROOT" ]; then
            echo "Directory $ANDROID_HOME does not exist. Creating it now."
            mkdir -p $ANDROID_SDK_ROOT
        fi
    
        cp -r flutterrc $ANDROID_HOME/
        cp -r flutter.fish $ANDROID_HOME/
        source $ANDROID_HOME/flutterrc
        
        # Install Flutter and Android SDK
        ## clone Flutter
        git clone https://github.com/flutter/flutter.git -b $channel $ANDROID_HOME/flutter
        
        ## installing sdk
		case $astudio in
			Yes | yes | y)
				./sdkmanager.sh $astudio
				;;
				
			No | no | n)
				./sdkmanager.sh $javaver
				;;
		esac
        
        
        sdkmanager "platform-tools" "build-tools;33.0.0" "platforms;android-33" "emulator"
        sdkmanager --licenses
        flutter precache
        flutter doctor --android-licenses
        flutter doctor -v
		;;
		
		No | no | N | n)
		echo "Cancel"
		exit
		;;
		
		*)
		echo "Error"
        exit
		;;
		
		esac	
    ;;
    
	fish)
    ./install.fish
    ;;
    
    *)
    echo
    echo "only support bash/zsh/fish shell (your shell is: $current_shell)"
    echo
    echo "exit.."
    exit
    ;;
    
esac

