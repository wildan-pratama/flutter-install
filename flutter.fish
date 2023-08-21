## SDK exporting
set -x ANDROID_HOME "$HOME/Android"

## Tools exporting 
set -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $PATH
set -x PATH $ANDROID_HOME/emulator $PATH
set -x PATH $ANDROID_HOME/platform-tools $PATH

## Flutter binary exporting
set -x PATH $ANDROID_HOME/flutter/bin $PATH

## Androidstudio binary exporting
#set -x PATH /opt/android-studio/bin $PATH

## Fix problems with Java apps
#wmname "LG3D"
set -x _JAVA_AWT_WM_NONREPARENTING "1"

## Browser exporting for web dev
#set -x browser_flutter "brave-browser-nightly" #set your browser here
#set -x CHROME_EXECUTABLE "$(which $browser_flutter)"