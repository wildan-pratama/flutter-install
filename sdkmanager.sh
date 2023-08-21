#!/bin/bash

# Define the URL, file name, and expected checksum
URL="https://example.com/path/to/your/file"
FILENAME="yourfile.ext"
EXPECTED_CHECKSUM="expected_checksum_here"

sdkmanager-install () {
    # Define the URL, file name, and expected checksum
    FILENAME="commandlinetools-linux-9477386_latest.zip"
    URL="https://dl.google.com/android/repository/"$FILENAME""
    EXPECTED_CHECKSUM="bd1aa17c7ef10066949c88dc6c9c8d536be27f992a1f3b5a584f9bd2ba5646a0"
    processfile
    if ! [ -d "$ANDROID_HOME"/cmdline-tools/latest ]; then
        mkdir -p $ANDROID_HOME/cmdline-tools/latest
    else
        rm -rf $ANDROID_HOME/cmdline-tools/latest/*
    fi
    unzip $FILENAME
    mv cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest/
}

# Function to calculate checksum
calculate_checksum() {
    local file="$1"
    echo $(sha256sum "$file" | awk '{print $1}')
}

redownload () {
    echo "Downloaded file checksum mismatch. Redownload file?."
    echo 
    echo "1. Yes."
    echo "2. No."
    echo

    # Read Input
    read -p "Redownload? [1-2]: " redown

    if [ "$redown" == '1' ]; then
        processfile
    else
        exit
    fi
}

processfile () {
# Check if the file exists
if [ -e "$FILENAME" ]; then
    # Calculate the current checksum of the file
    CURRENT_CHECKSUM=$(calculate_checksum "$FILENAME")
    
    # Compare the current checksum with the expected checksum
    if [ "$CURRENT_CHECKSUM" == "$EXPECTED_CHECKSUM" ]; then
        echo "Checksum matched. File is valid."
    else
        echo "Checksum mismatch. Downloading the file again..."
        # Download the file using curl
        curl -o "$FILENAME" "$URL"
        
        # Verify the newly downloaded file's checksum
        NEW_CHECKSUM=$(calculate_checksum "$FILENAME")
        if [ "$NEW_CHECKSUM" == "$EXPECTED_CHECKSUM" ]; then
            echo "Downloaded file checksum verified. File is valid."
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
    else
        redownload
    fi
fi
}

echo "Do you want Install with Android Studio?"
	echo 
	echo "1. Yes."
	echo "2. No."
	echo

	# Read Input
	read -p "Yes/No? [1-2]: " astudio

if [[ "$astudio" == '1' ]]; then
	# Define the URL, file name, and expected checksum
    FILENAME="android-studio-2022.3.1.18-linux.tar.gz"
    URL="https://r1---sn-npoe7nsk.gvt1.com/edgedl/android/studio/ide-zips/2022.3.1.18/"$FILENAME""
    EXPECTED_CHECKSUM="24215e1324a6ac911810b2cc1afb2d735cf745dfbc06918a42b8d6fbc6bf7433"
    processfile
    cp android-studio.desktop /usr/share/applications/
    tar -xvf $FILENAME
    sudo mv android-studio /opt/
    flutter config --android-studio-dir=/opt/android-studio
    sdkmanager-install
elif [[ "$astudio" == '2' ]]; then
	sdkmanager-install
else
    echo "Input error"
fi
