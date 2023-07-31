#!/bin/bash

# Check if the correct number of arguments is provided
verify_checksum () {
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 <file_path> <expected_checksum>"
    exit 1
    fi

    file_path="$1"
    expected_checksum="$2"

    # Check if the file exists
    if [ ! -f "$file_path" ]; then
        echo "Error: File not found!"
        exit 1
    fi

    # Compute the actual SHA-256 checksum
    actual_checksum=$(sha256sum "$file_path" | awk '{print $1}')

    # Compare the actual and expected checksums
    if [ "$actual_checksum" = "$expected_checksum" ]; then
        echo "Checksum verified successfully!"
    else
        echo "Checksum verification failed!"
        filecheck="failed"
    fi

    }

filesdk="commandlinetools-linux-9477386_latest.zip"

verify_file () {
    verify_checksum "$filesdk" bd1aa17c7ef10066949c88dc6c9c8d536be27f992a1f3b5a584f9bd2ba5646a0
    }

failedcheck () {
    if [[ "$filecheck" == 'failed' ]]; then
        rm -rf "$filesdk"
        curl -o "$filesdk" https://dl.google.com/android/repository/"$filesdk"
        verify_file
    fi
    }

if [ ! -f "$filesdk" ]; then
    curl -o "$filesdk" https://dl.google.com/android/repository/"$filesdk"
fi

verify_file
failedcheck

# create dir
if [ ! -d "$ANDROID_HOME"/cmdline-tools/latest ]; then
    mkdir -p $ANDROID_HOME/cmdline-tools/latest
else
    rm -rf $ANDROID_HOME/cmdline-tools/latest/*
fi
unzip commandlinetools-linux-9477386_latest.zip
mv cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest/
