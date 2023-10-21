#!/usr/bin/env fish

source flutter.fish
echo
echo "This script will install package required by Flutter and will download required sdk to $ANDROID_HOME"
echo

# Read Input
echo "Continue? [Yes/yes/y/No/no/n]: "
read confirm
    
# Proccesing input
switch $confirm
    case "Yes" "yes" "y"

		# Select channel
		set -x channel "stable"
        echo
        echo "Please slect flutter channel you want install:"
        echo "1. Stable (default, updated quarterly, for new users and for production app releases)."
        echo "2. Beta (updated monthly, recommended for experienced users)."
	    echo "3. Main (latest development branch, follows master channel)."
		echo "4. Master (latest development branch, for contributors)."
        echo

		echo "Channel? [1-4]: "
		read channel

		if [ "$channel" = '1' ]
			set -x channel "stable"
		else if [ "$channel" = '2' ]
			set -x channel "beta"
		else if [ "$channel" = '3' ]
			set -x channel "main"
		else if [ "$channel" = '4' ]
			set -x channel "master"
		else
			echo
		    echo "Please select channel"
		    exit
		end

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
		echo "Your OS? [1-3]: "
		read OS
	
		if [ "$OS" = '1' ]
			set -x os "pacman"
		else if [ "$OS" = '2' ]
			set -x os "apt"
		else if [ "$OS" = '3' ]
			set -x os "aptub"
		else
			echo
		    echo "Please select your os (1, 2 or 3)"
			exit
		end
		
		# Android studio
        echo
        echo "Do you want Install with Android Studio?"
		echo 
		
		echo "[Yes/yes/y/No/no/n]: "
		read astudio
		
		switch $astudio
			case "Yes" "yes" "y"
				echo
				echo "Installing with Android Studio"
				echo 
				
			case "No" "no" "n"
				echo
				echo "Please chose Java version: "
				echo
				echo "1. Java 11 LTS"
				echo "2. Java 17 LTS"
				echo "3. Java 21 LTS"
				echo
				echo "[1-3]?: "
				read javaver
				
				if [ "$javaver" = '1' ]
					echo
					echo "selecting Java 11 LTS"
					echo
				else if [ "$javaver" = '2' ]
					echo
					echo "selecting Java 17 LTS"
					echo
				else if [ "$javaver" = '3' ]
					echo
					echo "selecting Java 21 LTS"
					echo
				else
					echo
					echo "Error, Please select correct java version (1, 2 or 3)."
					echo
					exit
				end
			
			case "*"
				echo
				echo "Error, Please repeat from the beginning and choose install with or without android."
				echo
				exit
		end
				
		
		# Install PKGS
		if test "$os" = "apt" -o "$os" = "aptub"
			sudo apt-get update
			sudo apt-get install git clang build-essential cmake ninja-build wget apt-transport-https libgtk-3-dev android-tools-adb which curl unzip -y
			
			switch $astudio
				case "Yes" "yes" "y"
					echo
					echo "Skip installing java, beacuse included with Android studio"
					echo
				
				case "No" "no" "n"
					sudo mkdir -p /etc/apt/keyrings
					wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
		
					if [ "$os" = 'apt' ]
						echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
					else if [ "$os" = 'aptub' ]
						echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^UBUNTU_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
					end
		
					sudo apt-get update
					
					if [ "$javaver" = '1' ]
						sudo apt-get install temurin-11-jdk -y
					else if [ "$javaver" = '2' ]
						sudo apt-get install temurin-17-jdk -y
					else if [ "$javaver" = '3' ]
						sudo apt-get install temurin-21-jdk -y
					end
			end
		
		else if [ "$os" = 'pacman' ]
			sudo pacman -Syy --noconfirm git base-devel clang cmake ninja gtk3 android-tools which curl unzip
			
			switch $astudio
				case "Yes" "yes" "y"
					echo
					echo "Skip installing java, beacuse included with Android studio"
					echo
				
				case "No" "no" "n"
					if [ "$javaver" = '1' ]
						sudo pacman -Syy --noconfirm jdk11-openjdk
					else if [ "$javaver" = '2' ]
						sudo pacman -Syy --noconfirm jdk17-openjdk
					else if [ "$javaver" = '3' ]
						sudo pacman -Syy --noconfirm jdk21-openjdk
					end
			end
		end
	
		# Exporting PATH
		if grep -q "source \$HOME/Android/flutter.fish" "$HOME"/.config/fish/config.fish
			echo "Flutter is already on PATH"
		else
			echo 'source $HOME/Android/flutter.fish' >> "$HOME"/.config/fish/config.fish
		end
	
		# Create DIR
		if test -d "$ANDROID_SDK_ROOT"
			echo "The directory exists."
		else
			echo "Directory $ANDROID_HOME does not exist. Creating it now."
			mkdir -p $ANDROID_SDK_ROOT
		end
	
		cp -r flutter.fish $ANDROID_HOME/
		cp -r flutterrc $ANDROID_HOME/
		source $ANDROID_HOME/flutter.fish
	
		# Install Flutter and Android SDK
        ## clone Flutter
        git clone https://github.com/flutter/flutter.git -b $channel $ANDROID_HOME/flutter
        
        ## installing sdk
		switch $astudio
			case "Yes" "yes" "y"
				./sdkmanager.sh $astudio
				
			case "No" "no" "n"
				./sdkmanager.sh $javaver
		
		end
        
        sdkmanager "platform-tools" "build-tools;33.0.0" "platforms;android-33" "emulator"
        sdkmanager --licenses
        flutter precache
        flutter doctor --android-licenses
        flutter doctor -v
	
	case "No" "no" "n"
		echo
		echo "Cancel"
		exit
		
	case "*"
		echo
		echo "Error"
		exit
end

    
    

