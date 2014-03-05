@echo off

echo This will attempt to stop the temp root bootloops

pause
cls

echo reverting temp root
adb shell "echo "ro.kernel.qemu=0" > /data/local.prop"
echo rebooting...
adb reboot
cls

echo Cleaning up....
adb shell "busybox rm /data/x-root -rf"

echo System stability should be restored.

pause
cls



