## Notes
_This script will install android sdk and flutter sdk on /home/Android/_

# Flutter installer

1. Download CommandLineTools from here https://developer.android.com/studio#command-tools
2. run create-path.sh
```
./create-path.sh
```
3. Extract CommandLineTools to /home/Android/sdk/cmdline-tools/latest/
![Screenshot_2022-07-04-13-20-14_1366x768](https://user-images.githubusercontent.com/84622086/177096244-2d09689f-0c54-45e7-b335-ac767f0670b4.png)

4. Export path according to the shell you are using  and exit/close terminal after that

_Bash Shell_
```
./path-bashrc.sh
```

_Zsh Shell_
```
./path-zshrc.sh
```
5. Run the installer according to the system you are using
```
./flutter-arch.sh
```

or
```
./flutter-debian.sh
```
