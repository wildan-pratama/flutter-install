#!/bin/bash

# Define the URL, file name, and expected checksum
URL="https://example.com/path/to/your/file"
FILENAME="yourfile.ext"
EXPECTED_CHECKSUM="expected_checksum_here"
ANDROID_SDK_ROOT="$HOME/Android/sdk"

# Extract FILE
extract_file() {
	if [ "$FILE" == "sdkmanager" ]; then
		unzip $FILENAME
	elif [ "$FILE" == "android-studio" ]; then
		tar -xvf $FILENAME
	fi
}

# Function to calculate checksum
calculate_checksum() {
    local file="$1"
    echo $(sha256sum "$file" | awk '{print $1}')
}

redownload () {
	echo
    echo "Downloaded file checksum mismatch. Redownload file?." 
    echo

    # Read Input
    read -p "Redownload? [Yes/yes/y/No/no/n]: " redown
	
	case $redown in
		Yes | yes | y)
			processfile
			;;
		
		*)
			echo
			echo "Please start again from beginning"
			echo
			exit
			;;
	esac
}

processfile () {
# Check if the file exists
if [ -e "$FILENAME" ]; then
    # Calculate the current checksum of the file
    CURRENT_CHECKSUM=$(calculate_checksum "$FILENAME")
    
    # Compare the current checksum with the expected checksum
    if [ "$CURRENT_CHECKSUM" == "$EXPECTED_CHECKSUM" ]; then
        echo "Checksum matched. File is valid."
		extract_file
    else
        echo "Checksum mismatch. Downloading the file again..."
        # Download the file using curl
        curl -o "$FILENAME" "$URL"
        
        # Verify the newly downloaded file's checksum
        NEW_CHECKSUM=$(calculate_checksum "$FILENAME")
        if [ "$NEW_CHECKSUM" == "$EXPECTED_CHECKSUM" ]; then
            echo "Downloaded file checksum verified. File is valid."
            extract_file
        else
            redownload
        fi
    fi
else
    echo "File not found. Downloading the file..."
    # Download the file using curl
    curl -o "$FILENAME" "$URL"
    
    # Verify the downloaded file's checksum
    NEW_CHECKSUM=$(calculate_checksum "$FILENAME")
    if [ "$NEW_CHECKSUM" == "$EXPECTED_CHECKSUM" ]; then
        echo "Downloaded file checksum verified. File is valid."
        extract_file
    else
        redownload
    fi
fi
}

case $1 in
  Yes | yes | y)
	# Define the URL, file name, and expected checksum
    FILE="android-studio"
    FILENAME="android-studio-2022.3.1.20-linux.tar.gz"
    URL="https://r1---sn-npoe7ner.gvt1.com/edgedl/android/studio/ide-zips/2022.3.1.20/"$FILENAME""
    EXPECTED_CHECKSUM="224c4eb7a0c8e1c04f50eced1013495740c71abb898d5749d2c93172e7beadd8"
    
    if [ -d android-studio ]; then
		rm -rf android-studio
    fi
    
    processfile
    
    cp android-studio.desktop /usr/share/applications/
    if [ -d /opt/android-studio ]; then
        sudo rm -rf /opt/android-studio
    fi
    
    sudo mv android-studio /opt/
    flutter config --android-studio-dir=/opt/android-studio
    ;;
esac

case $1 in
  Yes | yes | y | 2 | 3)
	# Define the URL, file name, and expected checksum
    FILE="sdkmanager"
    FILENAME="commandlinetools-linux-10406996_latest.zip"
    URL="https://dl.google.com/android/repository/"$FILENAME""
    EXPECTED_CHECKSUM="8919e8752979db73d8321e9babe2caedcc393750817c1a5f56c128ec442fb540"

    if [ -d cmdline-tools ]; then
		rm -rf cmdline-tools
    fi

    processfile
    
    if ! [ -d "$ANDROID_SDK_ROOT"/cmdline-tools/latest ]; then
        mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/latest
    else
        rm -rf $ANDROID_SDK_ROOT/cmdline-tools/latest/*
    fi
    
    mv cmdline-tools/* $ANDROID_SDK_ROOT/cmdline-tools/latest/
    rm -rf cmdline-tools
    ;;

  1)
    # Define the URL, file name, and expected checksum
    FILE="sdkmanager"
    FILENAME="commandlinetools-linux-9477386_latest.zip"
    URL="https://dl.google.com/android/repository/"$FILENAME""
    EXPECTED_CHECKSUM="bd1aa17c7ef10066949c88dc6c9c8d536be27f992a1f3b5a584f9bd2ba5646a0"

    if [ -d cmdline-tools ]; then
		rm -rf cmdline-tools
    fi

    processfile
    
    if ! [ -d "$ANDROID_SDK_ROOT"/cmdline-tools/latest ]; then
        mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/latest
    else
        rm -rf $ANDROID_SDK_ROOT/cmdline-tools/latest/*
    fi
    
    mv cmdline-tools/* $ANDROID_SDK_ROOT/cmdline-tools/latest/
    rm -rf cmdline-tools
    ;;
esac