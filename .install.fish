#!/bin/fish
source flutter.fish
echo "This script will install package required by Flutter and will download required sdk to ~/Android"
echo
    
echo "1. Continue."
echo "2. Abbort."
echo

# Read Input
echo -n "Continue? [1/2]: "
read confirm
    
# Proccesing input
if [ "$confirm" = '1' ]
	# Select OS
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
	
	set -x flutter_path "source \$HOME/Android/flutter.fish"
	if grep -q "$flutter_path" "$HOME"/.config/fish/config.fish
		echo "Flutter is already on PATH"
	else
		echo 'source $HOME/Android/flutter.fish' >> "$HOME"/.config/fish/config.fish
	end
	
	# create dir
	if test -d "$ANDROID_HOME"
		echo "The directory exists."
	else
		echo "Directory $ANDROID_HOME does not exist. Creating it now."
		mkdir -p $ANDROID_HOME
	end
	
	cp -r flutter.fish $ANDROID_HOME/
	source $ANDROID_HOME/flutter.fish
	
	if test "$os" = "apt" -o "$os" = "aptub"
		sudo apt-get update
		sudo apt-get install git clang build-essential cmake ninja-build wget apt-transport-https libgtk-3-dev android-tools-adb which curl -y
		sudo mkdir -p /etc/apt/keyrings
		wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
		
		if [ "$os" = 'apt' ]
			echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
		else if [ "$os" = 'aptub' ]
			echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^UBUNTU_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
		end
		
		sudo apt-get update
		sudo apt-get install temurin-11-jdk temurin-11-jre -y
		
	else if [ "$os" = 'pacman' ]
		sudo pacman -Syy git base-devel clang cmake ninja jdk11-openjdk jre11-openjdk gtk3 android-tools which curl
	end
	
	git clone https://github.com/flutter/flutter.git -b beta $ANDROID_HOME/flutter
	./sdkmanager.sh
	source $ANDROID_HOME/flutter.fish
	sdkmanager "platform-tools" "build-tools;33.0.0" "platforms;android-33" "emulator"
	sdkmanager --licenses
	flutter precache
	flutter doctor --android-licenses
	flutter doctor -v
	
else if [ "$confirm" = '2' ]
		echo "Cancel"
		exit
else
		echo "Error"
		exit
end

    
    

