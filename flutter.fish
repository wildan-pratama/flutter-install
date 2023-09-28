## SDK exporting
set -x ANDROID_HOME "$HOME/Android"
set -x ANDROID_SDK_ROOT "$ANDROID_HOME/sdk"

## Tools exporting 
set -x PATH $ANDROID_SDK_ROOT/cmdline-tools/latest/bin $PATH
set -x PATH $ANDROID_SDK_ROOT/emulator $PATH
set -x PATH $ANDROID_SDK_ROOT/platform-tools $PATH

## Flutter binary exporting
set -x PATH $ANDROID_HOME/flutter/bin $PATH

## Androidstudio binary exporting
if test -d /opt/android-studio/bin
    set -x PATH /opt/android-studio/bin $PATH
end

## Fix problems with Java apps
#set -x wmname "LG3D"
set -x _JAVA_AWT_WM_NONREPARENTING "1"

## Browser exporting for web dev
#set -x CHROME_EXECUTABLE "brave"
