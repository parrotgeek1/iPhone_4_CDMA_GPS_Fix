#!/bin/bash -e
get_key() {
	cat "$1" | grep -A1 "<key>$2</key>" | tail -1 | cut -d '>' -f 2 | cut -d '<' -f 1
}

unzip -p "$1" Restore.plist 2>/dev/null > Restore.plist
if [ ! -s Restore.plist ] ; then
	echo "Not an IPSW file: $1"
	rm -f Restore.plist
	exit 1
fi
ptype=`get_key Restore.plist ProductType`
pvers=`get_key Restore.plist ProductVersion`
build=`get_key Restore.plist ProductBuildVersion`
if [ "x$ptype" != "xiPhone3,3" ] ; then
	echo "Only the iPhone3,3 is supported."
	rm -f Restore.plist
	exit 1
fi
bndl=FirmwareBundles/Down_${ptype}_${pvers}_${build}.bundle
if [ ! -d "$bndl" ]; then
	echo "You must use a 7.1.2 IPSW as input."
	rm -f Restore.plist
	exit 1
fi
rm -f Restore.plist
