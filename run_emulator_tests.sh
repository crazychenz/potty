#!/bin/bash -v

AVD_IMAGE=Pixel-API28-v9.0-1080x1920-x86
APP_NAME=org.godotengine.pottytime
#APK_PATH=/mnt/c/projects/stable/potty/releases/PottyTime.apk
APK_PATH=$(pwd)/PottyTime-Android.apk

EMULATOR=/mnt/d/android-sdk/emulator/emulator.exe
PLATTOOLS=/mnt/d/android-sdk/platform-tools
BUILDTOOLS=/mnt/d/android-sdk/build-tools/29.0.3
ADB=$PLATTOOLS/adb.exe
AAPT=$BUILDTOOLS/aapt.exe

# Execute the emulator.
$EMULATOR -shell -avd $AVD_IMAGE >emulator.log 2>&1 &
EMULATOR_PID=$!
echo Emulator Pid: $EMULATOR_PID

# Wait a few seconds for emulator to settle.
# TODO: Replace this sleep with event or active monitor.
sleep 30

# Install the APK (or replace installed)
pushd `dirname $APK_PATH`
$ADB install -r `basename $APK_PATH`
popd

# You can get APP_NAME with Android Asset Packaging Tool
#$AAPT d xmltree PottyTime-v0.0.3-Android.apk AndroidManifest.xml

# Set adbd in root mode to get access to /data directory.
# Note: This will not work with an image that has GooglePlay
$ADB root

# Allow the application to be installed and settle.
# TODO: Replace this sleep with event or active monitor.
sleep 5

# Run the application first to have user:// directory created.
$ADB shell am start -a android.intent.action.MAIN $APP_NAME/com.godot.game.GodotApp

# Allow application to open and settle.
# TODO: Replace this sleep with event or active monitor.
sleep 2

# Add the file that causes the testing to trigger.
$ADB shell touch /data/data/$APP_NAME/files/testmode

# Wait a few moments for the tests to finish.
# TODO: Replace this sleep with event or active monitor.
sleep 10

# Grab the test output
$ADB logcat -d | grep -i godot

# In windows, taskkill PID to force shutdown.
#taskkill /F /PID $EMULATOR_PID

# In linux, kill PID to force shutdown
#kill -9 $EMULATOR_PID

# Kill emulator via ADB. 
# Note: This may be problematic if more than one device connected.
$ADB emu kill



