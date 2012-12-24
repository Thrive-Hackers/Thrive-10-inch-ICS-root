@echo off

echo Welcome to the opportunity to free your Thrive!
echo
echo Originally developed by TYBAR at the Thrive forums,
echo this tool pushes several files onto your device,
echo then flashes the unlocked bootloader, then
echo installs the SU binary and Superuser app.
echo
echo I am not responsible if you break your tablet, you
echo were the one that ran this. In the off chance that
echo something does happen, please PM me, pio_masaki,
echo or dalepl for help. Also, I am completely not 
echo responsible for pixies flying out of your HDMI
echo port, either. ;)
echo
echo Please connect your tablet now, or exit to keep
echo a full stock Thrive.

pause

cd ../roottool

adb wait-for-device
adb push tputimg /data/local/tmp
adb shell "/data/local/tmp/tputimg --des /data/local.prop"
adb shell "echo ro.kernel.qemu=1 > /data/local.prop"
adb reboot

echo Please let me know if it works. I haven't done
echo ANYTHING to your partitions. If it's super-laggy,
echo that's EXCELLENT news. Also, let me know of any
echo error messages that pop up. Just leave an issue in
echo https://github.com/AmEv7Fam/Thrive-IMM76D.01.000072314-root/issues
echo or on the Thrive forums.