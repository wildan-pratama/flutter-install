#!/bin/fish
source flutter.fish
echo
echo "This script will install package required by Flutter and will download required sdk to $ANDROID_HOME"
echo

# Read Input
#set -p "Continue? [Yes/yes/y/No/no/n]: " confirm
echo -n "Continue? [Yes/yes/y/No/no/n]: "
read confirm
    
# Proccesing input
switch $confirm
    case "Yes" "yes" "y"
   
		# Select OS
		echo
		echo "Please chose your os:"
		echo "1. Arch linux based OS (Pacman)."
		echo "2. Debian 11 based OS or newer (APT)."
		echo "3. Ubuntu 20.04 LTS based OS or newer (APT)."
		echo
	
		# Read Input
		echo -n "Your OS? [1-3]: "
		read OS
	
		if [ "$OS" = '1' ]
			set -x os "pacman"
		else if [ "$OS" = '2' ]
			set -x os "apt"
		else if [ "$OS" = '3' ]
			set -x os "aptub"
		else
			echo "Error"
			exit
		end
		
		# Android studio
        echo
        echo "Do you want Install with Android Studio?"
		echo 
		
		#set -p "[Yes/yes/y/No/no/n]: " astudio
		echo -n "[Yes/yes/y/No/no/n]: "
		read astudio
		
		# Install PKGS
		if test "$os" = "apt" -o "$os" = "aptub"
			sudo apt-get update
			sudo apt-get install git clang build-essential cmake ninja-build wget apt-transport-https libgtk-3-dev android-tools-adb which curl -y
			
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
					sudo apt-get install temurin-11-jdk temurin-11-jre -y
				
				case "*"
					echo
					echo "Error, Please repeat from the beginning and choose install with or without android."
					echo
					exit
			end
		
		else if [ "$os" = 'pacman' ]
			sudo pacman -Syy --noconfirm git base-devel clang cmake ninja gtk3 android-tools which curl
			
			switch $astudio
				case "Yes" "yes" "y"
					echo
					echo "Skip installing java, beacuse included with Android studio"
					echo
				
				case "No" "no" "n"
					sudo pacman -Syy --noconfirm jdk11-openjdk jre11-openjdk 
				
				case "*"
					echo
					echo "Error, Please repeat from the beginning and choose install with or without android."
					echo
					exit
			end
		end
	
		# Exporting PATH
		set -x flutter_path "source \$HOME/Android/flutter.fish"
		if grep -q "$flutter_path" "$HOME"/.config/fish/config.fish
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
        git clone https://github.com/flutter/flutter.git -b beta $ANDROID_HOME/flutter
        
        ## installing sdk
        ./sdkmanager.sh $astudio
        
        
        source $ANDROID_HOME/flutterrc
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

    
    

