#!/bin/bash -e
build=11D259
modtime=201910160021
mkdir -p Firmware
cd Firmware
if [ ! -f Phoenix-3.6.03.Release.bbfw ] || [ ! -f Phoenix-3.6.03.Release.plist ] ; then
	echo "Downloading 3.6.03 baseband firmware (1/2)"
	../tools/partialZipBrowser -g Firmware/Phoenix-3.6.03.Release.bbfw http://updates-http.cdn-apple.com/2019/ios/041-80042-20190722-68F07B91-8EA1-4A3B-A930-35314A006ECB/iPad2,3_9.3.6_13G37_Restore.ipsw >/dev/null
	echo "Downloading 3.6.03 baseband firmware (2/2)"
	../tools/partialZipBrowser -g Firmware/Phoenix-3.6.03.Release.plist http://updates-http.cdn-apple.com/2019/ios/041-80042-20190722-68F07B91-8EA1-4A3B-A930-35314A006ECB/iPad2,3_9.3.6_13G37_Restore.ipsw >/dev/null
fi
cd ..
echo "Creating patched IPSW (this will take several minutes)"
rm -rf 713.tar rootfs
mkdir rootfs
cd rootfs
mkdir -p System/Library/CoreServices
cat ../SystemVersionT.plist | sed "s/11D257/$build/g" > System/Library/CoreServices/SystemVersion.plist
mkdir -p usr/standalone/update
cp ../Firmware/Phoenix-3.6.03.Release.bbfw usr/standalone/update/Phoenix.Release.bbfw
cp ../Firmware/Phoenix-3.6.03.Release.plist usr/standalone/update/Phoenix.Release.plist
chmod 0644 `find . -type f -not -name '.*'`
chmod 0444 System/Library/CoreServices/SystemVersion.plist
TZ=PDT+7 touch -a -c -m -t $modtime `find . -type f -not -name '.*'`
../tools/root_tar/mytar cRf ../713.tar `find . -type f -not -name '.*'`
cd ..
rm -rf rootfs
iname="`echo "$1" | sed "s/7.1.2_11D257/7.1.3_$build/"`"
rm -rf "$iname"
./tools/ipsw "$1" "$iname" -bbupdate 713.tar >/dev/null
rm -f 713.tar
echo Replacing Restore.plist and BuildManifest.plist
rm -rf Restore.plist BuildManifest.plist
cat RestoreT.plist | sed "s/11D257/$build/g" > Restore.plist
cat BuildManifestT.plist | sed "s/11D257/$build/g" > BuildManifest.plist
TZ=PDT+7 touch -a -c -m -t $modtime Restore.plist BuildManifest.plist
zip -qq "$iname" Restore.plist BuildManifest.plist
rm -f Restore.plist BuildManifest.plist
echo Replacing baseband firmware
zip -qq -d "$iname" 'Firmware/Phoenix*'
TZ=PDT+7 touch -a -c -m -t $modtime Firmware/Phoenix*
zip -qq "$iname" Firmware/Phoenix*
echo Removing update ramdisk
zip -qq -d "$iname" 058-4266-010.dmg
echo "Created patched IPSW at: $iname"
