#!/bin/sh
sudo apt-get update
sudo apt-get install git clang cmake ninja-build openjdk-11-jdk openjdk-11-jre libgtk-3-dev -y

git clone https://github.com/flutter/flutter.git /home/Android/flutter
sdkmanager "platform-tools"
sdkmanager "build-tools;33.0.0"
sdkmanager "platforms;android-33"
sdkmanager --licenses
flutter doctor --android-licenses
flutter doctor -v
