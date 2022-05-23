## Check devices

flutter devices

## Add config on existing project

flutter create --platforms=windows,macos,linux .

## Add developper mode

start ms-settings:developers

## Config desktop app

flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

## Run     

flutter run 

## Debug

flutter run -d [platform]

## Release

flutter build apk --release
flutter build windows --release
flutter build web --release --web-renderer canvaskit