#!/bin/sh

echo '# SDK exporting' >> ~/.bashrc
echo 'export ANDROID_HOME="/home/Android"' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT="$ANDROID_HOME/sdk"' >> ~/.bashrc

echo '# Tools exporting ' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin"' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"' >> ~/.bashrc

echo '# Flutter binary exporting' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_HOME/flutter/bin"' >> ~/.bashrc
