#!/bin/sh
# SDK exporting' >> ~/.bashrc
export ANDROID_HOME="/home/Android"
export ANDROID_SDK_ROOT="$ANDROID_HOME/sdk"

# Tools exporting ' >> ~/.bashrc
export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin"
export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"

# Flutter binary exporting' >> ~/.bashrc
export PATH="$PATH:$ANDROID_HOME/flutter/bin"
