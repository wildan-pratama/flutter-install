#!/bin/sh
sudo pacman -Syy git base-devel clang cmake ninja jre11-openjdk jdk11-openjdk gtk3 android-tools --noconfirm 

git clone https://github.com/flutter/flutter.git /home/Android/flutter
sdkmanager "platform-tools"
sdkmanager "build-tools;33.0.0"
sdkmanager "platforms;android-33"
sdkmanager "cmdline-tools;latest"
sdkmanager --licenses
flutter doctor --android-licenses
flutter doctor -v
