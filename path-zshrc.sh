#!/bin/sh

echo '# SDK exporting' >> ~/.zshrc
echo 'export ANDROID_HOME="/home/Android"' >> ~/.zshrc
echo 'export ANDROID_SDK_ROOT="$ANDROID_HOME/sdk"' >> ~/.zshrc
echo '' >> ~/.zshrc
echo '# Tools exporting ' >> ~/.zshrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"' >> ~/.zshrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin"' >> ~/.zshrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"' >> ~/.zshrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"' >> ~/.zshrc
echo '' >> ~/.zshrc
echo '# Flutter binary exporting' >> ~/.zshrc
echo 'export PATH="$PATH:$ANDROID_HOME/flutter/bin"' >> ~/.zshrc
