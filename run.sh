#!/bin/bash -v

# Execute the emulator.
/mnt/d/android-sdk/emulator/emulator.exe -shell -avd Pixel-API28-v9.0-1080x1920-x86 >emulator.log 2>&1 &
EMULATOR_PID=$!
echo Emulator Pid: $EMULATOR_PID

# Until we have feedback working, wait 10 seconds
sleep 10

PLATTOOLS=/mnt/d/android-sdk/platform-tools
BUILDTOOLS=/mnt/d/android-sdk/build-tools/29.0.3
ADB=$PLATTOOLS/adb.exe
AAPT=$BUILDTOOLS/aapt.exe
APP_NAME=org.godotengine.pottytime

# Install the APK
$ADB install PottyTime-v0.0.3-Android.apk

# You can get APP_NAME with Android Asset Packaging Tool
#$AAPT d xmltree PottyTime-v0.0.3-Android.apk AndroidManifest.xml

# Set adbd in root mode to get access to /data directory.
# Note: This will not work with an image that has GooglePlay
$ADB root

# Add the file that causes the testing code branch.
$ADB shell touch /data/data/org.godotengine.androidfilecheck/files/testmode

# Run the application.
$ADB shell am start -a android.intent.action.MAIN $APP_NAME/com.godot.game.GodotApp

# Until we get a feedback working, sleep for some time and then quit.
sleep 10
#taskkill /F /PID $EMULATOR_PID
$ADB emu kill



